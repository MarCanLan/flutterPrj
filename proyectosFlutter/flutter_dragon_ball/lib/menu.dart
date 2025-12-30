// homepage.dart
import 'package:flutter/material.dart';
import 'characters.dart';
import 'service.dart';
import 'details.dart';
import 'planets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Character>> _futureCharacters;
  final CharacterService _characterService = CharacterService();

  @override
  void initState() {
    super.initState();
    _futureCharacters = _characterService.getCharacters();
  }

  Future<void> _refreshCharacters() async {
    setState(() {
      _futureCharacters = _characterService.getCharacters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personajes de Dragon Ball'),
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.public),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PlanetsPage()),
            );
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCharacters,
        child: _buildCharacterList(), // Usamos ListView
      ),
    );
  }

  Widget _buildCharacterList() {
    return FutureBuilder<List<Character>>(
      future: _futureCharacters,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (snapshot.hasData) {
          final characters = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                elevation: 2.0,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailsPage(characterId: character.id),
                      ),
                    );
                  },
                  leading: SizedBox(
                    width: 56,
                    height: 56,
                    child: ClipOval(
                      child: Image.network(
                        character.imageUrl,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.person,
                              size: 56,
                              color: Colors.grey,
                            ),
                      ),
                    ),
                  ),
                  title: Text(
                    character.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Raza: ${character.race}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
