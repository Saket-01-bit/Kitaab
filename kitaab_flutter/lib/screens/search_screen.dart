
import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/journal_entry_card.dart';
import '../widgets/search_field.dart';
import 'entry_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<JournalEntry> entries;

  const SearchScreen({
    super.key,
    required this.entries,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  List<JournalEntry> get _results {
    final query = _query.trim().toLowerCase();

    if (query.isEmpty) return widget.entries;

    return widget.entries.where((entry) {
      return entry.title.toLowerCase().contains(query) ||
          entry.content.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openEntry(JournalEntry entry) async {
    await Navigator.push<JournalEntry>(
      context,
      MaterialPageRoute(
        builder: (_) => EntryDetailScreen(entry: entry),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse journal'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find a thought.',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Search through your saved moments and ideas.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 22),
              SearchField(
                controller: _controller,
                hintText: 'Search titles and content...',
                onChanged: (value) {
                  setState(() => _query = value);
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _query.trim().isEmpty
                          ? 'All entries'
                          : 'Search results',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Text(
                    '${results.length} found',
                    style: const TextStyle(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: results.isEmpty
                    ? const EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'Nothing came up',
                  message:
                  'Try another keyword to find the entry you need.',
                )
                    : ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final entry = results[index];

                    return JournalEntryCard(
                      entry: entry,
                      onTap: () => _openEntry(entry),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
