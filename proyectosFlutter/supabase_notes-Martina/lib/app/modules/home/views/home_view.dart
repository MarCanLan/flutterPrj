import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_notes/app/data/models/info_model.dart';
//import 'package:supabase_notes/app/data/models/notes_model.dart';
import 'package:supabase_notes/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flight Info'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                Get.toNamed(Routes.PROFILE);
              },
              icon: const Icon(Icons.person),
            )
          ],
        ),
        body: FutureBuilder(
            future: controller.getAllInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return Obx(() => controller.allInfo.isEmpty
                  ? const Center(
                      child: Text("NO DATA"),
                    )
                  : ListView.builder(
                      itemCount: controller.allInfo.length,
                      itemBuilder: (context, index) {
                        Info info = controller.allInfo[index];
                        return ListTile(
                          onTap: () => Get.toNamed(
                            Routes.EDIT_NOTE,
                            arguments: info,
                          ),
                          leading: CircleAvatar(
                            child: Text("t${info.id}"),
                          ),
                          title: Text("${info.airline}"),
                          subtitle: Text("destination: ${info.country}"),
                          trailing: IconButton(
                            onPressed: () async =>
                                await controller.deleteInfo(info.id!),
                            icon: const Icon(Icons.delete),
                          ),
                        );
                      },
                    ));
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.ADD_NOTE),
          child: const Icon(Icons.add),
        ));
  }
}
