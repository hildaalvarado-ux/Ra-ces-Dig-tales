import 'package:flutter/material.dart';
import '../main.dart';

class SearchableMultiSelect extends StatefulWidget {
  final String title;
  final List<String> options;
  final List<String> initialSelected;
  final Function(List<String>) onSelected;
  final String hintText;

  const SearchableMultiSelect({
    super.key,
    required this.title,
    required this.options,
    required this.initialSelected,
    required this.onSelected,
    this.hintText = 'Buscar o agregar...',
  });

  @override
  State<SearchableMultiSelect> createState() => _SearchableMultiSelectState();
}

class _SearchableMultiSelectState extends State<SearchableMultiSelect> {
  late List<String> _selected;
  final TextEditingController _searchCtrl = TextEditingController();
  late List<String> _filteredOptions;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.initialSelected);
    _filteredOptions = _getFilteredOptions('');
  }

  List<String> _getFilteredOptions(String query) {
    final q = query.trim().toLowerCase();
    final allOptions = {...widget.options, ..._selected}.toList();
    if (q.isEmpty) return allOptions;
    return allOptions.where((o) => o.toLowerCase().contains(q)).toList();
  }

  void _toggle(String option) {
    setState(() {
      if (_selected.contains(option)) {
        _selected.remove(option);
      } else {
        _selected.add(option);
      }
      widget.onSelected(_selected);
    });
  }

  void _addNew(String name) {
    final clean = name.trim();
    if (clean.isEmpty) return;
    if (!_selected.contains(clean)) {
      setState(() {
        _selected.add(clean);
        _searchCtrl.clear();
        _filteredOptions = _getFilteredOptions('');
        widget.onSelected(_selected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            widget.title,
            style: const TextStyle(
              color: AppColors.greenDarker,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.greenDark.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => _addNew(_searchCtrl.text),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (v) => setState(() {
                    _filteredOptions = _getFilteredOptions(v);
                  }),
                  onSubmitted: _addNew,
                ),
              ),
              if (_selected.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Wrap(
                    spacing: 8,
                    children: _selected.map((s) => Chip(
                      label: Text(s, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      backgroundColor: AppColors.greenDark.withOpacity(0.1),
                      deleteIcon: const Icon(Icons.close, size: 14),
                      onDeleted: () => _toggle(s),
                    )).toList(),
                  ),
                ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredOptions.length,
                  itemBuilder: (context, index) {
                    final option = _filteredOptions[index];
                    final isSelected = _selected.contains(option);
                    return CheckboxListTile(
                      title: Text(option),
                      value: isSelected,
                      activeColor: AppColors.greenDark,
                      onChanged: (_) => _toggle(option),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CopyrightFooter extends StatelessWidget {
  const CopyrightFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Centro Universitario Regional de Cabañas',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.greenDarker,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '© 2026 Raíces Digitales',
              style: TextStyle(
                color: AppColors.greenSoft,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
