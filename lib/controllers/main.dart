import 'package:get/get.dart';

class MainController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void onDestinationSelected(int index) {
    selectedIndex.value = index;
  }
}
