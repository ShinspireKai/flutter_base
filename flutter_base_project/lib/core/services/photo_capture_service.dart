import 'package:image_picker/image_picker.dart';

/// PhotoCaptureService — bọc [ImagePicker] của plugin `image_picker`
///
/// Single Responsibility: chỉ lo việc mở camera/thư viện ảnh và trả về
/// đường dẫn file — không biết gì về hạng mục kiểm tra hay bloc.
abstract class PhotoCaptureService {
  /// Mở camera chụp ảnh hiện trường, trả về đường dẫn file hoặc `null` nếu huỷ
  Future<String?> captureFromCamera();

  /// Mở thư viện ảnh để chọn, trả về đường dẫn file hoặc `null` nếu huỷ
  Future<String?> pickFromGallery();
}

class PhotoCaptureServiceImpl implements PhotoCaptureService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> captureFromCamera() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1600,
        imageQuality: 85,
      );
      return file?.path;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> pickFromGallery() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      return file?.path;
    } catch (_) {
      return null;
    }
  }
}
