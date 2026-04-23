import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/department_service.dart';
import '../models/department_model.dart';

class DepartmentListView extends StatefulWidget {
  const DepartmentListView({Key? key}) : super(key: key);

  @override
  State<DepartmentListView> createState() => _DepartmentListViewState();
}

class _DepartmentListViewState extends State<DepartmentListView> {
  bool isLoading = true;
  String? errorMessage;
  List<Department> departments = [];

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await DepartmentService.getDepartments();
      setState(() {
        departments = data;
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
          title: const Text('Departamentos'),
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
          title: const Text('Departamentos'),
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
                onPressed: _loadDepartments,
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
        title: const Text('Departamentos'),
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final department = departments[index];
          return ListTile(
            title: Text(department.name),
            subtitle: Text(department.capital ?? 'Sin capital'),
            onTap: () {
              context.goNamed(
                'departmentDetail',
                pathParameters: {'id': department.id.toString()},
              );
            },
          );
        },
      ),
    );
  }
}
