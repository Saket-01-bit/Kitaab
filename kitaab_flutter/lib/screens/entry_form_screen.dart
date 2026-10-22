import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../theme/app_theme.dart';
import '../services/journal_api_service.dart';

class EntryFormScreen extends StatefulWidget {
  final JournalEntry? entry;

  const EntryFormScreen({super.key, this.entry});

  @override
  State<EntryFormScreen> createState() => _EntryFormScreenState();
}

class _EntryFormScreenState extends State<EntryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  bool get _isEditing => widget.entry != null;
  final JournalApiService _api = JournalApiService();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.entry?.title ?? '');

    _contentController = TextEditingController(
      text: widget.entry?.content ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate() || _isSaving) return;

    setState(() => _isSaving = true);

    final entry = JournalEntry(
      id: widget.entry?.id,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      createdAt: widget.entry?.createdAt ?? DateTime.now(),
    );

    try {
      final savedEntry;

      if (_isEditing) {
        final id = entry.id;

        if (id == null || id.isEmpty) {
          throw Exception('This entry has no valid server ID.');
        }

        savedEntry = await _api.updateEntry(id, entry);
      } else {
        savedEntry = await _api.createEntry(entry);
      }

      if (!mounted) return;
      Navigator.pop(context, savedEntry);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not save entry: $error')));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit entry' : 'New entry')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
            children: [
              Text(
                _isEditing ? 'Refine your thoughts.' : 'A page of your own.',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                _isEditing
                    ? 'Your story can change as you do.'
                    : 'Write freely. This space belongs to you.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppTheme.secondaryText),
              ),
              const SizedBox(height: 32),
              const Text(
                'TITLE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 100,
                decoration: const InputDecoration(
                  hintText: 'Give this entry a title...',
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 28),
              const Text(
                'YOUR THOUGHTS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _contentController,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                minLines: 10,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText:
                      'Start writing here...\n\nThere is no right or wrong way to begin.',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please write something in your entry.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveEntry,
                icon: _isSaving
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Icon(
                  _isEditing
                      ? Icons.check_rounded
                      : Icons.bookmark_add_outlined,
                ),
                label: Text(
                  _isSaving
                      ? 'Saving...'
                      : _isEditing
                      ? 'Save changes'
                      : 'Save entry',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
