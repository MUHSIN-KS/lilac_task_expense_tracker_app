import 'package:flutter/material.dart';
import 'package:lilac_company_task/models/onbordingmodels.dart';


class OnboardingController {
  final OnboardingModel data = const OnboardingModel(
    title: 'Spend Smarter\nSave More',
    imagePath: 'assets/images/onboarding.png',
    buttonText: 'Get Started',
  );

  void onGetStarted(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Get Started pressed')),
    );
  }
}