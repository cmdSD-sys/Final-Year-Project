import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import 'app_navigation_drawer.dart';
import 'palette_switcher_dialog.dart';
import 'portal_ui.dart';

/// Page frame shared by the dashboards.
///
/// Wide screens get a permanent navigation sidebar with a slim top bar;
/// narrow screens keep the slide-over drawer behind the profile picture.
class PortalShell extends StatelessWidget {
  final AppState appState;
  final VoidCallback? onOpenCatalog;
  final String title;
  final List<Widget> actions;
  final Widget body;

  const PortalShell({
    super.key,
    required this.appState,
    required this.title,
    required this.body,
    this.onOpenCatalog,
    this.actions = const [],
  });

  static const double wideBreakpoint = 1040;

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final wide = MediaQuery.sizeOf(context).width >= wideBreakpoint;

    final paletteBtn = IconButton(
      icon: const Icon(Icons.palette_outlined),
      tooltip: 'Theme & Color Palette',
      onPressed: () => PaletteSwitcherDialog.show(context, appState),
    );

    if (!wide) {
      return Scaffold(
        backgroundColor: p.paper,
        drawer: AppNavigationDrawer(
          appState: appState,
          onOpenCatalog: onOpenCatalog,
        ),
        appBar: AppBar(
          titleSpacing: 4,
          leading: Builder(
            builder: (ctx) => PortalMenuAvatar(
              image: appState.currentUserPfpBytes != null
                  ? MemoryImage(appState.currentUserPfpBytes!)
                  : null,
              onTap: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          title: PortalAppBarTitle(subtitle: title),
          actions: [...actions, paletteBtn],
        ),
        body: body,
      );
    }

    return Scaffold(
      backgroundColor: p.paper,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppNavigationDrawer(
            appState: appState,
            onOpenCatalog: onOpenCatalog,
            persistent: true,
          ),
          Expanded(
            child: Scaffold(
              backgroundColor: p.paper,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 64,
                titleSpacing: 40,
                title: Text(
                  title,
                  style: AppType.display(p.ink, size: 22, height: 1.2),
                ),
                actions: [...actions, paletteBtn, const SizedBox(width: 24)],
              ),
              body: body,
            ),
          ),
        ],
      ),
    );
  }
}
