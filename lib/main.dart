// import 'package:flutter/material.dart';
// import 'package:lilac_company_task/views/splashscreen.dart';
// import 'package:lilac_company_task/views/onbordingview.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//      home: Splashscreen(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:lilac_company_task/controller/craditcontroller.dart';
import 'package:lilac_company_task/controller/navcontroller.dart';
import 'package:lilac_company_task/controller/profilecontroller.dart';
import 'package:lilac_company_task/controller/transactioncontroller.dart';
import 'package:lilac_company_task/service/hiveservice.dart';
import 'package:lilac_company_task/utils/apptheme.dart';
import 'package:lilac_company_task/views/mainshell.dart';
import 'package:lilac_company_task/views/onbordingview.dart';
import 'package:lilac_company_task/views/splashscreen.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await HiveService.init();
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(body: Center(child: Text('Failed to open database.\n$e', textAlign: TextAlign.center))),
    ));
    return;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionController()..load()),
        ChangeNotifierProvider(create: (_) => CreditController()..load()),
        ChangeNotifierProvider(create: (_) => ProfileController()..load()),
        ChangeNotifierProvider(create: (_) => NavController()),
      ],
      child: const ExpenseApp(),
    ),
  );
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const Splashscreen(),
    );
  }
}