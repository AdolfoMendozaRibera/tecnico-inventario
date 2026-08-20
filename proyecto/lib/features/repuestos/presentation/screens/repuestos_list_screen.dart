import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/repuestos_provider.dart';
import '../../../reservas/presentation/screens/reservar_screen.dart';

class RepuestosListScreen extends StatelessWidget {
  const RepuestosListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inventario'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Disponibles', icon: Icon(Icons.check_circle_outline)),
              Tab(text: 'Reservados', icon: Icon(Icons.lock_outline)),
            ],
          ),
        ),
        body: Consumer<RepuestosProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return TabBarView(
              children: [
                _ListaDisponibles(provider.disponibles),
                _ListaReservados(provider.reservados),
              ],
            );
          }
        ),
      ),
    );
  }
}

class _ListaDisponibles extends StatelessWidget {
  final List repuestos;
  const _ListaDisponibles(this.repuestos);

  @override
  Widget build(BuildContext context) {
    if (repuestos.isEmpty) {
      return const Center(child: Text('No hay repuestos disponibles'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: repuestos.length,
      itemBuilder: (context, index) {
        final repuesto = repuestos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.withValues(alpha: 0.1),
              child: const Icon(Icons.memory, color: Colors.blue),
            ),
            title: Text(repuesto.nombre),
            subtitle: Text('Categoría: ${repuesto.categoria}'),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ReservarScreen(repuestoId: repuesto.id, repuestoNombre: repuesto.nombre)
                ));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text('Reservar'),
            ),
          ),
        );
      },
    );
  }
}

class _ListaReservados extends StatelessWidget {
  final List repuestos;
  const _ListaReservados(this.repuestos);

  @override
  Widget build(BuildContext context) {
    if (repuestos.isEmpty) {
      return const Center(child: Text('No hay repuestos reservados'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: repuestos.length,
      itemBuilder: (context, index) {
        final repuesto = repuestos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange.withValues(alpha: 0.1),
              child: const Icon(Icons.lock, color: Colors.orange),
            ),
            title: Text(repuesto.nombre),
            subtitle: Text('Destino: ${repuesto.equipoDestino ?? "N/A"}\nPor: Técnico'),
            isThreeLine: true,
            trailing: OutlinedButton(
              onPressed: () {
                context.read<RepuestosProvider>().liberarRepuesto(repuesto.id);
              },
              child: const Text('Liberar'),
            ),
          ),
        );
      },
    );
  }
}
