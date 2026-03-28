import 'package:assignment/model/artists/artist.dart';
import 'package:assignment/model/comments/comment_model.dart';

class ArtistDto {
  static const String idKey = 'id';
  static const String nameKey = 'name';
  static const String genreKey = 'genre';
  static const String imageKey = 'imageUrl';
  static const String commentKey = 'comments';

  static Artist fromJson(Map<String, dynamic> json) {
    assert(json[idKey] is String);
    assert(json[nameKey] is String);
    assert(json[genreKey] is String);
    assert(json[imageKey] is String);

    Map<String, dynamic> commentsMap =
        json[commentKey] as Map<String, dynamic>;
    List<CommentModel> commentModel = commentsMap.values
        .map((comment) => CommentModel(comment: comment.toString()))
        .toList();

    return Artist(
      id: json[idKey],
      name: json[nameKey],
      genre: json[genreKey],
      image: Uri.parse(json[imageKey]),
      comments: commentModel,
    );
  }

  Map<String, dynamic> toJson(Artist artist) {
    return {
      idKey: artist.id,
      nameKey: artist.name,
      genreKey: artist.genre,
      imageKey: artist.image.toString(),
      commentKey: artist.comments,
    };
  }
}
