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
    ),
    GoRoute(
      name: 'departmentDetail',
      path: '/departments/:id',
      builder: (context, state) =>
          DepartmentDetailView(id: state.pathParameters['id'] ?? '0'),
    ),
    GoRoute(
      name: 'presidents',
      path: '/presidents',
      builder: (context, state) => const PresidentListView(),
    ),
    GoRoute(
      name: 'presidentDetail',
      path: '/presidents/:id',
      builder: (context, state) =>
          PresidentDetailView(id: state.pathParameters['id'] ?? '0'),
    ),
    GoRoute(
      name: 'naturalAreas',
      path: '/natural-areas',
      builder: (context, state) => const NaturalAreaListView(),
    ),
    GoRoute(
      name: 'naturalAreaDetail',
      path: '/natural-areas/:id',
      builder: (context, state) =>
          NaturalAreaDetailView(id: state.pathParameters['id'] ?? '0'),
    ),
    GoRoute(
      name: 'touristicAttractions',
      path: '/touristic-attractions',
      builder: (context, state) => const TouristicAttractionListView(),
    ),
    GoRoute(
      name: 'touristicAttractionDetail',
      path: '/touristic-attractions/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id'] ?? '0');
        return TouristicAttractionDetailView(id: id);
      },
    ),
  ],
);
