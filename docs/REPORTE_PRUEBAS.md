# Reporte de pruebas automatizadas — SaludMovil IES

Fecha: ____/____/2026        Responsable: ______________________

## 1. Cómo se ejecutaron

    flutter test                       # todas las pruebas
    flutter test --coverage            # genera coverage/lcov.info
    dart run tool/coverage_summary.dart

## 2. Resultado general

| Indicador | Valor |
|---|---|
| Pruebas ejecutadas | ______ |
| Pruebas aprobadas | ______ |
| Pruebas fallidas | ______ |
| Cobertura de líneas (lib/) | ______ % |

## 3. Pruebas unitarias

| Archivo | Qué verifica |
|---|---|
| `validators_test.dart` | DNI, nombre, rangos y presión arterial |
| `triage_calculator_test.dart` | Reglas de prioridad (niveles I a V) |
| `triage_bloc_test.dart` | Flujo de triage: admisión, cálculo y reinicio |
| `patients_bloc_test.dart` | Orden por prioridad, guardar y sincronizar |
| `crud_test.dart` | Editar y eliminar fichas; CRUD de citas |
| `database_test.dart` | Esquema SQLite, DAO y migración v1 a v2 |
| `sync_patients_test.dart` | Envío y descarga de fichas, con y sin conexión |
| `failures_test.dart` | Traducción de errores HTTP |
| `auth_bloc_test.dart` | Inicio de sesión correcto, vacío y rechazado |
| `geo_test.dart` | Distancias y formato |
| `location_cubit_test.dart` | GPS en tiempo real y errores |
| `notifications_cubit_test.dart` | Recepción de notificaciones push |

## 4. Pruebas de interfaz (widget tests)

| Archivo | Qué verifica |
|---|---|
| `widget_test.dart` | La app arranca en el inicio de sesión |
| `widget/login_test.dart` | Validaciones y entrada a la app |
| `widget/triage_flow_test.dart` | Validación de formularios y flujo completo de triage |
| `widget/charts_test.dart` | Detalle y eliminación de fichas |
| `widget/appointments_test.dart` | Listado y cancelación de citas |
| `widget/notifications_test.dart` | Aviso push visible en la lista |

## 5. Depuración y perfilado (DevTools)

| Prueba | Resultado observado | Acción tomada |
|---|---|---|
| Performance: lista de pacientes | | |
| Memory: navegación repetida al mapa | | |
| Network: sincronización | | |

## 6. Defectos encontrados y corregidos

| N.º | Defecto | Corrección |
|---|---|---|
| 1 | Mensaje "La contraseña es obligatorio" (concordancia) | Mensaje cambiado a "<campo>: campo obligatorio" |
| 2 | | |

## 7. Limitaciones conocidas
- Las pruebas de interfaz no incluyen el mapa (necesita red para los mosaicos) ni el envío real de push (requiere Firebase).
- Los datos de las pruebas son en memoria; SQLite se prueba por separado.
