import 'package:flutter/material.dart';
import 'characters.dart';
import 'service.dart';
import 'rating.dart'; // Importamos el nuevo servicio

class DetailsPage extends StatefulWidget {
  final int characterId;

  const DetailsPage({super.key, required this.characterId});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<Character> _futureCharacter;
  final CharacterService _characterService = CharacterService();
  final RatingService _ratingService =
      RatingService(); // Instancia del nuevo servicio
  int _rating = 0; // Estado para almacenar la valoración actual (0 a 10)

  @override
  void initState() {
    super.initState();
    _futureCharacter = _characterService.getCharacterDetails(
      widget.characterId,
    );
    _loadRating();
  }

  // Función para cargar la valoración guardada del personaje
  Future<void> _loadRating() async {
    final loadedRating = await _ratingService.getCharacterRating(
      widget.characterId,
    );
    if (mounted) {
      setState(() {
        _rating = loadedRating;
      });
    }
  }

  // Función para guardar la nueva valoración
  void _saveRating(int newRating) {
    setState(() {
      _rating = newRating;
    });
    _ratingService.saveCharacterRating(widget.characterId, newRating);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Character>(
        future: _futureCharacter,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final character = snapshot.data!;
            return _buildDetailsContent(context, character);
          }
          return const Center(child: Text('No se encontraron datos.'));
        },
      ),
    );
  }

  Widget _buildDetailsContent(BuildContext context, Character character) {
    Widget buildDetailRow(String title, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: Text(value, textAlign: TextAlign.right)),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(character.name), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  character.imageUrl,
                  fit: BoxFit.cover,
                  height: 250,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // **Mostrar la valoración actual**
            Text(
              '${_rating.toString().padLeft(2, '0')}/10', // Puntuación dinámica
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            // **Control de valoración (Slider)**
            Slider(
              value: _rating.toDouble(),
              min: 0,
              max: 10,
              divisions: 10, // Para permitir valores enteros (0, 1, 2, ..., 10)
              label: 'Valoración: $_rating',
              onChanged: (double newValue) {
                // Actualiza la interfaz mientras se arrastra
                setState(() {
                  _rating = newValue.round();
                });
              },
              onChangeEnd: (double newValue) {
                // Guarda la valoración en la persistencia solo al soltar el slider
                _saveRating(newValue.round());
              },
            ),

            const SizedBox(height: 20),

            // ... Resto del contenido de la página de detalles ...
            ExpansionTile(
              initiallyExpanded: true,
              title: const Text(
                '📋 Información General',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    children: [
                      buildDetailRow('Raza', character.race),
                      buildDetailRow('Género', character.gender),
                      buildDetailRow('Afiliación', character.affiliation),
                      buildDetailRow(
                        'Planeta de Origen',
                        character.originPlanet.name,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 0),

            ExpansionTile(
              title: const Text(
                '💥 Datos de Combate (KI)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    children: [
                      buildDetailRow('Base KI', character.ki),
                      buildDetailRow('Total KI', character.maxKi),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 0),

            ExpansionTile(
              title: const Text(
                '📜 Biografía',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    character.description,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            const Divider(height: 0),

            ExpansionTile(
              title: const Text(
                '🧬 Transformaciones',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [_buildTransformationsList(character.transformations)],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransformationsList(List<Transformation> transformations) {
    if (transformations.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Text(
          'No hay transformaciones listadas.',
          textAlign: TextAlign.center,
        ),
      );
    }
    return Column(
      children: transformations
          .map(
            (t) => ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(t.image)),
              title: Text(t.name),
              subtitle: Text('KI: ${t.ki}'),
            ),
          )
          .toList(),
    );
  }
}
