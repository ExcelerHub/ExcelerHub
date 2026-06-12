import 'package:flutter/material.dart';
import '../services/mock_database.dart';
import '../models/program_model.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/program_card.dart';
import 'program_details_screen.dart';

class ProgramListingScreen extends StatefulWidget {
  final bool autoFocusSearch;

  const ProgramListingScreen({
    super.key,
    this.autoFocusSearch = false,
  });

  @override
  State<ProgramListingScreen> createState() => _ProgramListingScreenState();
}

class _ProgramListingScreenState extends State<ProgramListingScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _searchQuery = '';
  String _selectedCategory = 'All'; // Categories: 'All', 'Joined', 'Design', 'Mobile', 'Data & AI'

  @override
  void initState() {
    super.initState();
    if (widget.autoFocusSearch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Get matching category for filtering
  bool _matchesCategory(ProgramModel program, String category) {
    if (category == 'All') return true;
    
    // Check if user has joined this program
    final user = MockDatabase.instance.users.firstWhere((u) => u.joinedPrograms.contains(program.id), orElse: () => MockDatabase.instance.users.first);
    
    if (category == 'Joined') {
      return program.joinedUsers.contains(user.id);
    }
    if (category == 'Design') {
      return program.title.toLowerCase().contains('design') || program.title.toLowerCase().contains('ux');
    }
    if (category == 'Mobile') {
      return program.title.toLowerCase().contains('flutter') || program.title.toLowerCase().contains('android') || program.title.toLowerCase().contains('mobile');
    }
    if (category == 'Data & AI') {
      return program.title.toLowerCase().contains('learning') || program.title.toLowerCase().contains('data') || program.title.toLowerCase().contains('ai') || program.title.toLowerCase().contains('science');
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Programs & Internships'),
      body: ListenableBuilder(
        listenable: MockDatabase.instance,
        builder: (context, _) {
          final allPrograms = MockDatabase.instance.programs;
          
          // Apply search query and category filters
          final filteredPrograms = allPrograms.where((p) {
            final matchesQuery = p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.mentor.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.skills.any((s) => s.toLowerCase().contains(_searchQuery.toLowerCase()));
            
            final matchesCat = _matchesCategory(p, _selectedCategory);
            
            return matchesQuery && matchesCat;
          }).toList();

          return Column(
            children: [
              // Search Input Row
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search programs, skills, or mentors...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                ),
              ),
              
              // Category filter horizontal chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: ['All', 'Joined', 'Mobile', 'Data & AI', 'Design'].map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(category),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white,
                        checkmarkColor: Colors.white,
                        side: BorderSide(
                          color: isSelected ? Colors.transparent : Colors.grey.shade200,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              // Program List
              Expanded(
                child: filteredPrograms.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_outlined,
                              size: 64,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No programs found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Try adjusting your search query or filters',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filteredPrograms.length,
                        itemBuilder: (context, index) {
                          final prog = filteredPrograms[index];
                          return ProgramCard(
                            program: prog,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProgramDetailsScreen(programId: prog.id),
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
