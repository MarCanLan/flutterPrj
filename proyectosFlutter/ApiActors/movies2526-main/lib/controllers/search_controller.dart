import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/person.dart';

class SearchController1 extends GetxController {
  TextEditingController searchController = TextEditingController();
  var searchText = ''.obs;
  var foundedP = <Person>[].obs;
  var isLoading = false.obs;
  void setSearchText(text) => searchText.value = text;
  void search(String query) async {
    isLoading.value = true;
    foundedP.value = (await ApiService.getSearch(query)) ?? [];
    isLoading.value = false;
  }
}
