import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../presenters/presenters.dart';
import './widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go('/car_list');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final isFormValid =
              state is ValidationState ? state.isFormValid : false;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Login with your email or phone number',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.blueGrey.shade600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: identifierController,
                    label: 'Email or Phone Number',
                    icon: Icons.person_outline,
                    onChanged: (value) {
                      _updateValidation(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: passwordController,
                    label: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    onChanged: (value) {
                      _updateValidation(context);
                    },
                  ),
                  const SizedBox(height: 30),
                  GradientButton(
                    text: 'Login',
                    onTap: isFormValid
                        ? () {
                            final identifier = identifierController.text;
                            final password = passwordController.text;
                            context
                                .read<AuthBloc>()
                                .add(LoginEvent(identifier, password));
                          }
                        : null,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      context.push('/register');
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.blueGrey.shade600),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _updateValidation(BuildContext context) {
    final fields = {
      'identifier': identifierController.text,
      'password': passwordController.text,
    };

    context.read<AuthBloc>().add(
          AuthValidationChangedEvent(fields: fields),
        );
  }
}
