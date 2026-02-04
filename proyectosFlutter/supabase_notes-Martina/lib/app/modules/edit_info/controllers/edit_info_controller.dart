import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditInfoController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController airlineC = TextEditingController();
  TextEditingController countryC = TextEditingController();
  SupabaseClient client = Supabase.instance.client;

  Future<bool> editInfo(int id) async {
    if (airlineC.text.isNotEmpty && countryC.text.isNotEmpty) {
      isLoading.value = true;
      await client
          .from("info")
          .update({"airline": airlineC.text, "country": countryC.text}).match({
        "id": id,
      });
      return true;
    } else {
      return false;
    }
  }
}
