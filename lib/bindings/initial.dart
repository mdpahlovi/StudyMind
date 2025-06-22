import 'package:get/get.dart';
import 'package:studymind/controllers/auth.dart';
import 'package:studymind/controllers/main.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(MainController(), permanent: true);
  }
}
