import 'package:get/get.dart';
import 'package:supabase_notes/app/data/models/info_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  RxList<Info> allInfo = List<Info>.empty().obs;
  SupabaseClient client = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    getAllInfo();
  }

  Future<void> getAllInfo() async {
    List<dynamic> res = await client
        .from("clients")
        .select("id")
        .match({"uid": client.auth.currentUser!.id});
    Map<String, dynamic> user = (res).first as Map<String, dynamic>;
    int id = user["id"]; //get user id before get all notes data
    var infoRes = await client.from("info").select().match(
      {"client_id": id}, //get all notes data with match user id
    );
    List<Info> infoData = Info.fromJsonList((infoRes as List));
    allInfo(infoData);
    allInfo.refresh();
  }

  Future<void> deleteInfo(int id) async {
    await client.from("info").delete().match({
      "id": id,
    });
    getAllInfo();
  }
}
