import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'data/db_instance.dart';
import 'data/app_database.dart';

class RecuperarPassPage extends StatefulWidget {
  const RecuperarPassPage({super.key});

  @override
  State<RecuperarPassPage> createState() => _RecuperarPassPageState();
}

class _RecuperarPassPageState extends State<RecuperarPassPage> {
  final _formKey = GlobalKey<FormState>();
  final _userOrEmailCtrl = TextEditingController();
  final _answerCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  int _currentStep = 1; // 1: Search, 2: Question, 3: New Pass
  bool _loading = false;
  bool _hidePass = true;
  bool _hideConfirm = true;
  User? _foundUser;

  @override
  void dispose() {
    _userOrEmailCtrl.dispose();
    _answerCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
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

  Future<void> _searchUser() async {
    if (!_formKey.currentState!.validate()) return;
    final input = _userOrEmailCtrl.text.trim();

    setState(() => _loading = true);
    try {
      final user = await appDb.findUserByUsernameOrEmail(input);
      if (!mounted) return;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró ningún usuario con ese dato.')),
        );
      } else {
        if (user.securityQuestion.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tu cuenta no tiene una pregunta de seguridad configurada. Contacta a soporte.')),
          );
        } else {
          setState(() {
            _foundUser = user;
            _currentStep = 2;
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _verifyAnswer() async {
    if (!_formKey.currentState!.validate()) return;
    final answer = _answerCtrl.text.trim().toLowerCase();

    // Hash the input answer
    final bytes = utf8.encode(answer);
    final hashedAnswer = sha256.convert(bytes).toString();

    if (hashedAnswer == _foundUser!.securityAnswer) {
      setState(() => _currentStep = 3);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Respuesta incorrecta.')),
      );
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    final newPass = _passCtrl.text;

    setState(() => _loading = true);
    try {
      await appDb.updateUserPassword(_foundUser!.id, newPass);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Contraseña actualizada correctamente.')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
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
          padding: const EdgeInsets.all(18),
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
                        'Recuperar contraseña',
                        style: TextStyle(
                          color: AppColors.greenDarker,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Progress Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStepCircle(1, _currentStep >= 1),
                      _buildStepLine(_currentStep >= 2),
                      _buildStepCircle(2, _currentStep >= 2),
                      _buildStepLine(_currentStep >= 3),
                      _buildStepCircle(3, _currentStep >= 3),
                    ],
                  ),
                  const SizedBox(height: 30),

                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_currentStep == 1) _buildStep1(),
                        if (_currentStep == 2) _buildStep2(),
                        if (_currentStep == 3) _buildStep3(),

                        const SizedBox(height: 25),

                        ElevatedButton(
                          onPressed: _loading ? null : _onNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.greenDarker,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  _currentStep == 3 ? 'RESTABLECER' : 'CONTINUAR',
                                  style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
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

  Widget _buildStepCircle(int step, bool active) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: active ? AppColors.greenDark : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: active ? AppColors.greenDark : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '$step',
          style: TextStyle(
            color: active ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStepLine(bool active) {
    return Container(
      width: 40,
      height: 2,
      color: active ? AppColors.greenDark : Colors.grey.shade300,
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        const Icon(Icons.person_search_rounded, size: 64, color: AppColors.greenDark),
        const SizedBox(height: 16),
        const Text(
          'Identifica tu cuenta',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        const Text(
          'Ingresa tu usuario o correo electrónico para comenzar.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _userOrEmailCtrl,
          decoration: _inputDecoration(
            label: 'Usuario o correo',
            hint: 'Ej: ah002 o correo@ejemplo.com',
          ),
          validator: (v) => (v ?? '').isEmpty ? 'Ingresa tu usuario o correo.' : null,
          onFieldSubmitted: (_) => _searchUser(),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        const Icon(Icons.security_rounded, size: 64, color: AppColors.greenDark),
        const SizedBox(height: 16),
        const Text(
          'Pregunta de seguridad',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.greenDark.withOpacity(0.2)),
          ),
          child: Text(
            _foundUser?.securityQuestion ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.greenDarker,
            ),
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _answerCtrl,
          decoration: _inputDecoration(
            label: 'Tu respuesta',
            hint: 'Escribe la respuesta aquí',
          ),
          validator: (v) => (v ?? '').isEmpty ? 'Ingresa la respuesta.' : null,
          onFieldSubmitted: (_) => _verifyAnswer(),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        const Icon(Icons.lock_reset_rounded, size: 64, color: AppColors.greenDark),
        const SizedBox(height: 16),
        const Text(
          'Nueva contraseña',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        const Text(
          'Elige una contraseña segura que puedas recordar.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _passCtrl,
          obscureText: _hidePass,
          decoration: _inputDecoration(
            label: 'Nueva contraseña',
            suffixIcon: IconButton(
              icon: Icon(_hidePass ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _hidePass = !_hidePass),
            ),
          ),
          validator: (v) {
            if ((v ?? '').isEmpty) return 'Ingresa una contraseña.';
            if (v!.length < 6) return 'Mínimo 6 caracteres.';
            return null;
          },
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _confirmCtrl,
          obscureText: _hideConfirm,
          decoration: _inputDecoration(
            label: 'Confirmar contraseña',
            suffixIcon: IconButton(
              icon: Icon(_hideConfirm ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _hideConfirm = !_hideConfirm),
            ),
          ),
          validator: (v) {
            if ((v ?? '') != _passCtrl.text) return 'Las contraseñas no coinciden.';
            return null;
          },
          onFieldSubmitted: (_) => _resetPassword(),
        ),
      ],
    );
  }

  void _onNext() {
    if (_currentStep == 1) {
      _searchUser();
    } else if (_currentStep == 2) {
      _verifyAnswer();
    } else if (_currentStep == 3) {
      _resetPassword();
    }
  }
}
