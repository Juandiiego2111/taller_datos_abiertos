import 'package:flutter/material.dart';
import '../services/department_service.dart';
import '../models/department_model.dart';

class DepartmentDetailView extends StatefulWidget {
  final String id;

  const DepartmentDetailView({Key? key, required this.id}) : super(key: key);

  @override
  State<DepartmentDetailView> createState() => _DepartmentDetailViewState();
}

class _DepartmentDetailViewState extends State<DepartmentDetailView> {
  final DepartmentService _service = DepartmentService();
  bool isLoading = true;
  String? errorMessage;
  Department? department;

  @override
  void initState() {
    super.initState();
    _loadDepartment();
  }

  Future<void> _loadDepartment() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _service.getDepartmentById(int.parse(widget.id));
      setState(() {
        department = data;
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
          title: const Text('Detalle de Departamento'),
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
          title: const Text('Detalle de Departamento'),
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
                onPressed: _loadDepartment,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (department == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalle de Departamento'),
          leading: const BackButton(),
          backgroundColor: const Color(0xFF003087),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('Departamento no encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(department!.name),
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
              _buildInfoCard('Nombre', department!.name),
              const SizedBox(height: 12),
              _buildInfoCard('Descripción', department!.description),
              const SizedBox(height: 12),
              _buildInfoCard(
                'Superficie',
                department!.superficie != null
                    ? '${department!.superficie} km²'
                    : 'No especificada',
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                'Población',
                department!.population != null
                    ? '${department!.population} habitantes'
                    : 'No especificada',
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                'Capital',
                department!.capital ?? 'No especificada',
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
