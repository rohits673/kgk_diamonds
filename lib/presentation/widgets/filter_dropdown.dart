import 'package:flutter/material.dart';
import 'package:kgk_diamonds/core/theme/app_theme.dart';

class FilterDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const FilterDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: value,
              menuMaxHeight: 300,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: "Type in your text",
              ),
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              dropdownColor: AppTheme.backgroundColor,
              icon: const Icon(Icons.keyboard_arrow_down),
              borderRadius: BorderRadius.circular(12),
              style: Theme.of(context).textTheme.bodyMedium,
              hint: Text(
                'Select $label',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
