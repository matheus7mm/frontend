import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../presenters/presenters.dart';
import './widgets/widgets.dart';

class UserRegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  UserRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: const CustomAppBar(title: 'Register'),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (_) => context.read<AuthBloc>()),
        ],
        child: BlocConsumer<UserRegisterBloc, UserRegisterState>(
          listener: (context, state) {
            if (state is UserRegisterSuccess) {
              context.go('/car_list');
            } else if (state is UserRegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is UserRegisterLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create an Account',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey.shade800,
                              ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sign up with your email and phone number',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.blueGrey.shade600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    BlocBuilder<UserRegisterBloc, UserRegisterState>(
                      builder: (context, state) {
                        // Ensure we have a UserRegisterValidationState to display field validations
                        final validationState =
                            state is UserRegisterValidationState
                                ? state
                                : const UserRegisterValidationState(
                                    isFormValid: false, fieldValidities: {});

                        return Column(
                          children: [
                            CustomTextField(
                              controller: emailController,
                              label: 'Email',
                              icon: Icons.email_outlined,
                              onChanged: (value) => _updateValidation(context),
                              errorText:
                                  validationState.fieldValidities['email'] ==
                                          false
                                      ? 'Invalid email'
                                      : null,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: phoneNumberController,
                              label: 'Phone Number',
                              icon: Icons.phone_outlined,
                              onChanged: (value) => _updateValidation(context),
                              errorText: validationState
                                          .fieldValidities['phoneNumber'] ==
                                      false
                                  ? 'Invalid phone number'
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: passwordController,
                              label: 'Password',
                              icon: Icons.lock_outline,
                              obscureText: true,
                              onChanged: (value) => _updateValidation(context),
                              errorText:
                                  validationState.fieldValidities['password'] ==
                                          false
                                      ? 'Password must be at least 6 characters'
                                      : null,
                            ),
                            const SizedBox(height: 30),
                            GradientButton(
                              text: 'Register',
                              onTap: validationState.isFormValid
                                  ? () {
                                      context.read<UserRegisterBloc>().add(
                                            RegisterEvent(
                                              email: emailController.text,
                                              password: passwordController.text,
                                              phoneNumber:
                                                  phoneNumberController.text,
                                            ),
                                          );
                                    }
                                  : null,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _updateValidation(BuildContext context) {
    final fields = {
      'email': emailController.text,
      'phoneNumber': phoneNumberController.text,
      'password': passwordController.text,
    };
    context
        .read<UserRegisterBloc>()
        .add(ValidationChangedEvent(fields: fields));
  }
}
