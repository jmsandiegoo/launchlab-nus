import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class ManageMemberBox extends StatelessWidget {
  final bool isOwner;
  final List memberData;
  final VoidCallback onClose;

  const ManageMemberBox({
    super.key,
    required this.isOwner,
    required this.memberData,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: lightGreyColor,
      content: SizedBox(
        width: 1000000,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(children: [
                  Image.asset("assets/images/yellow_curve_shape_4.png"),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 30.0),
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            subHeaderText("Team Member"),
                            SizedBox(
                                height: 35,
                                child: SvgPicture.asset(
                                    'assets/images/add_member.svg'))
                          ]),
                      for (int i = 0; i < memberData.length; i++) ...[
                        manageMemberBar(
                            memberData[i]['users']['avatar_url'],
                            "${memberData[i]['users']['first_name']} ${memberData[i]['users']['last_name']}",
                            memberData[i]['position'],
                            memberData[i]['id'],
                            context)
                      ]
                    ]),
                  ),
                ]),
                OutlinedButton(onPressed: onClose, child: bodyText("Close")),
                const SizedBox(height: 20),
              ]),
        ),
      ),
    );
  }

  Widget manageMemberBar(imgDir, name, position, memberId, context) {
    void manageMember(String value) {
      switch (value) {
        case 'Remove':
          Navigator.of(context).pop(['Delete', memberId]);
          break;
      }
    }

    return Column(children: [
      const SizedBox(height: 20),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 3,
                offset: const Offset(0, 3),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 5.0, 8.0),
          child: Column(children: [
            if (position == 'Owner') ...[
              memberProfile(imgDir, name, position,
                  imgSize: 35.0, isBold: true),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  memberProfile(imgDir, name, position,
                      imgSize: 35.0, isBold: true),
                  isOwner
                      ? PopupMenuButton<String>(
                          onSelected: manageMember,
                          itemBuilder: (BuildContext context) {
                            return {'Remove'}.map((String choice) {
                              return PopupMenuItem<String>(
                                  value: choice, child: Text(choice));
                            }).toList();
                          },
                        )
                      : const SizedBox()
                ],
              )
            ],
          ]),
        ),
      ),
    ]);
  }
}
