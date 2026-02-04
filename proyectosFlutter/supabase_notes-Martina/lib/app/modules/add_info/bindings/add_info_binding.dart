import 'package:get/get.dart';

import '../controllers/add_info_controller.dart';

class AddNoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddNoteController>(
      () => AddNoteController(),
    );
  }
}
