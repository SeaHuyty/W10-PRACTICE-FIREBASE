import 'package:assignment/data/repositories/artists/artists_repository.dart';
import 'package:assignment/ui/screens/artists/view_model/artists_viewmodel.dart';
import 'package:assignment/ui/screens/artists/widgets/artists_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistsScreen extends StatelessWidget {
  const ArtistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArtistsViewmodel(
        artistsRepository: context.read<ArtistsRepository>(),
      ),
      child: ArtistsContent(),
    );
  }
}
