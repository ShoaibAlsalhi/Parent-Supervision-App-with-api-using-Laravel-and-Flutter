import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parent_supervision/core/di/dependency_injection.dart' as di;
import 'package:parent_supervision/core/routes/app_router.dart';
import 'package:parent_supervision/core/theme/app_theme.dart';
import 'package:parent_supervision/presentation/cubits/auth/auth_cubit.dart';
import 'package:parent_supervision/presentation/cubits/device/device_cubit.dart';
import 'package:hive_flutter/hive_flutter.dart'; // استدعاء Hive


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Hive وفتح الصندوق المحلي
  await Hive.initFlutter();
  await Hive.openBox('offline_box');

  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()),
        BlocProvider(create: (_) => di.sl<DeviceCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Family Safety',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,

        // إعدادات اللغة العربية (RTL)
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar', 'AE'), // العربية
          Locale('en', 'US'), // الإنجليزية
        ],
        locale: const Locale('ar', 'AE'), // اللغة الافتراضية

        // ربط نظام التوجيه
        routerConfig: AppRouter.router,
      ),
    );
  }
}