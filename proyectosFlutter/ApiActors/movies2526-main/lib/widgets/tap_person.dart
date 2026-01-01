import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/models/person.dart';
import 'package:movies/screens/details_screen_person.dart';

class TabBuilderActor extends StatelessWidget {
  const TabBuilderActor({
    required this.future,
    super.key,
  });
  final Future<List<Person>?> future;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 12.0),
      child: FutureBuilder<List<Person>?>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.hasData) {
            return GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              // shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                childAspectRatio: 0.6,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Get.to(DetailsScreenPerson(p: snapshot.data![index]));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    Api.imageBaseUrl + snapshot.data![index].profilePath,
                    height: 300,
                    width: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      size: 180,
                    ),
                    loadingBuilder: (_, __, ___) {
                      if (___ == null) return __;
                      return const FadeShimmer(
                        width: 180,
                        height: 250,
                        highlightColor: Color(0xff22272f),
                        baseColor: Color(0xff20252d),
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
