// lib/controllers/person_controller.dart
import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/person.dart';

class PersonController extends GetxController {
  var isLoading = false.obs;
  var popularPeople = <Person>[].obs;
  var personfav = <Person>[].obs;

  @override
  void onInit() {
    fetchPopularPeople();
    super.onInit();
  }

  void fetchPopularPeople() async {
    isLoading.value = true;
    var res = await ApiService.topPersons();
    popularPeople.value = res ?? [];
    isLoading.value = false;
  }

  void addFav(Person p) {
    if (fav(p)) {
      personfav.removeWhere((item) => item.id == p.id);
    } else {
      personfav.add(p);
    }
  }

  bool fav(Person p) {
    return personfav.any((m) => m.id == p.id);
  }
}
