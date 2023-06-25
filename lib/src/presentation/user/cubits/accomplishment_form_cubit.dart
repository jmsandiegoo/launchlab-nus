import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/checkbox_field.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/end_date_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/start_date_field.dart';

@immutable
class AccomplishmentFormState extends Equatable {
  const AccomplishmentFormState({
    this.titleNameFieldInput = const TextFieldInput.unvalidated(),
    this.issuerFieldInput = const TextFieldInput.unvalidated(),
    this.isActiveFieldInput = const CheckboxFieldInput.unvalidated(),
    this.startDateFieldInput = const StartDateFieldInput.unvalidated(),
    this.endDateFieldInput = const EndDateFieldInput.unvalidated(),
    this.descriptionFieldInput = const TextFieldInput.unvalidated(),
  });

  final TextFieldInput titleNameFieldInput;
  final TextFieldInput issuerFieldInput;
  final CheckboxFieldInput isActiveFieldInput;
  final StartDateFieldInput startDateFieldInput;
  final EndDateFieldInput endDateFieldInput;
  final TextFieldInput descriptionFieldInput;

  AccomplishmentFormState copyWith({
    TextFieldInput? titleNameFieldInput,
    TextFieldInput? issuerFieldInput,
    CheckboxFieldInput? isActiveFieldInput,
    StartDateFieldInput? startDateFieldInput,
    EndDateFieldInput? endDateFieldInput,
    TextFieldInput? descriptionFieldInput,
  }) {
    return AccomplishmentFormState(
      titleNameFieldInput: titleNameFieldInput ?? this.titleNameFieldInput,
      issuerFieldInput: issuerFieldInput ?? this.issuerFieldInput,
      isActiveFieldInput: isActiveFieldInput ?? this.isActiveFieldInput,
      startDateFieldInput: startDateFieldInput ?? this.startDateFieldInput,
      endDateFieldInput: endDateFieldInput ?? this.endDateFieldInput,
      descriptionFieldInput:
          descriptionFieldInput ?? this.descriptionFieldInput,
    );
  }

  @override
  List<Object?> get props => [
        titleNameFieldInput,
        issuerFieldInput,
        isActiveFieldInput,
        startDateFieldInput,
        endDateFieldInput,
        descriptionFieldInput,
      ];
}

class AccomplishmentFormCubit extends Cubit<AccomplishmentFormState> {
  AccomplishmentFormCubit() : super(const AccomplishmentFormState());
  AccomplishmentFormCubit.withDefaultValue(
      {required AccomplishmentEntity accomplishment})
      : super(
          AccomplishmentFormState(
            titleNameFieldInput:
                TextFieldInput.unvalidated(accomplishment.title),
            issuerFieldInput: TextFieldInput.unvalidated(accomplishment.issuer),
            isActiveFieldInput:
                CheckboxFieldInput.unvalidated(accomplishment.isActive),
            startDateFieldInput:
                StartDateFieldInput.unvalidated(accomplishment.startDate),
            endDateFieldInput:
                EndDateFieldInput.unvalidated(value: accomplishment.endDate),
            descriptionFieldInput: accomplishment.description != null
                ? TextFieldInput.unvalidated(accomplishment.description!)
                : const TextFieldInput.unvalidated(),
          ),
        );

  void onTitleNameChanged(String val) {
    final prevState = state;
    final prevTitleNameFieldInputState = prevState.titleNameFieldInput;

    final shouldValidate = prevTitleNameFieldInputState.isNotValid;

    final newTitleNameFieldInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(
      titleNameFieldInput: newTitleNameFieldInputState,
    );

    emit(newState);
  }

  void onTitleNameUnfocused() {
    final prevState = state;
    final prevTitleNameFieldInputState = prevState.titleNameFieldInput;
    final prevTitleNameFieldInputVal = prevTitleNameFieldInputState.value;

    final newTitleNameFieldInputState =
        TextFieldInput.validated(prevTitleNameFieldInputVal);

    final newState = prevState.copyWith(
      titleNameFieldInput: newTitleNameFieldInputState,
    );

    emit(newState);
  }

  void onIssuerChanged(String val) {
    final prevState = state;
    final prevIssuerFieldInputState = prevState.issuerFieldInput;

    final shouldValidate = prevIssuerFieldInputState.isNotValid;

    final newIssuerFieldInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(
      issuerFieldInput: newIssuerFieldInputState,
    );

    emit(newState);
  }

  void onIssuerUnfocused() {
    final prevState = state;
    final prevIssuerFieldInputState = prevState.issuerFieldInput;
    final prevIssuerFieldInputVal = prevIssuerFieldInputState.value;

    final newIssuerFieldInputState =
        TextFieldInput.validated(prevIssuerFieldInputVal);

    final newState = prevState.copyWith(
      issuerFieldInput: newIssuerFieldInputState,
    );

    emit(newState);
  }

  void onIsActiveChanged(bool val) {
    final prevState = state;

    final newIsActiveFieldInputState = CheckboxFieldInput.validated(val);

    final prevEndDateFieldInputState = prevState.endDateFieldInput;

    final newEndDateFieldInputState = EndDateFieldInput.unvalidated(
        isPresent: val, value: val ? null : prevEndDateFieldInputState.value);

    final newState = state.copyWith(
      isActiveFieldInput: newIsActiveFieldInputState,
      endDateFieldInput: newEndDateFieldInputState,
    );

    emit(newState);
  }

  void onStartDateChanged(DateTime? val) {
    final prevState = state;

    final newStartDateFieldInputState = StartDateFieldInput.validated(val);

    final newEndDateFieldInputState = EndDateFieldInput.validated(
      isPresent: prevState.isActiveFieldInput.value,
      startDateFieldVal: val,
      value: prevState.endDateFieldInput.value,
    );

    final newState = state.copyWith(
      startDateFieldInput: newStartDateFieldInputState,
      endDateFieldInput: newEndDateFieldInputState,
    );

    emit(newState);
  }

  void onEndDateChanged(DateTime? val) {
    final newEndDateFieldInputState = EndDateFieldInput.validated(
        isPresent: state.isActiveFieldInput.value,
        startDateFieldVal: state.startDateFieldInput.value,
        value: val);

    final newState = state.copyWith(
      endDateFieldInput: newEndDateFieldInputState,
    );

    emit(newState);
  }

  void onDescriptionChanged(String val) {
    final prevState = state;
    final prevDescriptionFieldInputState = prevState.descriptionFieldInput;

    final shouldValidate = prevDescriptionFieldInputState.isNotValid;

    final newDescriptionFieldInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(
      descriptionFieldInput: newDescriptionFieldInputState,
    );

    emit(newState);
  }

  void onDescriptionUnfocused() {
    final prevState = state;
    final prevDescriptionFieldInputState = prevState.descriptionFieldInput;
    final prevDescriptionFieldInputVal = prevDescriptionFieldInputState.value;

    final newDescriptionFieldInputState =
        TextFieldInput.validated(prevDescriptionFieldInputVal);

    final newState = prevState.copyWith(
      descriptionFieldInput: newDescriptionFieldInputState,
    );

    emit(newState);
  }

  bool validateForm() {
    final titleNameFieldInput =
        TextFieldInput.validated(state.titleNameFieldInput.value);
    final issuerFieldInput =
        TextFieldInput.validated(state.issuerFieldInput.value);
    final CheckboxFieldInput isActiveFieldInput =
        CheckboxFieldInput.validated(state.isActiveFieldInput.value);
    final StartDateFieldInput startDateFieldInput =
        StartDateFieldInput.validated(state.startDateFieldInput.value);
    final EndDateFieldInput endDateFieldInput = EndDateFieldInput.validated(
      isPresent: state.isActiveFieldInput.value,
      startDateFieldVal: state.startDateFieldInput.value,
      value: state.endDateFieldInput.value,
    );
    final TextFieldInput descriptionFieldInput =
        TextFieldInput.validated(state.descriptionFieldInput.value);

    final isFormValid = Formz.validate([
      titleNameFieldInput,
      issuerFieldInput,
      isActiveFieldInput,
      startDateFieldInput,
      endDateFieldInput,
      descriptionFieldInput,
    ]);

    emit(state.copyWith(
      titleNameFieldInput: titleNameFieldInput,
      issuerFieldInput: issuerFieldInput,
      isActiveFieldInput: isActiveFieldInput,
      endDateFieldInput: endDateFieldInput,
      descriptionFieldInput: descriptionFieldInput,
    ));

    return isFormValid;
  }
}
