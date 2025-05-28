import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';

class LibraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LibraryController(), permanent: true);
  }
}
