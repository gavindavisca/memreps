import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/app_state.dart';
import '../logic/repository.dart';
import '../data/database.dart';
import '../logic/l10n.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'widgets/member_image.dart';


enum SortOption { lastName, leastMemorized, mostMemorized }

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedParty;
  String? _selectedRegion;
  SortOption _sortOption = SortOption.lastName;
  bool _showFilters = false;

  void _showSortMenu(BuildContext context, L10n l10n) async {
    final option = await showMenu<SortOption>(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem(value: SortOption.lastName, child: Text(l10n.get('sort_name'))),
        PopupMenuItem(value: SortOption.leastMemorized, child: Text(l10n.get('sort_least'))),
        PopupMenuItem(value: SortOption.mostMemorized, child: Text(l10n.get('sort_most'))),
      ],
    );
    if (option != null) setState(() => _sortOption = option);
  }

  void _sortMembers(List<MemberWithStats> items) {
    switch (_sortOption) {
      case SortOption.lastName:
        items.sort((a, b) => a.member.lastName.compareTo(b.member.lastName));
        break;
      case SortOption.leastMemorized:
        items.sort((a, b) {
          final hasQ_A = a.review != null && a.review!.totalQuestions > 0;
          final hasQ_B = b.review != null && b.review!.totalQuestions > 0;
          final allCorrA = hasQ_A && a.review!.correctQuestions == a.review!.totalQuestions;
          final allCorrB = hasQ_B && b.review!.correctQuestions == b.review!.totalQuestions;
          
          // Rank: 0 = Has errors, 1 = Unanswered, 2 = All correct
          final rankA = !hasQ_A ? 1 : (allCorrA ? 2 : 0);
          final rankB = !hasQ_B ? 1 : (allCorrB ? 2 : 0);

          if (rankA != rankB) return rankA.compareTo(rankB);
          
          if (rankA == 0) {
            final res = a.memorizationPercentage.compareTo(b.memorizationPercentage);
            if (res != 0) return res;
          }
          return a.member.lastName.compareTo(b.member.lastName);
        });
        break;
      case SortOption.mostMemorized:
        items.sort((a, b) {
          final hasQ_A = a.review != null && a.review!.totalQuestions > 0;
          final hasQ_B = b.review != null && b.review!.totalQuestions > 0;
          final allCorrA = hasQ_A && a.review!.correctQuestions == a.review!.totalQuestions;
          final allCorrB = hasQ_B && b.review!.correctQuestions == b.review!.totalQuestions;

          // Rank: 0 = All correct, 1 = Partial correct, 2 = Unanswered
          final rankA = allCorrA ? 0 : (hasQ_A ? 1 : 2);
          final rankB = allCorrB ? 0 : (hasQ_B ? 1 : 2);

          if (rankA != rankB) return rankA.compareTo(rankB);

          if (rankA == 1) {
            final res = b.memorizationPercentage.compareTo(a.memorizationPercentage);
            if (res != 0) return res;
          }
          return a.member.lastName.compareTo(b.member.lastName);
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final repository = Provider.of<Repository>(context);
    final l10n = appState.l10n;
    final legislatureId = appState.currentLegislature!.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(appState.currentLegislature!.name),
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortMenu(context, l10n),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.get('search_members'),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  filled: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),
          ),
          if (_showFilters)
            SliverToBoxAdapter(
              child: _buildFilterPanel(repository, legislatureId, l10n),
            ),
          FutureBuilder<List<MemberWithStats>>(
            future: repository.getMembersWithStats(appState.currentProfile!.id, legislatureId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
              }
              
              var items = snapshot.data ?? [];
              
              // Apply Filter
              if (_selectedParty != null) {
                items = items.where((i) => i.member.party == _selectedParty).toList();
              }
              if (_selectedRegion != null) {
                items = items.where((i) => i.member.region == _selectedRegion).toList();
              }
              
              // Apply Search
              if (_searchQuery.isNotEmpty) {
                final q = _searchQuery.toLowerCase();
                items = items.where((i) => 
                  i.member.firstName.toLowerCase().contains(q) || 
                  i.member.lastName.toLowerCase().contains(q) ||
                  (i.member.riding?.toLowerCase().contains(q) ?? false)
                ).toList();
              }
              
              // Apply Sort
              _sortMembers(items);

              if (items.isEmpty) {
                return SliverFillRemaining(
                  child: Center(child: Text(l10n.get('no_members'))),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final leftIndex = index * 2;
                      final rightIndex = index * 2 + 1;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: _buildMemberCard(items[leftIndex])),
                              const SizedBox(width: 16),
                              if (rightIndex < items.length)
                                Expanded(child: _buildMemberCard(items[rightIndex]))
                              else
                                const Expanded(child: SizedBox.shrink()),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: (items.length / 2).ceil(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel(Repository repository, int legislatureId, L10n l10n) {
    return FutureBuilder<List<Member>>(
      future: repository.getMembers(legislatureId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final members = snapshot.data!;
        final parties = members.map((m) => m.party).whereType<String>().toSet().toList()..sort();
        final regions = members.map((m) => m.region).whereType<String>().toSet().toList()..sort();

        return Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.get('party'), style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: Text(l10n.get('all')),
                    selected: _selectedParty == null,
                    onSelected: (_) => setState(() => _selectedParty = null),
                  ),
                  ...parties.map((p) => FilterChip(
                    label: Text(p),
                    selected: _selectedParty == p,
                    onSelected: (sel) => setState(() => _selectedParty = sel ? p : null),
                  )),
                ],
              ),
              const SizedBox(height: 16),
              Text(l10n.get('region'), style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: Text(l10n.get('all')),
                    selected: _selectedRegion == null,
                    onSelected: (_) => setState(() => _selectedRegion = null),
                  ),
                  ...regions.map((r) => FilterChip(
                    label: Text(r),
                    selected: _selectedRegion == r,
                    onSelected: (sel) => setState(() => _selectedRegion = sel ? r : null),
                  )),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMemberCard(MemberWithStats item) {
    final member = item.member;
    final percentage = item.memorizationPercentage;
    final hasStats = item.review != null && item.review!.totalQuestions > 0;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // Future: Member details
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 4 / 5,
                  child: MemberImage(
                    imageUrl: member.imageUrl,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${member.firstName} ${member.lastName}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        member.party ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        member.riding ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (hasStats)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPercentageColor(percentage).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${percentage.round()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }
}
