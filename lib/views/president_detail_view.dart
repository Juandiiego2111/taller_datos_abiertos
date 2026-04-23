import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/president_model.dart';
import '../services/president_service.dart';
import '../widgets/error_widget.dart';

class PresidentDetailView extends StatefulWidget {
  final int id;
  const PresidentDetailView({super.key, required this.id});

  @override
  State<PresidentDetailView> createState() => _PresidentDetailViewState();
}

class _PresidentDetailViewState extends State<PresidentDetailView> {
  late Future<President> _future;

  @override
  void initState() {
    super.initState();
    _future = PresidentService.getPresidentById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<President>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return AppErrorWidget(
              message: snapshot.error.toString(),
              onRetry: () => setState(() {
                _future = PresidentService.getPresidentById(widget.id);
              }),
            );
          }
          final p = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: const Color(0xFFCE1126),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.go('/presidents'),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    '${p.name} ${p.lastName ?? ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFCE1126), Color(0xFF8B0000)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: (p.image != null && p.image!.isNotEmpty)
                            ? CircleAvatar(
                                radius: 55,
                                backgroundImage: NetworkImage(p.image!),
                                onBackgroundImageError: (_, __) {},
                              )
                            : const CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.white24,
                                child: Icon(
                                  Icons.person,
                                  size: 55,
                                  color: Colors.white,
                                ),
                              ),
                      ),
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
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFCE1126), Color(0xFFE53935)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.groups,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Partido Político',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    p.politicalParty ?? 'No registrado',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _periodCard(
                              Icons.calendar_today,
                              'Inicio',
                              p.startPeriodDate?.substring(0, 10) ?? 'N/A',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _periodCard(
                              Icons.event,
                              'Fin',
                              p.endPeriodDate?.substring(0, 10) ?? 'N/A',
                            ),
                          ),
                        ],
                      ),
                      if (p.description != null &&
                          p.description!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Biografía',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFCE1126),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: const Border(
                              left: BorderSide(
                                color: Color(0xFFCE1126),
                                width: 4,
                              ),
                            ),
                          ),
                          child: Text(
                            p.description!,
                            style: const TextStyle(fontSize: 14, height: 1.6),
                          ),
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

  Widget _periodCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          Icon(icon, color: const Color(0xFFCE1126)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
