
import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/journal_entry_card.dart';
import '../services/journal_api_service.dart';
import '../widgets/search_field.dart';
import 'entry_detail_screen.dart';
import 'entry_form_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<JournalEntry> _entries = [];

  bool _isLoading = true;
  String? _loadError;

  final JournalApiService _api = JournalApiService();

  String _searchQuery = '';

  List<JournalEntry> get _filteredEntries {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) return _entries;

    return _entries.where((entry) {
      return entry.title.toLowerCase().contains(query) ||
          entry.content.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _createEntry() async {
    final result = await Navigator.push<JournalEntry>(
      context,
      MaterialPageRoute(
        builder: (_) => const EntryFormScreen(),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _entries.insert(0, result);
    });
  }


  Future<void> _openEntry(JournalEntry entry) async {
    final result = await Navigator.push<JournalEntry>(
      context,
      MaterialPageRoute(
        builder: (_) => EntryDetailScreen(entry: entry),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      if (result.title == '__DELETE__') {
        _entries.removeWhere((item) => item.id == result.id);
      } else {
        final index = _entries.indexWhere(
              (item) => item.id == result.id,
        );

        if (index != -1) {
          _entries[index] = result;
        }
      }
    });
  }


  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchScreen(entries: List.of(_entries)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }

    try {
      final entries = await _api.getAllEntries();

      if (!mounted) return;

      setState(() {
        _entries
          ..clear()
          ..addAll(entries);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadError = 'Could not load your journal entries.';
        _isLoading = false;
      });

      debugPrint('Failed to load journal entries: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = _filteredEntries;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'kitaab.',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 25,
                          letterSpacing: -0.7,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Browse entries',
                        onPressed: _openSearch,
                        icon: const Icon(Icons.grid_view_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 38),
                  Text(
                    'YOUR PERSONAL SPACE',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Every thought\nhas a place.',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'A quiet corner for your ideas, memories, and everyday reflections.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _createEntry,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Write a new entry'),
                  ),
                  const SizedBox(height: 34),
                  SearchField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Your journal',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      Text(
                        '${_entries.length} ${_entries.length == 1 ? 'entry' : 'entries'}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Little moments, collected over time.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_loadError != null)
                    EmptyState(
                      icon: Icons.cloud_off_rounded,
                      title: 'Unable to load entries',
                      message: _loadError!,
                      buttonText: 'Try again',
                      onButtonPressed: _loadEntries,
                    )
                  else if (entries.isEmpty)
                      EmptyState(
                        icon: _searchQuery.trim().isNotEmpty
                            ? Icons.search_off_rounded
                            : Icons.menu_book_rounded,
                        title: _searchQuery.trim().isNotEmpty
                            ? 'No entries found'
                            : 'Your journal is empty',
                        message: _searchQuery.trim().isNotEmpty
                            ? 'Try a different search.'
                            : 'Start collecting your thoughts with your first entry.',
                        buttonText: 'Write an entry',
                        onButtonPressed: _createEntry,
                      )
                    else
                      ...entries.map(
                            (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: JournalEntryCard(
                            entry: entry,
                            onTap: () => _openEntry(entry),
                          ),
                        ),
                      ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'MADE FOR YOUR THOUGHTS',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.secondaryText,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
