import 'package:flutter_bloc/flutter_bloc.dart';
import 'car_event.dart';
import 'car_state.dart';
import '../../../domain/usecases/usecases.dart';

class CarBloc extends Bloc<CarEvent, CarState> {
  final GetCars getCars;
  final CreateCar createCar;
  final UpdateCar updateCar;
  final DeleteCar deleteCar;
  final ClearToken clearToken;

  bool _isFormValid = false;
  final Map<String, bool> _fieldValidities = {'name': false, 'model': false};

  CarBloc({
    required this.getCars,
    required this.createCar,
    required this.updateCar,
    required this.deleteCar,
    required this.clearToken,
  }) : super(CarInitial()) {
    on<GetCarsEvent>((event, emit) async {
      emit(CarLoading());
      try {
        final cars = await getCars();
        emit(CarSuccess(cars));
      } catch (e) {
        emit(CarFailure(e.toString()));
      }
    });

    on<AddCarEvent>((event, emit) async {
      _validateFields(event.name, event.model);
      if (!_isFormValid) return;

      emit(CarLoading());
      try {
        await createCar(event.name, event.model);
        final cars = await getCars();
        emit(CarSuccess(cars));
      } catch (e) {
        emit(CarFailure(e.toString()));
      }
    });

    on<UpdateCarEvent>((event, emit) async {
      _validateFields(event.name, event.model);
      if (!_isFormValid) return;

      emit(CarLoading());
      try {
        await updateCar(event.id, event.name, event.model);
        final cars = await getCars();
        emit(CarSuccess(cars));
      } catch (e) {
        emit(CarFailure(e.toString()));
      }
    });

    on<DeleteCarEvent>((event, emit) async {
      emit(CarLoading());
      try {
        await deleteCar(event.id);
        final cars = await getCars();
        emit(CarSuccess(cars));
      } catch (e) {
        emit(CarFailure(e.toString()));
      }
    });

    on<CarValidationEvent>((event, emit) {
      _validateFields(event.name, event.model);
      emit(CarValidationState(
          isFormValid: _isFormValid, fieldValidities: _fieldValidities));
    });

    on<LogoutEvent>((event, emit) async {
      try {
        await clearToken();
        emit(CarLogoutSuccess());
      } catch (e) {
        emit(const CarFailure('Failed to logout'));
      }
    });
  }

  void _validateFields(String name, String model) {
    _fieldValidities['name'] = name.isNotEmpty;
    _fieldValidities['model'] = model.isNotEmpty;
    _isFormValid = _fieldValidities.values.every((isValid) => isValid);
  }

  bool get isFormValid => _isFormValid;
}
