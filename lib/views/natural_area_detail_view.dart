import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/natural_area_service.dart';
import '../models/natural_area_model.dart';

class NaturalAreaDetailView extends StatefulWidget {
  final String id;

  const NaturalAreaDetailView({Key? key, required this.id}) : super(key: key);

  @override
  State<NaturalAreaDetailView> createState() => _NaturalAreaDetailViewState();
}

class _NaturalAreaDetailViewState extends State<NaturalAreaDetailView> {
  final NaturalAreaService _service = NaturalAreaService();
  bool isLoading = true;
  String? errorMessage;
  NaturalArea? naturalArea;

  @override
  void initState() {
    super.initState();
    _loadNaturalArea();
  }

  Future<void> _loadNaturalArea() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await NaturalAreaService.getNaturalAreaById(int.parse(widget.id));
      setState(() {
        naturalArea = data;
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
          title: const Text('Detalle de Área Natural'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/natural-areas');
              }
            },
          ),
          backgroundColor: const Color(0xFF003087),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalle de Área Natural'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/natural-areas');
              }
            },
          ),
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
                onPressed: _loadNaturalArea,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (naturalArea == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalle de Área Natural'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/natural-areas');
              }
            },
          ),
          backgroundColor: const Color(0xFF003087),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('Área Natural no encontrada')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(naturalArea!.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/natural-areas');
            }
          },
        ),
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard('Nombre', naturalArea!.name),
              const SizedBox(height: 12),
              _buildInfoCard(
                'Descripción',
                naturalArea!.description ?? 'No especificada',
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                'Departamento',
                naturalArea!.departmentName ?? 'No especificado',
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
