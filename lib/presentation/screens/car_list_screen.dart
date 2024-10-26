import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../presenters/car/car.dart';
import './widgets/widgets.dart';

class CarListScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController modelController = TextEditingController();

  CarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CarBloc>().add(GetCarsEvent());

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: CustomAppBar(
        title: 'Cars',
        onLogout: () => context.read<CarBloc>().add(LogoutEvent()),
        showArrow: false,
      ),
      body: BlocListener<CarBloc, CarState>(
        listener: (context, state) {
          if (state is CarLogoutSuccess) {
            context.go('/');
          }
        },
        child: BlocBuilder<CarBloc, CarState>(
          buildWhen: (previous, current) =>
              current.runtimeType != CarValidationState,
          builder: (context, state) {
            if (state is CarLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CarFailure) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state is CarSuccess) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.cars.length,
                itemBuilder: (context, index) {
                  final car = state.cars[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        car.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(car.model,
                          style: Theme.of(context).textTheme.bodyMedium),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon:
                                const Icon(Icons.edit, color: Colors.blueGrey),
                            onPressed: () {
                              nameController.text = car.name;
                              modelController.text = car.model;

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Update Car'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        BlocBuilder<CarBloc, CarState>(
                                          builder: (context, state) {
                                            final isNameValid =
                                                state is CarValidationState &&
                                                    (state.fieldValidities[
                                                            'name'] ??
                                                        true);
                                            final isModelValid =
                                                state is CarValidationState &&
                                                    (state.fieldValidities[
                                                            'model'] ??
                                                        true);

                                            return Column(
                                              children: [
                                                CustomTextField(
                                                  controller: nameController,
                                                  label: 'Car Name',
                                                  icon: Icons.directions_car,
                                                  errorText: isNameValid
                                                      ? null
                                                      : 'Car name is required',
                                                  onChanged: (value) =>
                                                      _updateValidation(
                                                          context),
                                                ),
                                                const SizedBox(height: 10),
                                                CustomTextField(
                                                  controller: modelController,
                                                  label: 'Car Model',
                                                  icon: Icons.model_training,
                                                  errorText: isModelValid
                                                      ? null
                                                      : 'Car model is required',
                                                  onChanged: (value) =>
                                                      _updateValidation(
                                                          context),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      BlocBuilder<CarBloc, CarState>(
                                        builder: (context, carState) {
                                          final isFormValid =
                                              carState is CarValidationState &&
                                                  carState.isFormValid;
                                          return DialogActionButton(
                                            text: 'Update',
                                            onPressed: isFormValid
                                                ? () {
                                                    context.read<CarBloc>().add(
                                                          UpdateCarEvent(
                                                            car.id,
                                                            nameController.text,
                                                            modelController
                                                                .text,
                                                          ),
                                                        );
                                                    context.pop();
                                                  }
                                                : null,
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context
                                  .read<CarBloc>()
                                  .add(DeleteCarEvent(car.id));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('No cars found.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 164, 221, 248),
        onPressed: () {
          nameController.clear();
          modelController.clear();
          context
              .read<CarBloc>()
              .add(const CarValidationEvent(name: '', model: ''));

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Car'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocBuilder<CarBloc, CarState>(
                      builder: (context, state) {
                        final isNameValid = state is CarValidationState &&
                            (state.fieldValidities['name'] ?? true);
                        final isModelValid = state is CarValidationState &&
                            (state.fieldValidities['model'] ?? true);

                        return Column(
                          children: [
                            CustomTextField(
                              controller: nameController,
                              label: 'Car Name',
                              icon: Icons.directions_car,
                              errorText:
                                  isNameValid ? null : 'Car name is required',
                              onChanged: (value) => _updateValidation(context),
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: modelController,
                              label: 'Car Model',
                              icon: Icons.model_training,
                              errorText:
                                  isModelValid ? null : 'Car model is required',
                              onChanged: (value) => _updateValidation(context),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                actions: [
                  BlocBuilder<CarBloc, CarState>(
                    builder: (context, carState) {
                      final isFormValid = carState is CarValidationState &&
                          carState.isFormValid;
                      return DialogActionButton(
                        text: 'Add',
                        onPressed: isFormValid
                            ? () {
                                context.read<CarBloc>().add(
                                      AddCarEvent(
                                        nameController.text,
                                        modelController.text,
                                      ),
                                    );
                                Navigator.of(context).pop();
                              }
                            : null,
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _updateValidation(BuildContext context) {
    context.read<CarBloc>().add(CarValidationEvent(
          name: nameController.text,
          model: modelController.text,
        ));
  }
}
