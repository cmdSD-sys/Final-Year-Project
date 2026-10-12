import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Reusable helper to display an interactive Material calendar date picker
/// and format the selected date to DD/MM/YYYY (or DD-MM-YYYY).
Future<void> showCmDatePicker({
  required BuildContext context,
  required TextEditingController controller,
  String format = 'dd/MM/yyyy',
  DateTime? firstDate,
  DateTime? lastDate,
  ValueChanged<String>? onChanged,
}) async {
  DateTime initial = DateTime.now();
  final text = controller.text.trim();

  if (text.isNotEmpty) {
    try {
      final parts = text.split(RegExp(r'[-/]'));
      if (parts.length == 3) {
        int d = int.parse(parts[0]);
        int m = int.parse(parts[1]);
        int y = int.parse(parts[2]);
        if (d > 1900) {
          // Format was YYYY-MM-DD
          final temp = d;
          d = y;
          y = temp;
        }
        if (y >= 1990 && y <= 2050 && m >= 1 && m <= 12 && d >= 1 && d <= 31) {
          initial = DateTime(y, m, d);
        }
      }
    } catch (_) {}
  }

  final picked = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: firstDate ?? DateTime(1990),
    lastDate: lastDate ?? DateTime(2040),
    builder: (ctx, child) {
      final p = Pal.of(context);
      return Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: p.brand,
            onPrimary: p.onBrand,
            surface: p.surface,
            onSurface: p.ink,
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: p.surface,
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    final d = picked.day.toString().padLeft(2, '0');
    final m = picked.month.toString().padLeft(2, '0');
    final y = picked.year.toString();
    final result = format == 'dd-MM-yyyy' ? '$d-$m-$y' : '$d/$m/$y';
    controller.text = result;
    onChanged?.call(result);
  }
}

/// A standardized form text field for date inputs with an interactive calendar picker.
class CmDateField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool isMandatory;
  final String format;
  final ValueChanged<String>? onChanged;

  const CmDateField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText = 'DD/MM/YYYY',
    this.isMandatory = false,
    this.format = 'dd/MM/yyyy',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);

    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => showCmDatePicker(
        context: context,
        controller: controller,
        format: format,
        onChanged: onChanged,
      ),
      style: TextStyle(fontSize: 13.5, color: p.ink),
      decoration: InputDecoration(
        labelText: isMandatory ? '$label *' : label,
        hintText: hintText,
        hintStyle: TextStyle(color: p.inkMuted, fontSize: 13),
        filled: true,
        fillColor: p.surfaceAlt,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: p.rule),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: p.rule),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: p.brand, width: 1.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today, size: 18, color: p.brand),
          tooltip: 'Choose date from calendar',
          onPressed: () => showCmDatePicker(
            context: context,
            controller: controller,
            format: format,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
