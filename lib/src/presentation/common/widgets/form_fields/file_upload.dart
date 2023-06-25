import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';

class FileUploadWidget extends StatelessWidget {
  const FileUploadWidget(
      {super.key,
      required this.selectedFile,
      required this.onFileUploadChangedHandler});

  final File? selectedFile;
  final void Function(File?) onFileUploadChangedHandler;

  Future pickFile([bool isReplace = false]) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ["pdf"]);
    File? pickedFile;
    if (result != null) {
      pickedFile = File(result.files.single.path!);
    }

    if (isReplace && pickedFile == null) {
      return;
    }

    onFileUploadChangedHandler(pickedFile);
  }

  @override
  Widget build(BuildContext context) {
    if (selectedFile == null) {
      return DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(10.0),
          color: blackColor,
          child: GestureDetector(
            onTap: () {
              pickFile();
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: const Row(
                children: [
                  Icon(Icons.upload_file_outlined),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text("Tap here to select a file (.pdf)")
                ],
              ),
            ),
          ));
    }

    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(
          children: [
            const Icon(Icons.description_outlined),
            const SizedBox(
              width: 5.0,
            ),
            Expanded(
              child: Text(
                selectedFile!.path.split(Platform.pathSeparator).last,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      pickFile(true);
                    },
                    child: const Icon(Icons.edit_outlined)),
                const SizedBox(
                  width: 5.0,
                ),
                GestureDetector(
                    onTap: () {
                      onFileUploadChangedHandler(null);
                    },
                    child: const Icon(Icons.close_outlined)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
