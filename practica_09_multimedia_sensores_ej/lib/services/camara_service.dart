import 'package:image_picker/image_picker.dart';

class CamaraService {
  final ImagePicker _picker = ImagePicker();

  /// Devuelve la ruta de la foto, o `null` si el usuario canceló
  /// o si ocurrió un error (el error se propaga por `exception`).
  Future<String?> capturarFoto() async {
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
      maxWidth: 1600,
    );
    return file?.path; // null si el usuario canceló
  }
}