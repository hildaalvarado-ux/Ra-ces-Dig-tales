import 'dart:io';
import 'package:flutter/foundation.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool _aceptoPrivacidad = false;

  Future<void> _enviarCorreo() async {
    if (!_aceptoPrivacidad) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, acepta el uso de tus datos para continuar.',
          ),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    try {
      const correo = 'soporteraicesdigitales@gmail.com';

      final asunto = Uri.encodeComponent(
        'Comentario desde Raíces Digitales',
      );

      final mensaje = Uri.encodeComponent('');

      // WEB
      if (kIsWeb) {
        final Uri gmailWeb = Uri.parse(
          'https://mail.google.com/mail/?view=cm&fs=1'
          '&to=$correo'
          '&su=$asunto'
          '&body=$mensaje',
        );

        await launchUrl(
          gmailWeb,
          mode: LaunchMode.externalApplication,
        );

        if (mounted) {
          _mostrarDialogoGracias();
        }

        return;
      }

      // ANDROID / IOS
      if (Platform.isAndroid || Platform.isIOS) {
        final String encodedSubject = Uri.decodeComponent(asunto);
        final String encodedBody = Uri.decodeComponent(mensaje);

        final Uri mailtoUri = Uri(
          scheme: 'mailto',
          path: correo,
          queryParameters: {
            'subject': encodedSubject,
            'body': encodedBody,
          },
        );

        // En iOS, el usuario pidió priorizar Gmail si está disponible
        if (Platform.isIOS) {
          final Uri gmailApp = Uri.parse(
            'googlegmail://co?to=$correo&subject=$asunto&body=$mensaje',
          );

          if (await canLaunchUrl(gmailApp)) {
            await launchUrl(
              gmailApp,
              mode: LaunchMode.externalApplication,
            );

            if (mounted) {
              _mostrarDialogoGracias();
            }
            return;
          }
        }

        // Para Android (y iOS si no tiene Gmail o no se usó arriba), mailto es el estándar
        // que abrirá el selector o la app por defecto (incluyendo Gmail si es la seleccionada)
        if (await canLaunchUrl(mailtoUri)) {
          await launchUrl(
            mailtoUri,
            mode: LaunchMode.externalApplication,
          );

          if (mounted) {
            _mostrarDialogoGracias();
          }
        } else {
          throw 'No se encontró una aplicación de correo instalada para realizar esta acción.';
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.greenDark,
                size: 30,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  '¡Correo enviado con éxito!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.greenDarker,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Gracias por tus comentarios. Tu opinión nos ayuda a mejorar la aplicación.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.greenDarker,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                setState(() {
                  _aceptoPrivacidad = false;
                });
              },
              child: const Text(
                'ACEPTAR',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppColors.greenDark,
                ),
              ),
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
            'Contacto',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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

                  Text(
                    'Tu opinión es importante para nosotros. Envíanos tus comentarios, sugerencias o dudas.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greenSoft,
                    ),
                  ),

                  const SizedBox(height: 32),

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
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 2,
                      ),
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
                        Checkbox(
                          value: _aceptoPrivacidad,
                          onChanged: (val) {
                            setState(() {
                              _aceptoPrivacidad = val ?? false;
                            });
                          },
                          activeColor: AppColors.greenDark,
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _aceptoPrivacidad =
                                    !_aceptoPrivacidad;
                              });
                            },
                            child: Text(
                              'Tu privacidad es importante. Al enviar este mensaje, tu correo electrónico será utilizado únicamente para dar seguimiento a tu solicitud.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.greenDarker
                                    .withOpacity(0.7),
                              ),
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