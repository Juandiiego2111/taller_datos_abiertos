import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/touristic_attraction_model.dart';
import '../services/touristic_attraction_service.dart';
import '../widgets/error_widget.dart';

class TouristicAttractionDetailView extends StatefulWidget {
  final int id;
  const TouristicAttractionDetailView({super.key, required this.id});

  @override
  State<TouristicAttractionDetailView> createState() =>
      _TouristicAttractionDetailViewState();
}

class _TouristicAttractionDetailViewState
    extends State<TouristicAttractionDetailView> {
  late Future<TouristicAttraction> _future;

  @override
  void initState() {
    super.initState();
    _future = TouristicAttractionService.getTouristicAttractionById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<TouristicAttraction>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFE65100)),
            );
          }
          if (snapshot.hasError) {
            return AppErrorWidget(
              message: snapshot.error.toString(),
              onRetry: () => setState(() {
                _future = TouristicAttractionService.getTouristicAttractionById(
                  widget.id,
                );
              }),
            );
          }
          final attr = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: const Color(0xFFE65100),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.go('/touristic-attractions'),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    attr.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFE65100), Color(0xFFBF360C)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      if (attr.images != null && attr.images!.isNotEmpty)
                        Image.network(
                          attr.images![0],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported,
                              size: 80,
                              color: Colors.white30,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white70,
                              ),
                            );
                          },
                        )
                      else
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            Icon(
                              Icons.photo_library,
                              size: 80,
                              color: Colors.white30,
                            ),
                          ],
                        ),
                      // Gradient overlay for text readability
                      const Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black54, Colors.transparent],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location info cards
                      Row(
                        children: [
                          Expanded(
                            child: _locationCard(
                              Icons.location_city,
                              'Ciudad',
                              attr.cityName ?? attr.cityId?.toString() ?? 'N/A',
                              const Color(0xFFE65100),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _locationCard(
                              Icons.terrain,
                              'Departamento',
                              attr.departmentName ??
                                  attr.departmentId?.toString() ??
                                  'N/A',
                              const Color(0xFF003893),
                            ),
                          ),
                        ],
                      ),
                      // Coordinates
                      if (attr.latitude != null || attr.longitude != null) ...[
                        const SizedBox(height: 12),
                        _infoCard(
                          Icons.map,
                          'Coordenadas',
                          attr.latitude != null && attr.longitude != null
                              ? '${attr.latitude!.toStringAsFixed(6)}, ${attr.longitude!.toStringAsFixed(6)}'
                              : 'No disponible',
                          const Color(0xFF6A1B9A),
                          onTap: attr.latitude != null && attr.longitude != null
                              ? () {
                                  _openMap(attr.latitude!, attr.longitude!);
                                }
                              : null,
                        ),
                      ],
                      // Images count
                      if (attr.images != null && attr.images!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _infoCard(
                          Icons.photo_library,
                          'Imágenes',
                          '${attr.images!.length} imagen${attr.images!.length > 1 ? "es" : ""}',
                          const Color(0xFF00796B),
                          onTap: () {
                            _showImagePreview(context, attr.images!);
                          },
                        ),
                      ],
                      // Description
                      if (attr.description != null &&
                          attr.description!.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Text(
                          'Descripción',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: const Border(
                              left: BorderSide(
                                color: Color(0xFFE65100),
                                width: 4,
                              ),
                            ),
                          ),
                          child: Text(
                            attr.description!,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.7,
                              color: Color(0xFF333333),
                            ),
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
                      // Type indicator
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
                                  0xFFE65100,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.place,
                                color: Color(0xFFE65100),
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
                                    'Atracción Turística',
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
                      const SizedBox(height: 40),
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

  Widget _locationCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
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
          ),
        ],
      ),
    );
  }

  Widget _infoCard(
    IconData icon,
    String label,
    String value,
    Color color, {
    VoidCallback? onTap,
  }) {
    final isTappable = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: isTappable
              ? Border.all(color: color.withValues(alpha: 0.3), width: 1)
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
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
            ),
            if (isTappable)
              Icon(
                Icons.open_in_new,
                size: 14,
                color: color.withValues(alpha: 0.6),
              ),
          ],
        ),
      ),
    );
  }

  void _openMap(double latitude, double longitude) {
    final url = 'https://www.google.com/maps?q=$latitude,$longitude';
    // TODO: Implement using url_launcher package
    // For now, show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abrir mapas en $latitude, $longitude'),
        action: SnackBarAction(
          label: 'Copiar',
          onPressed: () {
            // TODO: Copy to clipboard
          },
        ),
      ),
    );
  }

  void _showImagePreview(BuildContext context, List<String> images) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    child: Image.network(
                      images[index],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image, size: 80),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
