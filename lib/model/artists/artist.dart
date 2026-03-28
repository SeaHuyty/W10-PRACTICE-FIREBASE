import 'package:assignment/model/comments/comment_model.dart';

class Artist {
  final String id;
  final String name;
  final String genre;
  final Uri image;
  final List<CommentModel> comments;

  const Artist({
    required this.id,
    required this.name,
    required this.genre,
    required this.image,
    required this.comments,
  });

  @override
  String toString() {
    return 'Song(id: $id, Name: $name, genre: $genre, image: $image)';
  }
}
