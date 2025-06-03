import 'dart:io';

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/user_profile/profile_animal.dart';
import 'package:c_breez/bloc/user_profile/profile_color.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BreezAvatar extends StatelessWidget {
  final String? avatarURL;
  final double radius;
  final Color? backgroundColor;

  const BreezAvatar(this.avatarURL, {this.radius = 20.0, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    Color avatarBgColor = backgroundColor ?? theme.sessionAvatarBackgroundColor;

    if ((avatarURL ?? "").isNotEmpty) {
      if (avatarURL!.startsWith("breez://profile_image?")) {
        var queryParams = Uri.parse(avatarURL!).queryParameters;
        return _GeneratedAvatar(radius, queryParams["animal"], queryParams["color"], avatarBgColor);
      }

      if (Uri.tryParse(avatarURL!)?.scheme.startsWith("http") ?? false) {
        return _NetworkImageAvatar(avatarURL!, radius);
      }

      if (Uri.tryParse(avatarURL!)?.scheme.startsWith("data") ?? false) {
        return _DataImageAvatar(avatarURL!, radius);
      }

      return _FileImageAvatar(radius, avatarURL!);
    }

    return _UnknownAvatar(radius, avatarBgColor);
  }
}

class _UnknownAvatar extends StatelessWidget {
  final double radius;
  final Color backgroundColor;

  const _UnknownAvatar(this.radius, this.backgroundColor);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      radius: radius,
      child: SvgPicture.asset(
        "src/icon/alien.svg",
        colorFilter: const ColorFilter.mode(Color.fromARGB(255, 0, 166, 68), BlendMode.srcATop),
        width: 0.70 * radius * 2,
        height: 0.70 * radius * 2,
      ),
    );
  }
}

class _GeneratedAvatar extends StatelessWidget {
  final double radius;
  final String? animal;
  final String? color;
  final Color backgroundColor;

  const _GeneratedAvatar(this.radius, this.animal, this.color, this.backgroundColor);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.sessionAvatarBackgroundColor,
      child: Icon(
        profileAnimalFromName(animal, texts)!.iconData,
        size: radius * 2 * 0.75,
        color: profileColorFromName(color, texts)!.color,
      ),
    );
  }
}

class _FileImageAvatar extends StatelessWidget {
  final double radius;
  final String filePath;

  const _FileImageAvatar(this.radius, this.filePath);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.yellow,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image(image: FileImage(File(filePath))),
      ),
    );
  }
}

class _NetworkImageAvatar extends StatelessWidget {
  final double radius;
  final String avatarURL;

  const _NetworkImageAvatar(this.avatarURL, this.radius);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: ClipRRect(borderRadius: BorderRadius.circular(radius), child: ExtendedImage.network(avatarURL)),
    );
  }
}

class _DataImageAvatar extends StatelessWidget {
  final double radius;
  final String avatarURL;

  const _DataImageAvatar(this.avatarURL, this.radius);

  @override
  Widget build(BuildContext context) {
    final uri = UriData.parse(avatarURL);
    final bytes = uri.contentAsBytes();
    return CircleAvatar(
      backgroundColor: theme.sessionAvatarBackgroundColor,
      radius: radius,
      child: ClipOval(child: Image.memory(bytes)),
    );
  }
}
