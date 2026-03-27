import 'dart:convert';

import 'package:assignment/data/dtos/artist_dto.dart';
import 'package:assignment/data/repositories/artists/artists_repository_firebase.dart';
import 'package:assignment/model/artists/artist.dart';
import 'package:assignment/model/song_with_artist/song_with_artist.dart';
import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final Uri songsUri = Uri.https(
    'week-nine-database-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/artist/songs.json',
  );

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      if (response.body == 'null') {
        return [];
      }

      final Map<String, dynamic> songsJson =
          json.decode(response.body) as Map<String, dynamic>;

      return songsJson.entries.map((entry) {
        final Map<String, dynamic> songMap = Map<String, dynamic>.from(
          entry.value as Map,
        );

        songMap[SongDto.idKey] = entry.key;

        return SongDto.fromJson(songMap);
      }).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}

  @override
  Future<List<SongWithArtist>> joinArtist() async {
    final http.Response songResponse = await http.get(songsUri);

    ArtistsRepositoryFirebase artistRepo = ArtistsRepositoryFirebase();
    final http.Response artistResponse = await http.get(artistRepo.artistsUri);

    if (songResponse.statusCode != 200 || artistResponse.statusCode != 200) {
      throw Exception('Failed to load songs/artists');
    }

    if (songResponse.body == 'null' || artistResponse.body == 'null') {
      return [];
    }

    final Map<String, dynamic> songsJson =
        json.decode(songResponse.body) as Map<String, dynamic>;

    final Map<String, dynamic> artistsJson =
        json.decode(artistResponse.body) as Map<String, dynamic>;

    final Map<String, Artist> artistById = artistsJson.map((id, value) {
      final artistMap = Map<String, dynamic>.from(value as Map);
      artistMap[ArtistDto.idKey] = id;
      return MapEntry(id, ArtistDto.fromJson(artistMap));
    });

    return songsJson.entries.map((entry) {
      final songMap = Map<String, dynamic>.from(entry.value as Map);
      songMap[SongDto.idKey] = entry.key;

      final song = SongDto.fromJson(songMap);
      final artist = artistById[song.artist];

      return SongWithArtist(song: song, artist: artist!);
    }).toList();
  }

  @override
  Future<bool> likeSong(String songId, int currentLike) async {
    final Uri songUri = Uri.https(
      'week-nine-database-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/artist/songs/$songId.json',
    );

    final response = await http.patch(
      songUri,
      body: json.encode({'like': currentLike + 1}),
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
