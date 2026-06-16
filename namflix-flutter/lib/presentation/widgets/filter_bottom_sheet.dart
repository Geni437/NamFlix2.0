import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/country.dart';

class FilterOptions {
  final String? country;
  final String? language;
  final List<String> categories;
  final bool liveOnly;
  final String sort;

  const FilterOptions({
    this.country,
    this.language,
    this.categories = const [],
    this.liveOnly = false,
    this.sort = 'name_asc',
  });

  FilterOptions copyWith({
    String? country,
    String? language,
    List<String>? categories,
    bool? liveOnly,
    String? sort,
    bool clearCountry = false,
    bool clearLanguage = false,
  }) => FilterOptions(
    country: clearCountry ? null : (country ?? this.country),
    language: clearLanguage ? null : (language ?? this.language),
    categories: categories ?? this.categories,
    liveOnly: liveOnly ?? this.liveOnly,
    sort: sort ?? this.sort,
  );
}

class FilterBottomSheet extends StatefulWidget {
  final FilterOptions current;
  final List<Category> categories;
  final List<Country> countries;
  final List<Country> languages;

  const FilterBottomSheet({
    super.key,
    required this.current,
    required this.categories,
    required this.countries,
    required this.languages,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late FilterOptions _options;

  static const _sortOptions = [
    ('name_asc', 'Name A–Z'),
    ('name_desc', 'Name Z–A'),
    ('trending', 'Trending'),
    ('newest', 'Newest'),
  ];

  @override
  void initState() {
    super.initState();
    _options = widget.current;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text('Filters', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(() => _options = const FilterOptions()),
                    child: const Text('Reset', style: TextStyle(color: AppColors.accentRed)),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.border, height: 1),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  _SectionLabel('Sort By'),
                  Wrap(
                    spacing: 8,
                    children: _sortOptions.map((opt) => ChoiceChip(
                      label: Text(opt.$2),
                      selected: _options.sort == opt.$1,
                      onSelected: (_) => setState(() => _options = _options.copyWith(sort: opt.$1)),
                      selectedColor: AppColors.accentRed,
                      labelStyle: TextStyle(
                        color: _options.sort == opt.$1 ? Colors.white : AppColors.textSecondary,
                        fontSize: 13,
                      ),
                      backgroundColor: AppColors.surfaceElevated,
                      side: BorderSide.none,
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                  _SectionLabel('Options'),
                  SwitchListTile(
                    title: const Text('Live Only', style: TextStyle(color: AppColors.textPrimary, fontSize: 14)),
                    value: _options.liveOnly,
                    onChanged: (v) => setState(() => _options = _options.copyWith(liveOnly: v)),
                    activeColor: AppColors.accentRed,
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (widget.countries.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _SectionLabel('Country'),
                    _DropdownFilter(
                      label: 'All Countries',
                      value: _options.country,
                      items: widget.countries.map((c) => (c.code, c.name)).toList(),
                      onChanged: (v) => setState(() =>
                          v == null ? _options = _options.copyWith(clearCountry: true)
                          : _options = _options.copyWith(country: v)),
                    ),
                  ],
                  if (widget.languages.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _SectionLabel('Language'),
                    _DropdownFilter(
                      label: 'All Languages',
                      value: _options.language,
                      items: widget.languages.map((l) => (l.code, l.name)).toList(),
                      onChanged: (v) => setState(() =>
                          v == null ? _options = _options.copyWith(clearLanguage: true)
                          : _options = _options.copyWith(language: v)),
                    ),
                  ],
                  if (widget.categories.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _SectionLabel('Categories'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: widget.categories.map((cat) {
                        final selected = _options.categories.contains(cat.id);
                        return FilterChip(
                          label: Text(cat.name),
                          selected: selected,
                          onSelected: (_) {
                            final updated = List<String>.from(_options.categories);
                            selected ? updated.remove(cat.id) : updated.add(cat.id);
                            setState(() => _options = _options.copyWith(categories: updated));
                          },
                          selectedColor: AppColors.accentRed,
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : AppColors.textSecondary,
                            fontSize: 12,
                          ),
                          backgroundColor: AppColors.surfaceElevated,
                          side: BorderSide.none,
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(_options),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
  );
}

class _DropdownFilter extends StatelessWidget {
  final String label;
  final String? value;
  final List<(String, String)> items;
  final ValueChanged<String?> onChanged;

  const _DropdownFilter({required this.label, this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
    value: value,
    decoration: InputDecoration(
      filled: true,
      fillColor: AppColors.surfaceElevated,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
    dropdownColor: AppColors.surfaceElevated,
    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
    hint: Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 14)),
    items: [
      DropdownMenuItem(value: null, child: Text(label, style: const TextStyle(color: AppColors.textMuted))),
      ...items.map((item) => DropdownMenuItem(value: item.$1, child: Text(item.$2))),
    ],
    onChanged: onChanged,
  );
}
