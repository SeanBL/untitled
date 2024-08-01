import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ModuleByAlphabet extends StatefulWidget {
  final String letter;
  final String letterId;

  ModuleByAlphabet({required this.letter, required this.letterId});

  @override
  _ModuleByAlphabetState createState() => _ModuleByAlphabetState();
}



class Modules {
  String? name;
  //String? description;
  //String? topics;
  //String? version;
  String? downloadLink;
  //String? launchFile;
  //String? packageSize;
  //String? letters;
  List<String>? letters;
  //String? credits;
  //String? module_name;
  //String? id;


  Modules({
    this.name,
    //this.description,
    //this.topics,
    //this.version,
    this.downloadLink,
    //this.launchFile,
    //this.packageSize,
    this.letters,
    //this.credits,
    //this.module_name,
    //this.id,
  });

  Modules.fromJson(Map<String, dynamic> json)
    : name = json['name'] as String,
      //description = json['description'] as String,
      //topics = json['topics'] as String,
      //version = json['version'] as String,
      downloadLink = json['downloadLink'] as String,
      //launchFile = json['launchFile'] as String,
      //packageSize = json['packageSize'] as String,
      //letters = json['letters'] as String;
      letters = (json['letters'] as List<dynamic>?)?.map((e) => e as String).toList();
      //credits = json['credits'] as String,
      //module_name = json['module_name'] as String,
      //id = json['id'] as String;

  Map<String, dynamic> toJson() => {
    'name': name,
    //'description': description,
    //'topics': topics,
    //'version': version,
    'downloadLink': downloadLink,
    //'launchFile': launchFile,
    //'packageSize': packageSize,
    'letters': letters,
    //'credits': credits,
    //'module_name': module_name,
    //'id': id,
  };
}

class _ModuleByAlphabetState extends State<ModuleByAlphabet> {
  late Future<List<Modules>> futureModules;
  late List<Modules> moduleData = [];

  Future<List<Modules>> getModules() async {
    try {
      final response = await http.get(Uri.parse(
          'https://obrpqbo4eb.execute-api.us-west-2.amazonaws.com/api/modules'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Modules> allModules = data.map<Modules>((e) => Modules.fromJson(e)).toList();

        // Filter modules by the letter
        moduleData = allModules.where((module) => module.letters?.contains(widget.letterId) ?? false).toList();

        // Sort modules by name
        moduleData.sort((a, b) => a.name!.compareTo(b.name!));

        debugPrint("Module Data: ${moduleData.length}");
        return moduleData;
      } else {
        debugPrint("Failed to load modules");
      }
      return moduleData;
    } catch (e) {
      debugPrint("$e");
    }
    return moduleData;
  }

  @override
  void initState() {
    super.initState();
    futureModules = getModules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("By Alphabet ${widget.letter}"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Search by"),
            Text("Alphabet: ${widget.letter}"),
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
              child: FutureBuilder<List<Modules>>(
                future: futureModules,
                builder: (context, snapshot) {
                  print("THis is the snapshot ${snapshot.data}");
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: moduleData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(moduleData[index].name!),
                          subtitle: Text(moduleData[index].downloadLink!),
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