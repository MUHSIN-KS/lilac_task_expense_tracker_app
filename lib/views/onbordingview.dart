import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lilac_company_task/controller/onbordingcontroller.dart';
import 'package:lilac_company_task/views/mainshell.dart';
import 'package:lilac_company_task/widgets/appcolors.dart';
import 'package:lilac_company_task/widgets/primarywidgets.dart';


class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController();
    final data = controller.data;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Image.asset(
                  "asset/Man.png",
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.image_outlined,
                    size: 80,
                    color: AppColors.title,
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      data.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.title,
                      ),
                    ),
                    const Spacer(),
                    PrimaryButton(
                      text: data.buttonText,
                      onPressed: () => controller.onGetStarted(context),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class AppColors {
  AppColors._();

  static const Color background = Color(0xFFEAF6F5);
  static const Color title = Color(0xFF3F8A82);
  static const Color buttonStart = Color(0xFF6FB3AA);
  static const Color buttonEnd = Color(0xFF3F8A82);
  static const Color buttonShadow = Color(0x663F8A82);
  static const Color white = Colors.white;
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [AppColors.buttonStart, AppColors.buttonEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.buttonShadow,
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainShell()));
          },
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}