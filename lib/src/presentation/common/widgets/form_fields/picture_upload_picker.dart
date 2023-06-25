import 'dart:io';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/modal_bottom_buttons_widget.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/helper.dart';

class PictureUploadPickerInput
    extends FormzInput<File?, PictureUploadPickerError> {
  const PictureUploadPickerInput.unvalidated([File? value]) : super.pure(value);
  const PictureUploadPickerInput.validated([File? value]) : super.dirty(value);

  @override
  PictureUploadPickerError? validator(File? value) {
    return null;
  }
}

enum PictureUploadPickerError { invalid }

class PictureUploadPickerWidget extends StatelessWidget {
  const PictureUploadPickerWidget(
      {super.key,
      required this.onPictureUploadChangedHandler,
      this.image,
      this.imageURL = '',
      this.isTeam = false});

  final void Function(File?) onPictureUploadChangedHandler;
  final File? image;
  final String? imageURL;
  final bool isTeam;

  Future pickImage(ImagePicker picker, ImageSource source) async {
    XFile? pickedImageXFile = await picker.pickImage(source: source);
    File? pickedImageFile = convertToFile(pickedImageXFile);
    onPictureUploadChangedHandler(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();
    return GestureDetector(
      onTap: () {
        showModalBottomSheetHandler(
          context,
          (context) => ModalBottomButtonsWidget(
            buttons: [
              ModalBottomButton(
                icon: Icons.photo_camera_outlined,
                label: "Camera",
                onPressHandler: () {
                  pickImage(picker, ImageSource.camera);
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              ModalBottomButton(
                icon: Icons.photo_outlined,
                label: "Photo",
                onPressHandler: () {
                  pickImage(picker, ImageSource.gallery);
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          ),
        );
      },
      child: CircleAvatar(
          radius: 50.0,
          backgroundImage: image != null ? FileImage(image!) : null,
          child: image == null
              ? imageURL == ''
                  ? isTeam
                      ? Image.asset("assets/images/team_avatar_temp.jpeg")
                      : Image.asset("assets/images/avatar_temp.png")
                  : Image.network(imageURL!)
              : null),
    );
  }
}
