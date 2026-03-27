import 'package:assignment/model/artists/artist.dart';

abstract class ArtistsRepository {
  Future<List<Artist>> fetchArtists();
}