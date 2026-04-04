import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../data/settings_provider.dart';

class AparienciaPage extends StatelessWidget {
  const AparienciaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Apariencia',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Personalización',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.greenDarker,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ajusta la interfaz a tu gusto',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greenSoft.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 32),

                const Text(
                  'Tamaño del texto',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.greenDarker,
                  ),
                ),
                const SizedBox(height: 16),

                _buildSizeOption(
                  context: context,
                  title: 'Pequeño',
                  value: AppTextSize.pequeno,
                  groupValue: settings.textSize,
                  onChanged: (val) => settings.setTextSize(val!),
                ),
                const SizedBox(height: 10),
                _buildSizeOption(
                  context: context,
                  title: 'Normal',
                  value: AppTextSize.normal,
                  groupValue: settings.textSize,
                  onChanged: (val) => settings.setTextSize(val!),
                ),
                const SizedBox(height: 10),
                _buildSizeOption(
                  context: context,
                  title: 'Grande',
                  value: AppTextSize.grande,
                  groupValue: settings.textSize,
                  onChanged: (val) => settings.setTextSize(val!),
                ),

                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.greenDark.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.visibility_rounded,
                        color: AppColors.greenDark,
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Vista previa del texto',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppColors.greenDarker,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Así es como se verá el contenido en la aplicación. Puedes ajustar el tamaño para mayor comodidad visual.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.greenDarker.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildSizeOption({
    required BuildContext context,
    required String title,
    required AppTextSize value,
    required AppTextSize groupValue,
    required ValueChanged<AppTextSize?> onChanged,
  }) {
    final isSelected = value == groupValue;
    return Material(
      color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
      borderRadius: BorderRadius.circular(16),
      elevation: isSelected ? 2 : 0,
      child: InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppColors.greenDark
                  : AppColors.greenDark.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Radio<AppTextSize>(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: AppColors.greenDark,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.greenDarker,
                ),
              ),
              const Spacer(),
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.greenDark,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
