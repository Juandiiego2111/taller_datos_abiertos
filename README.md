# Taller Datos Abiertos Colombia 🇨🇴

Aplicación móvil desarrollada en **Flutter** que consume datos reales de la API pública [API Colombia](https://api-colombia.com/), mostrando información geográfica, histórica y turística del país.

**Autor:** Juan Diego Rodriguez Ortiz  
**Código estudiantil:** 230231020  
**GitHub:** [@Juandiiego2111](https://github.com/Juandiiego2111)

---

## API Utilizada

- **Base URL:** `https://api-colombia.com/api/v1`
- **Documentación Swagger:** https://api-colombia.com/swagger/index.html
- No requiere autenticación. Responde en formato JSON.

### Endpoints implementados

| Endpoint | Descripción | URL |
|---|---|---|
| `Department` | Listado y detalle de los 32 departamentos de Colombia | `/Department` |
| `President` | Presidentes de Colombia con período de gobierno y partido | `/President` |
| `NaturalArea` | Áreas naturales protegidas con superficie y departamento | `/NaturalArea` |
| `TouristicAttraction` | Atracciones turísticas con imágenes y coordenadas | `/TouristicAttraction` |

### Ejemplo de respuesta JSON — Department

```json
{
  "id": 1,
  "name": "Amazonas",
  "description": "Departamento ubicado al sur de Colombia...",
  "regionId": 3,
  "surface": 109665,
  "population": 76243,
  "municipalities": 2,
  "cityCapital": {
    "name": "Leticia",
    "postalCode": "910001"
  }
}
```

---

## Arquitectura y Estructura del Proyecto

La aplicación sigue una arquitectura por capas que separa responsabilidades:

<img width="369" height="825" alt="image" src="https://github.com/user-attachments/assets/c3d228ef-12aa-4754-99db-02ef85c599ed" />

---

## Paquetes Utilizados

| Paquete | Versión | Uso |
|---|---|---|
| `http` | ^1.2.1 | Peticiones GET a la API |
| `go_router` | ^14.0.0 | Navegación declarativa entre pantallas |
| `flutter_dotenv` | ^5.1.0 | Manejo de la URL base mediante archivo `.env` |

---

## Rutas implementadas con go_router

Las rutas están definidas en `lib/routes/app_router.dart` con nombres y rutas anidadas:

| Nombre | Ruta | Pantalla | Parámetros |
|---|---|---|---|
| `home` | `/` | DashboardView | — |
| `departments` | `/departments` | DepartmentListView | — |
| `department-detail` | `/departments/:id` | DepartmentDetailView | `id` (int) |
| `presidents` | `/presidents` | PresidentListView | — |
| `president-detail` | `/presidents/:id` | PresidentDetailView | `id` (int) |
| `naturalAreas` | `/natural-areas` | NaturalAreaListView | — |
| `natural-area-detail` | `/natural-areas/:id` | NaturalAreaDetailView | `id` (int) |
| `touristicAttractions` | `/touristic-attractions` | TouristicAttractionListView | — |
| `touristic-attraction-detail` | `/touristic-attractions/:id` | TouristicAttractionDetailView | `id` (int) |

Los parámetros se pasan mediante `pathParameters` y se navega con `context.goNamed()`:

```dart
context.goNamed(
  'department-detail',
  pathParameters: {'id': dept.id.toString()},
);
```

---

## Manejo de Estados

Cada pantalla de listado y detalle gestiona tres estados con `FutureBuilder`:

- **Cargando** → `LoadingWidget` con `CircularProgressIndicator`
- **Éxito** → `ListView.builder` o vista de detalle con la información del registro
- **Error** → `AppErrorWidget` con mensaje descriptivo y botón **Reintentar** que relanza el `Future`

---

## Capturas de Pantalla

### Dashboard
> Cards de acceso a cada endpoint con iconos y colores temáticos.

<img width="295" height="625" alt="Dashboard" src="https://github.com/user-attachments/assets/9fbd89b4-c430-4100-86f5-d5762bba3dc2" />

### Listado — Departamentos
> ListView.builder con avatar, nombre y descripción breve.

<img width="301" height="625" alt="Listado Departamentos" src="https://github.com/user-attachments/assets/1215c132-fb28-4637-8ab9-64ad9255511a" />

### Listado — Presidentes
> Imagen de red del presidente, nombre completo y partido político.

<img width="315" height="619" alt="Listado Presidentes" src="https://github.com/user-attachments/assets/3bf6084d-f9b4-46cc-9577-fa593faff9dd" />

### Listado — Áreas Naturales
> Nombre del área, departamento y chips con superficie y código DANE.

<img width="294" height="625" alt="Listado Áreas Naturales" src="https://github.com/user-attachments/assets/09263ec5-6846-44cb-838c-2c5d4be31dc4" />

### Listado — Atracciones Turísticas
> Cards con imagen real de la atracción, ciudad y departamento.

<img width="293" height="619" alt="Listado Atracciones Turísticas" src="https://github.com/user-attachments/assets/cddd9fbf-ba91-4cf4-9729-ca5cf0d5528f" />

### Detalle
> SliverAppBar expandible con información completa del registro seleccionado.

<img width="310" height="626" alt="Detalle Departamento" src="https://github.com/user-attachments/assets/5217fb38-acb5-4feb-ab57-5fdacf7e3e07" />

<img width="298" height="618" alt="Detalle Presidente" src="https://github.com/user-attachments/assets/5ddaab59-3823-413e-94f8-8d17661c66ae" />

---

## Flujo de trabajo Git
main          ← rama estable (producción)
└── dev       ← rama de integración
└── feature/taller_api_colombia  ← desarrollo del taller

1. Se creó `feature/taller_api_colombia` a partir de `dev`
2. Commits atómicos con prefijos convencionales: `feat:`, `fix:`, `docs:`, `refactor:`
3. Pull Request de `feature/taller_api_colombia` → `dev` con descripción y capturas
4. Merge a `dev` y posteriormente a `main`

---

## Instrucciones para ejecutar

```bash
# 1. Clonar el repositorio
git clone https://github.com/Juandiiego2111/taller_datos_abiertos.git
cd taller_datos_abiertos

# 2. Instalar dependencias
flutter pub get

# 3. Verificar que existe el archivo .env en la raíz
# Contenido: BASE_URL=https://api-colombia.com/api/v1

# 4. Ejecutar la aplicación
flutter run
```
