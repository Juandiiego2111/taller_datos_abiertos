import 'package:flutter/material.dart';
import '../services/president_service.dart';
import '../models/president_model.dart';

class PresidentDetailView extends StatefulWidget {
  final String id;

  const PresidentDetailView({Key? key, required this.id}) : super(key: key);

  @override
  State<PresidentDetailView> createState() => _PresidentDetailViewState();
}

class _PresidentDetailViewState extends State<PresidentDetailView> {
  final PresidentService _service = PresidentService();
  bool isLoading = true;
  String? errorMessage;
  President? president;

  @override
  void initState() {
    super.initState();
    _loadPresident();
  }

  Future<void> _loadPresident() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _service.getPresidentById(int.parse(widget.id));
      setState(() {
        president = data;
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
          title: const Text('Detalle de Presidente'),
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
          title: const Text('Detalle de Presidente'),
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
                onPressed: _loadPresident,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (president == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalle de Presidente'),
          leading: const BackButton(),
          backgroundColor: const Color(0xFF003087),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('Presidente no encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${president!.name} ${president!.lastName}'),
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
              _buildInfoCard(
                'Nombre',
                '${president!.name} ${president!.lastName}',
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                'Descripción',
                president!.description ?? 'No especificada',
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                'Partido Político',
                president!.politicalParty ?? 'No especificado',
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                'Fecha de Inicio',
                president!.startPeriodDate ?? 'No especificada',
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                'Fecha de Fin',
                president!.endPeriodDate ?? 'No especificada',
              ),
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
