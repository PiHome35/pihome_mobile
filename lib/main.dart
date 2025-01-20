import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/core/utils/cache/hive_manager.dart';
import 'package:mobile_pihome/features/authentication/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies('mock');
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await getIt<HiveManager>().initHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: ScreenUtilInit(
        ensureScreenSize: true,
        minTextAdapt: true,
        splitScreenMode: true,
        designSize: Size(
          MediaQuery.sizeOf(context).width,
          MediaQuery.sizeOf(context).height,
        ),
        builder: (_, child) => MaterialApp.router(
          title: 'PiHome',
          debugShowCheckedModeBanner: false,
          routerConfig: AppRoutes.router,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}
