import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

import '../../../domain/usecases/usecases.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final SaveToken saveToken;
  final GetToken getToken;

  AuthBloc({
    required this.loginUser,
    required this.saveToken,
    required this.getToken,
  }) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginUser(event.identifier, event.password);
        await saveToken(user.token); // Save token on successful login
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<AuthValidationChangedEvent>((event, emit) {
      final fieldValidities = <String, bool>{};

      // Validation rules
      final identifier = event.fields['identifier'] ?? '';
      final password = event.fields['password'] ?? '';

      fieldValidities['identifier'] = identifier.isNotEmpty;
      fieldValidities['password'] = password.length >= 6;

      final isFormValid = fieldValidities.values.every((isValid) => isValid);

      emit(ValidationState(
          isFormValid: isFormValid, fieldValidities: fieldValidities));
    });

    on<AutoLoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final token = await getToken();
        if (token != null) {
          final user = await loginUser.withToken(token);
          emit(AuthSuccess(user));
        } else {
          emit(AuthInitial()); // No token found, show login screen
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
