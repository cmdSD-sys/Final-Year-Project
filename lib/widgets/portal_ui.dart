import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The college seal. Falls back to a plain icon if the asset is missing,
/// exactly as the earlier screens did. Pass [tint] to draw the seal as a
/// single-colour silhouette (used on dark grounds).
class PortalLogo extends StatelessWidget {
  final double height;
  final Color? tint;
  final String asset;

  const PortalLogo({
    super.key,
    this.height = 40,
    this.tint,
    this.asset = 'assets/images/nobgkkwp.png',
  });

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final Widget logo = Image.asset(
      asset,
      height: height,
      cacheHeight: (height * 3).round(),
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      fit: BoxFit.contain,
      errorBuilder: (c, e, s) => Icon(
        Icons.school,
        size: height * 0.6,
        color: tint ?? p.brand,
      ),
    );
    if (tint == null) return logo;
    return ColorFiltered(
      colorFilter: ColorFilter.mode(tint!, BlendMode.srcIn),
      child: logo,
    );
  }
}

/// Seal + institution name for the top bar.
class PortalAppBarTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const PortalAppBarTitle({
    super.key,
    this.title = 'K.K. Wagh Polytechnic, Nashik',
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Row(
      children: [
        PortalLogo(height: 36, tint: p.isDark ? Colors.white : null),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppType.display(p.ink, size: 18, height: 1.15),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: p.inkMuted,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Profile picture that opens the navigation drawer.
class PortalMenuAvatar extends StatelessWidget {
  final ImageProvider? image;
  final VoidCallback onTap;

  const PortalMenuAvatar({super.key, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Center(
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: p.ruleStrong),
          ),
          child: CircleAvatar(
            radius: 15,
            backgroundColor: p.brandTint,
            backgroundImage: image,
            child: image == null
                ? Icon(Icons.person, size: 17, color: p.brand)
                : null,
          ),
        ),
      ),
    );
  }
}

/// Compact label used for roles, semesters and counts.
class PortalTag extends StatelessWidget {
  final String label;
  final Color color;
  final Color? fill;
  final Color? border;
  final IconData? icon;
  final double fontSize;

  const PortalTag({
    super.key,
    required this.label,
    required this.color,
    this.fill,
    this.border,
    this.icon,
    this.fontSize = 11.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: border ?? color.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: color,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ODD / EVEN semester marker.
class SemesterTag extends StatelessWidget {
  final String semesterType;

  const SemesterTag({super.key, required this.semesterType});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final odd = semesterType == 'ODD';
    return PortalTag(
      label: '$semesterType SEM',
      color: odd ? p.brand : p.inkSoft,
      fill: odd ? p.brandTint : p.surfaceAlt,
      border: odd ? p.brand.withValues(alpha: 0.35) : p.rule,
    );
  }
}

/// Serif section title with a hairline underneath and an optional trailing
/// widget (counts, actions).
class SectionHeading extends StatelessWidget {
  final String text;
  final Widget? trailing;

  const SectionHeading({super.key, required this.text, this.trailing});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: p.ruleStrong)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              text,
              style: AppType.display(p.ink, size: 24, height: 1.2),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Soft, layered shadow shared by cards so surfaces read as raised paper
/// rather than flat boxes.
List<BoxShadow> portalShadow(Pal p) {
  return [
    BoxShadow(
      color: (p.isDark ? Colors.black : const Color(0xFF10252D))
          .withValues(alpha: p.isDark ? 0.35 : 0.05),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: (p.isDark ? Colors.black : const Color(0xFF10252D))
          .withValues(alpha: p.isDark ? 0.25 : 0.04),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];
}

/// Raised, bordered surface used for grouped content.
class PortalPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final bool raised;

  const PortalPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.raised = true,
  });

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? p.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: p.rule),
        boxShadow: raised ? portalShadow(p) : null,
      ),
      child: child,
    );
  }
}

/// A card with a header strip (title, optional trailing widget) above its
/// body. Used for the submissions table and the form sections.
class PortalCard extends StatelessWidget {
  final String title;
  final String? caption;
  final Widget? trailing;
  final Widget child;

  const PortalCard({
    super.key,
    required this.title,
    required this.child,
    this.caption,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: p.rule),
        boxShadow: portalShadow(p),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: p.rule)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppType.display(p.ink, size: 22, height: 1.2),
                      ),
                      if (caption != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          caption!,
                          style: TextStyle(fontSize: 13, color: p.inkMuted),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 16),
                  trailing!,
                ],
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}

/// One figure in the summary strip.
class PortalStatData {
  final String label;
  final String value;
  final IconData icon;

  const PortalStatData({
    required this.label,
    required this.value,
    required this.icon,
  });
}

/// Responsive strip of summary figures (4 / 2 / 1 columns).
class PortalStatRow extends StatelessWidget {
  final List<PortalStatData> stats;

  const PortalStatRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final cols = maxWidth >= 860 ? 4 : (maxWidth >= 480 ? 2 : 1);
        const gap = 16.0;
        final cardWidth = (maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: stats.map((s) {
            return Container(
              width: cardWidth,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              decoration: BoxDecoration(
                color: p.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: p.rule),
                boxShadow: portalShadow(p),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: p.brandTint,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(s.icon, size: 22, color: p.brand),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.value,
                          style: AppType.display(p.ink, size: 30, height: 1.0),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: p.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

/// Department monogram (CM, IT, ME, CE ...).
class DeptMonogram extends StatelessWidget {
  final String code;
  final double size;

  const DeptMonogram({super.key, required this.code, this.size = 44});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: p.brandTint,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: p.brand.withValues(alpha: 0.22)),
      ),
      child: Text(
        code.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.clip,
        style: AppType.display(p.brand, size: size * 0.38, height: 1.0),
      ),
    );
  }
}

/// The one strong element on a dashboard: a solid brand panel that opens the
/// monitoring form.
class PortalActionPanel extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;
  final String buttonLabel;

  const PortalActionPanel({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
    this.buttonLabel = 'Fill Form',
  });

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: p.brandDeep.withValues(alpha: p.isDark ? 0.5 : 0.28),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: p.brandDeep,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Positioned(
                right: -36,
                bottom: -56,
                child: IgnorePointer(
                  child: PortalLogo(
                    height: 240,
                    tint: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final stacked = constraints.maxWidth < 620;
                    final text = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          margin: const EdgeInsets.only(bottom: 18),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.22),
                            ),
                          ),
                          child: const Icon(
                            Icons.description_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        Text(
                          title,
                          style: AppType.display(Colors.white, size: 26, height: 1.2),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14.5,
                            height: 1.55,
                            color: Colors.white.withValues(alpha: 0.82),
                          ),
                        ),
                      ],
                    );
                    final button = ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: p.brandDeep,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 16),
                      ),
                      onPressed: onTap,
                      icon: const Icon(Icons.edit_note, size: 20),
                      label: Text(buttonLabel),
                    );
                    if (stacked) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [text, const SizedBox(height: 22), button],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: text),
                        const SizedBox(width: 28),
                        button,
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
