import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/app_config.dart';
import '../router/app_router.dart';
import '../services/app_state.dart';
import '../utils/app_snack_bar.dart';
import '../theme/app_theme.dart';
import '../widgets/portal_ui.dart';
import 'admin_dashboard_screen.dart';
import 'user_home_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  final AppState appState;

  const RoleSelectionScreen({super.key, required this.appState});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@kkwagh.edu.in');
  final _passwordController = TextEditingController(text: 'Admin@12345');

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.appState.checkBackendConnection();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await widget.appState.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      AppSnackBar.showSuccess(
        context,
        'Signed in successfully as ${widget.appState.currentUserName}!',
      );

      _navigateToDashboard();
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(
        context,
        e.toString().replaceAll('ApiException: ', ''),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _quickLogin(String email, String password) async {
    _emailController.text = email;
    _passwordController.text = password;
    setState(() => _isLoading = true);

    try {
      await widget.appState.login(email, password);
      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        'Signed in as ${widget.appState.currentUserName}!',
      );
      _navigateToDashboard();
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Login failed: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToDashboard() {
    try {
      if (GoRouter.maybeOf(context) != null) {
        context.go(widget.appState.isAdminOrSuper
            ? AppRoutes.admin
            : AppRoutes.user);
        return;
      }
    } catch (_) {}

    if (widget.appState.isAdminOrSuper) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDashboardScreen(appState: widget.appState),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UserHomeScreen(appState: widget.appState),
        ),
      );
    }
  }

  Widget _buildBrandPanel(Pal p, {required bool wide}) {
    return Container(
      color: p.brandDeep,
      child: Stack(
        children: [
          if (wide)
            Positioned(
              right: -110,
              bottom: -80,
              child: IgnorePointer(
                child: PortalLogo(
                  height: 560,
                  tint: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(wide ? 56 : 28),
            child: Column(
              mainAxisSize: wide ? MainAxisSize.max : MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PortalLogo(
                  height: wide ? 72 : 56,
                  tint: Colors.white,
                  asset: 'assets/images/nobgkkwpblack.png',
                ),
                if (wide) const Spacer() else const SizedBox(height: 28),
                Text(
                  'K K Wagh Polytechnic, Nashik',
                  style: AppType.display(
                    Colors.white,
                    size: wide ? 46 : 32,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: wide ? 18 : 12),
                Text(
                  'Internal Institute Monitoring System\n(Format IIM-26-27)',
                  style: TextStyle(
                    fontSize: wide ? 16 : 14,
                    height: 1.5,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(Pal p) {
    if (!AppConfig.useRemoteBackend) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: p.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Frontend Standalone • Mock Ready',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: p.inkSoft,
            ),
          ),
        ],
      );
    }

    final isBackendOnline = widget.appState.isBackendConnected;
    final isChecking = widget.appState.isCheckingBackend;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isBackendOnline ? p.success : p.ochre,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          isChecking
              ? 'Checking...'
              : isBackendOnline
                  ? 'API Online'
                  : 'API Offline',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: p.inkSoft,
          ),
        ),
        const SizedBox(width: 4),
        InkWell(
          onTap: () => widget.appState.checkBackendConnection(),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Icon(Icons.refresh, size: 14, color: p.inkMuted),
          ),
        ),
      ],
    );
  }

  Widget _demoButton(
    Pal p, {
    required String label,
    required String email,
    required String password,
    IconData? icon,
    Color? iconColor,
  }) {
    final textStyle = const TextStyle(fontSize: 13, fontWeight: FontWeight.w600);
    final style = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    );
    if (icon != null) {
      return OutlinedButton.icon(
        style: style,
        onPressed: _isLoading ? null : () => _quickLogin(email, password),
        icon: Icon(icon, size: 18, color: iconColor),
        label: Text(label, style: textStyle),
      );
    }
    return OutlinedButton(
      style: style,
      onPressed: _isLoading ? null : () => _quickLogin(email, password),
      child: Text(label, style: textStyle),
    );
  }

  Widget _buildSignInColumn(Pal p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildConnectionStatus(p),
        const SizedBox(height: 32),
        Text(
          'Portal Sign In',
          style: AppType.display(p.ink, size: 36, height: 1.1),
        ),
        const SizedBox(height: 28),

        // Authentication form
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Institutional Email *',
                  hintText: 'admin@kkwagh.edu.in',
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your email address.';
                  }
                  if (!val.contains('@') || !val.contains('.')) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password *',
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 18,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter your password.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleLogin,
                  icon: _isLoading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: p.onBrand,
                          ),
                        )
                      : const Icon(Icons.login, size: 20),
                  label: Text(
                    _isLoading ? 'Signing In...' : 'Sign In to Portal',
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 36),

        // Quick access
        Row(
          children: [
            Text(
              'Quick Access',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: p.inkSoft,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Divider(height: 1, color: p.rule)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _demoButton(
                p,
                label: 'Admin (CM Department)',
                email: 'admin@kkwagh.edu.in',
                password: 'Admin@12345',
                icon: Icons.admin_panel_settings,
                iconColor: p.brand,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _demoButton(
                p,
                label: 'User (CM Department)',
                email: 'user@kkwagh.edu.in',
                password: 'User@12345',
                icon: Icons.person,
                iconColor: p.inkSoft,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);

    return Scaffold(
      backgroundColor: p.paper,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 5, child: _buildBrandPanel(p, wide: true)),
                Expanded(
                  flex: 6,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 40),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: _buildSignInColumn(p),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: _buildBrandPanel(p, wide: false),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: _buildSignInColumn(p),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
