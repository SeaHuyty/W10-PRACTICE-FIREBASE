// song_repository_mock.dart

import 'package:assignment/model/song_with_artist/song_with_artist.dart';

import '../../../model/songs/song.dart';
import 'song_repository.dart';

class SongRepositoryMock implements SongRepository {
  final List<Song> _songs = [
    Song(
      id: 's1',
      title: 'Mock Song 1',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 2, seconds: 50),
      image: Uri.parse('https://images.unsplash.com/photo-1470225620780-dba8ba36b745'),
      like: 0,
    ),
    Song(
      id: 's2',
      title: 'Mock Song 2',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
      image: Uri.parse('https://images.unsplash.com/photo-1470225620780-dba8ba36b745'),
      like: 0,
    ),
    Song(
      id: 's3',
      title: 'Mock Song 3',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
      image: Uri.parse('https://images.unsplash.com/photo-1470225620780-dba8ba36b745'),
      like: 0,
    ),
    Song(
      id: 's4',
      title: 'Mock Song 4',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
      image: Uri.parse('https://images.unsplash.com/photo-1470225620780-dba8ba36b745'),
      like: 0,
    ),
    Song(
      id: 's5',
      title: 'Mock Song 5',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
      image: Uri.parse('https://images.unsplash.com/photo-1470225620780-dba8ba36b745'),
      like: 0,
    ),
  ];

  @override
  Future<List<Song>> fetchSongs() async {
    return Future.delayed(Duration(seconds: 4), () {
      throw Exception("G3 and G4 the class is finished");
    });
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    return Future.delayed(Duration(seconds: 4), () {
      return _songs.firstWhere(
        (song) => song.id == id,
        orElse: () => throw Exception("No song with id $id in the database"),
      );
    });
  }

  @override
  Future<bool> likeSong(String songId, int currentLike) {
    throw UnimplementedError();
  }

  @override
  Future<List<SongWithArtist>> joinArtist() {
    throw UnimplementedError();
  }
}
