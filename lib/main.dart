import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sgmc_app/core/localization/app_localizations.dart';
import 'package:sgmc_app/core/theme/app_theme.dart';
import 'package:sgmc_app/data/data_sources/local_data_source.dart';
import 'package:sgmc_app/data/repositories/service_repository.dart';
import 'package:sgmc_app/logic/cubits/service/cubit/service_cubit.dart';
import 'package:sgmc_app/logic/cubits/settings/settings_cubit.dart';
import 'package:sgmc_app/logic/cubits/settings/settings_state.dart';
import 'package:sgmc_app/presentation/screens/home_screen.dart';
import 'package:sgmc_app/presentation/screens/language_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit()..loadSettings(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          if (settingsState is! SettingsLoaded) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          // Check if first launch
          if (settingsState.isFirstLaunch) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              home: const LanguageSelectionScreen(),
            );
          }

          // Normal app flow
          final repository = ServiceRepository(LocalDataSource());

          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<SettingsCubit>()),
              BlocProvider(
                create: (_) =>
                    ServiceCubit(repository, settingsState.locale.languageCode)
                      ..loadData(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'SGMC Services',

              // Localization
              locale: settingsState.locale,
              supportedLocales: const [Locale('en', ''), Locale('ar', '')],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              // Theme
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: settingsState.themeMode,

              // Home
              home: const HomeScreen(),
            ),
          );
        },
      ),
    );
  }
}
