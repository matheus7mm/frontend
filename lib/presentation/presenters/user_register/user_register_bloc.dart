import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_register_event.dart';
import 'user_register_state.dart';

import '../../../domain/usecases/usecases.dart';

class UserRegisterBloc extends Bloc<UserRegisterEvent, UserRegisterState> {
  final RegisterUser registerUser;

  UserRegisterBloc({
    required this.registerUser,
  }) : super(UserRegisterInitial()) {
    on<RegisterEvent>((event, emit) async {
      emit(UserRegisterLoading());
      try {
        final user = await registerUser(event.email, event.password,
            phoneNumber: event.phoneNumber);
        emit(UserRegisterSuccess(user));
      } catch (e) {
        emit(UserRegisterFailure(e.toString()));
      }
    });

    on<ValidationChangedEvent>((event, emit) {
      final fieldValidities = <String, bool>{};

      // Validation rules for each field
      final email = event.fields['email'] ?? '';
      final phoneNumber = event.fields['phoneNumber'] ?? '';
      final password = event.fields['password'] ?? '';

      // Email should contain '@' and a period to be considered valid
      fieldValidities['email'] = email.contains('@') && email.contains('.');

      // Phone number should not be empty
      fieldValidities['phoneNumber'] = phoneNumber.isNotEmpty;

      // Password must be at least 6 characters long
      fieldValidities['password'] = password.length >= 6;

      // Check if all fields are valid
      final isFormValid = fieldValidities.values.every((isValid) => isValid);

      // Emit the validation state with updated values
      emit(UserRegisterValidationState(
        isFormValid: isFormValid,
        fieldValidities: fieldValidities,
      ));
    });
  }
}
