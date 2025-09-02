import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/add_transaction_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()..initDB()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: FinTrackApp(),
    ),
  );
}

class FinTrackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'FinTrack',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          routes: {
            '/': (_) => DashboardScreen(),
            '/add-transaction': (_) => AddTransactionScreen(),
          },
        );
      },
    );
  }
}
