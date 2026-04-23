import 'package:go_router/go_router.dart';
import '../views/dashboard_view.dart';
import '../views/department_list_view.dart';
import '../views/department_detail_view.dart';
import '../views/president_list_view.dart';
import '../views/president_detail_view.dart';
import '../views/natural_area_list_view.dart';
import '../views/natural_area_detail_view.dart';
import '../views/touristic_attraction_list_view.dart';
import '../views/touristic_attraction_detail_view.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const DashboardView(),
    ),
    GoRoute(
      name: 'departments',
      path: '/departments',
      builder: (context, state) => const DepartmentListView(),
      routes: [
        GoRoute(
          path: ':id',
          name: 'department-detail',
          builder: (context, state) => DepartmentDetailView(
            id: int.parse(state.pathParameters['id'] ?? '0'),
          ),
        ),
      ],
    ),
    GoRoute(
      name: 'presidents',
      path: '/presidents',
      builder: (context, state) => const PresidentListView(),
      routes: [
        GoRoute(
          path: ':id',
          name: 'president-detail',
          builder: (context, state) => PresidentDetailView(
            id: int.parse(state.pathParameters['id'] ?? '0'),
          ),
        ),
      ],
    ),
    GoRoute(
      name: 'naturalAreas',
      path: '/natural-areas',
      builder: (context, state) => const NaturalAreaListView(),
      routes: [
        GoRoute(
          path: ':id',
          name: 'natural-area-detail',
          builder: (context, state) => NaturalAreaDetailView(
            id: int.parse(state.pathParameters['id'] ?? '0'),
          ),
        ),
      ],
    ),
    GoRoute(
      name: 'touristicAttractions',
      path: '/touristic-attractions',
      builder: (context, state) => const TouristicAttractionListView(),
      routes: [
        GoRoute(
          path: ':id',
          name: 'touristic-attraction-detail',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id'] ?? '0');
            return TouristicAttractionDetailView(id: id);
          },
        ),
      ],
    ),
  ],
);
