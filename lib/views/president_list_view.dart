import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/president_model.dart';
import '../services/president_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class PresidentListView extends StatefulWidget {
  const PresidentListView({super.key});
  @override
  State<PresidentListView> createState() => _PresidentListViewState();
}

class _PresidentListViewState extends State<PresidentListView> {
  late Future<List<President>> _future;

  @override
  void initState() {
    super.initState();
    _future = PresidentService.getPresidents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Presidentes'),
      ),
      body: FutureBuilder<List<President>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }
          if (snapshot.hasError) {
            return AppErrorWidget(
              message: snapshot.error.toString(),
              onRetry: () => setState(() {
                _future = PresidentService.getPresidents();
              }),
            );
          }
          final items = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final p = items[index];
              return GestureDetector(
                onTap: () => context.goNamed(
                  'president-detail',
                  pathParameters: {'id': p.id.toString()},
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      (p.image != null && p.image!.isNotEmpty)
                          ? CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(p.image!),
                            )
                          : CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color(
                                0xFFCE1126,
                              ).withValues(alpha: 0.12),
                              child: Text(
                                p.name[0],
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFCE1126),
                                ),
                              ),
                            ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${p.name} ${p.lastName ?? ''}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            Text(
                              p.politicalParty ?? 'Partido desconocido',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
