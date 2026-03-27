import 'dart:convert';

import 'package:assignment/data/dtos/artist_dto.dart';
import 'package:assignment/data/repositories/artists/artists_repository.dart';
import 'package:assignment/model/artists/artist.dart';
import 'package:http/http.dart' as http;

class ArtistsRepositoryFirebase extends ArtistsRepository {
  final Uri artistsUri = Uri.https('week-nine-database-default-rtdb.asia-southeast1.firebasedatabase.app', '/artist/artists.json');

  @override
  Future<List<Artist>> fetchArtists() async {
    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      if (response.body == 'null') {
        return [];
      }

      final Map<String, dynamic> artistsJson = json.decode(response.body) as Map<String, dynamic>;

      return artistsJson.entries.map((entry) {
        final Map<String, dynamic> artistMap = Map<String, dynamic>.from(
          entry.value as Map,
        );

        artistMap[ArtistDto.idKey] = entry.key;

        return ArtistDto.fromJson(artistMap);
      }).toList();
    } else {
      throw Exception('Failed to load');
    }
  }
}