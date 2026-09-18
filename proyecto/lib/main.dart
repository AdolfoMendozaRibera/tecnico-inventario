import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/supabase_client.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/historial/providers/historial_provider.dart';
import 'features/home/presentation/screens/main_screen.dart';
import 'features/home/providers/navigation_provider.dart';
import 'features/repuestos/providers/repuestos_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializamos Supabase
  await SupabaseService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RepuestosProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => HistorialProvider()),
      ],
      child: const VaultTecnoApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) {
        // Permite navegar a un tab específico vía context.go('/', extra: {'tab': N})
        // 0=Inicio, 1=Repuestos, 2=Reservas
        final extra = state.extra as Map<String, dynamic>?;
        final initialTab = (extra?['tab'] as int?) ?? 0;
        return MainScreen(initialTab: initialTab);
      },
    ),
  ],
);

class VaultTecnoApp extends StatelessWidget {
  const VaultTecnoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VaultTecno',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
