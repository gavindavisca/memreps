import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:xml/xml.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as dom;
import '../data/database.dart';

class ScraperService {
  final Dio dio = Dio();

  String _proxyUrl(String url) {
    if (!kIsWeb) return url;
    if (kDebugMode) {
      return 'http://127.0.0.1:5001/openclaw-bot-486015/us-central1/proxyData?url=${Uri.encodeComponent(url)}';
    }
    // In production, use the absolute path since GitHub Pages hosting doesn't support relative rewrites
    return 'https://proxydata-wq27mxu42a-uc.a.run.app?url=${Uri.encodeComponent(url)}';
  }

  Future<List<MembersCompanion>> fetchMembers(String slug, {required String name, Function(int)? onProgress}) async {
    try {
      onProgress?.call(1);
      final response = await dio.get('https://represent.opennorth.ca/representatives/$slug/?limit=1000');
      final data = response.data;
      final objects = data['objects'] as List;

      var members = objects.map((obj) {
        String firstName = obj['first_name'] ?? '';
        String lastName = obj['last_name'] ?? '';
        
        if (firstName.isEmpty && lastName.isEmpty && obj['name'] != null) {
          final parts = (obj['name'] as String).split(' ');
          if (parts.length > 1) {
            firstName = parts.first;
            lastName = parts.sublist(1).join(' ');
          } else {
            lastName = parts.first;
          }
        }

        return MembersCompanion(
          firstName: Value(firstName),
          lastName: Value(lastName),
          riding: Value(obj['district_name']),
          party: Value(obj['party_name']),
          imageUrl: Value(obj['photo_url'] ?? ''),
          title: Value(obj['elected_office']),
          region: Value(_determineRegion(name, obj)),
        );
      }).toList();

      // Enrich House of Commons specifically
      if (slug == 'house-of-commons' || slug == 'quebec-assemblee-nationale' || slug == 'ontario-legislature' || slug == 'alberta-legislature' || slug == 'yukon-legislature') {
        onProgress?.call(2);
      }

      if (slug == 'house-of-commons') {
        members = await _enrichHouseOfCommons(members);
      } else if (slug == 'quebec-assemblee-nationale') {
        members = await _enrichQuebec(members);
      } else if (slug == 'alberta-legislature') {
        members = await _enrichAlberta(members);
      } else if (slug == 'ontario-legislature') {
        members = await _enrichOntario(members);
      } else if (slug == 'yukon-legislature') {
        members = await _enrichYukon(members);
      } else if (slug == 'senate-of-canada') {
        members = await _fetchSenate();
      }

      return members;
    } catch (e) {
      throw Exception('Failed to fetch data for $name: $e');
    }
  }

  Future<List<MembersCompanion>> _enrichAlberta(List<MembersCompanion> baseMembers) async {
    try {
      final response = await dio.get(_proxyUrl('https://www.assembly.ab.ca/txt/mla_home/contacts.csv'));
      final csvData = csv.decode(response.data.toString());
      
      if (csvData.length < 2) return baseMembers;
      
      final List<MembersCompanion> enriched = [];
      final headers = csvData[0];
      
      final lastNameIdx = headers.indexOf('Last Name');
      final firstNameIdx = headers.indexOf('First Name');
      final caucusIdx = headers.indexOf('Caucus');
      final constituencyIdx = headers.indexOf('Constituency');
      
      for (int i = 1; i < csvData.length; i++) {
        final row = csvData[i];
        if (row.length <= constituencyIdx) continue;
        
        final offFirstName = row[firstNameIdx].toString().trim();
        final offLastName = row[lastNameIdx].toString().trim();
        final offRiding = row[constituencyIdx].toString().trim();
        final offParty = row[caucusIdx].toString().trim();
        
        final match = baseMembers.firstWhere(
          (m) => m.lastName.value.toLowerCase() == offLastName.toLowerCase() && 
                 m.riding.value?.toLowerCase() == offRiding.toLowerCase(),
          orElse: () => MembersCompanion(
            firstName: Value(offFirstName),
            lastName: Value(offLastName),
            riding: Value(offRiding),
            party: Value(offParty),
            imageUrl: Value(''),
            title: Value('MLA'),
          ),
        );

        enriched.add(match.copyWith(
          firstName: Value(offFirstName),
          lastName: Value(offLastName),
          party: Value(offParty),
          riding: Value(offRiding),
        ));
      }
      return enriched;
    } catch (e) {
      return baseMembers;
    }
  }

  Future<List<MembersCompanion>> _enrichOntario(List<MembersCompanion> baseMembers) async {
    try {
      // Official Ontario Legislative Assembly CSV feed
      final response = await dio.get(_proxyUrl('https://www.ola.org/sites/default/files/node-files/office_csvs/offices-all.csv'));
      final csvData = csv.decode(response.data.toString());
      
      if (csvData.length < 2) return baseMembers;
      
      final List<MembersCompanion> enriched = [];
      final headers = csvData[0];
      
      final firstNameIdx = headers.indexOf('First name');
      final lastNameIdx = headers.indexOf('Last name');
      final ridingIdx = headers.indexOf('Riding name');
      final partyIdx = headers.indexOf('Party');
      
      // Keep track of added member names to avoid duplicates in the CSV (which has multiple offices per MPP)
      final seenMembers = <String>{};

      for (int i = 1; i < csvData.length; i++) {
        final row = csvData[i];
        final offFirstName = row[firstNameIdx].toString().trim();
        final offLastName = row[lastNameIdx].toString().trim();
        final offRiding = row[ridingIdx].toString().trim();
        final offParty = row[partyIdx].toString().trim();
        
        final memberKey = '$offFirstName|$offLastName';
        if (seenMembers.contains(memberKey)) continue;
        seenMembers.add(memberKey);

        final match = baseMembers.firstWhere(
          (m) => m.lastName.value.toLowerCase() == offLastName.toLowerCase() && 
                 m.riding.value?.toLowerCase() == offRiding.toLowerCase(),
          orElse: () => MembersCompanion(
            firstName: Value(offFirstName),
            lastName: Value(offLastName),
            riding: Value(offRiding),
            party: Value(offParty),
            imageUrl: Value(''),
            title: Value('MPP'),
          ),
        );

        enriched.add(match.copyWith(
          firstName: Value(offFirstName),
          lastName: Value(offLastName),
          party: Value(offParty),
          riding: Value(offRiding),
        ));
      }
      return enriched;
    } catch (e) {
      return baseMembers;
    }
  }

  Future<List<MembersCompanion>> _enrichHouseOfCommons(List<MembersCompanion> baseMembers) async {
    try {
      // Official House of Commons XML search endpoint
      final response = await dio.get(_proxyUrl('https://www.ourcommons.ca/Members/en/search/xml'));
      final document = XmlDocument.parse(response.data);
      final parliamentarians = document.findAllElements('MemberOfParliament');
      
      final List<MembersCompanion> enriched = [];
      
      for (final node in parliamentarians) {
        final offFirstName = node.findElements('PersonOfficialFirstName').first.innerText;
        final offLastName = node.findElements('PersonOfficialLastName').first.innerText;
        final offRiding = node.findElements('ConstituencyName').first.innerText;
        final offParty = node.findElements('CaucusShortName').first.innerText;
        
        final lastNameClean = offLastName.replaceAll(' ', '');
        final firstNameClean = offFirstName.replaceAll(' ', '');
        final partyCode = _getHouseOfCommonsPartyCode(offParty);
        final officialImageUrl = 'https://www.ourcommons.ca/Content/Parliamentarians/Images/OfficialMPPhotos/45/$lastNameClean${firstNameClean}_$partyCode.jpg';

        // Find match in OpenNorth data by name and riding
        final match = baseMembers.firstWhere(
          (m) => m.lastName.value.toLowerCase() == offLastName.toLowerCase() && 
                 m.riding.value?.toLowerCase() == offRiding.toLowerCase(),
          orElse: () => MembersCompanion(
            firstName: Value(offFirstName),
            lastName: Value(offLastName),
            riding: Value(offRiding),
            party: Value(offParty),
            imageUrl: Value(officialImageUrl), // Use calculated URL for brand-new members
            title: Value('MP'),
          ),
        );

        // Use OpenNorth URL if available, otherwise use calculated official URL
        final finalImageUrl = (match.imageUrl.present && match.imageUrl.value.isNotEmpty) 
            ? match.imageUrl.value 
            : officialImageUrl;

        // Update with latest official party/riding/name
        enriched.add(match.copyWith(
          firstName: Value(offFirstName),
          lastName: Value(offLastName),
          party: Value(offParty),
          riding: Value(offRiding),
          imageUrl: Value(finalImageUrl),
        ));
      }
      
      return enriched;
    } catch (e) {
      // If official site enrichment fails, return base members as fallback
      return baseMembers;
    }
  }

  String _getHouseOfCommonsPartyCode(String partyName) {
    final name = partyName.toLowerCase();
    if (name.contains('liberal')) return 'Lib';
    if (name.contains('conservative')) return 'CPC';
    if (name.contains('bloc')) return 'BQ';
    if (name.contains('ndp') || name.contains('new democratic')) return 'NDP';
    if (name.contains('green')) return 'GP';
    return 'IND';
  }

  Future<List<MembersCompanion>> _enrichQuebec(List<MembersCompanion> baseMembers) async {
    try {
      final response = await dio.get(_proxyUrl('https://www.assnat.qc.ca/fr/deputes/index.xml'));
      final document = XmlDocument.parse(response.data);
      final deputes = document.findAllElements('Depute');
      
      final List<MembersCompanion> enriched = [];
      
      for (final node in deputes) {
        final offFirstName = node.findElements('Prenom').first.innerText;
        final offLastName = node.findElements('Nom').first.innerText;
        final offRiding = node.findElements('Circonscription').first.innerText;
        final offParty = node.findElements('PartiPolitique').first.innerText;
        
        final match = baseMembers.firstWhere(
          (m) => m.lastName.value.toLowerCase() == offLastName.toLowerCase() && 
                 m.riding.value?.toLowerCase() == offRiding.toLowerCase(),
          orElse: () => MembersCompanion(
            firstName: Value(offFirstName),
            lastName: Value(offLastName),
            riding: Value(offRiding),
            party: Value(offParty),
            imageUrl: Value(''),
            title: Value('Député'),
          ),
        );

        enriched.add(match.copyWith(
          firstName: Value(offFirstName),
          lastName: Value(offLastName),
          party: Value(offParty),
          riding: Value(offRiding),
        ));
      }
      return enriched;
    } catch (e) {
      return baseMembers;
    }
  }

  Future<List<MembersCompanion>> _enrichYukon(List<MembersCompanion> baseMembers) async {
    try {
      final response = await dio.get(_proxyUrl('https://yukonassembly.ca/export-mla-list'));
      final csvData = csv.decode(response.data.toString());
      
      if (csvData.length < 2) return baseMembers;
      
      final List<MembersCompanion> enriched = [];
      final headers = csvData[0];
      final titleIdx = headers.indexOf('Title');
      final districtIdx = headers.indexOf('District');
      final partyIdx = headers.indexOf('Party');
      
      for (int i = 1; i < csvData.length; i++) {
        final row = csvData[i];
        final fullName = row[titleIdx].toString();
        final offRiding = row[districtIdx].toString();
        final offParty = row[partyIdx].toString();
        
        String offFirstName = '';
        String offLastName = '';
        final nameParts = fullName.split(' ');
        if (nameParts.length > 1) {
          offFirstName = nameParts.first;
          offLastName = nameParts.sublist(1).join(' ');
        } else {
          offLastName = fullName;
        }

        final match = baseMembers.firstWhere(
          (m) => m.lastName.value.toLowerCase() == offLastName.toLowerCase() && 
                 m.riding.value?.toLowerCase() == offRiding.toLowerCase(),
          orElse: () => MembersCompanion(
            firstName: Value(offFirstName),
            lastName: Value(offLastName),
            riding: Value(offRiding),
            party: Value(offParty),
            imageUrl: Value(''),
            title: Value('MLA'),
          ),
        );

        enriched.add(match.copyWith(
          firstName: Value(offFirstName),
          lastName: Value(offLastName),
          party: Value(offParty),
          riding: Value(offRiding),
        ));
      }
      return enriched;
    } catch (e) {
      return baseMembers;
    }
  }

  static const Map<String, String> provinceCodes = {
    '10': 'Newfoundland and Labrador',
    '11': 'Prince Edward Island',
    '12': 'Nova Scotia',
    '13': 'New Brunswick',
    '24': 'Quebec',
    '35': 'Ontario',
    '46': 'Manitoba',
    '47': 'Saskatchewan',
    '48': 'Alberta',
    '59': 'British Columbia',
    '60': 'Yukon',
    '61': 'Northwest Territories',
    '62': 'Nunavut',
  };

  String? _determineRegion(String legislatureName, Map<String, dynamic> obj) {
    if (legislatureName.contains('Alberta')) return 'Alberta';
    if (legislatureName.contains('Ontario')) return 'Ontario';
    if (legislatureName.contains('British Columbia')) return 'British Columbia';
    
    // For Federal House of Commons
    final boundaryUrl = obj['related']?['boundary_url'] as String?;
    if (boundaryUrl != null) {
      final parts = boundaryUrl.split('/').where((p) => p.isNotEmpty).toList();
      if (parts.isNotEmpty) {
        final code = parts.last;
        if (code.length >= 2) {
          final provCode = code.substring(0, 2);
          if (provinceCodes.containsKey(provCode)) {
            return provinceCodes[provCode];
          }
        }
      }
    }

    // Fallback: check postal codes in offices for province codes
    final offices = obj['offices'] as List?;
    if (offices != null) {
      final codes = {
        'AB': 'Alberta', 'BC': 'British Columbia', 'MB': 'Manitoba', 'NB': 'New Brunswick',
        'NL': 'Newfoundland and Labrador', 'NS': 'Nova Scotia', 'NT': 'Northwest Territories',
        'NU': 'Nunavut', 'ON': 'Ontario', 'PE': 'Prince Edward Island', 'QC': 'Quebec',
        'SK': 'Saskatchewan', 'YT': 'Yukon'
      };
      for (var office in offices) {
        final postal = office['postal'] as String?;
        if (postal != null) {
          for (var entry in codes.entries) {
            if (postal.contains(' ${entry.key} ')) return entry.value;
            if (postal.contains(', ${entry.key}')) return entry.value;
          }
        }
      }
    }

    return null;
  }

  Future<List<MembersCompanion>> _fetchSenate() async {
    try {
      // 1. Fetch Tiles Fragment for Images
      final tilesResponse = await dio.get(_proxyUrl('https://sencanada.ca/umbraco/surface/SenatorsAjax/GetSenators?displayFor=senatorstiles&Lang=en'));
      final tilesDoc = html.parse(tilesResponse.data);
      final imageMap = <String, String>{};
      
      // Target both special role cards and standard senator cards
      final cards = tilesDoc.querySelectorAll('a.sc-senators-political-card-photo, .sc-senators-senator-card-photo a');
      for (final card in cards) {
        final slug = card.attributes['href'];
        final img = card.querySelector('img');
        final src = img?.attributes['src'];
        if (slug != null && src != null) {
          final fullSrc = src.startsWith('http') ? src : 'https://sencanada.ca$src';
          imageMap[slug] = fullSrc;
        }
      }

      // 2. Fetch List Fragment for Data
      final listResponse = await dio.get(_proxyUrl('https://sencanada.ca/umbraco/surface/SenatorsAjax/GetSenators?displayFor=senatorslist&Lang=en'));
      final listDoc = html.parse(listResponse.data);
      final List<MembersCompanion> senators = [];
      
      final rows = listDoc.querySelectorAll('table#senator-list-view-table tbody tr');
      for (final row in rows) {
        final cells = row.querySelectorAll('td');
        if (cells.length < 3) continue;

        final link = cells[0].querySelector('a');
        final fullName = link?.text.trim() ?? '';
        final slug = link?.attributes['href'] ?? '';
        final partyAbbr = cells[1].text.trim();
        final province = cells[2].text.trim();

        if (fullName.isEmpty) continue;

        // Expand party names
        String party = partyAbbr;
        switch (partyAbbr) {
          case 'ISG': party = 'Independent Senators Group'; break;
          case 'CSG': party = 'Canadian Senators Group'; break;
          case 'PSG': party = 'Progressive Senate Group'; break;
          case 'C': party = 'Conservative Party of Canada'; break;
          case 'GRO': party = 'Government Representative’s Office'; break;
        }

        String firstName = '';
        String lastName = '';
        if (fullName.contains(',')) {
          final parts = fullName.split(',');
          lastName = parts[0].trim();
          firstName = parts[1].trim();
        } else {
          lastName = fullName;
        }

        senators.add(MembersCompanion(
          firstName: Value(firstName),
          lastName: Value(lastName),
          riding: Value(province),
          party: Value(party),
          imageUrl: Value(imageMap[slug] ?? ''),
          title: Value('Senator'),
          region: Value(province),
        ));
      }

      return senators;
    } catch (e) {
      throw Exception('Failed to fetch Senate data: $e');
    }
  }
}
