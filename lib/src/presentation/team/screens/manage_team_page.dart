import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/data/team/team_repository.dart';
import 'package:launchlab/src/domain/team/role_entity.dart';
import 'package:launchlab/src/domain/team/user_entity.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/presentation/team/cubits/manage_team_cubit.dart';
import 'package:launchlab/src/presentation/team/widgets/applicant_%20card.dart';
import 'package:launchlab/src/presentation/team/widgets/manage_roles_form.dart';
import 'package:launchlab/src/utils/helper.dart';

class ManageTeamPage extends StatelessWidget {
  final String teamId;

  const ManageTeamPage({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManageTeamCubit(TeamRepository()),
      child: ManageTeamContent(teamId: teamId),
    );
  }
}

class ManageTeamContent extends StatefulWidget {
  final String teamId;
  const ManageTeamContent({super.key, required this.teamId});

  @override
  State<ManageTeamContent> createState() => _ManageTeamState();
}

class _ManageTeamState extends State<ManageTeamContent> {
  late ManageTeamCubit manageTeamCubit;
  late List<RoleEntity> rolesData;
  late List<UserEntity> applicantUserData;

  @override
  void initState() {
    super.initState();
    manageTeamCubit = BlocProvider.of<ManageTeamCubit>(context);
    manageTeamCubit.getData(widget.teamId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageTeamCubit, ManageTeamState>(
        builder: (context, state) {
      if (manageTeamCubit.state.isLoaded) {
        rolesData = manageTeamCubit.state.rolesData;
        applicantUserData = manageTeamCubit.state.applicantUserData;
      }
      return manageTeamCubit.state.isLoaded
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: blackColor),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    headerText("Manage Team"),
                                    bodyText(
                                        "Create new roles and \nmanage applicants here!")
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                flex: 2,
                                child: SvgPicture.asset(
                                    'assets/images/create_team.svg'),
                              ),
                            ]),

                        const SizedBox(height: 20),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              subHeaderText("Roles"),
                              GestureDetector(
                                  onTap: () {
                                    _manageRoles("", "");
                                  },
                                  child:
                                      subHeaderText("Add Role +", size: 13.0))
                            ]),
                        for (int i = 0; i < rolesData.length; i++) ...[
                          const SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      subHeaderText(rolesData[i].title,
                                          size: 15.0),
                                      overflowText(rolesData[i].description),
                                    ])),
                                IconButton(
                                  onPressed: () {
                                    _manageRoles(rolesData[i].title,
                                        rolesData[i].description,
                                        roleId: rolesData[i].id);
                                  },
                                  icon: const Icon(Icons.edit_outlined),
                                ),
                                IconButton(
                                  onPressed: () {
                                    manageTeamCubit.deleteRoles(
                                        roleId: rolesData[i].id);
                                    refreshPage();
                                  },
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ]),
                          const SizedBox(height: 10),
                        ],
                        //Applicants
                        const SizedBox(height: 50),
                        subHeaderText('Applicants'),
                        Column(children: [
                          for (int i = 0;
                              i < applicantUserData.length;
                              i++) ...[
                            const SizedBox(height: 20),
                            GestureDetector(
                                onTap: () {
                                  navigatePushWithData(
                                          context,
                                          "/applicants",
                                          applicantUserData[i]
                                              .applicantId
                                              .toString())
                                      .then((value) {
                                    manageTeamCubit.loading();
                                    manageTeamCubit.getData(widget.teamId);
                                  });
                                },
                                child: ApplicantCard(
                                    applicantData: applicantUserData[i]))
                          ]
                        ])
                      ]),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator());
    });
  }

  void refreshPage() {
    manageTeamCubit.loading();
    manageTeamCubit.getData(widget.teamId);
  }

  void _manageRoles(title, description, {roleId = ''}) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        context: context,
        builder: (context) {
          return ManageRolesBox(
            title: title,
            description: description,
          );
        }).then((output) {
      if (output != null && roleId == '') {
        manageTeamCubit.addRoles(
            teamId: widget.teamId, title: output[0], description: output[1]);
      } else if (output != null) {
        manageTeamCubit.updateRoles(
            roleId: roleId, title: output[0], description: output[1]);
      }
      refreshPage();
    });
  }
}
