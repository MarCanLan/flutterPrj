// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_notes/app/data/models/info_model.dart';
import 'package:supabase_notes/app/modules/home/controllers/home_controller.dart';

import '../controllers/edit_info_controller.dart';

class EditNoteView extends GetView<EditInfoController> {
  Info info = Get.arguments;
  HomeController homeC = Get.find();

  EditNoteView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.airlineC.text = info.airline!;
    controller.countryC.text = info.country!;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit info'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: controller.airlineC,
              decoration: const InputDecoration(
                labelText: "Airline",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextField(
              controller: controller.countryC,
              decoration: const InputDecoration(
                labelText: "Country",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    bool res = await controller.editInfo(info.id!);
                    if (res == true) {
                      await homeC.getAllInfo();
                      Get.back();
                    }
                    controller.isLoading.value = false;
                  }
                },
                child: Text(
                    controller.isLoading.isFalse ? "Update" : "Loading...")))
          ],
        ));
  }
}
