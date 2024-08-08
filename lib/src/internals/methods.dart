// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../constants/type_defs.dart';
import 'package:image/image.dart' as img;
import 'package:image_editor/image_editor.dart';

/// Log only in debug mode.
/// 只在调试模式打印
void realDebugPrint(dynamic message) {
  if (!kReleaseMode) {
    log('$message', name: 'CameraPicker - LOG');
  }
}

void handleErrorWithHandler(
  Object e,
  StackTrace s,
  CameraErrorHandler? handler,
) {
  if (handler != null) {
    handler(e, s);
    return;
  }
  Error.throwWithStackTrace(e, s);
}

T? ambiguate<T>(T value) => value;

Future<File> flipImageHorizontally(String? imageFile) async {
  if (imageFile == null) {
    return Future.error('imageFile is null');
  }
  final File imageFileTemp = File(imageFile);
  final Uint8List imageBytes = await imageFileTemp.readAsBytes();
  final ImageEditorOption option = ImageEditorOption();
  option.addOption(const FlipOption(horizontal: true));

  final byteImage =
      await ImageEditor.editImage(image: imageBytes, imageEditorOption: option);
  final flipped = File('${imageFileTemp.path}_flipped.jpg');
  return await flipped.writeAsBytes(byteImage!);
}

Future<File> flipImageHorizontallyCore(String? imageFile) async {
  try {
    final File imageFileTemp = File(imageFile!);
    final imageBytes = await imageFileTemp.readAsBytes();
    final image = img.decodeImage(imageBytes);

    if (image == null) {
      throw Exception('Resim yüklenemedi.');
    }
    final flippedImage = img.flipHorizontal(image);

    final flippedFilePath = '${imageFileTemp.path}_flipped.png';
    final flippedFile = File(flippedFilePath);

    await flippedFile.writeAsBytes(img.encodePng(flippedImage));

    return flippedFile;
  } catch (e) {
    if (kDebugMode) {
      print('Resmi tersine çevirme hatası: $e');
    }
    rethrow;
  }
}
