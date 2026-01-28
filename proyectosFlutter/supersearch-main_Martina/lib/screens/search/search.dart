import 'dart:async'; // Necesario para el Timer
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supersearch/screens/search/tile.dart';
import 'package:supersearch/style.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<String>? _results;
  String _input = '';
  Timer? _debounce; // Temporizador para no saturar la búsqueda
  bool _isLoading = false;

  @override
  void dispose() {
    _debounce?.cancel(); // Cancelar el timer si se cierra la pantalla
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
        backgroundColor: Colors.red, // Coincide con tu imagen
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white, // Fondo blanco para el input como en la imagen
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black, // Texto negro para contraste
              ),
              onChanged: _onSearchFieldChanged,
              autocorrect: false,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Name",
                hintStyle: placeholderTextFieldStyle,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                // Añadimos un indicador de carga pequeño en el input
                suffixIcon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
              ),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_results == null) {
      // Estado inicial: no se ha buscado nada
      return Container();
    }

    if (_results!.isEmpty) {
      return Center(
        child: Text(
          "No results for '$_input'",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    return GridView.builder(
      itemCount: _results!.length,
      padding: EdgeInsets.zero, // Quitamos padding para que toque los bordes
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columnas como en la imagen
        childAspectRatio: 1.0, // Cuadrados perfectos
        mainAxisSpacing: 0, // Sin espacio entre cuadros (o muy poco)
        crossAxisSpacing: 0,
      ),
      itemBuilder: (context, index) {
        return Tile(_results![index]);
      },
    );
  }

  /// Maneja el cambio de texto con un "Debounce"
  void _onSearchFieldChanged(String value) {
    setState(() {
      _input = value;
    });

    // Si el usuario borra todo, limpiamos
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (value.isEmpty) {
      setState(() {
        _results = null;
        _isLoading = false;
      });
      return;
    }

    // Esperamos 500ms después de que deje de escribir para buscar
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _isLoading = true);
      final results = await _searchUsers(value);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    });
  }

  Future<List<String>> _searchUsers(String name) async {
    try {
      // NOTA: Asegúrate de que tu tabla en Supabase tenga el índice 'fts' configurado
      // Si no tienes configuración Full Text Search, usa .ilike() en su lugar.
      final result = await Supabase.instance.client
          .from('names')
          .select('fname, lname')
          .textSearch('fname', "$name:*") // Búsqueda parcial
          .limit(50);

      final List<String> names = [];

      // Manejo seguro de datos dinámicos
      final data = result as List<dynamic>;
      for (var v in data) {
        names.add("${v['fname']} ${v['lname']}");
      }
      return names;
    } catch (e) {
      print('Error buscando: $e');
      return [];
    }
  }
}
