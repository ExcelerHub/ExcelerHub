import 'package:flutter/material.dart';
import '../services/mock_database.dart';
import '../models/program_model.dart';
import '../utils/app_colors.dart';
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

  bool _matchesCategory(ProgramModel program, String category) {
    if (category == 'All') return true;
    if (category == 'Mobile') {
      return program.title.toLowerCase().contains('flutter') ||
          program.title.toLowerCase().contains('android') ||
          program.title.toLowerCase().contains('mobile');
    }
    if (category == 'Design') {
      return program.title.toLowerCase().contains('design') ||
          program.title.toLowerCase().contains('ux');
    }
    if (category == 'Data') {
      return program.title.toLowerCase().contains('data') ||
          program.title.toLowerCase().contains('ai') ||
          program.title.toLowerCase().contains('learning');
    }
    return true;
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
            return matchesQuery && _matchesCategory(p, _selectedCategory);
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search programs',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textLight,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: AppColors.textLight,
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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: ['All', 'Mobile', 'Design', 'Data'].map((category) {
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
                          fontSize: 13,
                        ),
                        selectedColor: AppColors.primary,
                        backgroundColor: const Color(0xfff8fafc),
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
              Expanded(
                child: filteredPrograms.isEmpty
                    ? const Center(
                        child: Text(
                          'No programs found',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filteredPrograms.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final program = filteredPrograms[index];
                          return ProgramCard(
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
