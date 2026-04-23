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

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFE65100), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/touristic-attractions'),
        ),
        title: const Text('Detalle Atracción'),
      ),
      body: FutureBuilder<TouristicAttraction>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return AppErrorWidget(
              message: snapshot.error.toString(),
              onRetry: () => setState(() {
                _future = TouristicAttractionService
                    .getTouristicAttractionById(widget.id);
              }),
            );
          }
          final attr = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 48,
                  backgroundColor: Color(0xFFE65100),
                  child: Icon(Icons.place, size: 48, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(attr.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _row(Icons.info_outline, 'Descripción',
                            attr.description ?? 'N/A'),
                        _row(Icons.location_city, 'Ciudad',
                            attr.city ?? 'N/A'),
                        _row(Icons.map, 'Departamento',
                            attr.department ?? 'N/A'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
