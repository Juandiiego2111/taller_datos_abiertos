import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/touristic_attraction_service.dart';
import '../models/touristic_attraction_model.dart';

class TouristicAttractionListView extends StatefulWidget {
  const TouristicAttractionListView({Key? key}) : super(key: key);

  @override
  State<TouristicAttractionListView> createState() =>
      _TouristicAttractionListViewState();
}

class _TouristicAttractionListViewState
    extends State<TouristicAttractionListView> {
  final TouristicAttractionService _service = TouristicAttractionService();
  bool isLoading = true;
  String? errorMessage;
  List<TouristicAttraction> touristicAttractions = [];

  @override
  void initState() {
    super.initState();
    _loadTouristicAttractions();
  }

  Future<void> _loadTouristicAttractions() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _service.getTouristicAttractions();
      setState(() {
        touristicAttractions = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Atracciones Turísticas'),
          backgroundColor: const Color(0xFF003087),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Atracciones Turísticas'),
          backgroundColor: const Color(0xFF003087),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadTouristicAttractions,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Atracciones Turísticas'),
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: touristicAttractions.length,
        itemBuilder: (context, index) {
          final attraction = touristicAttractions[index];
          return ListTile(
            title: Text(attraction.name),
            subtitle: Text(attraction.city ?? 'Sin ciudad'),
            onTap: () {
              context.goNamed(
                'touristicAttractionDetail',
                pathParameters: {'id': attraction.id.toString()},
              );
            },
          );
        },
      ),
    );
  }
}
