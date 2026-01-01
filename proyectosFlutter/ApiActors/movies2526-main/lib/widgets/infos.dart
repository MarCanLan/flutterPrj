import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/models/person.dart';

class Infos extends StatelessWidget {
  const Infos({super.key, required this.p});
  final Person p;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              p.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/Star.svg'),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    p.popularity.toString() == "0.0"
                        ? 'N/A'
                        : p.popularity.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                      color: Color(0xFFFF8700),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_city, color: Colors.white),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    p.placeOfBirth,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset('assets/calender.svg'),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    p.birthday,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
