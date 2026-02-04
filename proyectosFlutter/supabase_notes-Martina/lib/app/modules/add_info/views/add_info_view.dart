// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:supabase_notes/app/modules/home/controllers/home_controller.dart';

import '../controllers/add_info_controller.dart';

class AddNoteView extends GetView<AddNoteController> {
  HomeController homeC = Get.find();

  AddNoteView({super.key}); // get controller from another controller
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Flight Info'),
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
                    bool res = await controller.addInfo();
                    if (res == true) {
                      await homeC.getAllInfo();
                      Get.back();
                    }
                    controller.isLoading.value = false;
                  }
                },
                child: Text(
                    controller.isLoading.isFalse ? "Save info" : "Loading...")))
          ],
        ));
  }
}
