import 'package:flutter/material.dart';
import '../data/models/note.dart';
import '../data/models/source.dart';
import '../constants/colors.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final Source? source;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onSourceTap;
  final String Function(String) getTitleFromContent;

  const NoteCard({
    Key? key,
    required this.note,
    this.source,
    required this.onTap,
    required this.onDelete,
    this.onSourceTap,
    required this.getTitleFromContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      color: AppColors.cardBackground,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                note.title ?? getTitleFromContent(note.content),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  note.content,
                  style: TextStyle(color: AppColors.textSecondary),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                color: AppColors.textSecondary,
                onPressed: onDelete,
              ),
            ),
            if (source != null)
              InkWell(
                onTap: onSourceTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.format_quote,
                          color: AppColors.primaryLight, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          source!.title,
                          style: const TextStyle(
                            color: AppColors.primaryLight,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
