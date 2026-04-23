import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/natural_area_model.dart';
import '../services/natural_area_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class NaturalAreaListView extends StatefulWidget {
  const NaturalAreaListView({super.key});
  @override
  State<NaturalAreaListView> createState() => _NaturalAreaListViewState();
}

class _NaturalAreaListViewState extends State<NaturalAreaListView> {
  late Future<List<NaturalArea>> _future;

  @override
  void initState() {
    super.initState();
    _future = NaturalAreaService.getNaturalAreas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Áreas Naturales'),
      ),
      body: FutureBuilder<List<NaturalArea>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }
          if (snapshot.hasError) {
            return AppErrorWidget(
              message: snapshot.error.toString(),
              onRetry: () => setState(() {
                _future = NaturalAreaService.getNaturalAreas();
              }),
            );
          }
          final items = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final area = items[index];
              return GestureDetector(
                onTap: () => context.goNamed(
                  'natural-area-detail',
                  pathParameters: {'id': area.id.toString()},
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: const Color(
                          0xFF2E7D32,
                        ).withValues(alpha: 0.12),
                        child: const Icon(
                          Icons.park,
                          color: Color(0xFF2E7D32),
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              area.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            Text(
                              area.departmentName ?? 'Sin departamento',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
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
}
