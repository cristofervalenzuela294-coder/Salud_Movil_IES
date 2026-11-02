import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _form = GlobalKey<FormState>();
  final _user = TextEditingController();
  final _pass = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _user.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_form.currentState!.validate()) {
      context.read<AuthBloc>().add(LoginSubmitted(_user.text, _pass.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) context.go('/pacientes');
              if (state is AuthFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              final loading = state is AuthLoading;
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        decoration: BoxDecoration(
                          color: AppColors.mint,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: const Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.family_restroom,
                                  size: 48, color: AppColors.levelV),
                            ),
                            SizedBox(height: 20),
                            Text('Salud Movil IES',
                                style: TextStyle(fontSize: 26, color: AppColors.navy)),
                            Text('Gestion de Atencion Medica'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text('Usuario:',
                          style: TextStyle(fontSize: 20, color: AppColors.navy)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _user,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (v) => Validators.minLength(v, 3, 'El usuario'),
                      ),
                      const SizedBox(height: 24),
                      const Text('Contraseña:',
                          style: TextStyle(fontSize: 20, color: AppColors.navy)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _pass,
                        obscureText: _hidePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (v) => Validators.minLength(v, 4, 'La contraseña'),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            tooltip: _hidePassword ? 'Mostrar' : 'Ocultar',
                            icon: Icon(_hidePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () =>
                                setState(() => _hidePassword = !_hidePassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      FilledButton(
                        onPressed: loading ? null : _submit,
                        child: loading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(strokeWidth: 3))
                            : const Text('INGRESAR'),
                      ),
                      const SizedBox(height: 28),
                      const Text('Prototipo Academico',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, color: AppColors.navy)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
