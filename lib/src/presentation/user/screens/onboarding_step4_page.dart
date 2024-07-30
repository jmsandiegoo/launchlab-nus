import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launchlab/src/domain/user/models/accomplishment_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/user/cubits/onboarding_cubit.dart';
import 'package:launchlab/src/presentation/user/widgets/accomplishment_list.dart';
import 'package:launchlab/src/utils/constants.dart';
import 'package:launchlab/src/utils/helper.dart';

class OnboardingStep4Page extends StatelessWidget {
  const OnboardingStep4Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      // ignore: prefer_const_constructors
      builder: (context, state) => OnboardingStep4Content(),
    );
  }
}

class OnboardingStep4Content extends StatefulWidget {
  const OnboardingStep4Content({super.key});

  @override
  State<OnboardingStep4Content> createState() => _OnboardingStep4ContentState();
}

class _OnboardingStep4ContentState extends State<OnboardingStep4Content> {
  late OnboardingCubit _onboardingCubit;

  @override
  void initState() {
    super.initState();
    _onboardingCubit = BlocProvider.of<OnboardingCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        headerText("Share your accomplishments"),
        const LLBodyText(label:
            "Also, feel free to share some accomplishments you have made such as CCAs, awards etc."),
        const SizedBox(
          height: 20.0,
        ),
        AccomplishmentList(
          accomplishments: _onboardingCubit.state.accomplishmentListInput.value,
          onAddHandler: () async {
            final returnData = await navigatePush(
              context,
              "/onboard-add-accomplishment",
            );

            if (returnData == null ||
                returnData.actionType == ActionTypes.cancel) {
              return;
            }

            if (returnData.actionType == ActionTypes.create) {
              final newAccomplishments = [
                ..._onboardingCubit.state.accomplishmentListInput.value
              ];
              newAccomplishments.add(returnData.data);
              _onboardingCubit.onAccomplishmentListChanged(
                newAccomplishments,
              );
            }
          },
          onEditHandler: (acc) async {
            final NavigationData<AccomplishmentEntity>? returnData =
                await navigatePushWithData<AccomplishmentEntity>(
                    context, "/onboard-edit-accomplishment", acc);

            List<AccomplishmentEntity> newAccomplishments = [
              ..._onboardingCubit.state.accomplishmentListInput.value
            ];
            final index = newAccomplishments.indexOf(acc);

            if (returnData == null ||
                returnData.actionType == ActionTypes.cancel) {
              return;
            }

            if (returnData.actionType == ActionTypes.update) {
              newAccomplishments[index] = returnData.data!;
              _onboardingCubit.onAccomplishmentListChanged(newAccomplishments);
            }

            if (returnData.actionType == ActionTypes.delete) {
              newAccomplishments.removeAt(index);
              _onboardingCubit.onAccomplishmentListChanged(newAccomplishments);
            }
          },
        )
      ],
    );
  }
}
