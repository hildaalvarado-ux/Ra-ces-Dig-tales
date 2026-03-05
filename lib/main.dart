import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class AppColors {
  // Paleta basada en tus imágenes
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
      home: const SplashScreen(),
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

    // Zoom desde el fondo hacia adelante
    _scale = Tween<double>(begin: 0.20, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Aparición suave
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Brillo suave
    _glow = Tween<double>(begin: 0.0, end: 16.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    // Ahora sí: splash visible por ~7 segundos
    Future.delayed(const Duration(seconds: 7), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => const HomePage(),
          transitionsBuilder: (_, animation, __, child) {
            final fade = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            );
            return FadeTransition(opacity: fade, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo principal
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.bg, AppColors.bg2],
              ),
            ),
          ),

          // Decoraciones más vistosas y ordenadas
          const _BackgroundDecorations(),

          // Contenido principal sin cuadro
          SafeArea(
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
                          // Logo con zoom
                          Transform.scale(
                            scale: _scale.value,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.greenAccent.withOpacity(0.12),
                                    blurRadius: _glow.value,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/logosp.png',
                                width: 180,
                                height: 180,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Subtítulo
                          const Text(
                            'Bienvenido a Raíces Digitales',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.greenDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Frase motivadora
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

                          const SizedBox(height: 22),

                          // Versión
                          Text(
                            'Versión 1.0',
                            style: TextStyle(
                              color: AppColors.greenSoft.withOpacity(0.95),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Loader
                          const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.8,
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.greenDark,
                              ),
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
        // Arriba izquierda
        Positioned(
          top: 22,
          left: 16,
          child: _CircleDecor(
            size: 56,
            color: AppColors.greenDark.withOpacity(0.12),
            strokeWidth: 3,
          ),
        ),
        Positioned(
          top: 66,
          left: 70,
          child: _CircleDecor(
            size: 12,
            color: AppColors.greenAccent.withOpacity(0.18),
            strokeWidth: 2,
          ),
        ),

        // Arriba derecha
        Positioned(
          top: 38,
          right: 26,
          child: _CircleDecor(
            size: 34,
            color: AppColors.greenSoft.withOpacity(0.13),
            strokeWidth: 3,
          ),
        ),
        Positioned(
          top: 18,
          right: 72,
          child: _CircleDecor(
            size: 10,
            color: AppColors.greenAccent.withOpacity(0.18),
            strokeWidth: 2,
          ),
        ),

        // Centro izquierda
        Positioned(
          top: 230,
          left: 24,
          child: _CircleDecor(
            size: 18,
            color: AppColors.greenDark.withOpacity(0.10),
            strokeWidth: 2,
          ),
        ),

        // Centro derecha
        Positioned(
          top: 290,
          right: 28,
          child: _CircleDecor(
            size: 22,
            color: AppColors.greenAccent.withOpacity(0.10),
            strokeWidth: 2,
          ),
        ),

        // Abajo izquierda
        Positioned(
          bottom: 90,
          left: 30,
          child: _CircleDecor(
            size: 28,
            color: AppColors.greenSoft.withOpacity(0.10),
            strokeWidth: 3,
          ),
        ),
        Positioned(
          bottom: 58,
          left: 72,
          child: _CircleDecor(
            size: 10,
            color: AppColors.greenAccent.withOpacity(0.16),
            strokeWidth: 2,
          ),
        ),

        // Abajo derecha
        Positioned(
          bottom: 34,
          right: 20,
          child: _CircleDecor(
            size: 62,
            color: AppColors.greenDark.withOpacity(0.12),
            strokeWidth: 3,
          ),
        ),
        Positioned(
          bottom: 24,
          right: 80,
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
          border: Border.all(
            color: color,
            width: strokeWidth,
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raíces Digitales'),
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.greenDarker,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.greenDark.withOpacity(0.15),
            ),
          ),
          child: const Text(
            'Home (aquí seguirá tu app)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.greenDarker,
            ),
          ),
        ),
      ),
    );
  }
}