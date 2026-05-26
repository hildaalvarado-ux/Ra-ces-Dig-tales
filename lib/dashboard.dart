import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/db_instance.dart'; // conexión a tu BD (Drift)
import 'data/app_database.dart';
import 'data/image_utils.dart';
import 'data/notification_service.dart';
import 'data/crop_models.dart';
import 'data/soil_models.dart';
import 'data/file_management_service.dart';
import 'main.dart'; // AppColors + AppBackground (tu tema/fondo)
import 'datos/cultivos.dart'; // ✅ pantalla REAL de cultivos (ya creada)
import 'datos/fertilizantes.dart';
import 'datos/plagas.dart';
import 'datos/enfermedades.dart';
import 'datos/pesticidas.dart';
import 'datos/calendario.dart';
import 'datos/ayuda.dart';
import 'datos/notificaciones.dart';
import 'datos/diario.dart';
import 'datos/creditos.dart';
import 'datos/opciones.dart';
import 'datos/preparacion_suelo.dart';
import 'datos/contacto.dart';

class DashboardPage extends StatefulWidget {
  final int userId;
  const DashboardPage({super.key, required this.userId});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Datos del usuario logueado (solo para mostrar en el perfil/drawer)
  String _fullName = '...';
  String _email = '...';
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    _loadUser(); // cargar el nombre y correo desde Drift
    _syncNotifications();
    _checkFirstTutorial();
  }

  Future<void> _checkFirstTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('tutorial_shown_${widget.userId}') ?? false;

    if (!shown) {
      await prefs.setBool('tutorial_shown_${widget.userId}', true);
      if (mounted) {
        // Delay slightly to ensure dashboard is rendered
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AyudaPage(userId: widget.userId),
              ),
            );
          }
        });
      }
    }
  }

  Future<void> _syncNotifications() async {
    // Basic sync: schedule notifications for the next 7 days on every app start
    final tasks = await appDb.getUserTasks(widget.userId);
    final now = DateTime.now();
    final sevenDaysFromNow = now.add(const Duration(days: 7));

    final plans = await appDb.getUserCropPlans(widget.userId);
    final plansMap = {for (var p in plans) p.id: p};

    for (final task in tasks) {
      if (!task.completed && task.date.isAfter(now) && task.date.isBefore(sevenDaysFromNow)) {
        final plan = plansMap[task.planId];
        await notificationService.scheduleTaskNotification(
          taskId: task.id,
          userId: widget.userId,
          title: task.title,
          body: task.description ?? '',
          scheduledDate: task.date,
          colorValue: plan?.colorValue,
        );
      }
    }
  }

  /// Lee el usuario desde la BD usando el userId recibido desde Login
  Future<void> _loadUser() async {
    final user = await (appDb.select(appDb.users)
          ..where((u) => u.id.equals(widget.userId)))
        .getSingle();

    if (!mounted) return;

    setState(() {
      _fullName = user.fullName;
      _email = user.email;
      _avatarPath = user.avatarPath;
    });
  }

  Future<void> _changeAvatar() async {
    final path = await ImageUtils.pickAndSaveImage('user_avatars');
    if (path != null) {
      await appDb.updateUserAvatar(widget.userId, path);
      setState(() => _avatarPath = path);
    }
  }

  /// Iniciales para el avatar (ej: "Josefina Valdez" -> "JV")
  String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  // Ajustes responsive para el grid del dashboard
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

  // ==========================================================
  // ✅ NAVEGACIÓN CENTRAL
  // Aquí es donde vas a ir conectando tus archivos reales.
  // EJEMPLO:
  // - Cultivos ya navega a CultivosPage()
  // - lo demás por ahora está en placeholder
  // ==========================================================
  Future<void> _openFeature(String feature) async {
    switch (feature) {
      // ✅ YA IMPLEMENTADO (archivo real):
      case 'Cultivos':
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CultivosPage(userId: widget.userId),
          ),
        );
        break;

      case 'Fertilizantes':
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FertilizantesPage(userId: widget.userId),
          ),
        );
        break;

      case 'Insectos':
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PlagasPage(userId: widget.userId),
          ),
        );
        break;

      case 'Enfermedades':
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EnfermedadesPage(userId: widget.userId),
          ),
        );
        break;

      case 'Repelentes':
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PesticidasPage(userId: widget.userId),
          ),
        );
        break;

      case 'Calendario':
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CalendarioPage(userId: widget.userId),
          ),
        );
        break;

      case 'Notificaciones':
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => NotificacionesPage(userId: widget.userId),
          ),
        );
        break;

      case 'Diario':
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DiarioPage(userId: widget.userId),
          ),
        );
        break;

      case 'PreparacionSuelo':
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PreparacionSueloPage(userId: widget.userId),
          ),
        );
        break;

      case 'Créditos':
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const CreditosPage(),
          ),
        );
        break;

      case 'Configuración':
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OpcionesPage(userId: widget.userId),
          ),
        );
        break;

      case 'Contacto':
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ContactoPage(),
          ),
        );
        break;

      case 'Favoritos':
      default:
        // ✅ placeholder temporal para que no se rompa la navegación
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FeaturePlaceholderPage(title: feature),
          ),
        );
        break;
    }
    // Refresh the dashboard to ensure the active crop plans are updated
    if (mounted) {
      setState(() {});
    }
  }

  void _openHelp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AyudaPage(userId: widget.userId),
      ),
    );
  }

  // ==========================================================
  // ✅ CERRAR SESIÓN
  // ==========================================================
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

    await appDb.clearSession(); // ✅ borra la sesión local
    if (!mounted) return;

    // Regresa al home/bienvenida (donde están login/crear cuenta)
 Navigator.pushNamedAndRemoveUntil(context, '/appgate', (_) => false);
  }

  void _showFullImage() {
    if (_avatarPath == null) return;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 500, maxWidth: 500),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              clipBehavior: Clip.antiAlias,
              child: _avatarPath!.startsWith('data:image')
                  ? Image.memory(
                      base64Decode(_avatarPath!.split(',').last),
                      fit: BoxFit.contain,
                    )
                  : (kIsWeb
                      ? Image.network(_avatarPath!, fit: BoxFit.contain)
                      : Image.file(File(_avatarPath!), fit: BoxFit.contain)),
            ),
            const SizedBox(height: 12),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
            ),
          ],
        ),
      ),
    );
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

            // ✅ Drawer solo en móvil/tablet (en escritorio se usa menú web arriba)
            drawer: isDesktop ? null : _buildDrawer(context),

            appBar: AppBar(
              backgroundColor: AppColors.greenDark,
              foregroundColor: Colors.white,
              elevation: 0,

              // ✅ Importante: NO mostrar flecha back en el inicio
              automaticallyImplyLeading: false,

              // ✅ En móvil aparece hamburguesa para abrir Drawer
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

              // ==========================================================
              // ✅ MENÚ DE ESCRITORIO (tipo web) + PERFIL
              // ==========================================================
              actions: isDesktop
                  ? [
                      const SizedBox(width: 6),

                      // Inicio (no hace nada porque ya estamos aquí)
                      _TopLink(text: 'Inicio', onTap: () {}),

                      // Menú Cultivos (hover)
                      _HoverMenu(
                        text: 'Cultivos',
                        items: [
                          _HoverItem('Cultivos', () => _openFeature('Cultivos')),
                          _HoverItem('Fertilizantes', () => _openFeature('Fertilizantes')),
                          _HoverItem('Repelentes', () => _openFeature('Repelentes')),
                          _HoverItem('Insectos', () => _openFeature('Insectos')),
                          _HoverItem('Enfermedades', () => _openFeature('Enfermedades')),
                        ],
                      ),

                      _TopLink(text: 'Favoritos', onTap: () => _openFeature('Favoritos')),

                      // Calendario marcado como principal
                      _TopLink(
                        text: 'Calendario',
                        onTap: () => _openFeature('Calendario'),
                        primary: true,
                      ),

                      _HoverMenu(
                        text: 'Mi huerta',
                        items: [
                          _HoverItem('Notificaciones', () => _openFeature('Notificaciones')),
                          _HoverItem('Preparación de Suelo', () => _openFeature('PreparacionSuelo')),
                          _HoverItem('Diario', () => _openFeature('Diario')),
                        ],
                      ),

                      _HoverMenu(
                        text: 'Otros',
                        items: [
                          _HoverItem('Configuración', () => _openFeature('Configuración')),
                          _HoverItem('Contacto', () => _openFeature('Contacto')),
                          _HoverItem('Créditos', () => _openFeature('Créditos')),
                        ],
                      ),

                      IconButton(
                        tooltip: 'Ayuda',
                        onPressed: _openHelp,
                        icon: const Icon(Icons.help_outline_rounded),
                      ),

                      const SizedBox(width: 10),

                      // Logo circular en Web
                      const _AppLogo(size: 38),
                      const SizedBox(width: 10),

                      // Perfil desplegable (con cámara y logout rojo)
                      _ProfileMenuV2(
                        initials: _initials(_fullName),
                        fullName: _fullName,
                        email: _email,
                        avatarPath: _avatarPath,
                        onChangePhoto: _changeAvatar,
                        onLogout: _logout,
                      ),
                      const SizedBox(width: 12),
                    ]
                  : [
                      // En móvil, solo dejamos el botón ayuda (opcional)
                      IconButton(
                        tooltip: 'Ayuda',
                        onPressed: _openHelp,
                        icon: const Icon(Icons.help_outline_rounded),
                      ),
                      const SizedBox(width: 6),
                    ],
            ),

            // ==========================================================
            // ✅ CONTENIDO PRINCIPAL DEL DASHBOARD
            // ==========================================================
            body: SafeArea(
              child: Stack(
                children: [
                  // Logo de fondo con opacidad
                  Positioned.fill(
                    child: Center(
                      child: Opacity(
                        opacity: 0.60,
                        child: Image.asset(
                          'assets/images/logosp.png',
                          width: 300,
                          height: 300,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: _buildBodyContent(w),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Mini-vistas / tarjetas del inicio (botones grandes)
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
            _DashboardTile(label: 'Cultivos', icon: Icons.local_florist_rounded, onTap: () => _openFeature('Cultivos')),
            _DashboardTile(label: 'Fertilizantes', icon: Icons.science_rounded, onTap: () => _openFeature('Fertilizantes')),
            _DashboardTile(label: 'Repelentes', icon: Icons.sanitizer_rounded, onTap: () => _openFeature('Repelentes')),
            _DashboardTile(label: 'Insectos', icon: Icons.bug_report_rounded, onTap: () => _openFeature('Insectos')),
            _DashboardTile(label: 'Enfermedades', icon: Icons.biotech_rounded, onTap: () => _openFeature('Enfermedades')),
            _DashboardTile(label: 'Preparación de Suelo', icon: Icons.layers_rounded, onTap: () => _openFeature('PreparacionSuelo')),
            _DashboardTile(label: 'Calendario', icon: Icons.calendar_month_rounded, onTap: () => _openFeature('Calendario')),
            _DashboardTile(label: 'Diario', icon: Icons.menu_book_rounded, onTap: () => _openFeature('Diario')),
          ],
        ),
        const SizedBox(height: 24),

        // 1️⃣ Cultivos en tu huerta
        Text('Cultivos en tu huerta', style: TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.w900, fontSize: 18)),
        const SizedBox(height: 12),
        FutureBuilder<List<CropPlan>>(
          future: appDb.getUserCropPlans(widget.userId),
          builder: (context, snapshot) {
            final plans = (snapshot.data ?? []).where((plan) => plan.status != 'finalized').toList();
            if (plans.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.7), borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.greenDark.withOpacity(0.1))),
                child: const Text('No tienes cultivos programados.\nVe a la sección de cultivos para iniciar tu plan.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600)),
              );
            }
            return Column(
              children: plans.map((plan) {
                final start = plan.startDate;
                final now = DateTime.now();
                final daysSince = now.difference(start).inDays;
                final cultivoData = jsonDecode(plan.payloadJson);
                final harvestMonths = (cultivoData['cosechaMeses'] ?? 0) as int;
                final totalDays = harvestMonths * 30;
                final daysRemaining = totalDays - daysSince;
                final progress = totalDays > 0 ? (daysSince / totalDays).clamp(0.0, 1.0) : 0.0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: (plan.colorValue != null ? Color(plan.colorValue!) : AppColors.greenDark).withOpacity(0.3), width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: (plan.colorValue != null ? Color(plan.colorValue!) : AppColors.greenDark).withOpacity(0.2),
                            child: ClipOval(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: _buildCropImage(cultivoData['imagePath'], cultivoData['imagen'] ?? ''),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(plan.nickname ?? plan.cropName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.greenDarker)),
                                Text('Sembrado hace $daysSince días', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.greenSoft)),
                              ],
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => _openFeature('Calendario'),
                            icon: const Icon(Icons.calendar_month_rounded, size: 16),
                            label: const Text('Ver calendario', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            style: TextButton.styleFrom(foregroundColor: AppColors.greenDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey.shade200,
                          color: plan.colorValue != null ? Color(plan.colorValue!) : AppColors.greenDark,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${(progress * 100).toInt()}% del ciclo', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                          Text(daysRemaining > 0 ? 'Faltan $daysRemaining días para cosecha' : '¡Listo para cosechar!', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: AppColors.greenDark)),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 24),

        // 2️⃣ Preparaciones de suelo en curso
        Text('Preparaciones de suelo en curso', style: TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.w900, fontSize: 18)),
        const SizedBox(height: 12),
        FutureBuilder<List<SoilPreparation>>(
          future: appDb.getUserSoilPreparations(widget.userId),
          builder: (context, snapshot) {
            final activePreps = (snapshot.data ?? []).where((p) => p.status == 'active').toList();
            if (activePreps.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.7), borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.greenDark.withOpacity(0.1))),
                child: const Text('No hay preparaciones de suelo en curso.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600)),
              );
            }
            return Column(
              children: activePreps.map((prep) {
                final tasks = (jsonDecode(prep.payloadJson) as List).map((e) => TareaPreparacion.fromJson(e)).toList();
                final progress = tasks.progress;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.greenDark.withOpacity(0.2), width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: AppColors.greenDark.withOpacity(0.1), shape: BoxShape.circle),
                            child: const Icon(Icons.layers_rounded, color: AppColors.greenDark),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(prep.cropName ?? 'Preparación General', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.greenDarker)),
                                Text(tasks.statusMessage, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.greenSoft)),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SoilPreparationDetailPage(preparation: prep))).then((_) => setState(() {})),
                            icon: const Icon(Icons.chevron_right, color: AppColors.greenDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey.shade200,
                          color: AppColors.greenDark,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${(progress * 100).toInt()}% completado', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                          Text(tasks.timeRemainingMessage, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: AppColors.greenDark)),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 24),

        // 3️⃣ Notificaciones
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
        const SizedBox(height: 24),

        // 4️⃣ Cultivos finalizados
        _buildFinalizedCropsSection(),
        const SizedBox(height: 32),

        // 5️⃣ Promo App Móvil
        const _MobileAppPromoSection(),
      ],
    );
  }

  Widget _buildFinalizedCropsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cultivos finalizados', style: TextStyle(color: AppColors.greenDarker, fontWeight: FontWeight.w900, fontSize: 18)),
        const SizedBox(height: 12),
        FutureBuilder<List<CropPlan>>(
          future: appDb.getFinalizedCropPlans(widget.userId),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.7), borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.greenDark.withOpacity(0.1))),
                child: const Text('No tienes cultivos finalizados todavía.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600)),
              );
            }
            final plans = snapshot.data!;
            return Column(
              children: plans.map((plan) {
                final cultivoData = jsonDecode(plan.payloadJson);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.withOpacity(0.3), width: 2),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        child: ClipOval(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: _buildCropImage(cultivoData['imagePath'], cultivoData['imagen'] ?? ''),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(plan.nickname ?? plan.cropName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.greenDarker)),
                            const Text('Cosechado / Finalizado', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_circle_rounded, color: AppColors.greenDark),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  // ==========================================================
  // ✅ DRAWER MÓVIL (MENÚ LATERAL)
  // Aquí también usamos _openFeature para navegar.
  // ==========================================================
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: AppColors.greenDark,
            padding: const EdgeInsets.fromLTRB(16, 44, 16, 20),
            child: Column(
              children: [
                Row(
                  children: [
                    const _AppLogo(size: 50),
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
                              fontSize: 18,
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
                              fontSize: 13.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: _showFullImage,
                        child: _buildAvatar(radius: 45, fontSize: 28),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: _changeAvatar,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.greenDark,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                  onTap: () => Navigator.pop(context),
                ),
                _DrawerItem(
                  icon: Icons.star_rounded,
                  label: 'Favoritos',
                  onTap: () {
                    Navigator.pop(context);
                    _openFeature('Favoritos');
                  },
                ),
                _DrawerItem(
                  icon: Icons.calendar_month_rounded,
                  label: 'Calendario',
                  primary: true,
                  onTap: () {
                    Navigator.pop(context);
                    _openFeature('Calendario');
                  },
                ),

                const SizedBox(height: 6),
                const _DrawerSectionTitle('Cultivos'),
                _DrawerItem(
                  icon: Icons.local_florist_rounded,
                  label: 'Cultivos',
                  onTap: () {
                    Navigator.pop(context);
                    _openFeature('Cultivos');
                  },
                ),
                _DrawerItem(
                  icon: Icons.science_rounded,
                  label: 'Fertilizantes',
                  onTap: () {
                    Navigator.pop(context);
                    _openFeature('Fertilizantes');
                  },
                ),
                _DrawerItem(
                  icon: Icons.sanitizer_rounded,
                  label: 'Repelentes',
                  onTap: () {
                    Navigator.pop(context);
                    _openFeature('Repelentes');
                  },
                ),
                _DrawerItem(
                  icon: Icons.bug_report_rounded,
                  label: 'Insectos',
                  onTap: () {
                    Navigator.pop(context);
                    _openFeature('Insectos');
                  },
                ),
                _DrawerItem(
                  icon: Icons.biotech_rounded,
                  label: 'Enfermedades',
                  onTap: () {
                    Navigator.pop(context);
                    _openFeature('Enfermedades');
                  },
                ),

                const SizedBox(height: 6),
                const _DrawerSectionTitle('Mi huerta'),
                _DrawerItem(
                  icon: Icons.notifications_active_rounded,
                  label: 'Notificaciones',
                  onTap: () {
                    Navigator.pop(context);
                    _openFeature('Notificaciones');
                  },
                ),
                _DrawerItem(
                  icon: Icons.layers_rounded,
                  label: 'Preparación de Suelo',
                  onTap: () {
                    Navigator.pop(context);
                    _openFeature('PreparacionSuelo');
                  },
                ),
                _DrawerItem(
                  icon: Icons.menu_book_rounded,
                  label: 'Diario',
                  onTap: () {
                    Navigator.pop(context);
                    _openFeature('Diario');
                  },
                ),

                const SizedBox(height: 6),
                const _DrawerSectionTitle('Otros'),
                _DrawerItem(
                  icon: Icons.settings_rounded,
                  label: 'Configuración',
                  onTap: () {
                    Navigator.pop(context);
                    _openFeature('Configuración');
                  },
                ),
                _DrawerItem(
                  icon: Icons.contact_mail_rounded,
                  label: 'Contacto',
                  onTap: () {
                    Navigator.pop(context);
                    _openFeature('Contacto');
                  },
                ),
                _DrawerItem(
                  icon: Icons.info_outline_rounded,
                  label: 'Créditos',
                  onTap: () {
                    Navigator.pop(context);
                    _openFeature('Créditos');
                  },
                ),

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
              'Raíces Digitales © 2026 • v1.0',
              style: TextStyle(
                color: AppColors.greenDarker.withOpacity(0.70),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropImage(String? imagePath, String assetImagen) {
    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('data:image')) {
        return Image.memory(
          base64Decode(imagePath.split(',').last),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.local_florist_rounded,
            color: AppColors.greenDarker,
          ),
        );
      } else {
        if (kIsWeb) {
          return Image.network(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.local_florist_rounded,
              color: AppColors.greenDarker,
            ),
          );
        } else {
          return Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.local_florist_rounded,
              color: AppColors.greenDarker,
            ),
          );
        }
      }
    }

    if (assetImagen.isNotEmpty) {
      return Image.asset(
        assetImagen,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.local_florist_rounded,
          color: AppColors.greenDarker,
        ),
      );
    }

    return const Icon(
      Icons.local_florist_rounded,
      color: AppColors.greenDarker,
    );
  }

  Widget _buildAvatar({required double radius, required double fontSize}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      child: _avatarPath == null
          ? Text(
              _initials(_fullName),
              style: TextStyle(
                color: AppColors.greenDarker,
                fontWeight: FontWeight.w900,
                fontSize: fontSize,
              ),
            )
          : ClipOval(
              child: _avatarPath!.startsWith('data:image')
                  ? Image.memory(
                      base64Decode(_avatarPath!.split(',').last),
                      width: radius * 2,
                      height: radius * 2,
                      fit: BoxFit.cover,
                    )
                  : (kIsWeb
                      ? Image.network(
                          _avatarPath!,
                          width: radius * 2,
                          height: radius * 2,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(_avatarPath!),
                          width: radius * 2,
                          height: radius * 2,
                          fit: BoxFit.cover,
                        )),
            ),
    );
  }
}

// ==========================================================
// ✅ COMPONENTES REUTILIZABLES (UI)
// ==========================================================

class _AppLogo extends StatelessWidget {
  final double size;
  const _AppLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: ClipOval(
        child: Image.asset(
          'assets/images/logosp.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

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
                      constraints:
                          const BoxConstraints(minWidth: 190, maxWidth: 220),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 11),
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
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
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
  final String? avatarPath;
  final VoidCallback onChangePhoto;
  final Future<void> Function() onLogout;

  const _ProfileMenuV2({
    required this.initials,
    required this.fullName,
    required this.email,
    this.avatarPath,
    required this.onChangePhoto,
    required this.onLogout,
  });

  Widget _buildSmallAvatar() {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white,
      child: avatarPath == null
          ? Text(
              initials,
              style: const TextStyle(
                color: AppColors.greenDarker,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            )
          : ClipOval(
              child: avatarPath!.startsWith('data:image')
                  ? Image.memory(
                      base64Decode(avatarPath!.split(',').last),
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(avatarPath!),
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ),
            ),
    );
  }

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
          _buildSmallAvatar(),
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
                      child: avatarPath == null
                          ? Text(
                              initials,
                              style: const TextStyle(
                                color: AppColors.greenDarker,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            )
                          : ClipOval(
                              child: avatarPath!.startsWith('data:image')
                                  ? Image.memory(
                                      base64Decode(avatarPath!.split(',').last),
                                      width: 68,
                                      height: 68,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(avatarPath!),
                                      width: 68,
                                      height: 68,
                                      fit: BoxFit.cover,
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

  const _DashboardTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

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

  const _NotificationCard({
    required this.title,
    required this.subtitle,
    required this.onOpen,
  });

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
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.greenDarker,
            fontWeight: FontWeight.w900,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppColors.greenDarker.withOpacity(0.75),
            fontWeight: FontWeight.w700,
          ),
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
        style: TextStyle(
          color: color,
          fontWeight: primary ? FontWeight.w900 : FontWeight.w800,
        ),
      ),
      onTap: onTap,
    );
  }
}

// ✅ Sección Promo App Móvil
class _MobileAppPromoSection extends StatelessWidget {
  const _MobileAppPromoSection();

  static const String apkUrl = 'https://raices-digitales.netlify.app/raices_digitales.apk';

  Future<void> _handleAction(BuildContext context) async {
    try {
      if (kIsWeb) {
        final uri = Uri.parse(apkUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw 'No se pudo abrir el enlace de descarga.';
        }
      } else {
        // En móvil, compartimos el APK
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preparando archivo para compartir...')),
        );
        await fileManagementService.shareApkFromUrl(apkUrl);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.greenDark,
            AppColors.greenDarker.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.greenDark.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone_android_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Lleva Raíces Digitales en tu móvil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Para una experiencia más estable y completa, te recomendamos instalar nuestra aplicación oficial en Android.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoItem(Icons.cloud_off_rounded, 'Funciona sin conexión a internet.'),
          _buildInfoItem(Icons.storage_rounded, 'Almacenamiento persistente y seguro.'),
          _buildInfoItem(Icons.speed_rounded, 'Mayor estabilidad y rapidez.'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => _handleAction(context),
              icon: Icon(kIsWeb ? Icons.download_rounded : Icons.share_rounded),
              label: Text(
                kIsWeb ? 'DESCARGAR APK' : 'COMPARTIR APLICACIÓN',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.greenDarker,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
          if (kIsWeb)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '* En la versión web, algunos datos podrían perderse si limpias el historial o cambias de navegador.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Placeholder temporal para pantallas NO hechas todavía
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
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.greenDark.withOpacity(0.12)),
            ),
            child: Text(
              'Pantalla "$title" (próximamente)',
              style: const TextStyle(
                color: AppColors.greenDarker,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}