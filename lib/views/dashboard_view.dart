import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/dashboard_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colombia App 🇨🇴'),
        backgroundColor: const Color(0xFF003087), // Azul oscuro
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return DashboardCard(
                  title: 'Departamentos',
                  icon: Icons.map,
                  color: const Color(0xFFFCD116), // Amarillo
                  onTap: () => context.goNamed('departments'),
                );
              case 1:
                return DashboardCard(
                  title: 'Presidentes',
                  icon: Icons.person,
                  color: const Color(0xFF003087), // Azul oscuro
                  onTap: () => context.goNamed('presidents'),
                );
              case 2:
                return DashboardCard(
                  title: 'Áreas Naturales',
                  icon: Icons.park,
                  color: const Color(0xFFCE1126), // Rojo
                  onTap: () => context.goNamed('naturalAreas'),
                );
              case 3:
                return DashboardCard(
                  title: 'Atracciones Turísticas',
                  icon: Icons.attractions,
                  color: const Color(0xFF008000), // Verde
                  onTap: () => context.goNamed('touristicAttractions'),
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
