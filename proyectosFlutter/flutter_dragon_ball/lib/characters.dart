class Character {
  final int id;
  final String name;
  final String ki;
  final String maxKi;
  final String race;
  final String gender;
  final String description;
  final String imageUrl;
  final String affiliation;
  final OriginPlanet originPlanet;
  final List<Transformation> transformations;

  Character({
    required this.id,
    required this.name,
    required this.ki,
    required this.maxKi,
    required this.race,
    required this.gender,
    required this.description,
    required this.imageUrl,
    required this.affiliation,
    required this.originPlanet,
    required this.transformations,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    final List<dynamic> transformationsJson = json['transformations'] ?? [];
    final transformations = transformationsJson
        .map((t) => Transformation.fromJson(t))
        .toList();

    final Map<String, dynamic> planetJson =
        json['originPlanet'] ??
        {'id': 0, 'name': 'Desconocido', 'image': '', 'description': 'N/A'};

    return Character(
      id: (json['id'] as int?) ?? 0,
      name: json['name'] as String,
      ki: (json['ki'] as String?) ?? 'N/A',
      maxKi: (json['maxKi'] as String?) ?? 'N/A',
      race: json['race'] as String,
      gender: json['gender'] as String,
      description: json['description'] as String,
      imageUrl: json['image'] as String,
      affiliation: json['affiliation'] as String,
      originPlanet: OriginPlanet.fromJson(planetJson),
      transformations: transformations,
    );
  }
}

class Transformation {
  final String name;
  final String ki;
  final String image;

  Transformation({required this.name, required this.ki, required this.image});

  factory Transformation.fromJson(Map<String, dynamic> json) {
    return Transformation(
      name: json['name'] as String,
      ki: json['ki'] as String,
      image: json['image'] as String,
    );
  }
}

class OriginPlanet {
  final int id;
  final String name;
  final String image;
  final String description;

  OriginPlanet({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  factory OriginPlanet.fromJson(Map<String, dynamic> json) {
    return OriginPlanet(
      id: (json['id'] as int?) ?? 0,
      name: json['name'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
    );
  }
}
