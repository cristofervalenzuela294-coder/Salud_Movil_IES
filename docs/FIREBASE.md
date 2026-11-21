# Configuración de Firebase Cloud Messaging (Android)

1. En https://console.firebase.google.com crear un proyecto.
2. Agregar una app **Android**. El nombre de paquete debe ser igual al `applicationId`
   de `android/app/build.gradle.kts` (normalmente `pe.edu.iestp.saludmovil_ies`).
3. Descargar `google-services.json` y copiarlo en `android/app/google-services.json`.
   (Está en `.gitignore`: no se sube al repositorio.)
4. `android/settings.gradle.kts`, dentro del bloque `plugins { ... }`, agregar:
   `id("com.google.gms.google-services") version "4.4.2" apply false`
5. `android/app/build.gradle.kts`, dentro del bloque `plugins { ... }`, agregar:
   `id("com.google.gms.google-services")`
   y en `defaultConfig` fijar `minSdk = 23`.
6. `android/app/src/main/AndroidManifest.xml`, junto a los otros permisos:
   `<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>`
7. Ejecutar en un emulador **con Google Play** (o un celular) y abrir la pestaña Avisos.
8. Copiar el token FCM con el botón de la pantalla.
9. Firebase Console > Messaging > Nueva campaña > Notificaciones > Enviar mensaje de prueba,
   pegar el token. Opcional: en "Datos personalizados" usar `type` = `call`, `reminder` o `confirmation`.
