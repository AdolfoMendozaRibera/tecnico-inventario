import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../repuestos/providers/repuestos_provider.dart';

import '../../../inicio/presentation/screens/inicio_screen.dart';
import '../../../repuestos/presentation/screens/repuestos_list_screen.dart';
import '../../../reservas/presentation/screens/mis_reservas_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RepuestosProvider>().fetchRepuestos();
    });
  }

  final List<Widget> _screens = const [
    InicioScreen(),
    RepuestosListScreen(),
    MisReservasScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: AppColors.slate200,
              width: 1.0,
            ),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.white,
            elevation: 0,
            indicatorColor: AppColors.slate100,
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  return GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate800,
                  );
                }
                return GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.slate500,
                );
              },
            ),
            iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(
                    color: AppColors.slate800,
                    size: 24,
                  );
                }
                return const IconThemeData(
                  color: AppColors.slate500,
                  size: 24,
                );
              },
            ),
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.grid_view_rounded),
                selectedIcon: Icon(Icons.grid_view_rounded),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2_rounded),
                label: 'Repuestos',
              ),
              NavigationDestination(
                icon: Icon(Icons.bookmark_border_rounded),
                selectedIcon: Icon(Icons.bookmark_rounded),
                label: 'Reservas',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
