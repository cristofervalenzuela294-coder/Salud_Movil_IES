import "package:flutter/material.dart";

import "../../../../core/theme/app_colors.dart";
import "../../../../core/widgets/gradient_background.dart";
import "../../domain/entities/patient.dart";
import "../../domain/entities/triage_level.dart";

/// Datos de ejemplo. En el Hito 7 se leen de SQLite.
const _samples = [
  Patient(name: "Luis Q.", age: 67, reason: "Dolor torácico", level: TriageLevel.i),
  Patient(name: "Rosa M.", age: 54, reason: "Dificultad respiratoria", level: TriageLevel.ii),
  Patient(name: "Carlos P.", age: 31, reason: "Fiebre de 3 días", level: TriageLevel.iii),
  Patient(name: "Ana T.", age: 8, reason: "Dolor de oído", level: TriageLevel.iv),
  Patient(name: "Mario S.", age: 40, reason: "Control de presión", level: TriageLevel.v),
];

class WaitingListPage extends StatelessWidget {
  const WaitingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.mint,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pacientes en espera",
                          style: TextStyle(fontSize: 26, color: AppColors.navy)),
                      Text("Enfermería · Triage"),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: _samples.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _PatientCard(_samples[i]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard(this.patient);
  final Patient patient;

  @override
  Widget build(BuildContext context) {
    final level = patient.level;
    final darkText = level == TriageLevel.ii || level == TriageLevel.iii;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        title: Text(patient.name,
            style: const TextStyle(fontSize: 20, color: AppColors.navy)),
        subtitle: Text("${patient.age} años · ${patient.reason}"),
        trailing: Chip(
          label: Text(level.label),
          backgroundColor: level.color,
          labelStyle: TextStyle(color: darkText ? Colors.black : Colors.white),
          side: BorderSide.none,
        ),
      ),
    );
  }
}
