import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lg_star_command/core/services/ssh_service.dart';
import 'package:lg_star_command/features/connection/data/connection_repository.dart';
import 'package:lg_star_command/features/connection/presentation/bloc/connection_bloc.dart';
import 'package:lg_star_command/features/dashboard/data/dashboard_repository.dart';
import 'package:lg_star_command/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:lg_star_command/features/connection/presentation/pages/connection_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Service Locator
final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Core
  getIt.registerLazySingleton<SSHService>(() => SSHService());
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Connection Feature
  getIt.registerLazySingleton<ConnectionRepository>(
      () => ConnectionRepository(getIt<SSHService>(), getIt<SharedPreferences>()));
  getIt.registerFactory<ConnectionBloc>(
      () => ConnectionBloc(getIt<ConnectionRepository>()));

  // Dashboard Feature
  getIt.registerLazySingleton<DashboardRepository>(
      () => DashboardRepository(getIt<SSHService>()));
  getIt.registerFactory<DashboardBloc>(
      () => DashboardBloc(getIt<DashboardRepository>()));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencyInjection();

  runApp(const LGStarCommandApp());
}

class LGStarCommandApp extends StatelessWidget {
  const LGStarCommandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ConnectionBloc>()),
        BlocProvider(create: (_) => getIt<DashboardBloc>()),
      ],
      child: MaterialApp(
        title: 'LG Star Command',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark, 
          useMaterial3: true,
        ),
        // We need to implement proper navigation or a home page that decides
        // For now, let's point to ConnectionPage (which we need to build next)
        // or a Wrapper. Let's start with ConnectionPage once built. 
        // For this step, we'll placeholder it.
        home: const ConnectionPage(),
      ),
    );
  }
}