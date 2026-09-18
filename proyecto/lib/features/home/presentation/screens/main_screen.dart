import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../repuestos/providers/repuestos_provider.dart';

import '../../../inicio/presentation/screens/inicio_screen.dart';
import '../../../repuestos/presentation/screens/repuestos_list_screen.dart';
import '../../../reservas/presentation/screens/mis_reservas_screen.dart';
import '../../../historial/presentation/screens/historial_screen.dart';

import '../../providers/navigation_provider.dart';

class MainScreen extends StatefulWidget {
  /// Tab index to open on first render.
  /// 0 = Inicio, 1 = Repuestos (Inventario), 2 = Reservas (Mis Reservas), 3 = Historial
  final int initialTab;

  const MainScreen({super.key, this.initialTab = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.initialTab != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<NavigationProvider>().setTab(widget.initialTab);
        }
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<RepuestosProvider>().fetchRepuestos();
      }
    });
  }

  final List<Widget> _screens = const [
    InicioScreen(),
    RepuestosListScreen(),
    MisReservasScreen(),
    HistorialScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentTab = context.watch<NavigationProvider>().currentIndex;

    return Scaffold(
      body: _screens[currentTab],
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
            selectedIndex: currentTab,
            onDestinationSelected: (index) {
              context.read<NavigationProvider>().setTab(index);
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
              NavigationDestination(
                icon: Icon(Icons.history_rounded),
                selectedIcon: Icon(Icons.manage_history_rounded),
                label: 'Historial',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
