import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Config {
  final String apiUrl;
  final String apiVersion;

  Config({required this.apiUrl, required this.apiVersion});

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      apiUrl: json['apiUrl'],
      apiVersion: json['apiVersion'],
    );
  }
}

Future<Config> loadConfig() async {
  final jsonString = await rootBundle.loadString('assets/config.json');
  final jsonResponse = json.decode(jsonString);
  return Config.fromJson(jsonResponse);
}