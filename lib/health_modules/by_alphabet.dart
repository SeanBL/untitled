import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'module_by_alphabet.dart';

class ByAlphabet extends StatefulWidget {
  @override
  _ByAlphabetState createState() => _ByAlphabetState();
}

Future<List<Album>> fetchAlbums() async {
  final response = await http.get(Uri.parse('https://obrpqbo4eb.execute-api.us-west-2.amazonaws.com/api/letters'));

  if (response.statusCode == 200) {
    print("This is the response ${response.body}");
    Iterable jsonResponse = json.decode(response.body);
    List<Album> albums = jsonResponse.map((album) => Album.fromJson(album)).toList();
    albums.sort((a, b) => a.name.compareTo(b.name));
    return albums;
  } else {
    throw Exception('Failed to load album');
  }
}

class Album {
  final String description;
  final String id;
  final String name;

  Album({
    required this.description,
    required this.id,
    required this.name,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "description": String description,
        "id": String id,
        "name": String name,
      } => Album(
        description: description,
        id: id,
        name: name,
      ),
      _ => throw Exception('Failed to load album'),
    };
  }
}

class _ByAlphabetState extends State<ByAlphabet> {
  late Future<List<Album>> futureAlbums;
  late List<String> albumNames = [];

  @override
  void initState() {
    super.initState();
    futureAlbums = fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("By Alphabet"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Search by"),
            Text("Alphabet"),
            Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              child: FutureBuilder<List<Album>>(
                future: futureAlbums,
                builder: (context, snapshot) {
                  print("THis is the snapshot ${snapshot.data}");
                  if (snapshot.hasData) {
                    albumNames = snapshot.data!.map((album) => album.name).toList();
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 3,
                      ),
                      itemCount: albumNames.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            print("Album index ${albumNames[index]} was tapped");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ModuleByAlphabet(letter: albumNames[index])),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              albumNames[index],
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
            ),
            ),
          ],
        ),
      ),
    );
  }
}