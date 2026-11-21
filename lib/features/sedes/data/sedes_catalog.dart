import '../domain/entities/sede.dart';

/// Sedes de ejemplo en Nasca. REEMPLAZAR por las coordenadas reales de la clínica
/// (o por los datos del servidor en una versión posterior).
const sedesCatalog = [
  Sede(
    id: 'principal',
    name: 'Sede Principal',
    specialties: ['Medicina general', 'Pediatría'],
    latitude: -14.8310,
    longitude: -74.9390,
  ),
  Sede(
    id: 'norte',
    name: 'Ambulatorio Norte',
    specialties: ['Pediatría'],
    latitude: -14.8190,
    longitude: -74.9410,
  ),
  Sede(
    id: 'itinerante',
    name: 'Campaña itinerante',
    specialties: ['Obstetricia'],
    latitude: -14.8450,
    longitude: -74.9300,
  ),
];
