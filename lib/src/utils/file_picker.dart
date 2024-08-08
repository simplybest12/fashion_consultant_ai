import 'package:file_picker/file_picker.dart';

Future<FilePickerResult?> pickImage() async {
  await FilePicker.platform.pickFiles(type: FileType.image);
}
