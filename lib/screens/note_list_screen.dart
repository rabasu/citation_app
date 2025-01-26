import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../providers/source_list_provider.dart';
import '../providers/note_list_provider.dart';
import '../constants/colors.dart';
import '../data/models/source.dart';
import 'add_note_screen.dart';
import 'edit_note_screen.dart';

class NoteListScreen extends HookConsumerWidget {
  const NoteListScreen({Key? key}) : super(key: key);

  String _getTitleFromContent(String content) {
    final firstLine = content.split('\n').first;
    return firstLine.length > 50
        ? '${firstLine.substring(0, 47)}...'
        : firstLine;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteList = ref.watch(noteListProvider);
    final sourceList = ref.watch(sourceListProvider);
    final searchController = useTextEditingController();
    final selectedSource = useState<Source?>(null);
    final isSearching = useState(false);

    void performSearch() async {
      final notes = await ref
          .read(noteListProvider.notifier)
          .searchNotes(searchController.text, source: selectedSource.value);
      ref.read(noteListProvider.notifier).state = AsyncValue.data(notes);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Research Notes',
          style: TextStyle(fontFamily: 'Times New Roman'),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        bottom: isSearching.value
            ? PreferredSize(
                preferredSize: const Size.fromHeight(96),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '検索...',
                          hintStyle: const TextStyle(color: Colors.white70),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.white70),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.white70),
                                  onPressed: () {
                                    searchController.clear();
                                    performSearch();
                                  },
                                )
                              : null,
                        ),
                        onChanged: (_) => performSearch(),
                      ),
                      const SizedBox(height: 8),
                      sourceList.when(
                        data: (sources) => DropdownButtonFormField<Source?>(
                          value: selectedSource.value,
                          dropdownColor: AppColors.primary,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70),
                            ),
                          ),
                          items: [
                            const DropdownMenuItem<Source?>(
                              value: null,
                              child: Text(
                                '全ての引用元',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ...sources.map((source) =>
                                DropdownMenuItem<Source?>(
                                  value: source,
                                  child: Text(
                                    source.title,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )),
                          ],
                          onChanged: (Source? value) {
                            selectedSource.value = value;
                            performSearch();
                          },
                        ),
                        loading: () => const SizedBox(),
                        error: (_, __) => const SizedBox(),
                      ),
                    ],
                  ),
                ),
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(isSearching.value ? Icons.close : Icons.search),
            onPressed: () {
              isSearching.value = !isSearching.value;
              if (!isSearching.value) {
                searchController.clear();
                selectedSource.value = null;
                ref.read(noteListProvider.notifier).refresh();
              }
            },
          ),
          if (!isSearching.value)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.read(noteListProvider.notifier).refresh(),
            ),
        ],
      ),
      body: noteList.when(
        data: (notes) => notes.isEmpty
            ? Center(
                child: Text(
                  '検索結果がありません',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    elevation: 2,
                    color: AppColors.cardBackground,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditNoteScreen(note: note),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              note.title ?? _getTitleFromContent(note.content),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontFamily: 'Times New Roman',
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                note.content,
                                style:
                                    TextStyle(color: AppColors.textSecondary),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: AppColors.textSecondary,
                              onPressed: () => ref
                                  .read(noteListProvider.notifier)
                                  .deleteNote(note.id),
                            ),
                          ),
                          if (note.sourceId != null)
                            sourceList.when(
                              data: (sources) {
                                final source = sources.firstWhere(
                                  (s) => s.id == note.sourceId,
                                  orElse: () =>
                                      throw Exception('Source not found'),
                                );
                                return InkWell(
                                  onTap: () {
                                    selectedSource.value = source;
                                    isSearching.value = true;
                                    performSearch();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.format_quote,
                                            color: AppColors.primaryLight,
                                            size: 16),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            source.title,
                                            style: const TextStyle(
                                              color: AppColors.primaryLight,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              loading: () => const SizedBox(),
                              error: (_, __) => const SizedBox(),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error',
              style: TextStyle(color: AppColors.textSecondary)),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddNoteScreen()),
        ),
      ),
    );
  }
}
