import 'package:file_picker/file_picker.dart';

class FilePickerUtils {
  static Future<String?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'png',
          'jpg',
          'jpeg',
        ],
      );

      return result?.files.single.path;
    } catch (_) {
      return null;
    }
  }
}
