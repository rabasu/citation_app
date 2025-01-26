import 'package:flutter/material.dart';
import '../data/models/source.dart';

class SourceDropdown extends StatelessWidget {
  final Source? value;
  final List<Source> sources;
  final Function(Source?) onChanged;
  final bool isSearchMode;
  final String? labelText;

  const SourceDropdown({
    Key? key,
    required this.value,
    required this.sources,
    required this.onChanged,
    this.isSearchMode = false,
    this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Source?>(
      value: value,
      dropdownColor: isSearchMode ? Theme.of(context).primaryColor : null,
      decoration: InputDecoration(
        labelText: labelText,
        isDense: isSearchMode,
        contentPadding:
            isSearchMode ? const EdgeInsets.symmetric(horizontal: 8) : null,
        enabledBorder: isSearchMode
            ? const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              )
            : null,
      ),
      items: [
        DropdownMenuItem<Source?>(
          value: null,
          child: Text(
            isSearchMode ? '全ての引用元' : '引用元なし',
            style: TextStyle(
              color: isSearchMode ? Colors.white : null,
            ),
          ),
        ),
        ...sources.map((source) => DropdownMenuItem<Source?>(
              value: source,
              child: Text(
                source.title,
                style: TextStyle(
                  color: isSearchMode ? Colors.white : null,
                ),
              ),
            )),
      ],
      onChanged: onChanged,
    );
  }
}
