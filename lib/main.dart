import 'package:flutter/material.dart';
import 'crearcuenta.dart';
import 'login.dart';

// ✅ NUEVO: para leer sesión
import 'data/db_instance.dart';
import 'dashboard.dart';

void main() {
  runApp(const MyApp());
}

class AppColors {
  static const Color bg = Color(0xFFF2F8F4);
  static const Color bg2 = Color(0xFFDEE4E9);

  static const Color greenDark = Color(0xFF12603B);
  static const Color greenDarker = Color(0xFF0D452B);
  static const Color greenAccent = Color(0xFF088F00);
  static const Color greenSoft = Color(0xFF517D64);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raíces Digitales',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.greenDark,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),

      // ✅ Rutas correctas (se mantiene tu estructura)
      routes: {
        '/': (_) => const SplashScreen(),

        // ✅ NUEVO: ruta del AppGate (decide si va al dashboard o bienvenida)
        '/appgate': (_) => const AppGate(),

        '/bienvenida': (_) => const BienvenidaPage(),
        '/crear-cuenta': (_) => const CrearCuentaPage(),
        '/login': (_) => const LoginPage(),
      },

      // ✅ Inicia SIEMPRE en splash
      initialRoute: '/',
    );
  }
}

/// ✅ AppGate: decide a dónde ir según si hay sesión guardada.
/// - Si hay sesión -> Dashboard
/// - Si no hay sesión -> Bienvenida
class AppGate extends StatelessWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: appDb.getActiveUserId(),
      builder: (context, snapshot) {
        // Mientras carga
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final userId = snapshot.data;

        // ✅ Si hay sesión guardada, entra directo al dashboard
        if (userId != null) {
          return DashboardPage(userId: userId);
        }

        // ❌ Si no hay sesión, muestra bienvenida
        return const BienvenidaPage();
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _scale = Tween<double>(begin: 0.20, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _glow = Tween<double>(begin: 0.0, end: 16.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    // ✅ Después del splash -> ir al AppGate (NO directo a bienvenida)
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/appgate');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Opacity(
                  opacity: _opacity.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: _scale.value,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/images/logosp.png',
                            width: 220,
                            height: 220,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Raíces Digitales',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.greenDark,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '“Crece con cada idea, construye con cada paso.”',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.greenDarker,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.8,
                          valueColor:
                              AlwaysStoppedAnimation(AppColors.greenDark),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// ✅ BIENVENIDA (aquí van los botones Iniciar sesión / Crear cuenta)
class BienvenidaPage extends StatelessWidget {
  const BienvenidaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/images/logosp.png',
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'BIENVENIDO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.greenDarker,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A RAÍCES DIGITALES',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.greenDark,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3.0,
                    ),
                  ),
                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.greenDark.withOpacity(0.12),
                      ),
                    ),
                    child: const Text(
                      'Para darle seguimiento a tus cultivos necesitamos una cuenta.\n\n'
                      'Guardamos tu historial (siembra, riego, notas y avances)\n'
                      'Puedes ver el progreso de cada cultivo con el tiempo\n'
                      'No pierdes información si cambias de dispositivo\n\n'
                      'Inicia sesión o crea tu cuenta para comenzar.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.greenDarker,
                        fontSize: 15,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  _PrimaryButton(
                    text: 'INICIAR SESIÓN',
                    onTap: () => Navigator.pushNamed(context, '/login'),
                  ),
                  const SizedBox(height: 12),
                  _OutlineButton(
                    text: 'CREAR CUENTA',
                    onTap: () => Navigator.pushNamed(context, '/crear-cuenta'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _PrimaryButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenDarker,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _OutlineButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.greenDarker,
          side: BorderSide(
            color: AppColors.greenDarker.withOpacity(0.55),
            width: 1.6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.bg, AppColors.bg2],
              ),
            ),
          ),
          const _BackgroundDecorations(),
          child,
        ],
      ),
    );
  }
}

class _BackgroundDecorations extends StatelessWidget {
  const _BackgroundDecorations();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 18,
          left: 14,
          child: _CircleDecor(
            size: 54,
            color: AppColors.greenDark.withOpacity(0.12),
            strokeWidth: 3,
          ),
        ),
        Positioned(
          top: 62,
          left: 14,
          child: _CircleDecor(
            size: 54,
            color: AppColors.greenDark.withValues(alpha: 0.12),
            strokeWidth: 3,
          ),
        ),
        Positioned(
          top: 62,
          left: 68,
          child: _CircleDecor(
            size: 12,
            color: AppColors.greenAccent.withOpacity(0.18),
            strokeWidth: 2,
          ),
        ),
        Positioned(
          top: 26,
          right: 18,
          child: _CircleDecor(
            size: 38,
            color: AppColors.greenSoft.withOpacity(0.13),
            strokeWidth: 3,
          ),
        ),
        Positioned(
          top: 14,
          right: 70,
          child: _CircleDecor(
            size: 10,
            color: AppColors.greenAccent.withOpacity(0.18),
            strokeWidth: 2,
          ),
        ),
        Positioned(
          bottom: 70,
          left: 18,
          child: Column(
            children: List.generate(
              4,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: List.generate(
                    4,
                    (_) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.greenDark.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 26,
          right: 16,
          child: _CircleDecor(
            size: 62,
            color: AppColors.greenDark.withOpacity(0.12),
            strokeWidth: 3,
          ),
        ),
        Positioned(
          bottom: 18,
          right: 78,
          child: _CircleDecor(
            size: 14,
            color: AppColors.greenAccent.withOpacity(0.18),
            strokeWidth: 2,
          ),
        ),
      ],
    );
  }
}

class _CircleDecor extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const _CircleDecor({
    required this.size,
    required this.color,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: strokeWidth),
        ),
      ),
    );
  }
}