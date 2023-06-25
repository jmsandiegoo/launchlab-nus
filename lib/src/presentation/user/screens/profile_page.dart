import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/presentation/common/cubits/app_root_cubit.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/profile_cubit.dart';
import 'package:launchlab/src/presentation/user/screens/profile_edit_preference_page.dart';
import 'package:launchlab/src/presentation/user/widgets/profile_about.dart';
import 'package:launchlab/src/presentation/user/widgets/profile_accomplishment_list.dart';
import 'package:launchlab/src/presentation/user/widgets/profile_experience_list.dart';
import 'package:launchlab/src/presentation/user/widgets/profile_header.dart';
import 'package:launchlab/src/presentation/user/widgets/profile_skills.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// own cubit for profile
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Future<void> editPreference(
      BuildContext context,
      ProfileEditPreferencePageProps props,
      void Function() onUpdateHandler) async {
    final returnData = await navigatePushWithData<Object?>(
        context, "/profile/edit-settings", props);

    if (returnData == null || returnData.actionType == ActionTypes.cancel) {
      return;
    }

    if (returnData.actionType == ActionTypes.update) {
      onUpdateHandler();
    }
  }

  @override
  Widget build(BuildContext context) {
    AppRootCubit appRootCubit = BlocProvider.of<AppRootCubit>(context);
    return BlocProvider(
      create: (_) => ProfileCubit(UserRepository(Supabase.instance))
        ..handleGetProfileInfo(appRootCubit.state.authUserProfile?.id ?? ''),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          ProfileCubit profileCubit = BlocProvider.of<ProfileCubit>(context);
          return Scaffold(
            body: SafeArea(
              child: () {
                if (state.profileStateStatus == ProfileStateStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {},
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: () {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBar(
                            backgroundColor: yellowColor,
                            centerTitle: false,
                            title: headerText("My Profile"),
                            actions: [
                              IconButton(
                                  onPressed: () {
                                    editPreference(
                                        context,
                                        ProfileEditPreferencePageProps(
                                          userPreference: state.userPreference!,
                                        ),
                                        () => profileCubit.handleGetProfileInfo(
                                            state.userProfile!.id!));
                                  },
                                  icon: const Icon(Icons.settings_outlined)),
                              IconButton(
                                onPressed: () {
                                  BlocProvider.of<AppRootCubit>(context)
                                      .handleSignOut();
                                },
                                icon: const Icon(Icons.logout_outlined,
                                    color: blackColor),
                              ),
                            ],
                          ),
                          ProfileHeader(
                            userProfile: state.userProfile!,
                            userDegreeProgramme: state.userDegreeProgramme!,
                            userAvatarUrl: state.userAvatarUrl,
                            onUpdateHandler: () => profileCubit
                                .handleGetProfileInfo(state.userProfile!.id!),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProfileAbout(
                                  userProfile: state.userProfile!,
                                  onUpdateHandler: () =>
                                      profileCubit.handleGetProfileInfo(
                                          state.userProfile!.id!),
                                ),
                                const SizedBox(height: 20),
                                ProfileExperienceList(
                                  experiences: state.userExperiences,
                                  onUpdateHandler: () =>
                                      profileCubit.handleGetProfileInfo(
                                          state.userProfile!.id!),
                                ),
                                const SizedBox(height: 20),
                                ProfileSkills(
                                  userPreference: state.userPreference!,
                                  onUpdateHandler: () =>
                                      profileCubit.handleGetProfileInfo(
                                          state.userProfile!.id!),
                                ),
                                const SizedBox(height: 20),
                                ProfileAccomplishmentList(
                                  accomplishments: state.userAccomplishments,
                                  onUpdateHandler: () =>
                                      profileCubit.handleGetProfileInfo(
                                          state.userProfile!.id!),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }(),
                  ),
                );
              }(),
            ),
          );
        },
      ),
    );
  }
}
