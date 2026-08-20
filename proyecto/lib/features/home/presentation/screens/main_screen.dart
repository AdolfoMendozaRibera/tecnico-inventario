import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Repuestos',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Reservas',
          ),
        ],
      ),
    );
  }
}
