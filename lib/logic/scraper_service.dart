import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import '../data/database.dart';

class ScraperService {
  final Dio dio = Dio();

  Future<List<MembersCompanion>> fetchMembers(String slug, {required String name}) async {
    try {
      final response = await dio.get('https://represent.opennorth.ca/representatives/$slug/?limit=1000');
      final data = response.data;
      final objects = data['objects'] as List;

      return objects.map((obj) {
        // Some APIs might return names differently
        String firstName = obj['first_name'] ?? '';
        String lastName = obj['last_name'] ?? '';
        
        // If first/last names are empty, try to split the full name
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
    } catch (e) {
      throw Exception('Failed to fetch data for $name: $e');
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

  Future<List<MembersCompanion>> _fetchMockSenate() async {
    // Placeholder for Senate until a reliable source is found
    return [
      const MembersCompanion(
        firstName: Value('Raymond'),
        lastName: Value('Saint-Germain'),
        riding: Value('Quebec'),
        party: Value('Independent Senators Group'),
        imageUrl: Value('https://sencanada.ca/media/366363/sen_saint-germain_raymonde_001_800.jpg'),
        title: Value('Senator'),
        region: Value('Quebec'),
      ),
      // Add more or implement real scraper
    ];
  }
}
