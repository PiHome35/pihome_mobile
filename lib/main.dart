import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/features/authentication/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = AppRoutes.router;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => getIt<AuthBloc>(),
      child: ScreenUtilInit(
        ensureScreenSize: true,
        minTextAdapt: true,
        designSize: Size(
          MediaQuery.sizeOf(context).width,
          MediaQuery.sizeOf(context).height,
        ),
        builder: (context, child) {
          return MaterialApp.router(
            routerConfig: _router,
            title: 'PiHome',
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
