// ignore_for_file: avoid_print
// Servidor REST de práctica para SaludMovil IES (solo usa dart:io).
// Ejecutar desde la raíz del proyecto:  dart run mock_server/server.dart
// Usuarios: enfermera / medico / paciente, todos con contraseña 1234.
import 'dart:convert';
import 'dart:io';

const token = 'token-demo-saludmovil';
const users = {
  'enfermera': {'password': '1234', 'role': 'enfermeria'},
  'medico': {'password': '1234', 'role': 'medico'},
  'paciente': {'password': '1234', 'role': 'paciente'},
};

final patients = <Map<String, dynamic>>[];
var nextId = 1;

Future<void> main() async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 3000;
  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print('Servidor SaludMovil escuchando en http://localhost:$port');
  print('Usuarios: enfermera, medico, paciente (contraseña 1234)');
  await for (final req in server) {
    _handle(req);
  }
}

Future<void> _send(HttpRequest req, int status, Object body) async {
  req.response
    ..statusCode = status
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(body));
  await req.response.close();
}

Future<Map<String, dynamic>?> _readBody(HttpRequest req) async {
  try {
    final raw = await utf8.decoder.bind(req).join();
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? decoded : null;
  } catch (_) {
    return null;
  }
}

String? _validate(Map<String, dynamic> b) {
  final dni = b['dni'];
  if (dni is String && dni.isNotEmpty && !RegExp(r'^\d{8}$').hasMatch(dni)) {
    return 'El DNI debe tener 8 dígitos';
  }
  final name = b['name'];
  if (name is! String || name.trim().length < 3) return 'Nombre inválido';
  final age = b['age'];
  if (age is! int || age < 0 || age > 120) return 'Edad inválida';
  if (!['I', 'II', 'III', 'IV', 'V'].contains(b['level'])) return 'Nivel inválido';
  return null;
}

Future<void> _handle(HttpRequest req) async {
  final segs = req.uri.pathSegments;
  print('${req.method} ${req.uri.path}');
  try {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (req.method == 'GET' && segs.length == 1 && segs[0] == 'health') {
      return _send(req, 200, {'status': 'ok'});
    }

    if (req.method == 'POST' && segs.join('/') == 'auth/login') {
      final b = await _readBody(req);
      final user = users[(b?['username'] as String? ?? '').toLowerCase()];
      if (user == null || user['password'] != b?['password']) {
        return _send(req, 401, {'error': 'Usuario o contraseña incorrectos'});
      }
      return _send(req, 200, {
        'token': token,
        'user': {
          'username': (b!['username'] as String).toLowerCase(),
          'role': user['role'],
        },
      });
    }

    if (segs.isEmpty || segs[0] != 'patients') {
      return _send(req, 404, {'error': 'Ruta no encontrada'});
    }
    if (req.headers.value('authorization') != 'Bearer $token') {
      return _send(req, 401, {'error': 'Sesión no válida'});
    }

    if (segs.length == 1 && req.method == 'GET') {
      return _send(req, 200, patients);
    }

    if (segs.length == 1 && req.method == 'POST') {
      final b = await _readBody(req);
      if (b == null) return _send(req, 400, {'error': 'JSON inválido'});
      final error = _validate(b);
      if (error != null) return _send(req, 400, {'error': error});
      final item = {...b, 'id': nextId++};
      patients.add(item);
      return _send(req, 201, item);
    }

    if (segs.length == 2) {
      final id = int.tryParse(segs[1]);
      final i = patients.indexWhere((p) => p['id'] == id);
      if (i < 0) return _send(req, 404, {'error': 'Ficha no encontrada'});
      if (req.method == 'PUT') {
        final b = await _readBody(req);
        if (b == null) return _send(req, 400, {'error': 'JSON inválido'});
        final error = _validate(b);
        if (error != null) return _send(req, 400, {'error': error});
        patients[i] = {...b, 'id': id};
        return _send(req, 200, patients[i]);
      }
      if (req.method == 'DELETE') {
        patients.removeAt(i);
        return _send(req, 200, {'deleted': id});
      }
    }

    return _send(req, 405, {'error': 'Método no permitido'});
  } catch (e) {
    return _send(req, 500, {'error': 'Error interno: $e'});
  }
}
