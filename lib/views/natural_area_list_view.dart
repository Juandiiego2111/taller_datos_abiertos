import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/natural_area_service.dart';
import '../models/natural_area_model.dart';

class NaturalAreaListView extends StatefulWidget {
  const NaturalAreaListView({Key? key}) : super(key: key);

  @override
  State<NaturalAreaListView> createState() => _NaturalAreaListViewState();
}

class _NaturalAreaListViewState extends State<NaturalAreaListView> {
  bool isLoading = true;
  String? errorMessage;
  List<NaturalArea> naturalAreas = [];

  @override
  void initState() {
    super.initState();
    _loadNaturalAreas();
  }

  Future<void> _loadNaturalAreas() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await NaturalAreaService.getNaturalAreas();
      setState(() {
        naturalAreas = data;
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
          title: const Text('Áreas Naturales'),
          backgroundColor: const Color(0xFF003087),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
          title: const Text('Áreas Naturales'),
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
                onPressed: _loadNaturalAreas,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: const Text('Áreas Naturales'),
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: naturalAreas.length,
        itemBuilder: (context, index) {
          final naturalArea = naturalAreas[index];
          return ListTile(
            title: Text(naturalArea.name),
            subtitle: Text(naturalArea.departmentName ?? 'Sin departamento'),
            onTap: () {
              context.goNamed(
                'naturalAreaDetail',
                pathParameters: {'id': naturalArea.id.toString()},
              );
            },
          );
        },
      ),
    );
  }
}
