import 'package:get/get.dart';
import 'package:studymind/controllers/removed_chat.dart';
import 'package:studymind/controllers/removed_item.dart';

class RemovedItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RemovedItemController());
  }
}

class RemovedChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RemovedChatController());
  }
}
