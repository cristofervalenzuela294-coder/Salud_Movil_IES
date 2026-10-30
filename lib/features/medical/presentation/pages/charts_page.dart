import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/item_card.dart';
import '../../../../core/widgets/screen_layout.dart';
import '../../../triage/presentation/sample_data.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _search.text.trim().toLowerCase();
    final results = samplePatients
        .where((p) =>
            q.isEmpty ||
            p.name.toLowerCase().contains(q) ||
            p.reason.toLowerCase().contains(q))
        .toList();
    return ScreenLayout(
      title: 'Fichas por prioridad',
      subtitle: 'Médico',
      bottom: FilledButton(
        onPressed: () => context.go('/avisos'),
        child: const Text('LLAMAR SIGUIENTE PACIENTE'),
      ),
      child: SpacedList(
        children: [
          LabeledField(
            label: 'Buscar paciente',
            controller: _search,
            hint: 'Nombre o motivo',
            suffixIcon: const Icon(Icons.search),
          ),
          if (results.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No se encontraron fichas',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.navy, fontSize: 16)),
            ),
          for (final p in results)
            ItemCard(
              title: p.name,
              subtitle: p.reason,
              chipLabel: p.level.name.toUpperCase(),
              chipColor: p.level.color,
              onTap: () => context.push('/fichas/detalle'),
            ),
        ],
      ),
    );
  }
}
