import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/form_widgets.dart';
import '../../../../core/widgets/screen_layout.dart';
import '../../domain/entities/appointment.dart';
import '../cubit/appointments_cubit.dart';

/// Agenda una cita nueva o edita una existente (si recibe [initial]).
class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key, this.initial});
  final Appointment? initial;

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  static const _specialties = [
    'Medicina general',
    'Pediatría',
    'Obstetricia',
    'Odontología',
  ];
  static const _sedes = ['Sede Principal', 'Ambulatorio Norte', 'Campaña itinerante'];

  final _form = GlobalKey<FormState>();
  final _specialty = TextEditingController();
  final _sede = TextEditingController();
  final _date = TextEditingController();
  final _time = TextEditingController();
  TimeOfDay? _timeValue;

  bool get _editing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final a = widget.initial;
    if (a == null) return;
    _specialty.text = a.specialty;
    _sede.text = a.sede;
    _date.text = a.date;
    _time.text = a.time;
    final parts = a.time.split(':');
    if (parts.length == 2) {
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      if (h != null && m != null) _timeValue = TimeOfDay(hour: h, minute: m);
    }
  }

  @override
  void dispose() {
    _specialty.dispose();
    _sede.dispose();
    _date.dispose();
    _time.dispose();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  Future<void> _pickFromList(
      TextEditingController c, String title, List<String> options) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            for (final o in options)
              ListTile(title: Text(o), onTap: () => Navigator.pop(ctx, o)),
          ],
        ),
      ),
    );
    if (choice != null) c.text = choice;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (d != null) _date.text = '${_two(d.day)}/${_two(d.month)}/${d.year}';
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _timeValue ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (t == null) return;
    _timeValue = t;
    _time.text = '${_two(t.hour)}:${_two(t.minute)}';
  }

  String? _validateTime(String? v) {
    final t = _timeValue;
    if (t == null) return 'Seleccione una hora';
    if (t.hour < 8 || t.hour >= 18) return 'Atendemos de 8:00 a 18:00';
    return null;
  }

  void _confirm() {
    if (!_form.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete los datos de la cita')),
      );
      return;
    }
    final cubit = context.read<AppointmentsCubit>();
    final initial = widget.initial;
    if (initial != null) {
      cubit.update(initial.copyWith(
        specialty: _specialty.text,
        sede: _sede.text,
        date: _date.text,
        time: _time.text,
      ));
    } else {
      cubit.add(Appointment(
        specialty: _specialty.text,
        sede: _sede.text,
        date: _date.text,
        time: _time.text,
      ));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(_editing
              ? 'Cita actualizada correctamente'
              : 'Cita agendada correctamente')),
    );
    context.go('/citas');
  }

  @override
  Widget build(BuildContext context) {
    const arrow = Icon(Icons.arrow_drop_down);
    return ScreenLayout(
      title: _editing ? 'Editar cita' : 'Agendar cita',
      subtitle: 'Paciente',
      bottom: ButtonPair(
        left: OutlinedButton(
          onPressed: () => context.go('/citas'),
          child: const Text('CANCELAR'),
        ),
        right: FilledButton(
          onPressed: _confirm,
          child: Text(_editing ? 'GUARDAR' : 'CONFIRMAR'),
        ),
      ),
      child: Form(
        key: _form,
        child: SpacedList(
          children: [
            LabeledField(
              label: 'Especialidad',
              controller: _specialty,
              hint: 'Seleccione',
              readOnly: true,
              suffixIcon: arrow,
              onTap: () => _pickFromList(_specialty, 'Especialidad', _specialties),
              validator: (v) => Validators.required(v, 'La especialidad'),
            ),
            LabeledField(
              label: 'Sede',
              controller: _sede,
              hint: 'Seleccione',
              readOnly: true,
              suffixIcon: arrow,
              onTap: () => _pickFromList(_sede, 'Sede', _sedes),
              validator: (v) => Validators.required(v, 'La sede'),
            ),
            LabeledField(
              label: 'Fecha',
              controller: _date,
              hint: 'dd/mm/aaaa',
              readOnly: true,
              suffixIcon: const Icon(Icons.calendar_today_outlined),
              onTap: _pickDate,
              validator: (v) => Validators.required(v, 'La fecha'),
            ),
            LabeledField(
              label: 'Hora',
              controller: _time,
              hint: 'Seleccione',
              readOnly: true,
              suffixIcon: const Icon(Icons.access_time),
              onTap: _pickTime,
              validator: _validateTime,
            ),
          ],
        ),
      ),
    );
  }
}
