import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/user_profile/default_profile_generator.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/min_font_size.dart';
import 'package:c_breez/widgets/breez_avatar.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as dart_image;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class BreezAvatarDialog extends StatefulWidget {
  @override
  BreezAvatarDialogState createState() => BreezAvatarDialogState();
}

class BreezAvatarDialogState extends State<BreezAvatarDialog> {
  AutoSizeGroup autoSizeGroup = AutoSizeGroup();
  CroppedFile? pickedImage;
  String? randomAvatarPath;
  bool isUploading = false;
  final nameInputController = TextEditingController();
  late UserProfileBloc userBloc;

  @override
  void initState() {
    super.initState();
    userBloc = context.read<UserProfileBloc>();
    nameInputController.text = userBloc.state.profileSettings.name!;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(!isUploading);
      },
      child: StatefulBuilder(
        builder: (context, setState) {
          final themeData = Theme.of(context);
          final queryData = MediaQuery.of(context);
          final texts = context.texts();
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
                            final DefaultProfile randomUser =
                                generateDefaultProfile();
                            setState(() {
                              nameInputController.text =
                                  "${randomUser.color} ${randomUser.animal}";
                              randomAvatarPath =
                                  'breez://profile_image?animal=${randomUser.animal}&color=${randomUser.color}';
                              pickedImage = null;
                            });
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
                                            themeData.primaryTextTheme.button!
                                                .color!,
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
                                        randomAvatarPath ??
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
                                randomAvatarPath = null;
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
                          setState(() {
                            isUploading = true;
                          });
                          var userName = nameInputController.text.isNotEmpty
                              ? nameInputController.text
                              : userBloc.state.profileSettings.name;
                          userBloc.updateProfile(name: userName);
                          await uploadAvatar();
                          setState(() {
                            isUploading = false;
                          });
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

  Future<void> uploadAvatar() async {
    if (pickedImage != null) {
      String imageUrl = await userBloc.uploadImage(await scaleAndFormatPNG());
      userBloc.updateProfile(image: imageUrl);
    } else if (randomAvatarPath != null) {
      userBloc.updateProfile(image: randomAvatarPath);
    }
  }

  Future<List<int>> scaleAndFormatPNG() async {
    const int scaledWidth = 200;
    final dart_image.Image transparentImage =
        dart_image.Image(scaledWidth, scaledWidth);
    List<int> imageBytes = await pickedImage!.readAsBytes();
    dart_image.Image image = dart_image.decodeImage(imageBytes)!;
    dart_image.Image resized = dart_image.copyResize(image,
        width: image.width < image.height ? -1 : scaledWidth,
        height: image.width < image.height ? scaledWidth : -1);
    dart_image.Image centered = dart_image.copyInto(transparentImage, resized,
        dstX: ((scaledWidth - resized.width) / 2).round(),
        dstY: ((scaledWidth - resized.height) / 2).round());
    return dart_image.encodePng(centered);
  }
}
