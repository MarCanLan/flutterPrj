import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/controllers/person_controller.dart';
import 'package:movies/models/person.dart';
import 'package:movies/widgets/tab_builder.dart';

class DetailsScreenPerson extends StatelessWidget {
  const DetailsScreenPerson({
    super.key,
    required this.p,
  });

  final Person p;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 34),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      tooltip: 'Back to home',
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Detail',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                      ),
                    ),
                    Tooltip(
                      message: 'Save this actor to your favourite list',
                      child: IconButton(
                        onPressed: () {
                          Get.find<PersonController>().addFav(p);
                        },
                        icon: Obx(
                          () => Get.find<PersonController>().fav(p)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 33,
                                )
                              : const Icon(
                                  Icons.favorite_outline,
                                  color: Colors.white,
                                  size: 33,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 330,
                child: Stack(
                  children: [
                    // Imagen de fondo del actor.
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      child: Image.network(
                        Api.imageBaseUrl + p.profilePath,
                        width: Get.width,
                        height: 250,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return FadeShimmer(
                            width: Get.width,
                            height: 250,
                            highlightColor: const Color(0xff22272f),
                            baseColor: const Color(0xff20252d),
                          );
                        },
                        errorBuilder: (_, __, ___) => const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.broken_image,
                            size: 250,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(left: 30),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            Api.imageBaseUrl + p.profilePath,
                            width: 110,
                            height: 140,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const FadeShimmer(
                                width: 110,
                                height: 140,
                                highlightColor: Color(0xff22272f),
                                baseColor: Color(0xff20252d),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Nombre del actor.
                    Positioned(
                      top: 255,
                      left: 155,
                      child: SizedBox(
                        width: 230,
                        child: Text(
                          p.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 200,
                      right: 30,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color.fromRGBO(37, 40, 54, 0.52),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/Star.svg'),
                            const SizedBox(width: 5),
                            Text(
                              p.popularity.toString() == "0.0"
                                  ? 'N/A'
                                  : p.popularity.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFFF8700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Opacity(
                opacity: .6,
                child: SizedBox(
                  width: Get.width / 1.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset('assets/calender.svg'),
                          const SizedBox(width: 5),
                          Text(
                            p.birthday,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const Text('|'),
                      Row(
                        children: [
                          Icon(Icons.location_city, color: Colors.white),
                          const SizedBox(width: 5),
                          Text(
                            p.placeOfBirth,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const TabBar(
                        indicatorWeight: 4,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Color(0xFF3A3F47),
                        tabs: [
                          Tab(text: 'About Actor'),
                          Tab(text: 'Movies'),
                        ],
                      ),
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          children: [
                            // Biografía del actor.
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                p.biography,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),

                            TabBuilder(
                              future:
                                  ApiService.getMoviePerson(p.id.toString()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
