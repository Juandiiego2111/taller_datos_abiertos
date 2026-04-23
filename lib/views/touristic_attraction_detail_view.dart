import 'package:flutter/material.dart';
import '../services/touristic_attraction_service.dart';
import '../models/touristic_attraction_model.dart';

class TouristicAttractionDetailView extends StatefulWidget {
  final String id;

  const TouristicAttractionDetailView({Key? key, required this.id})
    : super(key: key);

  @override
  State<TouristicAttractionDetailView> createState() =>
      _TouristicAttractionDetailViewState();
}

class _TouristicAttractionDetailViewState
    extends State<TouristicAttractionDetailView> {
  final TouristicAttractionService _service = TouristicAttractionService();
  bool isLoading = true;
  String? errorMessage;
  TouristicAttraction? attraction;

  @override
  void initState() {
    super.initState();
    _loadAttraction();
  }

  Future<void> _loadAttraction() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _service.getTouristicAttractionById(
        int.parse(widget.id),
      );
      setState(() {
        attraction = data;
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
          title: const Text('Detalle de Atracción Turística'),
          leading: const BackButton(),
          backgroundColor: const Color(0xFF003087),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalle de Atracción Turística'),
          leading: const BackButton(),
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
                onPressed: _loadAttraction,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (attraction == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalle de Atracción Turística'),
          leading: const BackButton(),
          backgroundColor: const Color(0xFF003087),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('Atracción Turística no encontrada')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(attraction!.name),
        leading: const BackButton(),
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard('Nombre', attraction!.name),
              const SizedBox(height: 12),
              _buildInfoCard(
                'Descripción',
                attraction!.description ?? 'No especificada',
              ),
              const SizedBox(height: 12),
              _buildInfoCard('Ciudad', attraction!.city ?? 'No especificada'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
