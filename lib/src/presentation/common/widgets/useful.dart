import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/confirmation_box.dart';
import 'package:launchlab/src/presentation/common/widgets/text/ll_body_text.dart';

Widget userInput({
  required FocusNode focusNode,
  required void Function(String) onChangedHandler,
  required String label,
  bool obscureText = false,
  int minLines = 1,
  int maxLines = 1,
  String hint = "",
  bool isEnabled = true,
  bool isReadOnly = false,
  void Function()? onTapHandler,
  Widget? prefixWidget,
  Widget? suffixWidget,
  TextEditingController? controller,
  String? errorText,
  TextInputType keyboard = TextInputType.multiline,
  bool endSpacing = true,
  List<TextInputFormatter>? inputFormatter,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ...() {
        if (label == "") {
          return [];
        }
        return [
          Text(
            label,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(
            height: 5,
          )
        ];
      }(),
      TextField(
        enabled: isEnabled,
        readOnly: isReadOnly,
        focusNode: focusNode,
        controller: controller,
        onChanged: onChangedHandler,
        onTap: onTapHandler,
        keyboardType: maxLines > 1 ? keyboard : null,
        minLines: minLines,
        maxLines: maxLines,
        inputFormatters: inputFormatter,
        obscureText: obscureText,
        decoration: InputDecoration(
          errorText: errorText,
          prefixIcon: prefixWidget,
          suffixIcon: suffixWidget,
          hintText: hint,
          fillColor: isEnabled ? whiteColor : greyColor.shade300,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400, width: 0.25),
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          // border:
          //     OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
      endSpacing ? const SizedBox(height: 20) : const SizedBox()
    ],
  );
}

Widget userInput_2({
  label,
  focusNode,
  obsureText = false,
  controller,
  size = 1,
  hint = "",
  keyboard = TextInputType.multiline,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: blackColor),
      ),
      const SizedBox(height: 5),
      TextField(
        focusNode: focusNode,
        keyboardType: keyboard,
        minLines: size, //Normal textInputField will be displayed
        maxLines: size,
        obscureText: obsureText,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 15.0, color: greyColor),
          filled: true,
          fillColor: whiteColor,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: lightGreyColor,
            ),
          ),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
      const SizedBox(height: 30)
    ],
  );
}

Widget checkBox(String label, bool? value, bool tristate,
    void Function(bool?) onChangedHandler) {
  return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
    Checkbox(
      tristate: tristate,
      value: value,
      onChanged: onChangedHandler,
      checkColor: blackColor,
      fillColor: const WidgetStatePropertyAll(yellowColor),
      side: const BorderSide(width: 0.5),
      activeColor: whiteColor,
    ),
    LLBodyText(label: label),
  ]);
}

Widget profilePicture(
  double diameter,
  String address, {
  bool isUrl = false,
}) {
  return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: isUrl
                ? address == ''
                    ? const ExactAssetImage("assets/images/avatar_temp.png")
                    : Image.network(address).image
                : ExactAssetImage("assets/images/$address"),
            fit: BoxFit.cover,
          )));
}

Widget teamPicture(
  double size,
  String address, {
  bool isUrl = false,
}) {
  return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          // shape: BoxShape.circle,
          image: DecorationImage(
        image: isUrl
            ? address == ''
                ? const ExactAssetImage("assets/images/team_avatar_temp.png")
                : Image.network(address).image
            : ExactAssetImage("assets/images/$address"),
        fit: BoxFit.cover,
      )));
}

Widget searchBar() {
  return Flexible(
    flex: 1,
    child: TextField(
      cursorColor: greyColor,
      decoration: InputDecoration(
        fillColor: whiteColor,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        hintText: 'Search',
        hintStyle: const TextStyle(color: greyColor, fontSize: 13),
      ),
    ),
  );
}

Widget headerText(
  String label, {
  size = 25.0,
  color = blackColor,
  maxLines = 2,
  weight = FontWeight.bold,
  alignment = TextAlign.left,
  overflow = TextOverflow.ellipsis,
}) {
  return Text(
    label,
    maxLines: maxLines,
    textAlign: alignment,
    overflow: overflow,
    style: TextStyle(
        fontSize: size, fontWeight: FontWeight.bold, color: blackColor),
  );
}

Widget subHeaderText(
  String label, {
  size = 20.0,
  color = blackColor,
  maxLines = 2,
  weight = FontWeight.bold,
  alignment = TextAlign.left,
  overflow = TextOverflow.ellipsis,
}) {
  return Text(
    label,
    maxLines: maxLines,
    softWrap: true,
    overflow: TextOverflow.ellipsis,
    textAlign: alignment,
    style: TextStyle(fontSize: size, fontWeight: weight, color: color),
  );
}



Widget smallText(String label,
    {size = 13.0,
    color = blackColor,
    int? maxLines,
    fontStyle = FontStyle.normal,
    weight = FontWeight.w400,
    alignment = TextAlign.left,
    overflow = TextOverflow.ellipsis}) {
  return Text(
    label,
    maxLines: maxLines,
    textAlign: alignment,
    overflow: overflow,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontWeight: weight,
      fontStyle: fontStyle,
    ),
  );
}

Widget primaryButton(
  BuildContext context,
  Function() onPressedHandler,
  String label, {
  horizontalPadding = 30.0,
  verticalPadding = 10.0,
  double? elevation,
  bool isLoading = false,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: elevation,
      backgroundColor: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
    ),
    onPressed: () {
      if (isLoading) {
        return;
      }

      onPressedHandler();
    },
    child: isLoading
        ? SizedBox(
            height: 17,
            width: 17,
            child: CircularProgressIndicator(
                strokeWidth: 1, color: Theme.of(context).colorScheme.onPrimary),
          )
        : Text(
            label,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
  );
}

Widget secondaryButton(
  BuildContext context,
  Function() onPressedHandler,
  String label, {
  horizontalPadding = 30.0,
  verticalPadding = 10.0,
  double? elevation,
  bool isLoading = false,
  Widget? childBuilder,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: elevation,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      textStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
    ),
    onPressed: () {
      if (isLoading) {
        return;
      }
      onPressedHandler();
    },
    child: isLoading
        ? SizedBox(
            height: 17,
            width: 17,
            child: CircularProgressIndicator(
                strokeWidth: 1,
                color: Theme.of(context).colorScheme.onSecondary),
          )
        : childBuilder ??
            Text(
              label,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            ),
  );
}

Widget secondaryIconButton(
  BuildContext context,
  Function() onPressedHandler,
  IconData icon, {
  horizontalPadding = 30.0,
  verticalPadding = 10.0,
  double? elevation,
  bool isLoading = false,
  Widget? childBuilder,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: elevation,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      textStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
    ),
    onPressed: () {
      if (isLoading) {
        return;
      }
      onPressedHandler();
    },
    child: isLoading
        ? SizedBox(
            height: 17,
            width: 17,
            child: CircularProgressIndicator(
                strokeWidth: 1,
                color: Theme.of(context).colorScheme.onSecondary),
          )
        : childBuilder ??
            Icon(icon, color: Theme.of(context).colorScheme.onSecondary),
  );
}

Widget overflowText(String label,
    {size = 15.0, color = blackColor, maxLines = 3}) {
  return Text(
    label,
    maxLines: maxLines,
    softWrap: true,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(fontSize: size, color: color),
  );
}

Widget backButton() {
  return const Icon(Icons.keyboard_backspace_outlined,
      size: 30, color: blackColor);
}

Future<T?> showModalBottomSheetHandler<T>(
    BuildContext context, Widget Function(BuildContext) builder) {
  return showModalBottomSheet<T>(
      context: context, builder: builder, useRootNavigator: true);
}

Widget boldFirstText(String text1, String text2, {size = 12.5}) {
  return Row(
    children: [
      Text(text1,
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: size, fontWeight: FontWeight.bold)),
      Text(text2,
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: size)),
    ],
  );
}

Widget boldSecondText(String text1, String text2, {size = 12.0}) {
  return RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: size,
        color: Colors.black,
      ),
      children: <TextSpan>[
        TextSpan(text: text1),
        TextSpan(
            text: text2, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

Widget outerCircleBar(double progress) {
  return CircularProgressIndicator(
    strokeWidth: 3,
    backgroundColor: Colors.grey[350],
    valueColor: const AlwaysStoppedAnimation<Color>(yellowColor),
    value: progress,
  );
}

Widget circleProgressBar(current, total) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(children: [
          SizedBox(
              width: 100,
              height: 100,
              child: outerCircleBar(total == 0 ? 0 : current / total)),
          SizedBox(
            height: 100,
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                subHeaderText(
                    "${total == 0 ? 0 : (current / total * 100).round()}%",
                    size: 20.0),
                const SizedBox(height: 4),
                LLBodyText(label: '$current / $total', color: darkGreyColor, size: 12.0),
                const LLBodyText(label: "Milestones", color: darkGreyColor, size: 12.0),
              ],
            ),
          ),
        ]),
      ],
    ),
  );
}

Widget memberProfile(imgDir, name, position,
    {imgSize = 30.0, textSize = 12.0, isBold = false}) {
  return Column(children: [
    const SizedBox(height: 7),
    Row(children: [
      profilePicture(imgSize, imgDir ?? "avatar_temp.png",
          isUrl: imgDir != null ? true : false),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        isBold
            ? subHeaderText(name, size: textSize)
            : LLBodyText(label: name, size: textSize),
        LLBodyText(label: position, color: darkGreyColor, size: textSize)
      ])
    ])
  ]);
}

Widget taskBar(taskName, isChecked, checkBox) {
  return Container(
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
    child: Row(
      children: [
        checkBox,
        // task name
        Text(
          taskName,
          style: TextStyle(
            decoration:
                isChecked ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
      ],
    ),
  );
}

void confirmationBox(context, title, message, {onAccept}) {
  showDialog(
    context: context,
    builder: (context) {
      return ConfirmationBox(
        title: title,
        message: message,
        onClose: () => Navigator.pop(context),
      );
    },
  );
}

String stringToDateFormatter(date, {noDate = false}) {
  final formatter = noDate ? DateFormat('MMM yyyy') : DateFormat('dd MMM yyyy');
  return formatter.format(DateTime.parse(date));
}

String dateToDateFormatter(date, {noDate = false}) {
  String formattedDate = noDate
      ? DateFormat('MMM yyyy').format(date)
      : DateFormat('dd MMM yyyy').format(date);
  return formattedDate;
}

Widget futureBuilderFail(onReload) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(
            child: LLBodyText(label: 'Please ensure that you have internet connection')),
        ElevatedButton(onPressed: onReload, child: const LLBodyText(label: "Reload"))
      ]);
}

Widget chip<T>(label, T value, {void Function(T value)? onDeleteHandler}) {
  return Chip(
      labelPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5.0),
      label: smallText(label, size: 11.5),
      backgroundColor: Colors.transparent,
      deleteIcon: const Icon(
        Icons.close_outlined,
        size: 20.0,
        weight: 300,
      ),
      deleteIconColor: blackColor,
      onDeleted: onDeleteHandler == null ? null : () => onDeleteHandler(value),
      shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.5),
          borderRadius: BorderRadius.circular(10.0)));
}

Widget chipsWrap<T>(List<T> items, {void Function(T value)? onDeleteHandler}) {
  return Wrap(
    spacing: 5.0,
    children: items
        .map((item) =>
            chip(item.toString(), item, onDeleteHandler: onDeleteHandler))
        .toList(),
  );
}
