import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/touristic_attraction_model.dart';
import '../services/touristic_attraction_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class TouristicAttractionListView extends StatefulWidget {
  const TouristicAttractionListView({super.key});

  @override
  State<TouristicAttractionListView> createState() =>
      _TouristicAttractionListViewState();
}

class _TouristicAttractionListViewState
    extends State<TouristicAttractionListView> {
  late Future<List<TouristicAttraction>> _future;

  @override
  void initState() {
    super.initState();
    _future = TouristicAttractionService.getTouristicAttractions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text(
          'Atracciones Turísticas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFE65100),
      ),
      body: FutureBuilder<List<TouristicAttraction>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }
          if (snapshot.hasError) {
            return AppErrorWidget(
              message: snapshot.error.toString(),
              onRetry: () => setState(() {
                _future = TouristicAttractionService.getTouristicAttractions();
              }),
            );
          }
          final items = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final attr = items[index];
              return GestureDetector(
                onTap: () => context.goNamed(
                  'touristic-attraction-detail',
                  pathParameters: {'id': attr.id.toString()},
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image header with gradient overlay
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            // Background image
                            attr.images != null && attr.images!.isNotEmpty
                                ? Image.network(
                                    attr.images![0],
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildImagePlaceholder();
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return _buildImagePlaceholder(
                                            isLoading: true,
                                          );
                                        },
                                  )
                                : _buildImagePlaceholder(),
                            // Dark gradient overlay for text readability
                            const Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black54,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Optional badge
                            if (attr.images != null && attr.images!.isNotEmpty)
                              const Positioned(
                                top: 12,
                                right: 12,
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.white24,
                                  child: Icon(
                                    Icons.photo_camera,
                                    size: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Content section
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name and location
                            Text(
                              attr.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    attr.cityName ??
                                        attr.cityId?.toString() ??
                                        'Sin ciudad',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.terrain,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    attr.departmentName ??
                                        attr.departmentId?.toString() ??
                                        'Sin departamento',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            // Action chips
                            if (attr.latitude != null ||
                                attr.images != null &&
                                    attr.images!.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  if (attr.latitude != null &&
                                      attr.longitude != null)
                                    _buildActionChip(
                                      icon: Icons.map,
                                      label: 'Ver mapa',
                                      color: const Color(0xFF1976D2),
                                      onTap: () => _openMap(
                                        attr.latitude!,
                                        attr.longitude!,
                                      ),
                                    ),
                                  if (attr.images != null &&
                                      attr.images!.isNotEmpty)
                                    _buildActionChip(
                                      icon: Icons.photo_library,
                                      label: '${attr.images!.length} imagenes',
                                      color: const Color(0xFF00796B),
                                      onTap: () => _showImagePreview(
                                        context,
                                        attr.images!,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildImagePlaceholder({bool isLoading = false}) {
    return Container(
      height: 180,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE65100), Color(0xFFBF360C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white70),
            )
          : const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_library, size: 60, color: Colors.white30),
                SizedBox(height: 8),
                Text(
                  'Sin imagen',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ],
            ),
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openMap(double latitude, double longitude) {
    final url = 'https://www.google.com/maps?q=$latitude,$longitude';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('URL maps generada: $url'),
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
