# Guía de depuración y perfilado con Flutter DevTools

## 1. Ejecutar en modo *profile*
El rendimiento se mide en modo `profile`, nunca en `debug` (es mucho más lento).
Use el emulador de Android o, mejor, un celular real:

    flutter run --profile -d emulator-5554

## 2. Abrir DevTools
En VS Code: `Ctrl+Shift+P` > **Flutter: Open DevTools** (con la app ejecutándose).
También aparece un enlace en la terminal ("Flutter DevTools debugger and profiler...").

## 3. Qué medir y dónde

| Pestaña | Qué hacer en la app | Qué buscar |
|---|---|---|
| **Performance** | Desplazar la lista de pacientes; abrir y mover el mapa; cambiar de pestañas | Fotogramas rojos (más de 16 ms). Capture una captura de pantalla de la gráfica |
| **CPU Profiler** | Pulsar *Record*, ejecutar la sincronización, *Stop* | Funciones que más tiempo consumen (Bottom Up) |
| **Memory** | Pulsar *Take Snapshot* antes y después de abrir 10 veces el mapa y volver | Objetos que crecen sin liberarse (fugas); botón *GC* para forzar limpieza |
| **Network** | Pulsar "SINCRONIZAR AHORA" con el servidor de práctica encendido | Peticiones POST, PUT y GET a `/patients`, códigos de estado y tiempos |
| **Logging** | Usar la app | Mensajes `SQLite:`, `FCM token:` y errores |
| **Widget Inspector** | Activar *Select Widget Mode* y tocar la pantalla | Estructura de widgets y desbordamientos (overflow) |

## 4. Qué entregar en el reporte
- Captura de Performance con la lista de pacientes en movimiento.
- Captura de Memory antes y después de la prueba de navegación repetida.
- Captura de Network con la sincronización.
- Una conclusión por captura: qué se observó y si hay algo que corregir.
