# StudyFlow

Prototipo Flutter para organizar tareas y responsabilidades en trabajos grupales universitarios.

## Ejecutar

Requiere Flutter instalado y un dispositivo, emulador o navegador configurado.

```bash
flutter pub get
flutter run -d web-server --web-hostname=127.0.0.1 --web-port=8080
```

Después, abra `http://127.0.0.1:8080` en el navegador. Se utiliza `web-server` porque evita depender de la conexión de depuración remota de Chrome, que puede ser bloqueada por el firewall.

Para verificar el proyecto:

```bash
flutter analyze
flutter test
flutter build web
```

La aplicación también incluye la plataforma Android. Antes de ejecutarla en un emulador o dispositivo se deben instalar las herramientas de línea de comandos del Android SDK y aceptar sus licencias.

## Datos de demostración

La pantalla de acceso está precargada. Presione **Ingresar** para abrir la aplicación. Los proyectos y tareas se guardan localmente mediante `shared_preferences` y permanecen disponibles después de cerrar o recargar la aplicación.

Desde **Proyectos** se pueden crear proyectos. En el detalle se puede editar o eliminar el proyecto, crear tareas, cambiar su estado y editar o eliminar cada tarea.
