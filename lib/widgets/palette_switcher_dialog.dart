import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

/// Modal dialog allowing users to switch between the 6 collegiate color palettes
/// and preview them in both Light and Dark modes.
class PaletteSwitcherDialog extends StatelessWidget {
  final AppState appState;

  const PaletteSwitcherDialog({super.key, required this.appState});

  static void show(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (_) => PaletteSwitcherDialog(appState: appState),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final pal = Pal.of(context);
        final isDark = appState.isDarkMode;

        return AlertDialog(
          backgroundColor: pal.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: pal.rule),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          actionsPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          title: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: pal.brandTint,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.palette_outlined, color: pal.brand, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'College Color Palette',
                      style: AppType.display(pal.ink, size: 20, height: 1.2),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Select a collegiate color scheme for the portal',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: pal.inkMuted,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Light / Dark mode quick toggle banner
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: pal.surfaceAlt,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: pal.rule),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isDark ? Icons.dark_mode : Icons.light_mode,
                              size: 18,
                              color: isDark ? pal.ochre : pal.brand,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isDark ? 'Dark Mode Active' : 'Light Mode Active',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: pal.ink,
                                  ),
                                ),
                                Text(
                                  isDark ? 'High contrast low-light' : 'Institutional clean light',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: pal.inkMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Switch(
                          value: isDark,
                          onChanged: (_) => appState.toggleTheme(),
                          activeThumbColor: pal.brand,
                        ),
                      ],
                    ),
                  ),

                  // Palette Options
                  Text(
                    'Available Themes (6 Institutional Schemes)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: pal.inkMuted,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  ...AppTheme.paletteList.map((meta) {
                    final isSelected = appState.currentPalette == meta.id;
                    final samplePal = AppTheme.getPalette(meta.id, isDark: isDark);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? samplePal.brandTint.withValues(alpha: 0.45)
                            : pal.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? samplePal.brand : pal.rule,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => appState.setPalette(meta.id),
                        borderRadius: BorderRadius.circular(7),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              // Color Swatch Circles
                              Row(
                                children: [
                                  Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: meta.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.6),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: meta.primary.withValues(alpha: 0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: meta.deep,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.4),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 14),

                              // Title and description
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          meta.name,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                            color: isSelected ? samplePal.brand : pal.ink,
                                          ),
                                        ),
                                        if (meta.id == AppPaletteId.teal) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: pal.brandTint,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              'College Default',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: pal.brand,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      meta.description,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: pal.inkSoft,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Active checkmark or selection radio
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? samplePal.brand : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected ? samplePal.brand : pal.ruleStrong,
                                    width: 1.5,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: pal.brand,
                foregroundColor: pal.onBrand,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}
