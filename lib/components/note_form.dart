import 'package:flutter/material.dart';
import '../data/models/source.dart';
import 'source_dropdown.dart';

class NoteForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final Source? selectedSource;
  final List<Source> sources;
  final Function(Source?) onSourceChanged;
  final Function(String) onTitleChanged;
  final Function(String) onContentChanged;

  const NoteForm({
    Key? key,
    required this.titleController,
    required this.contentController,
    required this.selectedSource,
    required this.sources,
    required this.onSourceChanged,
    required this.onTitleChanged,
    required this.onContentChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'タイトル',
            border: OutlineInputBorder(),
          ),
          onChanged: onTitleChanged,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: contentController,
          decoration: const InputDecoration(
            labelText: 'メモの内容',
            border: OutlineInputBorder(),
          ),
          maxLines: 10,
          onChanged: onContentChanged,
        ),
        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 16),
        const Text('引用情報',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SourceDropdown(
          value: selectedSource,
          sources: sources,
          onChanged: onSourceChanged,
          labelText: '引用元',
        ),
        if (selectedSource != null) ...[
          const SizedBox(height: 16),
          Text(
            'URL: ${selectedSource?.url ?? "なし"}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '詳細: ${selectedSource?.description ?? "なし"}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}
