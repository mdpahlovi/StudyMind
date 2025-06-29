import 'package:get/get.dart';
import 'package:studymind/controllers/auth.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }
}
