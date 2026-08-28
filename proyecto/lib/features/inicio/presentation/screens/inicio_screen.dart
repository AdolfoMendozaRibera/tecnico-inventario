import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/supabase_client.dart';
import '../../../repuestos/providers/repuestos_provider.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen del Taller', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              SupabaseService.client.auth.signOut();
              context.go('/login');
            },
          )
        ],
      ),
      body: SafeArea(
        child: Consumer<RepuestosProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(24.0), // Escala 8px: 24
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Orientar
                  Text(
                    'Estado Actual del Inventario',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24, // Jerarquía principal
                    ),
                  ),
                  const SizedBox(height: 8), // Escala 8px: 8
                  Text(
                    'Hola, aquí puedes ver los repuestos disponibles y tus reservas.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32), // Escala 8px: 32
                  
                  // Informar
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context, 
                          title: 'Disponibles', 
                          count: provider.disponibles.length.toString(), 
                          icon: Icons.check_circle_outline, 
                          color: Colors.green
                        ),
                      ),
                      const SizedBox(width: 16), // Escala 8px: 16
                      Expanded(
                        child: _buildStatCard(
                          context, 
                          title: 'Reservados', 
                          count: provider.reservados.length.toString(), 
                          icon: Icons.pending_actions, 
                          color: Colors.orange
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, {required String title, required String count, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16.0), // Escala 8px: 16
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16), // Escala 8px: 16
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color), // Jerarquía visual
          const SizedBox(height: 16), // Escala 8px: 16
          Text(
            count, 
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold, 
              color: color,
              fontSize: 32, // Dato principal destacado
            ),
          ),
          const SizedBox(height: 8), // Escala 8px: 8
          Text(
            title, 
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
