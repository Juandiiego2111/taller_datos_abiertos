import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/natural_area_model.dart';
import '../services/natural_area_service.dart';
import '../widgets/error_widget.dart';

class NaturalAreaDetailView extends StatefulWidget {
  final int id;
  const NaturalAreaDetailView({super.key, required this.id});

  @override
  State<NaturalAreaDetailView> createState() => _NaturalAreaDetailViewState();
}

class _NaturalAreaDetailViewState extends State<NaturalAreaDetailView> {
  late Future<NaturalArea> _future;

  @override
  void initState() {
    super.initState();
    _future = NaturalAreaService.getNaturalAreaById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<NaturalArea>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            );
          }
          if (snapshot.hasError) {
            return AppErrorWidget(
              message: snapshot.error.toString(),
              onRetry: () => setState(() {
                _future = NaturalAreaService.getNaturalAreaById(widget.id);
              }),
            );
          }
          final area = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: const Color(0xFF2E7D32),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.go('/natural-areas'),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    area.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.park,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Departamento
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Departamento',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    area.department != null &&
                                            area.department!['name'] != null
                                        ? area.department!['name'].toString()
                                        : area.departmentId != null
                                        ? 'ID: ${area.departmentId}'
                                        : 'No registrado',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Descripción
                      if (area.description != null &&
                          area.description!.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Text(
                          'Descripción',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: const Border(
                              left: BorderSide(
                                color: Color(0xFF2E7D32),
                                width: 4,
                              ),
                            ),
                          ),
                          child: Text(
                            area.description!,
                            style: const TextStyle(fontSize: 14, height: 1.6),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Sin descripción disponible',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      // Tarjetas de información
                      Row(
                        children: [
                          Expanded(
                            child: _infoCard(
                              Icons.landscape,
                              'Superficie Terrestre',
                              area.landArea != null
                                  ? '${area.landArea!.toStringAsFixed(2)} km²'
                                  : 'N/A',
                              const Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _infoCard(
                              Icons.water,
                              'Superficie Marítima',
                              area.maritimeArea != null
                                  ? '${area.maritimeArea!.toStringAsFixed(2)} km²'
                                  : 'No aplica',
                              const Color(0xFF1976D2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _infoCard(
                              Icons.code,
                              'Código DANE',
                              area.daneCode?.toString() ?? 'N/A',
                              const Color(0xFFE65100),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _infoCard(
                              Icons.group_work,
                              'Grupo de Área',
                              area.areaGroupId != null
                                  ? 'Grupo ${area.areaGroupId}'
                                  : 'N/A',
                              const Color(0xFF6A1B9A),
                            ),
                          ),
                        ],
                      ),
                      if (area.categoryNaturalAreaId != null) ...[
                        const SizedBox(height: 12),
                        _infoCard(
                          Icons.category,
                          'Categoría',
                          area.categoryNaturalAreaId.toString(),
                          const Color(0xFF5D4037),
                        ),
                      ],
                      const SizedBox(height: 20),
                      // Tarjeta de tipo
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF2E7D32,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.eco,
                                color: Color(0xFF2E7D32),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tipo',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Área Natural Protegida',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
