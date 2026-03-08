import 'package:flutter/material.dart';
import 'main.dart';
import 'data/db_instance.dart';

class CrearCuentaPage extends StatefulWidget {
  const CrearCuentaPage({super.key});

  @override
  State<CrearCuentaPage> createState() => _CrearCuentaPageState();
}

class _CrearCuentaPageState extends State<CrearCuentaPage> {
  final _formKey = GlobalKey<FormState>();

  final _nombreCtrl = TextEditingController();
  final _usuarioCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _hidePass = true;
  bool _hideConfirm = true;

  String _suggestion = '';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nombreCtrl.addListener(_updateSuggestion);
  }

  @override
  void dispose() {
    _nombreCtrl.removeListener(_updateSuggestion);
    _nombreCtrl.dispose();
    _usuarioCtrl.dispose();
    _correoCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _updateSuggestion() {
    final name = _nombreCtrl.text.trim();
    final suggestion = _buildUsernameSuggestion(name);
    if (suggestion == _suggestion) return;
    setState(() => _suggestion = suggestion);
  }

  String _buildUsernameSuggestion(String fullName) {
    if (fullName.isEmpty) return '';
    final parts = fullName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-záéíóúñ\s]'), '')
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '';
    final first = parts.first;
    final last = parts.length >= 2 ? parts.last : 'cultivo';

    final raw = '$first.$last';
    return raw
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ñ', 'n');
  }

  void _useSuggestion() {
    if (_suggestion.isEmpty) return;
    _usuarioCtrl.text = _suggestion;
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
      fillColor: Colors.white.withOpacity(0.82),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: AppColors.greenDark.withOpacity(0.14)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: AppColors.greenDark.withOpacity(0.14)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: AppColors.greenDark.withOpacity(0.55),
          width: 1.6,
        ),
      ),
      suffixIcon: suffixIcon,
    );
  }

  String _friendlyDbError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('unique') && msg.contains('username')) {
      return 'Ese usuario ya existe. Prueba otro.';
    }
    if (msg.contains('unique') && msg.contains('email')) {
      return 'Ese correo ya está registrado. Usa otro correo.';
    }
    if (msg.contains('constraint')) {
      return 'No se pudo guardar por una restricción. Revisa tus datos.';
    }
    if (msg.contains('unsupportederror') || msg.contains('sqlite3') || msg.contains('wasm')) {
      return 'Error de base de datos. Si estás en web, asegúrate de que los archivos WASM carguen.';
    }
    return 'No se pudo crear la cuenta. Intenta nuevamente. (Error: $e)';
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    final fullName = _nombreCtrl.text.trim();
    final username = _usuarioCtrl.text.trim();
    final email = _correoCtrl.text.trim();
    final password = _passCtrl.text;

    setState(() => _saving = true);
    try {
      // Verificar si la base de datos está disponible (esto forzará la inicialización si falla)
      await appDb.executor.ensureOpen(appDb);

      await appDb.createUser(
        fullName: fullName,
        username: username,
        email: email,
        password: password,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Cuenta creada correctamente.')),
      );

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ ${_friendlyDbError(e)}')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
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
                        onPressed: _saving ? null : () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: AppColors.greenDarker,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Crear cuenta',
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
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Crea tu cuenta para guardar y dar seguimiento a tus cultivos.',
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
                          controller: _nombreCtrl,
                          textInputAction: TextInputAction.next,
                          enabled: !_saving,
                          decoration: _inputDecoration(
                            label: 'Nombre completo',
                            hint: 'Al menos un nombre y un apellido ',
                          ),
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return 'Escribe tu nombre completo.';
                            if (value.split(RegExp(r'\s+')).length < 2) {
                              return 'Incluye al menos nombre y apellido.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        TextFormField(
                          controller: _usuarioCtrl,
                          textInputAction: TextInputAction.next,
                          enabled: !_saving,
                          decoration: _inputDecoration(
                            label: 'Usuario',
                            hint: 'Ej:ah002',
                            suffixIcon: (_suggestion.isEmpty)
                                ? null
                                : IconButton(
                                    tooltip: 'Usar sugerencia',
                                    onPressed: _saving ? null : _useSuggestion,
                                    icon: const Icon(Icons.auto_fix_high_rounded),
                                  ),
                          ),
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return 'Elige un usuario.';
                            if (value.length < 4) return 'Usuario muy corto.';
                            if (value.contains(' ')) return 'No uses espacios.';
                            return null;
                          },
                        ),

                        if (_suggestion.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: _saving ? null : _useSuggestion,
                              child: Text(
                                'Sugerencia: $_suggestion  (toca para usarla)',
                                style: TextStyle(
                                  color: AppColors.greenDark.withOpacity(0.90),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 14),

                        TextFormField(
                          controller: _correoCtrl,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          enabled: !_saving,
                          decoration: _inputDecoration(
                            label: 'Correo electrónico',
                            hint: 'Ej: correo@ejemplo.com',
                          ),
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return 'Escribe tu correo.';
                            final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                .hasMatch(value);
                            if (!ok) return 'Correo no válido.';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        TextFormField(
                          controller: _passCtrl,
                          obscureText: _hidePass,
                          textInputAction: TextInputAction.next,
                          enabled: !_saving,
                          decoration: _inputDecoration(
                            label: 'Contraseña',
                            hint: 'Mínimo 6 caracteres',
                            suffixIcon: IconButton(
                              onPressed: _saving
                                  ? null
                                  : () => setState(() => _hidePass = !_hidePass),
                              icon: Icon(
                                  _hidePass ? Icons.visibility_off : Icons.visibility),
                            ),
                          ),
                          validator: (v) {
                            final value = (v ?? '');
                            if (value.isEmpty) return 'Escribe una contraseña.';
                            if (value.length < 6) return 'Mínimo 6 caracteres.';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        TextFormField(
                          controller: _confirmCtrl,
                          obscureText: _hideConfirm,
                          textInputAction: TextInputAction.done,
                          enabled: !_saving,
                          decoration: _inputDecoration(
                            label: 'Confirmar contraseña',
                            suffixIcon: IconButton(
                              onPressed: _saving
                                  ? null
                                  : () => setState(
                                      () => _hideConfirm = !_hideConfirm),
                              icon: Icon(_hideConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                          validator: (v) {
                            final value = (v ?? '');
                            if (value.isEmpty) return 'Confirma tu contraseña.';
                            if (value != _passCtrl.text) {
                              return 'No coincide con la contraseña.';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _saving ? null : _createAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greenDarker,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 0,
                            ),
                            child: _saving
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
                                    'CREAR CUENTA',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        TextButton(
                          onPressed: _saving
                              ? null
                              : () => Navigator.pushReplacementNamed(
                                    context,
                                    '/login',
                                  ),
                          child: Text(
                            'Ya tengo cuenta → Iniciar sesión',
                            style: TextStyle(
                              color: AppColors.greenDark.withOpacity(0.95),
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
