import 'dart:convert';

import 'package:assignment/data/repositories/artists/artists_repository.dart';
import 'package:assignment/data/repositories/artists/artists_repository_firebase.dart';
import 'package:assignment/model/artists/artist.dart';
import 'package:assignment/model/song_with_artist/song_with_artist.dart';
import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final ArtistsRepository artistsRepository;

  SongRepositoryFirebase({ArtistsRepository? artistsRepository})
    : artistsRepository = artistsRepository ?? ArtistsRepositoryFirebase();

  final Uri songsUri = Uri.https(
    'week-nine-database-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/artist/songs.json',
  );

  List<Song>? _cachedSong;
  List<SongWithArtist>? _cachedSongWithArtist;

  @override
  Future<List<Song>> fetchSongs() async {
    if (_cachedSong != null) {
      return _cachedSong!;
    }

    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      if (response.body == 'null') {
        _cachedSong = [];
        return _cachedSong!;
      }

      final Map<String, dynamic> songsJson =
          json.decode(response.body) as Map<String, dynamic>;

      final songs = songsJson.entries.map((entry) {
        final Map<String, dynamic> songMap = Map<String, dynamic>.from(
          entry.value as Map,
        );

        songMap[SongDto.idKey] = entry.key;

        return SongDto.fromJson(songMap);
      }).toList();

      _cachedSong = songs;

      return songs;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}

  @override
  Future<List<SongWithArtist>> joinArtist() async {
    if (_cachedSongWithArtist != null) {
      return _cachedSongWithArtist!;
    }

    final songs = await fetchSongs();
    final artists = await artistsRepository.fetchArtists();

    if (songs.isEmpty || artists.isEmpty) {
      _cachedSongWithArtist = [];
      return [];
    }

    final Map<String, Artist> artistById = {
      for (final artist in artists) artist.id: artist,
    };

    final songsWithArtist = songs
        .where((song) => artistById.containsKey(song.artist))
        .map((song) {
          final artist = artistById[song.artist]!;
          return SongWithArtist(song: song, artist: artist);
        })
        .toList();

    _cachedSongWithArtist = songsWithArtist;

    return songsWithArtist;
  }

  @override
  Future<List<SongWithArtist>> fetchSongsByArtistId(String artistId) async {
    final allSongs = await joinArtist();
    return allSongs.where((song) => song.artist.id == artistId).toList();
  }

  @override
  Future<bool> addComment(String artistId, String comment) async {
    final uri = Uri.https(
      'week-nine-database-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/artist/artists/$artistId/comments.json',
    );

    final response = await http.post(uri, body: json.encode(comment));
    return response.statusCode == 200;
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
      if (_cachedSong != null) {
        _cachedSong = _cachedSong!
            .map(
              (song) => song.id == songId
                  ? Song(
                      id: song.id,
                      title: song.title,
                      artist: song.artist,
                      duration: song.duration,
                      image: song.image,
                      like: song.like + 1,
                    )
                  : song,
            )
            .toList();
      }

      if (_cachedSongWithArtist != null) {
        _cachedSongWithArtist = _cachedSongWithArtist!
            .map(
              (item) => item.song.id == songId
                  ? SongWithArtist(
                      artist: item.artist,
                      song: Song(
                        id: item.song.id,
                        title: item.song.title,
                        artist: item.song.artist,
                        duration: item.song.duration,
                        image: item.song.image,
                        like: item.song.like + 1,
                      ),
                    )
                  : item,
            )
            .toList();
      }

      return true;
    }
    return false;
  }
}
