import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> getImage({ImageSource? source}) async {
    final XFile? image = await _picker.pickImage(
      source: source ?? ImageSource.gallery,
      imageQuality: 70, // Compress images to 70% quality
      maxWidth: 1920, // Limit maximum width
      maxHeight: 1920, // Limit maximum height
    );
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  static Future<List<File>> getImageList() async {
    final List<XFile> images = await _picker.pickMultiImage(
      limit: 5,
      imageQuality: 70, // Compress images to 70% quality to reduce file size
      maxWidth: 1920, // Limit maximum width to 1920px
      maxHeight: 1920, // Limit maximum height to 1920px
    );

    return images.map<File>((e) => File(e.path)).toList();
  }

  static Future<File?> getVideo({ImageSource? source}) async {
    final XFile? video = await _picker.pickVideo(
      source: source ?? ImageSource.gallery,
    );

    if (video != null) {
      return File(video.path);
    }
    return null;
  }
}
