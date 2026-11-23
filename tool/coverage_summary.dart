// ignore_for_file: avoid_print
// Resume la cobertura de pruebas por archivo.
// Uso:  flutter test --coverage
//       dart run tool/coverage_summary.dart
import 'dart:io';

void main(List<String> args) {
  final file = File(args.isNotEmpty ? args.first : 'coverage/lcov.info');
  if (!file.existsSync()) {
    stderr.writeln('No existe ${file.path}. Ejecute primero: flutter test --coverage');
    exit(1);
  }

  final stats = <String, List<int>>{}; // archivo -> [líneas cubiertas, líneas totales]
  String? current;
  var found = 0;
  var hit = 0;
  for (final line in file.readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      current = line.substring(3).replaceAll('\\', '/');
      found = 0;
      hit = 0;
    } else if (line.startsWith('DA:')) {
      found++;
      final count = int.tryParse(line.split(',')[1]) ?? 0;
      if (count > 0) hit++;
    } else if (line == 'end_of_record' && current != null) {
      stats[current] = [hit, found];
      current = null;
    }
  }

  final entries = stats.entries.where((e) => e.key.contains('lib/')).toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  var totalHit = 0;
  var totalFound = 0;
  print('Cobertura por archivo (líneas):');
  for (final e in entries) {
    final pct = e.value[1] == 0 ? 100.0 : e.value[0] * 100 / e.value[1];
    totalHit += e.value[0];
    totalFound += e.value[1];
    final name = e.key.substring(e.key.indexOf('lib/'));
    print('${pct.toStringAsFixed(0).padLeft(4)}%  ${e.value[0]}/${e.value[1]}  $name');
  }
  final total = totalFound == 0 ? 0.0 : totalHit * 100 / totalFound;
  print('\nTOTAL: ${total.toStringAsFixed(1)}%  ($totalHit de $totalFound líneas)');
}
