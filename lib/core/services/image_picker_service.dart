import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ImagePickerService {
  final ImagePicker _picker;

  ImagePickerService(this._picker);

  Future<String?> pickImageFromCamera({int imageQuality = 80}) async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: imageQuality,
    );
    return photo?.path;
  }

  Future<String?> pickImageFromGallery({int imageQuality = 80}) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
    );
    return image?.path;
  }
}