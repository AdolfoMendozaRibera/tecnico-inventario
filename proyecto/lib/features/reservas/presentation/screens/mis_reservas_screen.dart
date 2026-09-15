import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../repuestos/providers/repuestos_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/reservation_card.dart';

class MisReservasScreen extends StatefulWidget {
  const MisReservasScreen({super.key});

  @override
  State<MisReservasScreen> createState() => _MisReservasScreenState();
}

class _MisReservasScreenState extends State<MisReservasScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: AppBar(
        backgroundColor: AppColors.slate50,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Mis Reservas',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppColors.slate900,
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<RepuestosProvider>(
          builder: (context, provider, child) {
            final repuestos = provider.misReservas;
            final int count = repuestos.length;

            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.slate800,
                ),
              );
            }

            final filtered = repuestos.where((r) {
              if (_searchQuery.isEmpty) return true;
              final query = _searchQuery.toLowerCase();
              final nombre = (r.nombre).toLowerCase();
              final categoria = (r.categoria).toLowerCase();
              final equipo = (r.equipoDestino ?? '').toLowerCase();
              final motivo = (r.motivo ?? '').toLowerCase();
              return nombre.contains(query) ||
                  categoria.contains(query) ||
                  equipo.contains(query) ||
                  motivo.contains(query);
            }).toList();

            return RefreshIndicator(
              color: AppColors.slate800,
              onRefresh: () => provider.fetchRepuestos(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                children: [
                  // Subtítulo / Contador con el estilo de Figma
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, left: 2.0),
                    child: Text(
                      count == 1
                          ? 'Tienes 1 repuesto reservado para tus reparaciones actuales'
                          : 'Tienes $count repuestos reservados para tus reparaciones actuales',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.slate500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Barra de búsqueda si hay piezas
                  if (repuestos.isNotEmpty) ...[
                    TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val.trim();
                        });
                      },
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.slate900,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Buscar en mis reservas...',
                        hintStyle: GoogleFonts.inter(
                          color: const Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF94A3B8),
                          size: 20,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.slate500),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.slate200,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.slate800,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Lista de tarjetas
                  if (repuestos.isEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.bookmark_border_rounded,
                            size: 56,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No tienes reservas activas',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: AppColors.slate500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (filtered.isEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          'No se encontraron reservas con "$_searchQuery"',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.slate500,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    ...filtered.map((repuesto) {
                      return ReservationCard(
                        repuesto: repuesto,
                        isMiReserva: true,
                        useRedLiberarButton: true,
                        onMarcarUsado: () async {
                          final confirmar = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Text(
                                'Marcar como Usado',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: AppColors.slate900,
                                ),
                              ),
                              content: Text(
                                '¿Confirmas que utilizaste "${repuesto.nombre}" para "${repuesto.equipoDestino ?? 'el equipo'}"?\n\nLa pieza se descontará permanentemente del inventario.',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF475569),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: Text(
                                    'Cancelar',
                                    style: GoogleFonts.inter(color: AppColors.slate500),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.slate800,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Confirmar Uso'),
                                ),
                              ],
                            ),
                          );

                          if (confirmar != true || !context.mounted) return;

                          final exito = await provider.marcarComoUsado(repuesto.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(exito
                                    ? 'Repuesto marcado como usado (descontado del inventario)'
                                    : 'Error al marcar como usado: ${provider.lastError ?? "Rechazado"}'),
                                backgroundColor: exito ? AppColors.slate800 : Theme.of(context).colorScheme.error,
                              ),
                            );
                          }
                        },
                        onLiberar: () async {
                          final confirmar = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Text(
                                'Liberar al Taller',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: AppColors.slate900,
                                ),
                              ),
                              content: Text(
                                '¿Deseas devolver "${repuesto.nombre}" al inventario disponible para cualquier técnico del taller?',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF475569),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: Text(
                                    'Cancelar',
                                    style: GoogleFonts.inter(color: AppColors.slate500),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFDC2626),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Liberar Repuesto'),
                                ),
                              ],
                            ),
                          );

                          if (confirmar != true || !context.mounted) return;

                          final exito = await provider.liberarRepuesto(repuesto.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(exito
                                    ? 'Repuesto liberado y devuelto a disponibles'
                                    : 'Error al liberar el repuesto.'),
                                backgroundColor: exito ? AppColors.slate800 : Theme.of(context).colorScheme.error,
                              ),
                            );
                          }
                        },
                      );
                    }),
                  ],

                  // Sección inferior (Dashed Card Figma: "¿Necesitas otro repuesto?")
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.slate50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFCBD5E1),
                        width: 1.5,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.help_outline_rounded,
                          size: 32,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '¿Necesitas otro repuesto?',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Explora las piezas disponibles en el taller y resérvalas para tu reparación.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.slate500,
                          ),
                        ),
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.search_rounded, size: 16),
                          label: const Text('Buscar en el Inventario'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.slate800,
                            side: const BorderSide(color: AppColors.slate200, width: 1.5),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
