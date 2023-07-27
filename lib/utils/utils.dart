import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }

  print("No Image Selected");
}

Future pickFile() async {
  final result = await FilePicker.platform.pickFiles();
  if (result == null) return;
}
