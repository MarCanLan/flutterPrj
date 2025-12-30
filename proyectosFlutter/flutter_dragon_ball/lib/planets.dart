import 'package:flutter/material.dart';
import 'characters.dart';
import 'service.dart';
import 'pdetails.dart';

class PlanetsPage extends StatefulWidget {
  const PlanetsPage({super.key});

  @override
  State<PlanetsPage> createState() => _PlanetsPageState();
}

class _PlanetsPageState extends State<PlanetsPage> {
  late Future<List<OriginPlanet>> _futurePlanets;
  final CharacterService _characterService = CharacterService();

  @override
  void initState() {
    super.initState();
    _futurePlanets = _characterService.getPlanets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planetas de Dragon Ball')),
      body: FutureBuilder<List<OriginPlanet>>(
        future: _futurePlanets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final planet = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(planet.image),
                  ),
                  title: Text(planet.name),
                  subtitle: Text(planet.description.split('.').first),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PlanetDetailsPage(planetId: planet.id),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const Center(child: Text('No hay planetas disponibles.'));
        },
      ),
    );
  }
}
