import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:launchlab/src/data/common/common_repository.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/common/models/category_entity.dart';
import 'package:launchlab/src/domain/common/models/skill_entity.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/domain/user/models/degree_programme_entity.dart';
import 'package:launchlab/src/domain/user/models/experience_entity.dart';
import 'package:launchlab/src/domain/user/models/requests/onboard_user_request.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/picture_upload_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/form_fields/text_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/accomplishments_list_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/degree_programme_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/experience_list_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_preferred_category_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_resume_field.dart';
import 'package:launchlab/src/presentation/user/widgets/form_fields/user_skills_interests_field.dart';

@immutable
class OnboardingState extends Equatable {
  const OnboardingState({
    this.steps = 4,
    this.currStep = 1,
    this.onboardingStatus,
    this.pictureUploadPickerInput =
        const PictureUploadPickerInput.unvalidated(),
    this.firstNameInput = const TextFieldInput.unvalidated(),
    this.lastNameInput = const TextFieldInput.unvalidated(),
    this.titleInput = const TextFieldInput.unvalidated(),
    this.degreeProgrammeInput = const DegreeProgrammeFieldInput.unvalidated(),
    this.degreeProgrammeOptions = const [],
    this.aboutInput = const TextFieldInput.unvalidated(),
    this.userSkillsInterestsInput =
        const UserSkillsInterestsFieldInput.unvalidated(),
    this.skillInterestOptions = const [],
    this.userPreferredCategoryInput =
        const UserPreferredCategoryFieldInput.unvalidated(),
    this.categoryOptions = const [],
    this.userResumeInput = const UserResumeFieldInput.unvalidated(),
    this.experienceListInput = const ExperienceListFieldInput.unvalidated(),
    this.accomplishmentListInput =
        const AccomplishmentListFieldInput.unvalidated(),
  });

  // ====================================================================
  // Onboarding general states
  // ====================================================================

  final int steps;
  final int currStep;
  final OnboardingStatus? onboardingStatus;

  // ====================================================================
  // STEP 1 Input states
  // ====================================================================

  final PictureUploadPickerInput pictureUploadPickerInput;
  final TextFieldInput firstNameInput;
  final TextFieldInput lastNameInput;
  final TextFieldInput titleInput;
  final DegreeProgrammeFieldInput degreeProgrammeInput;
  final TextFieldInput aboutInput;

  final List<DegreeProgrammeEntity> degreeProgrammeOptions;
  // ====================================================================
  // STEP 2 Input states
  // ====================================================================

  final UserSkillsInterestsFieldInput userSkillsInterestsInput;
  final UserPreferredCategoryFieldInput userPreferredCategoryInput;

  final List<SkillEntity> skillInterestOptions;
  final List<CategoryEntity> categoryOptions;

  // ====================================================================
  // STEP 3 Input states
  // ====================================================================

  final UserResumeFieldInput userResumeInput;
  final ExperienceListFieldInput experienceListInput;

  // ====================================================================
  // STEP 4 Input states
  // ====================================================================

  final AccomplishmentListFieldInput accomplishmentListInput;

  // ====================================================================
  // others
  // ====================================================================

  OnboardingState copyWith({
    int? steps,
    int? currStep,
    OnboardingStatus? onboardingStatus,
    PictureUploadPickerInput? pictureUploadPickerInput,
    TextFieldInput? firstNameInput,
    TextFieldInput? lastNameInput,
    TextFieldInput? titleInput,
    DegreeProgrammeFieldInput? degreeProgrammeInput,
    List<DegreeProgrammeEntity>? degreeProgrammeOptions,
    TextFieldInput? aboutInput,
    UserSkillsInterestsFieldInput? userSkillsInterestsInput,
    List<SkillEntity>? skillInterestOptions,
    UserPreferredCategoryFieldInput? userPreferredCategoryInput,
    List<CategoryEntity>? categoryOptions,
    UserResumeFieldInput? userResumeInput,
    ExperienceListFieldInput? experienceListInput,
    AccomplishmentListFieldInput? accomplishmentListInput,
  }) {
    return OnboardingState(
      steps: steps ?? this.steps,
      currStep: currStep ?? this.currStep,
      onboardingStatus: onboardingStatus,
      pictureUploadPickerInput:
          pictureUploadPickerInput ?? this.pictureUploadPickerInput,
      firstNameInput: firstNameInput ?? this.firstNameInput,
      lastNameInput: lastNameInput ?? this.lastNameInput,
      titleInput: titleInput ?? this.titleInput,
      degreeProgrammeInput: degreeProgrammeInput ?? this.degreeProgrammeInput,
      degreeProgrammeOptions:
          degreeProgrammeOptions ?? this.degreeProgrammeOptions,
      aboutInput: aboutInput ?? this.aboutInput,
      userSkillsInterestsInput:
          userSkillsInterestsInput ?? this.userSkillsInterestsInput,
      skillInterestOptions: skillInterestOptions ?? this.skillInterestOptions,
      userPreferredCategoryInput:
          userPreferredCategoryInput ?? this.userPreferredCategoryInput,
      categoryOptions: categoryOptions ?? this.categoryOptions,
      userResumeInput: userResumeInput ?? this.userResumeInput,
      experienceListInput: experienceListInput ?? this.experienceListInput,
      accomplishmentListInput:
          accomplishmentListInput ?? this.accomplishmentListInput,
    );
  }

  @override
  List<Object?> get props => [
        steps,
        currStep,
        onboardingStatus,
        pictureUploadPickerInput,
        firstNameInput,
        lastNameInput,
        titleInput,
        degreeProgrammeInput,
        degreeProgrammeOptions,
        aboutInput,
        userSkillsInterestsInput,
        skillInterestOptions,
        userPreferredCategoryInput,
        categoryOptions,
        userResumeInput,
        experienceListInput,
        accomplishmentListInput,
      ];
}

enum OnboardingStatus {
  initializing,
  prevPage,
  nextPage,
  submissionInProgress,
  submissionSuccess,
  submissionError,
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._commonRepository, this._userRepository)
      : super(const OnboardingState());

  final CommonRepository _commonRepository;
  final UserRepository _userRepository;

  // ====================================================================
  // STEP 1 Input handlers
  // ====================================================================

  Future<void> handleGetDegreeProgrammes(String? filter) async {
    // call api
    try {
      final List<DegreeProgrammeEntity> degreeProgrammeOptions =
          await _userRepository.getDegreeProgrammes(filter);

      emit(state.copyWith(degreeProgrammeOptions: degreeProgrammeOptions));
    } on Exception catch (error) {
      print(error);
    }
  }

  void onPictureUploadChanged(File? image) {
    final prevState = state;
    final prevPictureUploadPickerInputState =
        prevState.pictureUploadPickerInput;

    final shouldValidate = prevPictureUploadPickerInputState.isNotValid;

    final newPictureUploadPickerInputState = shouldValidate
        ? PictureUploadPickerInput.validated(image)
        : PictureUploadPickerInput.unvalidated(image);

    final newState = state.copyWith(
      pictureUploadPickerInput: newPictureUploadPickerInputState,
      onboardingStatus: null,
    );

    emit(newState);
  }

  void onFirstNameChanged(String val) {
    final prevState = state;
    final prevFirstNameInputState = prevState.firstNameInput;

    final shouldValidate = prevFirstNameInputState.isNotValid;

    final newFirstNameInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(
      firstNameInput: newFirstNameInputState,
      onboardingStatus: null,
    );

    emit(newState);
  }

  void onFirstNameUnfocused() {
    final prevState = state;
    final prevFirstNameInputState = prevState.firstNameInput;
    final prevFirstNameInputVal = prevFirstNameInputState.value;

    final newFirstNameInputState =
        TextFieldInput.validated(prevFirstNameInputVal);

    final newState = prevState.copyWith(
      firstNameInput: newFirstNameInputState,
      onboardingStatus: null,
    );

    emit(newState);
  }

  void onLastNameChanged(String val) {
    final prevState = state;
    final prevLastNameInputState = prevState.lastNameInput;

    final shouldValidate = prevLastNameInputState.isNotValid;

    final newLastNameInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(
      lastNameInput: newLastNameInputState,
      onboardingStatus: null,
    );

    emit(newState);
  }

  void onLastNameUnfocused() {
    final prevState = state;
    final prevLastNameInputState = prevState.lastNameInput;
    final prevLastNameInputVal = prevLastNameInputState.value;

    final newLastNameInputState =
        TextFieldInput.validated(prevLastNameInputVal);

    final newState = prevState.copyWith(
      lastNameInput: newLastNameInputState,
      onboardingStatus: null,
    );
    emit(newState);
  }

  void onTitleChanged(String val) {
    final prevState = state;
    final prevTitleInputState = prevState.titleInput;

    final shouldValidate = prevTitleInputState.isNotValid;

    final newTitleInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(
      titleInput: newTitleInputState,
      onboardingStatus: null,
    );

    emit(newState);
  }

  void onTitleUnfocused() {
    final prevState = state;
    final prevTitleInputState = prevState.titleInput;
    final prevTitleInputVal = prevTitleInputState.value;

    final newTitleInputState = TextFieldInput.validated(prevTitleInputVal);

    final newState = prevState.copyWith(
      titleInput: newTitleInputState,
      onboardingStatus: null,
    );

    emit(newState);
  }

  void onDegreeProgrammeChanged(DegreeProgrammeEntity? val) {
    final prevState = state;
    final prevDegreeProgrammeInputState = prevState.degreeProgrammeInput;

    final shouldValidate = prevDegreeProgrammeInputState.isNotValid;

    final newDegreeProgrammeInputState = shouldValidate
        ? DegreeProgrammeFieldInput.validated(val)
        : DegreeProgrammeFieldInput.unvalidated(val);

    final newState = state.copyWith(
      degreeProgrammeInput: newDegreeProgrammeInputState,
      onboardingStatus: null,
    );

    emit(newState);
  }

  void onAboutChanged(String val) {
    final prevState = state;
    final prevAboutInputState = prevState.aboutInput;

    final shouldValidate = prevAboutInputState.isNotValid;

    final newAboutInputState = shouldValidate
        ? TextFieldInput.validated(val)
        : TextFieldInput.unvalidated(val);

    final newState = state.copyWith(
      aboutInput: newAboutInputState,
      onboardingStatus: null,
    );

    emit(newState);
  }

  void onAboutUnfocused() {
    final prevState = state;
    final prevAboutInputState = prevState.aboutInput;
    final prevAboutInputVal = prevAboutInputState.value;

    final newAboutInputState = TextFieldInput.validated(prevAboutInputVal);

    final newState = prevState.copyWith(
      aboutInput: newAboutInputState,
      onboardingStatus: null,
    );

    emit(newState);
  }

  // ====================================================================
  // STEP 2 Input handlers
  // ====================================================================

  Future<void> handleGetSkillsInterests(String? filter) async {
    try {
      final List<SkillEntity> skillInterestOptions =
          await _commonRepository.getSkillsInterestsFromEmsi(filter);

      emit(state.copyWith(skillInterestOptions: skillInterestOptions));
    } on Exception catch (error) {
      print(error);
    }
  }

  void onUserSkillsInterestsChanged(List<SkillEntity> val) {
    final newUserSkillsInterestsInputState =
        UserSkillsInterestsFieldInput.validated(val);

    final newState = state.copyWith(
      userSkillsInterestsInput: newUserSkillsInterestsInputState,
      onboardingStatus: null,
    );

    emit(newState);
  }

  void onUserPreferredCategoryChanged(List<CategoryEntity> val) {
    final newUserPreferredCategoryInputState =
        UserPreferredCategoryFieldInput.validated(val);

    final newState = state.copyWith(
      userPreferredCategoryInput: newUserPreferredCategoryInputState,
      onboardingStatus: null,
    );

    emit(newState);
  }

  // ====================================================================
  // STEP 3 Input handlers
  // ====================================================================

  void onUserResumeChanged(File? val) {
    final newUserResumeInputState = UserResumeFieldInput.validated(val);

    final newState = state.copyWith(
        userResumeInput: newUserResumeInputState, onboardingStatus: null);

    emit(newState);
  }

  void onExperienceListChanged(List<ExperienceEntity> val) {
    final newExperienceListInputState = ExperienceListFieldInput.validated(val);

    final newState = state.copyWith(
      experienceListInput: newExperienceListInputState,
      onboardingStatus: null,
    );

    emit(newState);
  }

  // ====================================================================
  // STEP 4 Input handlers
  // ====================================================================

  void onAccomplishmentListChanged(List<AccomplishmentEntity> val) {
    final newAccomplishmentListInputState =
        AccomplishmentListFieldInput.validated(val);

    final newState = state.copyWith(
      accomplishmentListInput: newAccomplishmentListInputState,
      onboardingStatus: null,
    );

    emit(newState);
  }

  // ====================================================================
  // General handlers
  // ====================================================================

  Future<void> handleInitializeForm() async {
    try {
      emit(state.copyWith(onboardingStatus: OnboardingStatus.initializing));
      // loading state
      final List<CategoryEntity> categoryOptions =
          await _commonRepository.getCategories();

      emit(state.copyWith(
        categoryOptions: categoryOptions,
        currStep: 1,
        onboardingStatus: OnboardingStatus.nextPage,
      ));
      // not loading state
    } on Exception catch (error) {
      print("error occured ${error}");
    } finally {
      emit(state.copyWith(onboardingStatus: null));
    }
  }

  Future<void> handleNextStep(UserEntity user) async {
    if (state.onboardingStatus == OnboardingStatus.initializing ||
        state.onboardingStatus == OnboardingStatus.submissionInProgress) {
      return;
    }

    if (state.currStep == 1) {
      final pictureUploadPickerInput = PictureUploadPickerInput.validated(
          state.pictureUploadPickerInput.value);
      final firstNameInput =
          TextFieldInput.validated(state.firstNameInput.value);
      final lastNameInput = TextFieldInput.validated(state.lastNameInput.value);
      final titleInput = TextFieldInput.validated(state.titleInput.value);
      final degreeProgrammeInput =
          DegreeProgrammeFieldInput.validated(state.degreeProgrammeInput.value);
      final aboutInput = TextFieldInput.validated(state.aboutInput.value);

      final isFormValid = Formz.validate([
        pictureUploadPickerInput,
        firstNameInput,
        lastNameInput,
        titleInput,
        degreeProgrammeInput,
        aboutInput,
      ]);

      if (isFormValid) {
        emit(state.copyWith(
            onboardingStatus: OnboardingStatus.nextPage,
            currStep: state.currStep + 1));
      } else {
        emit(state.copyWith(
          pictureUploadPickerInput: pictureUploadPickerInput,
          firstNameInput: firstNameInput,
          lastNameInput: lastNameInput,
          titleInput: titleInput,
          degreeProgrammeInput: degreeProgrammeInput,
          aboutInput: aboutInput,
        ));
      }
    } else if (state.currStep == 2) {
      final userSkillsInterestsInput = UserSkillsInterestsFieldInput.validated(
          state.userSkillsInterestsInput.value);
      final userPreferredCategoryInput =
          UserPreferredCategoryFieldInput.validated(
              state.userPreferredCategoryInput.value);

      final isFormValid = Formz.validate([
        userSkillsInterestsInput,
        userPreferredCategoryInput,
      ]);

      if (isFormValid) {
        emit(state.copyWith(
            onboardingStatus: OnboardingStatus.nextPage,
            currStep: state.currStep + 1));
      } else {
        emit(state.copyWith(
          userSkillsInterestsInput: userSkillsInterestsInput,
          userPreferredCategoryInput: userPreferredCategoryInput,
        ));
      }
    } else if (state.currStep == 3) {
      final userResumeInput =
          UserResumeFieldInput.validated(state.userResumeInput.value);
      final experienceListInput =
          ExperienceListFieldInput.validated(state.experienceListInput.value);

      final isFormValid = Formz.validate([
        userResumeInput,
        experienceListInput,
      ]);

      if (isFormValid) {
        emit(
          state.copyWith(
              onboardingStatus: OnboardingStatus.nextPage,
              currStep: state.currStep + 1),
        );
      } else {
        emit(state.copyWith(
          userResumeInput: userResumeInput,
          experienceListInput: experienceListInput,
        ));
      }
    } else {
      final accomplishmentListInput = AccomplishmentListFieldInput.validated(
          state.accomplishmentListInput.value);

      final isFormValid = Formz.validate([
        accomplishmentListInput,
      ]);

      if (!isFormValid) {
        return;
      }

      await handleSubmit(user);
    }
  }

  Future<void> handleSubmit(UserEntity user) async {
    emit(state.copyWith(
      onboardingStatus: OnboardingStatus.submissionInProgress,
    ));
    final OnboardUserRequest request = OnboardUserRequest(
      userAvatar: state.pictureUploadPickerInput.value,
      userResume: state.userResumeInput.value,
      user: user.copyWith(
        firstName: state.firstNameInput.value,
        lastName: state.lastNameInput.value,
        title: state.titleInput.value,
        degreeProgrammeId: state.degreeProgrammeInput.value?.id,
        about: state.aboutInput.value,
      ),
      selectedSkills: state.userSkillsInterestsInput.value,
      selectedCategories: state.userPreferredCategoryInput.value,
      experiences: state.experienceListInput.value,
      accomplishments: state.accomplishmentListInput.value,
    );
    try {
      print("request: $request");
      await _userRepository.onboardUser(request: request);
      emit(state.copyWith(
        onboardingStatus: OnboardingStatus.submissionSuccess,
      ));
    } on Exception catch (error) {
      print(error);
      emit(state.copyWith(
        onboardingStatus: OnboardingStatus.submissionError,
      ));
    }
  }

  Future<void> handleSkip(UserEntity user) async {
    if (state.currStep < 3 ||
        state.currStep > 4 ||
        state.onboardingStatus == OnboardingStatus.initializing ||
        state.onboardingStatus == OnboardingStatus.submissionInProgress) {
      return;
    }

    if (state.currStep == 3) {
      emit(state.copyWith(
          userResumeInput: const UserResumeFieldInput.validated(),
          experienceListInput: const ExperienceListFieldInput.validated(),
          onboardingStatus: OnboardingStatus.nextPage,
          currStep: state.currStep + 1));
    } else {
      emit(state.copyWith(
        accomplishmentListInput: const AccomplishmentListFieldInput.validated(),
      ));
      await handleSubmit(user);
    }
  }

  void handlePrevStep() {
    if (state.currStep <= 0 ||
        state.onboardingStatus == OnboardingStatus.initializing ||
        state.onboardingStatus == OnboardingStatus.submissionInProgress) {
      return;
    }
    emit(state.copyWith(
      onboardingStatus: OnboardingStatus.prevPage,
      currStep: state.currStep - 1,
    ));
  }
}
