
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/journal_entry.dart';
import '../theme/app_theme.dart';
import 'entry_form_screen.dart';
import '../services/journal_api_service.dart';

class EntryDetailScreen extends StatefulWidget {
  final JournalEntry entry;

  const EntryDetailScreen({
    super.key,
    required this.entry,
  });

  @override
  State<EntryDetailScreen> createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen> {
  late JournalEntry _entry;
  final JournalApiService _api = JournalApiService();

  @override
  void initState() {
    super.initState();
    _entry = widget.entry;
  }

  Future<void> _editEntry() async {
    final result = await Navigator.push<JournalEntry>(
      context,
      MaterialPageRoute(
        builder: (_) => EntryFormScreen(entry: _entry),
      ),
    );

    if (!mounted || result == null) return;

    setState(() => _entry = result);

    // Return the updated entry to the home screen.
    Navigator.pop(context, result);
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this entry?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    final id = _entry.id;

    debugPrint('Entry title: ${_entry.title}');
    debugPrint('Entry ID: $id');
    debugPrint('Entry ID type: ${id.runtimeType}');

    if (id == null ||
        id.isEmpty ||
        id == 'null' ||
        !RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid journal entry ID. Check the API response.'),
        ),
      );
      return;
    }

    try {
      await _api.deleteEntry(id);

      if (!mounted) return;

      Navigator.pop(context, _entry.copyWith(title: '__DELETE__'));
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete entry: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat(
      'EEEE, dd MMMM yyyy',
    ).format(_entry.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal entry'),
        actions: [
          IconButton(
            tooltip: 'Edit entry',
            onPressed: _editEntry,
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Delete entry',
            onPressed: _confirmDelete,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'PERSONAL JOURNAL',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _entry.title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppTheme.secondaryText,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Divider(color: AppTheme.border),
              const SizedBox(height: 24),
              Text(
                _entry.content,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 17,
                  height: 1.9,
                ),
              ),
              const SizedBox(height: 40),
              OutlinedButton.icon(
                onPressed: _editEntry,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit this entry'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  side: const BorderSide(color: AppTheme.primary),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
