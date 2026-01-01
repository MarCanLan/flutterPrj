import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/controllers/bottom_navigator_controller.dart';
import 'package:movies/controllers/movies_controller.dart';
import 'package:movies/controllers/person_controller.dart';
import 'package:movies/controllers/search_controller.dart';
import 'package:movies/widgets/search_box.dart';
import 'package:movies/widgets/top_rated_item.dart';
import 'package:movies/widgets/tap_person.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final MoviesController controller = Get.put(MoviesController());
  final SearchController1 searchController = Get.put(SearchController1());
  final PersonController personController = Get.put(PersonController());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 42,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What do you want to watch?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            SearchBox(
              onSumbit: () {
                String search =
                    Get.find<SearchController1>().searchController.text;
                Get.find<SearchController1>().searchController.text = '';
                Get.find<SearchController1>().search(search);
                Get.find<BottomNavigatorController>().setIndex(1);
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            const SizedBox(
              height: 34,
            ),
            Obx(
              (() => personController.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: 300,
                      child: ListView.separated(
                        itemCount: personController.popularPeople.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, __) => const SizedBox(width: 24),
                        itemBuilder: (_, index) => TopRatedItem(
                            p: personController.popularPeople[index],
                            index: index + 1),
                      ),
                    )),
            ),
            SizedBox(height: 20),
            DefaultTabController(
              length: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TabBar(
                      indicatorWeight: 3,
                      indicatorColor: Color(
                        0xFF3A3F47,
                      ),
                      labelStyle: TextStyle(fontSize: 11.0),
                      tabs: [
                        Tab(text: 'Popular'),
                        Tab(text: 'Trending'),
                      ]),
                  SizedBox(
                    height: 400,
                    child: TabBarView(children: [
                      TabBuilderActor(
                        future: ApiService.popularActors(),
                      ),
                      TabBuilderActor(future: ApiService.trendingActors()),
                    ]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
