import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../providers/note_list_provider.dart';
import '../providers/source_list_provider.dart';
import '../constants/colors.dart';
import '../data/models/note.dart';
import '../data/models/source.dart';
import 'dart:async';

class EditNoteScreen extends HookConsumerWidget {
  final Note note;
  const EditNoteScreen({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController(text: note.title);
    final contentController = useTextEditingController(text: note.content);
    final sourceList = ref.watch(sourceListProvider);
    final selectedSource = useState<Source?>(null);
    final Timer? autoSaveTimer = null;
    final hasChanges = useState(false);

    useEffect(() {
      if (note.sourceId != null) {
        sourceList.whenData((sources) {
          final source = sources.firstWhere(
            (s) => s.id == note.sourceId,
            orElse: () => throw Exception('Source not found'),
          );
          selectedSource.value = source;
        });
      }
      return null;
    }, []);

    // 自動保存のタイマー設定
    useEffect(() {
      void saveChanges() async {
        if (hasChanges.value) {
          final updatedNote = note.copyWith(
            title: titleController.text.isEmpty ? null : titleController.text,
            content: contentController.text,
            sourceId: selectedSource.value?.id,
          );
          await ref.read(noteListProvider.notifier).updateNote(updatedNote);
          hasChanges.value = false;
        }
      }

      final timer =
          Timer.periodic(const Duration(seconds: 2), (_) => saveChanges());
      return () => timer.cancel();
    }, []);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'メモを編集',
          style: TextStyle(fontFamily: 'Times New Roman'),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'タイトル',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => hasChanges.value = true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: 'メモの内容',
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
              onChanged: (_) => hasChanges.value = true,
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
                decoration: const InputDecoration(
                  labelText: '引用元',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem<Source?>(
                    value: null,
                    child: Text('引用元なし'),
                  ),
                  ...sources.map((source) => DropdownMenuItem(
                        value: source,
                        child: Text(source.title),
                      )),
                ],
                onChanged: (Source? value) {
                  selectedSource.value = value;
                  hasChanges.value = true;
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('引用元の読み込みに失敗しました'),
            ),
            if (selectedSource.value != null) ...[
              const SizedBox(height: 16),
              Text(
                'URL: ${selectedSource.value?.url ?? "なし"}',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                '詳細: ${selectedSource.value?.description ?? "なし"}',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
