import 'package:flutter/material.dart';
import '../services/mock_database.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/program_utils.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/program_card.dart';
import 'program_details_screen.dart';

class ProgramListingScreen extends StatefulWidget {
  final bool autoFocusSearch;
  final VoidCallback? onSearchFocused;

  const ProgramListingScreen({
    super.key,
    this.autoFocusSearch = false,
    this.onSearchFocused,
  });

  @override
  State<ProgramListingScreen> createState() => _ProgramListingScreenState();
}

class _ProgramListingScreenState extends State<ProgramListingScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  static const _categories = [
    'All',
    'Mobile',
    'Data & AI',
    'Web Dev',
    'Security',
    'General',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.autoFocusSearch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
        widget.onSearchFocused?.call();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Programs', showBackButton: false),
      body: ListenableBuilder(
        listenable: MockDatabase.instance,
        builder: (context, _) {
          final filteredPrograms = MockDatabase.instance.programs.where((p) {
            final matchesQuery =
                p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.description.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                );
            return matchesQuery &&
                ProgramUtils.matchesCategory(p, _selectedCategory);
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.paddingLarge,
                  8,
                  AppConstants.paddingLarge,
                  0,
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search programs',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textLight,
                      size: 20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: AppColors.textLight,
                              size: 20,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.paddingLarge,
                  14,
                  AppConstants.paddingLarge,
                  6,
                ),
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        showCheckmark: false,
                        label: Text(category),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.card,
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.divider,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onSelected: (_) =>
                            setState(() => _selectedCategory = category),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingLarge,
                ),
                child: Text(
                  '${filteredPrograms.length} program${filteredPrograms.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: filteredPrograms.isEmpty
                    ? const Center(
                        child: Text(
                          'No programs found',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          AppConstants.paddingLarge,
                          0,
                          AppConstants.paddingLarge,
                          16,
                        ),
                        itemCount: filteredPrograms.length,
                        itemBuilder: (context, index) {
                          final program = filteredPrograms[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ProgramCard(
                              program: program,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ProgramDetailsScreen(
                                      programId: program.id,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
