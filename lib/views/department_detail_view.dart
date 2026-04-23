import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/department_model.dart';
import '../services/department_service.dart';
import '../widgets/error_widget.dart';

class DepartmentDetailView extends StatefulWidget {
  final int id;
  const DepartmentDetailView({super.key, required this.id});
  @override
  State<DepartmentDetailView> createState() => _DepartmentDetailViewState();
}

class _DepartmentDetailViewState extends State<DepartmentDetailView> {
  late Future<Department> _future;

  @override
  void initState() {
    super.initState();
    _future = DepartmentService.getDepartmentById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Department>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return AppErrorWidget(
              message: snapshot.error.toString(),
              onRetry: () => setState(() {
                _future = DepartmentService.getDepartmentById(widget.id);
              }),
            );
          }
          final dept = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: const Color(0xFF003893),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.go('/departments'),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    dept.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF003893), Color(0xFF001F5B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              dept.name.isNotEmpty ? dept.name[0] : '?',
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (dept.description != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: const Border(
                              left: BorderSide(
                                color: Color(0xFF003893),
                                width: 4,
                              ),
                            ),
                          ),
                          child: Text(
                            dept.description!,
                            style: const TextStyle(fontSize: 14, height: 1.6),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _infoCard(
                              Icons.people,
                              'Población',
                              dept.population != null
                                  ? '${dept.population} hab.'
                                  : 'N/A',
                              const Color(0xFF003893),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _infoCard(
                              Icons.straighten,
                              'Superficie',
                              dept.surface != null
                                  ? '${dept.surface} km²'
                                  : 'N/A',
                              const Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _infoCard(
                              Icons.phone,
                              'Prefijo',
                              dept.phonePrefix ?? 'N/A',
                              const Color(0xFFE65100),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _infoCard(
                              Icons.local_post_office,
                              'Código Postal',
                              dept.postalCode ?? 'N/A',
                              const Color(0xFF6A1B9A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _infoCard(
                              Icons.location_city,
                              'Capital',
                              dept.capital ?? 'No disponible',
                              const Color(0xFFCE1126),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _infoCard(
                              Icons.attach_money,
                              'Moneda',
                              dept.currency ?? 'Peso colombiano (COP)',
                              const Color(0xFF00796B),
                            ),
                          ),
                        ],
                      ),
                      if (dept.municipalities != null) ...[
                        const SizedBox(height: 12),
                        _infoCard(
                          Icons.map,
                          'Municipios',
                          '${dept.municipalities} municipios',
                          const Color(0xFF5D4037),
                        ),
                      ],
                      if (dept.language != null) ...[
                        const SizedBox(height: 12),
                        _infoCard(
                          Icons.language,
                          'Idioma',
                          dept.language!,
                          const Color(0xFF455A64),
                        ),
                      ],
                      if (dept.regionId != null) ...[
                        const SizedBox(height: 12),
                        _infoCard(
                          Icons.terrain,
                          'Región',
                          'Región ${dept.regionId}',
                          const Color(0xFF455A64),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
