import 'package:flutter/material.dart';
import 'package:outty/core/constants/string_constants.dart';
import 'package:outty/core/providers/theme_provider.dart';
import 'package:outty/core/routes/app_router.dart';
import 'package:provider/provider.dart';
import 'package:outty/core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          child: MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: AppRouter.initialRoute,
            onGenerateRoute: AppRouter.onGenerateRoute,
          ),
        );
      },
    );
  }
}
