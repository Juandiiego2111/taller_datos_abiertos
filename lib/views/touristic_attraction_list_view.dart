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
        title: const Text('Atracciones Turísticas'),
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
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final attr = items[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE65100),
                    child: Icon(Icons.place, color: Colors.white),
                  ),
                  title: Text(
                    attr.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    attr.city ?? attr.department ?? 'Sin ubicación',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => context.goNamed(
                    'touristic-attraction-detail',
                    pathParameters: {'id': attr.id.toString()},
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
