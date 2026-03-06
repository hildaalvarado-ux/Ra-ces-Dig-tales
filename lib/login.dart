import 'package:flutter/material.dart';
import 'main.dart';
import 'data/db_instance.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _userOrEmailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _hidePass = true;
  bool _loading = false;

  @override
  void dispose() {
    _userOrEmailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.82),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: AppColors.greenDark.withValues(alpha: 0.14)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: AppColors.greenDark.withValues(alpha: 0.14)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: AppColors.greenDark.withValues(alpha: 0.55),
          width: 1.6,
        ),
      ),
      suffixIcon: suffixIcon,
    );
  }

  Future<void> _doLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final userOrEmail = _userOrEmailCtrl.text.trim();
    final pass = _passCtrl.text;

    setState(() => _loading = true);

    try {
      // Forzar apertura de la BD
      await appDb.executor.ensureOpen(appDb);

      // 1) Verificar si el usuario/correo existe
      final existing = await appDb.findUserByUsernameOrEmail(userOrEmail);

      if (!mounted) return;

      if (existing == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ El usuario o correo no existe.')),
        );
        return;
      }

      // 2) Si existe, validar contraseña
      final user = await appDb.authenticate(
        userOrEmail: userOrEmail,
        password: pass,
      );

      if (!mounted) return;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Contraseña incorrecta.')),
        );
        return;
      }

      // 3) Login correcto
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Bienvenido, ${user.fullName}!')),
      );

      // Aquí luego redirigimos a la pantalla principal (cuando la hagamos).
      // Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error al iniciar sesión: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: _loading ? null : () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: AppColors.greenDarker,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          color: AppColors.greenDarker,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/logosp.png',
                    width: 110,
                    height: 110,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Accede para continuar con el seguimiento de tus cultivos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.greenDarker,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 18),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _userOrEmailCtrl,
                          enabled: !_loading,
                          textInputAction: TextInputAction.next,
                          decoration: _inputDecoration(
                            label: 'Usuario o correo',
                            hint: 'usuario o correo@ejemplo.com',
                          ),
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) {
                              return 'Escribe tu usuario o correo.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        TextFormField(
                          controller: _passCtrl,
                          enabled: !_loading,
                          obscureText: _hidePass,
                          textInputAction: TextInputAction.done,
                          decoration: _inputDecoration(
                            label: 'Contraseña',
                            hint: 'Tu contraseña',
                            suffixIcon: IconButton(
                              onPressed: _loading
                                  ? null
                                  : () => setState(() => _hidePass = !_hidePass),
                              icon: Icon(
                                _hidePass ? Icons.visibility_off : Icons.visibility,
                              ),
                            ),
                          ),
                          validator: (v) {
                            final value = (v ?? '');
                            if (value.isEmpty) return 'Escribe tu contraseña.';
                            if (value.length < 6) return 'Mínimo 6 caracteres.';
                            return null;
                          },
                          onFieldSubmitted: (_) => _loading ? null : _doLogin(),
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _doLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greenDarker,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 0,
                            ),
                            child: _loading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.6,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'INICIAR SESIÓN',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        TextButton(
                          onPressed: _loading
                              ? null
                              : () => Navigator.pushReplacementNamed(
                                    context,
                                    '/crear-cuenta',
                                  ),
                          child: Text(
                            '¿No tienes cuenta? → Crear cuenta',
                            style: TextStyle(
                              color: AppColors.greenDark.withValues(alpha: 0.95),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}