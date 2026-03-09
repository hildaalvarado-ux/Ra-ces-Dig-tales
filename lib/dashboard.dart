import 'dart:async';
import 'package:flutter/material.dart';
import 'data/db_instance.dart';
import 'main.dart';

class DashboardPage extends StatefulWidget {
  final int userId;
  const DashboardPage({super.key, required this.userId});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _fullName = '...';
  String _email = '...';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await (appDb.select(appDb.users)
          ..where((u) => u.id.equals(widget.userId)))
        .getSingle();
    if (!mounted) return;
    setState(() {
      _fullName = user.fullName;
      _email = user.email;
    });
  }

  String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  int _gridCountForWidth(double w) {
    if (w >= 1100) return 4;
    if (w >= 700) return 3;
    return 2;
  }

  double _gridChildAspectForWidth(double w) {
    if (w >= 1100) return 1.15;
    if (w >= 700) return 1.05;
    return 1.05;
  }

  Future<void> _openFeature(String title) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FeaturePlaceholderPage(title: title),
      ),
    );
  }

  Future<bool> _confirmLogout() async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text('¿Quieres cerrar tu sesión?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenDarker,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Sí'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<void> _logout() async {
    final ok = await _confirmLogout();
    if (!ok) return;

    await appDb.clearSession();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final isDesktop = w >= 900;

          return Scaffold(
            backgroundColor: Colors.transparent,

            // ✅ Drawer solo en móvil/tablet
            drawer: isDesktop ? null : _buildDrawer(context),

            appBar: AppBar(
              backgroundColor: AppColors.greenDark,
              foregroundColor: Colors.white,
              elevation: 0,

              // ✅ Nunca flecha back en Inicio
              automaticallyImplyLeading: false,

              // ✅ En móvil: botón hamburguesa para abrir Drawer
              leading: isDesktop
                  ? null
                  : Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu_rounded),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),

              title: const Text(
                'Inicio',
                style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.3),
              ),

              actions: isDesktop
                  ? [
                      const SizedBox(width: 6),
                      _TopLink(text: 'Inicio', onTap: () {}),
                      _HoverMenu(
                        text: 'Cultivos',
                        items: [
                          _HoverItem('Cultivos', () => _openFeature('Cultivos')),
                          _HoverItem(
                              'Fertilizantes', () => _openFeature('Fertilizantes')),
                          _HoverItem('Pesticidas', () => _openFeature('Pesticidas')),
                          _HoverItem('Plagas', () => _openFeature('Plagas')),
                        ],
                      ),
                      _TopLink(
                          text: 'Favoritos',
                          onTap: () => _openFeature('Favoritos')),
                      _TopLink(
                        text: 'Calendario',
                        onTap: () => _openFeature('Calendario'),
                        primary: true,
                      ),
                      _HoverMenu(
                        text: 'Mi huerta',
                        items: [
                          _HoverItem('Notificaciones',
                              () => _openFeature('Notificaciones')),
                          _HoverItem('Diario', () => _openFeature('Diario')),
                        ],
                      ),
                      _HoverMenu(
                        text: 'Otros',
                        items: [
                          _HoverItem('Opciones', () => _openFeature('Opciones')),
                          _HoverItem('Contacto', () => _openFeature('Contacto')),
                          _HoverItem('Créditos', () => _openFeature('Créditos')),
                        ],
                      ),
                      const SizedBox(width: 10),
                      _ProfileMenuV2(
                        initials: _initials(_fullName),
                        fullName: _fullName,
                        email: _email,
                        onChangePhoto: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Próximamente: cambiar foto de perfil'),
                            ),
                          );
                        },
                        onLogout: _logout,
                      ),
                      const SizedBox(width: 12),
                    ]
                  : [
                      IconButton(
                        tooltip: 'Ayuda',
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Próximamente: ayuda')),
                        ),
                        icon: const Icon(Icons.help_outline_rounded),
                      ),
                      const SizedBox(width: 6),
                    ],
            ),

            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: _buildBodyContent(w),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBodyContent(double w) {
    final gridCount = _gridCountForWidth(w);
    final aspect = _gridChildAspectForWidth(w);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: aspect,
          ),
          children: [
            _DashboardTile(
              label: 'Cultivos',
              icon: Icons.local_florist_rounded,
              onTap: () => _openFeature('Cultivos'),
            ),
            _DashboardTile(
              label: 'Fertilizantes',
              icon: Icons.science_rounded,
              onTap: () => _openFeature('Fertilizantes'),
            ),
            _DashboardTile(
              label: 'Pesticidas',
              icon: Icons.sanitizer_rounded,
              onTap: () => _openFeature('Pesticidas'),
            ),
            _DashboardTile(
              label: 'Plagas',
              icon: Icons.bug_report_rounded,
              onTap: () => _openFeature('Plagas'),
            ),
            _DashboardTile(
              label: 'Calendario',
              icon: Icons.calendar_month_rounded,
              onTap: () => _openFeature('Calendario'),
            ),
            _DashboardTile(
              label: 'Diario',
              icon: Icons.menu_book_rounded,
              onTap: () => _openFeature('Diario'),
            ),
          ],
        ),
        const SizedBox(height: 18),

        Text(
          'Cultivos sembrados en tu huerta',
          style: TextStyle(
            color: AppColors.greenDarker,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.70),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.greenDark.withOpacity(0.12)),
          ),
          child: Text(
            'Aún no hay datos para mostrar.\nAquí irá un resumen/gráfica cuando registremos información.',
            style: TextStyle(
              color: AppColors.greenDarker.withOpacity(0.85),
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Notificaciones',
          style: TextStyle(
            color: AppColors.greenDarker,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        _NotificationCard(
          title: 'Hay tareas pendientes',
          subtitle: 'Diario • hoy',
          onOpen: () => _openFeature('Notificaciones'),
        ),
      ],
    );
  }

  // =======================
  // DRAWER MÓVIL COMPLETO
  // =======================
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: AppColors.greenDark,
            padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Text(
                    _initials(_fullName),
                    style: const TextStyle(
                      color: AppColors.greenDarker,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Cambiar foto (próximamente)',
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Próximamente: cambiar foto')),
                  ),
                  icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                const _DrawerSectionTitle('Información'),
                _DrawerItem(
                    icon: Icons.home_rounded,
                    label: 'Inicio',
                    onTap: () => Navigator.pop(context)),
                _DrawerItem(
                  icon: Icons.calendar_month_rounded,
                  label: 'Calendario',
                  primary: true,
                  onTap: () => _openFromDrawer(context, 'Calendario'),
                ),

                const SizedBox(height: 6),
                const _DrawerSectionTitle('Cultivos'),
                _DrawerItem(
                    icon: Icons.local_florist_rounded,
                    label: 'Cultivos',
                    onTap: () => _openFromDrawer(context, 'Cultivos')),
                _DrawerItem(
                    icon: Icons.science_rounded,
                    label: 'Fertilizantes',
                    onTap: () => _openFromDrawer(context, 'Fertilizantes')),
                _DrawerItem(
                    icon: Icons.sanitizer_rounded,
                    label: 'Pesticidas',
                    onTap: () => _openFromDrawer(context, 'Pesticidas')),
                _DrawerItem(
                    icon: Icons.bug_report_rounded,
                    label: 'Plagas',
                    onTap: () => _openFromDrawer(context, 'Plagas')),

                const SizedBox(height: 6),
                const _DrawerSectionTitle('Mi huerta'),
                _DrawerItem(
                    icon: Icons.notifications_active_rounded,
                    label: 'Notificaciones',
                    onTap: () => _openFromDrawer(context, 'Notificaciones')),
                _DrawerItem(
                    icon: Icons.menu_book_rounded,
                    label: 'Diario',
                    onTap: () => _openFromDrawer(context, 'Diario')),

                const SizedBox(height: 6),
                const _DrawerSectionTitle('Otros'),
                _DrawerItem(
                    icon: Icons.settings_rounded,
                    label: 'Opciones',
                    onTap: () => _openFromDrawer(context, 'Opciones')),
                _DrawerItem(
                    icon: Icons.contact_mail_rounded,
                    label: 'Contacto',
                    onTap: () => _openFromDrawer(context, 'Contacto')),
                _DrawerItem(
                    icon: Icons.info_outline_rounded,
                    label: 'Créditos',
                    onTap: () => _openFromDrawer(context, 'Créditos')),

                const Divider(height: 22),
                _DrawerItem(
                  icon: Icons.logout_rounded,
                  label: 'Cerrar sesión',
                  danger: true,
                  onTap: () async {
                    Navigator.pop(context);
                    await _logout();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
            child: Text(
              'Raíces Digitales • v1.0',
              style: TextStyle(
                color: AppColors.greenDarker.withOpacity(0.70),
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _openFromDrawer(BuildContext context, String title) {
    Navigator.pop(context);
    _openFeature(title);
  }
}

// =======================
// COMPONENTES UI
// =======================

class _TopLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool primary;

  const _TopLink({required this.text, required this.onTap, this.primary = false});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(foregroundColor: Colors.white),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: primary ? FontWeight.w900 : FontWeight.w800,
          decoration: primary ? TextDecoration.underline : TextDecoration.none,
          decorationThickness: 2,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _HoverItem {
  final String label;
  final VoidCallback onTap;
  _HoverItem(this.label, this.onTap);
}

class _HoverMenu extends StatefulWidget {
  final String text;
  final List<_HoverItem> items;

  const _HoverMenu({required this.text, required this.items});

  @override
  State<_HoverMenu> createState() => _HoverMenuState();
}

class _HoverMenuState extends State<_HoverMenu> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;
  Timer? _closeTimer;

  void _open() {
    _closeTimer?.cancel();
    if (_entry != null) return;

    _entry = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: Stack(
            children: [
              GestureDetector(
                onTap: _close,
                behavior: HitTestBehavior.translucent,
                child: const SizedBox.expand(),
              ),
              CompositedTransformFollower(
                link: _link,
                showWhenUnlinked: false,
                offset: const Offset(0, 44),
                child: MouseRegion(
                  onEnter: (_) => _closeTimer?.cancel(),
                  onExit: (_) => _scheduleClose(),
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFF2F8F4),
                    child: ConstrainedBox(
                      // ✅ compacto y consistente
                      constraints: const BoxConstraints(minWidth: 190, maxWidth: 220),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.items
                            .map(
                              (it) => InkWell(
                                onTap: () {
                                  _close();
                                  it.onTap();
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                                  child: Text(
                                    it.label,
                                    style: const TextStyle(
                                      color: AppColors.greenDarker,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_entry!);
  }

  void _scheduleClose() {
    _closeTimer?.cancel();
    _closeTimer = Timer(const Duration(milliseconds: 180), _close);
  }

  void _close() {
    _closeTimer?.cancel();
    _entry?.remove();
    _entry = null;
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    _close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: MouseRegion(
        onEnter: (_) => _open(),
        onExit: (_) => _scheduleClose(),
        child: TextButton(
          onPressed: _open,
          style: TextButton.styleFrom(foregroundColor: Colors.white),
          child: Row(
            children: [
              Text(
                widget.text,
                style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.arrow_drop_down_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuV2 extends StatelessWidget {
  final String initials;
  final String fullName;
  final String email;
  final VoidCallback onChangePhoto;
  final Future<void> Function() onLogout;

  const _ProfileMenuV2({
    required this.initials,
    required this.fullName,
    required this.email,
    required this.onChangePhoto,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Perfil',
      position: PopupMenuPosition.under,
      onSelected: (value) async {
        if (value == 'foto') onChangePhoto();
        if (value == 'logout') await onLogout();
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Text(
              initials,
              style: const TextStyle(
                color: AppColors.greenDarker,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.arrow_drop_down_rounded, color: Colors.white),
        ],
      ),
      itemBuilder: (_) => [
        PopupMenuItem(
          enabled: false,
          child: SizedBox(
            width: 240,
            child: Column(
              children: [
                const SizedBox(height: 6),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: AppColors.greenDark.withOpacity(0.12),
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: AppColors.greenDarker,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        child: IconButton(
                          tooltip: 'Cambiar imagen',
                          onPressed: onChangePhoto,
                          icon: const Icon(Icons.camera_alt_rounded),
                          color: AppColors.greenDarker,
                          iconSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 3),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.65),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'foto',
          child: ListTile(
            dense: true,
            leading: Icon(Icons.image_rounded),
            title: Text('Cambiar imagen'),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: ListTile(
            dense: true,
            leading: Icon(Icons.logout_rounded, color: Colors.red),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardTile({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.78),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.greenDark.withOpacity(0.14)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.greenDark.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 32, color: AppColors.greenDarker),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.greenDarker,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onOpen;

  const _NotificationCard({required this.title, required this.subtitle, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.greenDark.withOpacity(0.12)),
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.greenDark.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.notifications_rounded, color: AppColors.greenDarker),
        ),
        title: Text(title, style: const TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.w900)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: AppColors.greenDarker.withOpacity(0.75), fontWeight: FontWeight.w700),
        ),
        trailing: IconButton(
          onPressed: onOpen,
          icon: const Icon(Icons.open_in_new_rounded),
          color: AppColors.greenDarker,
        ),
      ),
    );
  }
}

class _DrawerSectionTitle extends StatelessWidget {
  final String text;
  const _DrawerSectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.greenDarker.withOpacity(0.80),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;
  final bool primary;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? Colors.red.shade700 : AppColors.greenDarker;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(color: color, fontWeight: primary ? FontWeight.w900 : FontWeight.w800),
      ),
      onTap: onTap,
    );
  }
}

class FeaturePlaceholderPage extends StatelessWidget {
  final String title;
  const FeaturePlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        ),
        body: Center(child: Text('Pantalla "$title" (próximamente)')),
      ),
    );
  }
}