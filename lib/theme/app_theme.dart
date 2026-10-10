import 'package:flutter/material.dart';

/// Colour tokens for the faculty portal.
///
/// The palette is taken from the college seal (a cerulean teal, ~#1281B0) and
/// kept deliberately narrow: one brand hue, one warm accent for "admin"
/// authority, one plum for "super admin", and semantic success / danger.
/// Everything else is a cool neutral so the data, not the chrome, carries
/// the page.
enum AppPaletteId {
  teal,
  navy,
  forest,
  crimson,
  indigo,
  graphite,
}

class AppPaletteMeta {
  final AppPaletteId id;
  final String name;
  final String description;
  final Color primary;
  final Color deep;

  const AppPaletteMeta({
    required this.id,
    required this.name,
    required this.description,
    required this.primary,
    required this.deep,
  });
}

class PalThemeExtension extends ThemeExtension<PalThemeExtension> {
  final Pal pal;

  const PalThemeExtension({required this.pal});

  @override
  PalThemeExtension copyWith({Pal? pal}) => PalThemeExtension(pal: pal ?? this.pal);

  @override
  PalThemeExtension lerp(ThemeExtension<PalThemeExtension>? other, double t) {
    if (other is! PalThemeExtension) return this;
    return this;
  }
}

class Pal {
  final Brightness brightness;

  /// Page background.
  final Color paper;

  /// Panels, dialogs, app bar.
  final Color surface;

  /// Read-only fields, quiet fills.
  final Color surfaceAlt;

  /// Primary text.
  final Color ink;

  /// Labels and secondary text.
  final Color inkSoft;

  /// Captions, helper text, timestamps.
  final Color inkMuted;

  /// Hairlines and card borders.
  final Color rule;

  /// Input borders and stronger dividers.
  final Color ruleStrong;

  /// Interactive brand colour (buttons, links, focus).
  final Color brand;

  /// Solid brand ground (masthead, login panel).
  final Color brandDeep;

  /// Very light brand fill.
  final Color brandTint;

  /// Text / icons that sit on [brand].
  final Color onBrand;

  final Color ochre;
  final Color ochreTint;
  final Color plum;
  final Color plumTint;
  final Color success;
  final Color successTint;
  final Color danger;
  final Color dangerTint;

  const Pal({
    required this.brightness,
    required this.paper,
    required this.surface,
    required this.surfaceAlt,
    required this.ink,
    required this.inkSoft,
    required this.inkMuted,
    required this.rule,
    required this.ruleStrong,
    required this.brand,
    required this.brandDeep,
    required this.brandTint,
    required this.onBrand,
    required this.ochre,
    required this.ochreTint,
    required this.plum,
    required this.plumTint,
    required this.success,
    required this.successTint,
    required this.danger,
    required this.dangerTint,
  });

  bool get isDark => brightness == Brightness.dark;

  static AppPaletteId activePalette = AppPaletteId.teal;

  // 1. Cerulean Teal (Default K.K. Wagh)
  static const Pal tealLight = Pal(
    brightness: Brightness.light,
    paper: Color(0xFFF3F6F7),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFE9EFF1),
    ink: Color(0xFF10252D),
    inkSoft: Color(0xFF33474F),
    inkMuted: Color(0xFF5B6E76),
    rule: Color(0xFFD5DEE2),
    ruleStrong: Color(0xFFB4C2C8),
    brand: Color(0xFF0B6A90),
    brandDeep: Color(0xFF084E6B),
    brandTint: Color(0xFFE3F0F5),
    onBrand: Color(0xFFFFFFFF),
    ochre: Color(0xFF9A5B00),
    ochreTint: Color(0xFFFBF1DF),
    plum: Color(0xFF7A3568),
    plumTint: Color(0xFFF5E9F1),
    success: Color(0xFF1F7A4D),
    successTint: Color(0xFFE5F3EB),
    danger: Color(0xFFB3261E),
    dangerTint: Color(0xFFFBE9E7),
  );

  static const Pal tealDark = Pal(
    brightness: Brightness.dark,
    paper: Color(0xFF0C1A20),
    surface: Color(0xFF122830),
    surfaceAlt: Color(0xFF183640),
    ink: Color(0xFFE8F0F3),
    inkSoft: Color(0xFFC5D4DA),
    inkMuted: Color(0xFF8FA6AF),
    rule: Color(0xFF26404A),
    ruleStrong: Color(0xFF3A5661),
    brand: Color(0xFF5DB8DB),
    brandDeep: Color(0xFF0E4A63),
    brandTint: Color(0xFF15374A),
    onBrand: Color(0xFF06222C),
    ochre: Color(0xFFE0A24A),
    ochreTint: Color(0xFF3A2C12),
    plum: Color(0xFFD79BC8),
    plumTint: Color(0xFF3A1F33),
    success: Color(0xFF5CC58F),
    successTint: Color(0xFF123526),
    danger: Color(0xFFF08A82),
    dangerTint: Color(0xFF3E1A18),
  );

  // 2. Oxford Navy & Slate
  static const Pal navyLight = Pal(
    brightness: Brightness.light,
    paper: Color(0xFFF5F7FA),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEBF0F5),
    ink: Color(0xFF0F172A),
    inkSoft: Color(0xFF334155),
    inkMuted: Color(0xFF64748B),
    rule: Color(0xFFD6DFEB),
    ruleStrong: Color(0xFFB0C2D8),
    brand: Color(0xFF1E3A8A),
    brandDeep: Color(0xFF172554),
    brandTint: Color(0xFFEFF6FF),
    onBrand: Color(0xFFFFFFFF),
    ochre: Color(0xFFB45309),
    ochreTint: Color(0xFFFEF3C7),
    plum: Color(0xFF6B21A8),
    plumTint: Color(0xFFF3E8FF),
    success: Color(0xFF15803D),
    successTint: Color(0xFFDCFCE7),
    danger: Color(0xFFB91C1C),
    dangerTint: Color(0xFFFEE2E2),
  );

  static const Pal navyDark = Pal(
    brightness: Brightness.dark,
    paper: Color(0xFF0B0F17),
    surface: Color(0xFF111827),
    surfaceAlt: Color(0xFF1E293B),
    ink: Color(0xFFF1F5F9),
    inkSoft: Color(0xFFCBD5E1),
    inkMuted: Color(0xFF94A3B8),
    rule: Color(0xFF1E2D42),
    ruleStrong: Color(0xFF2C3E57),
    brand: Color(0xFF60A5FA),
    brandDeep: Color(0xFF1E3A8A),
    brandTint: Color(0xFF172554),
    onBrand: Color(0xFF0A101D),
    ochre: Color(0xFFFBBF24),
    ochreTint: Color(0xFF37260C),
    plum: Color(0xFFC084FC),
    plumTint: Color(0xFF321345),
    success: Color(0xFF4ADE80),
    successTint: Color(0xFF0D381E),
    danger: Color(0xFFF87171),
    dangerTint: Color(0xFF381414),
  );

  // 3. Institutional Emerald & Forest
  static const Pal forestLight = Pal(
    brightness: Brightness.light,
    paper: Color(0xFFF4F7F5),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFE8F0EA),
    ink: Color(0xFF0F261A),
    inkSoft: Color(0xFF2A4A38),
    inkMuted: Color(0xFF537361),
    rule: Color(0xFFD2E0D6),
    ruleStrong: Color(0xFFAEC4B4),
    brand: Color(0xFF0D5C3A),
    brandDeep: Color(0xFF064E3B),
    brandTint: Color(0xFFECFDF5),
    onBrand: Color(0xFFFFFFFF),
    ochre: Color(0xFFB45309),
    ochreTint: Color(0xFFFEF3C7),
    plum: Color(0xFF701A75),
    plumTint: Color(0xFFFAE8FF),
    success: Color(0xFF16A34A),
    successTint: Color(0xFFDCFCE7),
    danger: Color(0xFFDC2626),
    dangerTint: Color(0xFFFEE2E2),
  );

  static const Pal forestDark = Pal(
    brightness: Brightness.dark,
    paper: Color(0xFF08140D),
    surface: Color(0xFF0E2419),
    surfaceAlt: Color(0xFF153324),
    ink: Color(0xFFECFDF5),
    inkSoft: Color(0xFFC4E2D0),
    inkMuted: Color(0xFF88B399),
    rule: Color(0xFF1B3D2C),
    ruleStrong: Color(0xFF2B5740),
    brand: Color(0xFF34D399),
    brandDeep: Color(0xFF064E3B),
    brandTint: Color(0xFF0E2E20),
    onBrand: Color(0xFF03140B),
    ochre: Color(0xFFFBBF24),
    ochreTint: Color(0xFF37260C),
    plum: Color(0xFFE879F9),
    plumTint: Color(0xFF38103D),
    success: Color(0xFF4ADE80),
    successTint: Color(0xFF0D381E),
    danger: Color(0xFFF87171),
    dangerTint: Color(0xFF381414),
  );

  // 4. Heritage Crimson & Burgundy
  static const Pal crimsonLight = Pal(
    brightness: Brightness.light,
    paper: Color(0xFFF8F4F4),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF2EAEA),
    ink: Color(0xFF260D10),
    inkSoft: Color(0xFF4D2428),
    inkMuted: Color(0xFF7A4A4F),
    rule: Color(0xFFE5D5D7),
    ruleStrong: Color(0xFFCCA8AC),
    brand: Color(0xFF881337),
    brandDeep: Color(0xFF4C0E14),
    brandTint: Color(0xFFFFF1F2),
    onBrand: Color(0xFFFFFFFF),
    ochre: Color(0xFFB45309),
    ochreTint: Color(0xFFFEF3C7),
    plum: Color(0xFF581C87),
    plumTint: Color(0xFFF3E8FF),
    success: Color(0xFF15803D),
    successTint: Color(0xFFDCFCE7),
    danger: Color(0xFFE11D48),
    dangerTint: Color(0xFFFFE4E6),
  );

  static const Pal crimsonDark = Pal(
    brightness: Brightness.dark,
    paper: Color(0xFF17090C),
    surface: Color(0xFF241014),
    surfaceAlt: Color(0xFF36181F),
    ink: Color(0xFFFFF1F2),
    inkSoft: Color(0xFFE2BFC4),
    inkMuted: Color(0xFFB0858C),
    rule: Color(0xFF421C22),
    ruleStrong: Color(0xFF5E2730),
    brand: Color(0xFFFB7185),
    brandDeep: Color(0xFF4C0E14),
    brandTint: Color(0xFF2E1218),
    onBrand: Color(0xFF140407),
    ochre: Color(0xFFFBBF24),
    ochreTint: Color(0xFF37260C),
    plum: Color(0xFFC084FC),
    plumTint: Color(0xFF321345),
    success: Color(0xFF4ADE80),
    successTint: Color(0xFF0D381E),
    danger: Color(0xFFFB7185),
    dangerTint: Color(0xFF381414),
  );

  // 5. Modern Polytechnic Cobalt & Indigo
  static const Pal indigoLight = Pal(
    brightness: Brightness.light,
    paper: Color(0xFFF5F5FB),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFECECF7),
    ink: Color(0xFF14122E),
    inkSoft: Color(0xFF302B5E),
    inkMuted: Color(0xFF5F5994),
    rule: Color(0xFFD7D6E8),
    ruleStrong: Color(0xFFB4B2D1),
    brand: Color(0xFF3730A3),
    brandDeep: Color(0xFF282270),
    brandTint: Color(0xFFEEF2FF),
    onBrand: Color(0xFFFFFFFF),
    ochre: Color(0xFFB45309),
    ochreTint: Color(0xFFFEF3C7),
    plum: Color(0xFF86198F),
    plumTint: Color(0xFFFAE8FF),
    success: Color(0xFF16A34A),
    successTint: Color(0xFFDCFCE7),
    danger: Color(0xFFDC2626),
    dangerTint: Color(0xFFFEE2E2),
  );

  static const Pal indigoDark = Pal(
    brightness: Brightness.dark,
    paper: Color(0xFF0E0D1C),
    surface: Color(0xFF181630),
    surfaceAlt: Color(0xFF242147),
    ink: Color(0xFFEEF2FF),
    inkSoft: Color(0xFFCDCBE3),
    inkMuted: Color(0xFF9894BF),
    rule: Color(0xFF2C2852),
    ruleStrong: Color(0xFF413C78),
    brand: Color(0xFF818CF8),
    brandDeep: Color(0xFF282270),
    brandTint: Color(0xFF1F1C42),
    onBrand: Color(0xFF090814),
    ochre: Color(0xFFFBBF24),
    ochreTint: Color(0xFF37260C),
    plum: Color(0xFFE879F9),
    plumTint: Color(0xFF38103D),
    success: Color(0xFF4ADE80),
    successTint: Color(0xFF0D381E),
    danger: Color(0xFFF87171),
    dangerTint: Color(0xFF381414),
  );

  // 6. Industrial Polytechnic Graphite & Bronze
  static const Pal graphiteLight = Pal(
    brightness: Brightness.light,
    paper: Color(0xFFF6F6F7),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEAEBED),
    ink: Color(0xFF1E2024),
    inkSoft: Color(0xFF3B4047),
    inkMuted: Color(0xFF6B7280),
    rule: Color(0xFFD8DADC),
    ruleStrong: Color(0xFFB4B8BC),
    brand: Color(0xFF334155),
    brandDeep: Color(0xFF1E293B),
    brandTint: Color(0xFFF1F5F9),
    onBrand: Color(0xFFFFFFFF),
    ochre: Color(0xFFD97706),
    ochreTint: Color(0xFFFEF3C7),
    plum: Color(0xFF7C3AED),
    plumTint: Color(0xFFEDE9FE),
    success: Color(0xFF059669),
    successTint: Color(0xFFD1FAE5),
    danger: Color(0xFFDC2626),
    dangerTint: Color(0xFFFEE2E2),
  );

  static const Pal graphiteDark = Pal(
    brightness: Brightness.dark,
    paper: Color(0xFF111215),
    surface: Color(0xFF191B20),
    surfaceAlt: Color(0xFF252830),
    ink: Color(0xFFF1F5F9),
    inkSoft: Color(0xFFCFD3DA),
    inkMuted: Color(0xFF9096A2),
    rule: Color(0xFF2E323B),
    ruleStrong: Color(0xFF434956),
    brand: Color(0xFF94A3B8),
    brandDeep: Color(0xFF0F172A),
    brandTint: Color(0xFF20232A),
    onBrand: Color(0xFF0C0D0F),
    ochre: Color(0xFFFBBF24),
    ochreTint: Color(0xFF37260C),
    plum: Color(0xFFA78BFA),
    plumTint: Color(0xFF2A1C47),
    success: Color(0xFF34D399),
    successTint: Color(0xFF0D381E),
    danger: Color(0xFFF87171),
    dangerTint: Color(0xFF381414),
  );

  static Pal getPalette(AppPaletteId id, {required bool isDark}) {
    switch (id) {
      case AppPaletteId.teal:
        return isDark ? tealDark : tealLight;
      case AppPaletteId.navy:
        return isDark ? navyDark : navyLight;
      case AppPaletteId.forest:
        return isDark ? forestDark : forestLight;
      case AppPaletteId.crimson:
        return isDark ? crimsonDark : crimsonLight;
      case AppPaletteId.indigo:
        return isDark ? indigoDark : indigoLight;
      case AppPaletteId.graphite:
        return isDark ? graphiteDark : graphiteLight;
    }
  }

  // Backwards compatibility shortcuts
  static Pal get light => getPalette(activePalette, isDark: false);
  static Pal get dark => getPalette(activePalette, isDark: true);

  /// Resolves the palette for the current theme brightness and active palette extension.
  static Pal of(BuildContext context) {
    final ext = Theme.of(context).extension<PalThemeExtension>();
    if (ext != null) return ext.pal;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return getPalette(activePalette, isDark: isDark);
  }
}

/// Typography helpers. Newsreader (a text serif) carries headings and
/// figures; Public Sans (designed for public institutions) does the UI work.
class AppType {
  static const String serif = 'Newsreader';
  static const String sans = 'PublicSans';

  static TextStyle display(
    Color color, {
    double size = 32,
    FontWeight weight = FontWeight.w500,
    double height = 1.15,
  }) {
    return TextStyle(
      fontFamily: serif,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: size >= 28 ? -0.5 : -0.2,
      color: color,
    );
  }
}

class AppTheme {
  static ThemeData light([AppPaletteId id = AppPaletteId.teal]) =>
      _build(Pal.getPalette(id, isDark: false));

  static ThemeData dark([AppPaletteId id = AppPaletteId.teal]) =>
      _build(Pal.getPalette(id, isDark: true));

  static const List<AppPaletteMeta> palettes = [
    AppPaletteMeta(
      id: AppPaletteId.teal,
      name: 'Cerulean Teal',
      description: 'K.K. Wagh seal teal & cool neutral steel',
      primary: Color(0xFF0B6A90),
      deep: Color(0xFF084E6B),
    ),
    AppPaletteMeta(
      id: AppPaletteId.navy,
      name: 'Oxford Navy',
      description: 'Classic university executive navy & slate',
      primary: Color(0xFF1E3A8A),
      deep: Color(0xFF172554),
    ),
    AppPaletteMeta(
      id: AppPaletteId.forest,
      name: 'Emerald Forest',
      description: 'Botanical campus green & emerald prestige',
      primary: Color(0xFF0D5C3A),
      deep: Color(0xFF064E3B),
    ),
    AppPaletteMeta(
      id: AppPaletteId.crimson,
      name: 'Heritage Crimson',
      description: 'Collegiate burgundy wine & deep crimson',
      primary: Color(0xFF881337),
      deep: Color(0xFF4C0E14),
    ),
    AppPaletteMeta(
      id: AppPaletteId.indigo,
      name: 'Polytechnic Cobalt',
      description: 'Engineering royal indigo & modern tech blue',
      primary: Color(0xFF3730A3),
      deep: Color(0xFF282270),
    ),
    AppPaletteMeta(
      id: AppPaletteId.graphite,
      name: 'Graphite Bronze',
      description: 'Industrial polytechnic charcoal & warm amber',
      primary: Color(0xFF334155),
      deep: Color(0xFF1E293B),
    ),
  ];

  static const List<AppPaletteMeta> paletteList = palettes;

  static Pal getPalette(AppPaletteId id, {required bool isDark}) =>
      Pal.getPalette(id, isDark: isDark);

  static ThemeData _build(Pal p) {
    final scheme = ColorScheme.fromSeed(
      seedColor: p.brand,
      brightness: p.brightness,
    ).copyWith(
      primary: p.brand,
      onPrimary: p.onBrand,
      primaryContainer: p.brandTint,
      onPrimaryContainer: p.brandDeep,
      secondary: p.ochre,
      tertiary: p.plum,
      error: p.danger,
      surface: p.surface,
      onSurface: p.ink,
      onSurfaceVariant: p.inkMuted,
      outline: p.ruleStrong,
      outlineVariant: p.rule,
    );

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    );

    OutlineInputBorder inputBorder(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return ThemeData(
      useMaterial3: true,
      brightness: p.brightness,
      fontFamily: AppType.sans,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.paper,
      canvasColor: p.surface,
      dividerColor: p.rule,
      appBarTheme: AppBarTheme(
        backgroundColor: p.surface,
        foregroundColor: p.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        shape: Border(bottom: BorderSide(color: p.rule)),
        titleTextStyle: TextStyle(
          fontFamily: AppType.serif,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: p.ink,
        ),
        iconTheme: IconThemeData(color: p.inkSoft),
        actionsIconTheme: IconThemeData(color: p.inkSoft),
      ),
      cardTheme: CardThemeData(
        color: p.surface,
        elevation: 2,
        shadowColor: (p.isDark ? Colors.black : p.ink).withValues(alpha: 0.12),
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: p.rule),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: p.rule),
        ),
        titleTextStyle: TextStyle(
          fontFamily: AppType.serif,
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: p.ink,
        ),
        contentTextStyle: TextStyle(
          fontFamily: AppType.sans,
          fontSize: 14,
          height: 1.45,
          color: p.inkSoft,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(),
      ),
      dividerTheme: DividerThemeData(color: p.rule, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: inputBorder(p.ruleStrong),
        enabledBorder: inputBorder(p.ruleStrong),
        disabledBorder: inputBorder(p.rule),
        focusedBorder: inputBorder(p.brand, 1.6),
        errorBorder: inputBorder(p.danger),
        focusedErrorBorder: inputBorder(p.danger, 1.6),
        labelStyle: TextStyle(color: p.inkMuted),
        floatingLabelStyle: TextStyle(color: p.brand),
        hintStyle: TextStyle(color: p.inkMuted.withValues(alpha: 0.75)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.brand,
          foregroundColor: p.onBrand,
          disabledBackgroundColor: p.surfaceAlt,
          disabledForegroundColor: p.inkMuted,
          elevation: 0,
          shape: buttonShape,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          textStyle: const TextStyle(
            fontFamily: AppType.sans,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.ink,
          side: BorderSide(color: p.ruleStrong),
          shape: buttonShape,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontFamily: AppType.sans,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.brand,
          shape: buttonShape,
          textStyle: const TextStyle(
            fontFamily: AppType.sans,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.ink,
        elevation: 0,
        contentTextStyle: TextStyle(
          fontFamily: AppType.sans,
          color: p.paper,
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: p.ink,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: TextStyle(
          fontFamily: AppType.sans,
          fontSize: 12,
          color: p.paper,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: p.brand),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: p.brand,
        selectionColor: p.brand.withValues(alpha: 0.25),
      ),
    );
  }
}
