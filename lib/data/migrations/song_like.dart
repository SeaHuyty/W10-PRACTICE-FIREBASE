import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> populateSongLikes() async {
  final Uri songsUri = Uri.https('week-nine-database-default-rtdb.asia-southeast1.firebasedatabase.app', '/artist/songs.json');

  final http.Response response = await http.get(songsUri);

  if (response.statusCode != 200) {
    print('Failed');
    return;
  }

  if (response.body == 'null') {
    print('No Songs');
  }

  final Map<String, dynamic> songsJson = json.decode(response.body) as Map<String, dynamic>;

  final Map<String, dynamic> updates = {};
   
  songsJson.forEach((songId, songData) {
    updates['$songId/like'] = 0;
  });

  final http.Response update = await http.patch(songsUri, body: json.encode(updates));

  if (update.statusCode == 200) {
    print('Success');
  } else {
    print('Failed');
  }
}

void main() async {
  populateSongLikes();
}