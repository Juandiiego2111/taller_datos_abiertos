import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/president_service.dart';
import '../models/president_model.dart';

class PresidentListView extends StatefulWidget {
  const PresidentListView({Key? key}) : super(key: key);

  @override
  State<PresidentListView> createState() => _PresidentListViewState();
}

class _PresidentListViewState extends State<PresidentListView> {
  final PresidentService _service = PresidentService();
  bool isLoading = true;
  String? errorMessage;
  List<President> presidents = [];

  @override
  void initState() {
    super.initState();
    _loadPresidents();
  }

  Future<void> _loadPresidents() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _service.getPresidents();
      setState(() {
        presidents = data;
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
          title: const Text('Presidentes'),
          backgroundColor: const Color(0xFF003087),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Presidentes'),
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
                onPressed: _loadPresidents,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Presidentes'),
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: presidents.length,
        itemBuilder: (context, index) {
          final president = presidents[index];
          return ListTile(
            title: Text('${president.name} ${president.lastName}'),
            subtitle: Text(president.politicalParty ?? 'Sin partido'),
            onTap: () {
              context.goNamed(
                'presidentDetail',
                pathParameters: {'id': president.id.toString()},
              );
            },
          );
        },
      ),
    );
  }
}
