import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../providers/note_list_provider.dart';
import '../providers/source_list_provider.dart';
import '../data/models/source.dart';
import '../data/models/note.dart';

class AddNoteScreen extends HookConsumerWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final contentController = useTextEditingController();
    final sourceController = useTextEditingController();
    final urlController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final sourceList = ref.watch(sourceListProvider);
    final selectedSource = useState<Source?>(null);
    final isNewSource = useState<bool>(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('メモを追加'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'タイトル',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'メモの内容',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              const Text('引用情報',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              sourceList.when(
                data: (sources) => DropdownButtonFormField<Source?>(
                  value: selectedSource.value,
                  decoration: InputDecoration(
                    labelText: '引用元',
                    border: const OutlineInputBorder(),
                    suffixIcon: selectedSource.value != null
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              selectedSource.value = null;
                              sourceController.clear();
                              urlController.clear();
                              descriptionController.clear();
                              isNewSource.value = false;
                            },
                          )
                        : null,
                  ),
                  items: [
                    const DropdownMenuItem<Source?>(
                      value: null,
                      child: Text('新規入力'),
                    ),
                    ...sources.map((source) {
                      return DropdownMenuItem(
                        value: source,
                        child: Text(source.title),
                      );
                    }),
                  ],
                  onChanged: (Source? value) {
                    selectedSource.value = value;
                    if (value != null) {
                      sourceController.text = value.title;
                      urlController.text = value.url ?? '';
                      descriptionController.text = value.description ?? '';
                      isNewSource.value = false;
                    } else {
                      sourceController.clear();
                      urlController.clear();
                      descriptionController.clear();
                      isNewSource.value = true;
                    }
                  },
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),
              const SizedBox(height: 16),
              if (selectedSource.value == null) ...[
                TextField(
                  controller: sourceController,
                  decoration: const InputDecoration(
                    labelText: '引用元のタイトル',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextField(
                controller: urlController,
                enabled: selectedSource.value == null,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                enabled: selectedSource.value == null,
                decoration: const InputDecoration(
                  labelText: '詳細',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (contentController.text.isNotEmpty) {
                    int? sourceId = selectedSource.value?.id;

                    if (selectedSource.value == null &&
                        sourceController.text.isNotEmpty) {
                      final source =
                          await ref.read(sourceListProvider.notifier).addSource(
                                title: sourceController.text,
                                url: urlController.text.isEmpty
                                    ? null
                                    : urlController.text,
                                description: descriptionController.text.isEmpty
                                    ? null
                                    : descriptionController.text,
                              );
                      sourceId = source.id;
                    }

                    final note = Note.create(
                      title: titleController.text.isEmpty
                          ? null
                          : titleController.text,
                      content: contentController.text,
                      sourceId: sourceId,
                    );

                    await ref.read(noteListProvider.notifier).addNote(note);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
