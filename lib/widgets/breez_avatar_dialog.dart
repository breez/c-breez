import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/user_profile/default_profile_generator.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/min_font_size.dart';
import 'package:c_breez/widgets/breez_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image/image.dart' as DartImage;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'flushbar.dart';

int scaledWidth = 200;
var _transparentImage = DartImage.Image(scaledWidth, scaledWidth);

Widget breezAvatarDialog(UserProfileBloc userBloc) {
  AutoSizeGroup autoSizeGroup = AutoSizeGroup();
  CroppedFile? pickedImage;
  DefaultProfile defaultProfile;
  bool isUploading = false;

  final nameInputController = TextEditingController();

  Future<CroppedFile?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    final File file = File(pickedFile!.path);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: [CropAspectRatioPreset.square],
    );
    return croppedFile;
  }

  return WillPopScope(
    onWillPop: () {
      return Future.value(!isUploading);
    },
    child: StatefulBuilder(
      builder: (context, setState) {
        final themeData = Theme.of(context);
        final queryData = MediaQuery.of(context);
        final texts = AppLocalizations.of(context)!;
        final navigator = Navigator.of(context);
        final minFontSize = MinFontSize(context);

        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          title: Stack(
            children: [
              Container(
                height: 70.0,
                decoration: ShapeDecoration(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12.0),
                    ),
                  ),
                  color: theme.themeId == "BLUE"
                      ? themeData.primaryColorDark
                      : themeData.canvasColor,
                ),
              ),
              SizedBox(
                width: queryData.size.width,
                height: 100.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(
                            bottom: 20.0,
                            top: 26.0,
                          ),
                        ),
                        child: AutoSizeText(
                          texts.breez_avatar_dialog_random,
                          style: theme.whiteButtonStyle,
                          maxLines: 1,
                          minFontSize: minFontSize.minFontSize,
                          stepGranularity: 0.1,
                          group: autoSizeGroup,
                        ),
                        onPressed: () {
                          var generated = userBloc.generateRandomProfile();
                          setState(() {
                            pickedImage = null;
                            defaultProfile = generated;
                          });
                          //userBloc.updateProfile(color: generated.color, animal: generated.animal);
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
                    BlocBuilder<UserProfileBloc, UserProfileState>(
                      builder: (context, userModel) {
                        return Stack(
                          children: [
                            isUploading
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 26.0),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          themeData
                                              .primaryTextTheme.button!.color!,
                                        ),
                                        backgroundColor:
                                            themeData.backgroundColor,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            Padding(
                              padding: const EdgeInsets.only(top: 26.0),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: BreezAvatar(
                                  pickedImage?.path ??
                                      userModel.profileSettings.avatarURL,
                                  radius: 36.0,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(
                            bottom: 20.0,
                            top: 26.0,
                          ),
                        ),
                        child: AutoSizeText(
                          texts.breez_avatar_dialog_gallery,
                          style: theme.whiteButtonStyle,
                          maxLines: 1,
                          minFontSize: minFontSize.minFontSize,
                          stepGranularity: 0.1,
                          group: autoSizeGroup,
                        ),
                        onPressed: () async {
                          await _pickImage().then((file) {
                            setState(() {
                              pickedImage = file;
                            });
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Theme(
                  data: ThemeData(
                    primaryColor: themeData.primaryTextTheme.bodyText2!.color,
                    hintColor: themeData.primaryTextTheme.bodyText2!.color,
                  ),
                  child: TextField(
                    enabled: !isUploading,
                    style: themeData.primaryTextTheme.bodyText2,
                    controller: nameInputController,
                    decoration: InputDecoration(
                      hintText: texts.breez_avatar_dialog_your_name,
                    ),
                    onSubmitted: (text) {},
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isUploading ? null : () => navigator.pop(),
              child: Text(
                texts.breez_avatar_dialog_action_cancel,
                style: themeData.primaryTextTheme.button,
              ),
            ),
            TextButton(
              onPressed: isUploading
                  ? null
                  : () async {
                      try {
                        var userName = nameInputController.text;
                        setState(() {
                          isUploading = true;
                        });
                        String url = await _uploadImage(pickedImage!, userBloc)
                            .then((u) {
                          setState(() {
                            isUploading = false;
                          });
                          return u;
                        });
                        userBloc.updateProfile(image: url);
                        userBloc.updateProfile(name: userName);
                        navigator.pop();
                      } catch (e) {
                        setState(() {
                          isUploading = false;
                          pickedImage = null;
                        });
                        showFlushbar(
                          context,
                          message: texts.breez_avatar_dialog_error_upload,
                        );
                      }
                    },
              child: Text(
                texts.breez_avatar_dialog_action_save,
                style: themeData.primaryTextTheme.button,
              ),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(12.0),
              top: Radius.circular(13.0),
            ),
          ),
        );
      },
    ),
  );
}

Future<String> _uploadImage(
    CroppedFile pickedImage, UserProfileBloc userBloc) async {
  return pickedImage
      .readAsBytes()
      .then(scaleAndFormatPNG)
      .then((imageBytes) async {
    return userBloc.uploadImage(imageBytes);
  });
}

List<int> scaleAndFormatPNG(List<int> imageBytes) {
  DartImage.Image image = DartImage.decodeImage(imageBytes)!;
  DartImage.Image resized = DartImage.copyResize(image,
      width: image.width < image.height ? -1 : scaledWidth,
      height: image.width < image.height ? scaledWidth : -1);
  DartImage.Image centered = DartImage.copyInto(_transparentImage, resized,
      dstX: ((scaledWidth - resized.width) / 2).round(),
      dstY: ((scaledWidth - resized.height) / 2).round());
  return DartImage.encodePng(centered);
}
