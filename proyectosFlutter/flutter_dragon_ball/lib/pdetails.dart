import 'package:flutter/material.dart';
import 'characters.dart';
import 'service.dart';

class PlanetDetailsPage extends StatefulWidget {
  final int planetId;

  const PlanetDetailsPage({super.key, required this.planetId});

  @override
  State<PlanetDetailsPage> createState() => _PlanetDetailsPageState();
}

class _PlanetDetailsPageState extends State<PlanetDetailsPage> {
  late Future<OriginPlanet> _futurePlanet;
  final CharacterService _characterService = CharacterService();

  @override
  void initState() {
    super.initState();
    _futurePlanet = _characterService.getPlanetDetails(widget.planetId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Planeta')),
      body: FutureBuilder<OriginPlanet>(
        future: _futurePlanet,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (snapshot.hasData) {
            final planet = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        planet.image,
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    planet.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 30),
                  Text(
                    'Descripción:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(planet.description, textAlign: TextAlign.justify),
                ],
              ),
            );
          }
          return const Center(child: Text('Datos del planeta no disponibles.'));
        },
      ),
    );
  }
}
