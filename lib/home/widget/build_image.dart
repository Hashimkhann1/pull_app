import 'package:flutter/material.dart';
import 'package:pull_app/core/assets/app_assets.dart';

class BuildImage extends StatelessWidget {
  const BuildImage({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(AppAssets.image + image),
    );
  }
}
