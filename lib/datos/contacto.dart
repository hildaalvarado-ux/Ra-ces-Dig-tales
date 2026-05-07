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

  Future<void> _enviarCorreo() async {
    if (!_formKey.currentState!.validate()) return;

    final String body = Uri.encodeComponent(_mensajeCtrl.text);
    final String subject = Uri.encodeComponent('Comentario desde Raíces Digitales');
    final Uri gmailUri = Uri.parse('mailto:raicesdigitalesdev@gmail.com?subject=$subject&body=$body');

    try {
      if (await canLaunchUrl(gmailUri)) {
        await launchUrl(gmailUri);
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
            'Contacto',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
const CopyrightFooter(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '¡Contáctanos!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: AppColors.greenDarker,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tu opinión es muy importante para nosotros. Envíanos tus comentarios, sugerencias o dudas.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greenSoft.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: AppColors.greenDark.withOpacity(0.15),
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mensaje',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: AppColors.greenDarker,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _mensajeCtrl,
                          minLines: 5,
                          maxLines: 8,
                          validator: (v) => (v == null || v.isEmpty) ? 'Por favor escribe un mensaje' : null,
                          decoration: InputDecoration(
                            hintText: 'Escribe tu comentario aquí...',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: AppColors.greenDark.withOpacity(0.1),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            onPressed: _enviarCorreo,
                            icon: const Icon(Icons.send_rounded),
                            label: const Text(
                              'ENVIAR COMENTARIO',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greenDarker,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.greenDark.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.security_rounded, color: AppColors.greenDark),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Tu privacidad es importante. Al enviar este mensaje, tu correo electrónico será utilizado únicamente para dar seguimiento a tu solicitud de acuerdo con nuestras políticas de seguridad y datos personales.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.greenDarker.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
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
