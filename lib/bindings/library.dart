import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/controllers/item_create.dart';

class LibraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LibraryController(), permanent: true);
    Get.put(ItemCreateController(), permanent: true);
  }
}
