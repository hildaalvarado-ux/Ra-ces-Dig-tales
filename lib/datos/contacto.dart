import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../data/common_widgets.dart';

class ContactoPage extends StatefulWidget {
  const ContactoPage({super.key});

  @override
  State<ContactoPage> createState() => _ContactoPageState();
}

class _ContactoPageState extends State<ContactoPage> {
  final TextEditingController _mensajeCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _aceptoPrivacidad = false;

  Future<void> _enviarCorreo() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_aceptoPrivacidad) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, acepta el uso de tus datos para continuar.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    final String body = Uri.encodeComponent(_mensajeCtrl.text);
    final String subject = Uri.encodeComponent('Comentario desde Raíces Digitales');
    // Nuevo correo oficial de soporte
    final Uri mailUri = Uri.parse('mailto:soporteraicesdigitales@gmail.com?subject=$subject&body=$body');

    try {
      if (await canLaunchUrl(mailUri)) {
        await launchUrl(mailUri);
        // Mostrar mensaje de agradecimiento al intentar enviar
        if (mounted) {
          _mostrarDialogoGracias();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo abrir la aplicación de correo')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _mostrarDialogoGracias() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.volunteer_activism_rounded, color: AppColors.greenDark, size: 30),
              SizedBox(width: 10),
              Text('¡Muchas gracias!', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.greenDarker)),
            ],
          ),
          content: const Text(
            'Gracias por tus comentarios. Tu opinión nos ayuda a mejorar la aplicación y brindar una mejor experiencia.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.greenDarker),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _mensajeCtrl.clear();
                setState(() {
                  _aceptoPrivacidad = false;
                });
              },
              child: const Text('ACEPTAR', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.greenDark)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Soporte Técnico',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo / Ilustración
                  Image.asset(
                    'assets/images/logosp.png',
                    height: 110,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '¡Queremos escucharte!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.greenDarker,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tu opinión nos permite mejorar Raíces Digitales día con día.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greenSoft,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Card Principal
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.greenDark.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.edit_note_rounded, color: AppColors.greenDark, size: 28),
                            SizedBox(width: 8),
                            Text(
                              'Escribe tu comentario',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: AppColors.greenDarker,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _mensajeCtrl,
                          minLines: 4,
                          maxLines: 6,
                          validator: (v) => (v == null || v.isEmpty) ? 'Por favor escribe un mensaje' : null,
                          decoration: InputDecoration(
                            hintText: 'Sugerencias, dudas o problemas técnicos...',
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.grey.shade100),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: AppColors.greenDark, width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Sección de Privacidad Informativa
                        Row(
                          children: [
                            Icon(Icons.shield_rounded, color: AppColors.greenDark.withOpacity(0.6), size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Uso de Datos Personales',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.greenDarker,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'La información compartida y tu correo se utilizarán únicamente para brindarte atención personalizada y mejorar la app, cumpliendo con nuestras políticas de seguridad.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey.shade700,
                            height: 1.3,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Checkbox Obligatorio
                        InkWell(
                          onTap: () => setState(() => _aceptoPrivacidad = !_aceptoPrivacidad),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Checkbox(
                                    value: _aceptoPrivacidad,
                                    onChanged: (v) => setState(() => _aceptoPrivacidad = v ?? false),
                                    activeColor: AppColors.greenDark,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Estoy informado y acepto el uso de mis datos para soporte y mejora.',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.greenDarker,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Botón Enviar
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: _enviarCorreo,
                            icon: const Icon(Icons.send_rounded),
                            label: const Text(
                              'ENVIAR COMENTARIO',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                                fontSize: 15,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greenDarker,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'También puedes escribirnos directamente a:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.greenSoft),
                  ),
                  const Text(
                    'soporteraicesdigitales@gmail.com',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.greenDark),
                  ),

                  const SizedBox(height: 30),
                  const CopyrightFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
