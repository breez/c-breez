import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/user_profile/default_profile_generator.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
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
  late UserProfileBloc userBloc;
  final nameInputController = TextEditingController();
  final AutoSizeGroup autoSizeGroup = AutoSizeGroup();
  CroppedFile? pickedImage;
  String? randomAvatarPath;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    userBloc = context.read<UserProfileBloc>();
    nameInputController.text = userBloc.state.profileSettings.name ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(!isUploading),
      child: StatefulBuilder(
        builder: (context, setState) {
          final texts = context.texts();
          final themeData = Theme.of(context);
          final navigator = Navigator.of(context);
          final queryData = MediaQuery.of(context);

          return AlertDialog(
            titlePadding: const EdgeInsets.all(0.0),
            title: Stack(
              children: [
                const TitleBackground(),
                SizedBox(
                  width: queryData.size.width,
                  height: 100.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RandomButton(onPressed: generateRandomProfile),
                      AvatarPreview(
                        isUploading: isUploading,
                        pickedImage: pickedImage,
                        randomAvatarPath: randomAvatarPath,
                      ),
                      GalleryButton(onPressed: pickImageFromGallery),
                    ],
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Theme(
                data: ThemeData(
                  primaryColor: themeData.primaryTextTheme.bodyMedium!.color,
                  hintColor: themeData.primaryTextTheme.bodyMedium!.color,
                ),
                child: TextField(
                  enabled: !isUploading,
                  style: themeData.primaryTextTheme.bodyMedium,
                  controller: nameInputController,
                  decoration: InputDecoration(
                    hintText: texts.breez_avatar_dialog_your_name,
                  ),
                  onSubmitted: (text) {},
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isUploading ? null : () => navigator.pop(),
                child: Text(
                  texts.breez_avatar_dialog_action_cancel,
                  style: themeData.primaryTextTheme.labelLarge,
                ),
              ),
              TextButton(
                onPressed: isUploading
                    ? null
                    : () async {
                        await saveAvatarChanges();
                      },
                child: Text(
                  texts.breez_avatar_dialog_action_save,
                  style: themeData.primaryTextTheme.labelLarge,
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

  Future<void> saveAvatarChanges() async {
    final navigator = Navigator.of(context);
    final texts = context.texts();
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
  }

  void generateRandomProfile() {
    final DefaultProfile randomUser = generateDefaultProfile();
    setState(() {
      nameInputController.text = "${randomUser.color} ${randomUser.animal}";
      randomAvatarPath = 'breez://profile_image?animal=${randomUser.animal}&color=${randomUser.color}';
      pickedImage = null;
    });
    // Close keyboard
    FocusScope.of(context).unfocus();
  }

  pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final File file = File(pickedFile!.path);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: [CropAspectRatioPreset.square],
    );
    setState(() {
      pickedImage = croppedFile;
      randomAvatarPath = null;
    });
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
    const int scaledSize = 200;
    try {
      final image = dart_image.decodeImage(await pickedImage!.readAsBytes());
      final resized = dart_image.copyResize(
        image!,
        width: image.width < image.height ? -1 : scaledSize,
        height: image.width < image.height ? scaledSize : -1,
      );
      return dart_image.encodePng(resized);
    } catch (e) {
      rethrow;
    }
  }
}

class TitleBackground extends StatelessWidget {
  const TitleBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      height: 70.0,
      decoration: ShapeDecoration(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12.0),
          ),
        ),
        color: themeData.isLightTheme ? themeData.primaryColorDark : themeData.canvasColor,
      ),
    );
  }
}

class RandomButton extends StatelessWidget {
  final Function() onPressed;
  final AutoSizeGroup? autoSizeGroup;

  const RandomButton({Key? key, required this.onPressed, this.autoSizeGroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final minFontSize = MinFontSize(context);

    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.only(
            bottom: 20.0,
            top: 26.0,
          ),
        ),
        onPressed: onPressed,
        child: AutoSizeText(
          texts.breez_avatar_dialog_random,
          style: theme.whiteButtonStyle,
          maxLines: 1,
          minFontSize: minFontSize.minFontSize,
          stepGranularity: 0.1,
          group: autoSizeGroup,
        ),
      ),
    );
  }
}

class AvatarPreview extends StatelessWidget {
  final CroppedFile? pickedImage;
  final String? randomAvatarPath;
  final bool isUploading;

  const AvatarPreview({
    Key? key,
    required this.pickedImage,
    required this.randomAvatarPath,
    required this.isUploading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, userModel) {
        return Stack(
          children: [
            isUploading ? const AvatarSpinner() : const SizedBox(),
            Padding(
              padding: const EdgeInsets.only(top: 26.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: BreezAvatar(
                  pickedImage?.path ?? randomAvatarPath ?? userModel.profileSettings.avatarURL,
                  radius: 36.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AvatarSpinner extends StatelessWidget {
  const AvatarSpinner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 26.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            themeData.primaryTextTheme.labelLarge!.color!,
          ),
          backgroundColor: themeData.colorScheme.background,
        ),
      ),
    );
  }
}

class GalleryButton extends StatelessWidget {
  final Function() onPressed;
  final AutoSizeGroup? autoSizeGroup;

  const GalleryButton({Key? key, required this.onPressed, this.autoSizeGroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final minFontSize = MinFontSize(context);

    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.only(
            bottom: 20.0,
            top: 26.0,
          ),
        ),
        onPressed: onPressed,
        child: AutoSizeText(
          texts.breez_avatar_dialog_gallery,
          style: theme.whiteButtonStyle,
          maxLines: 1,
          minFontSize: minFontSize.minFontSize,
          stepGranularity: 0.1,
          group: autoSizeGroup,
        ),
      ),
    );
  }
}
