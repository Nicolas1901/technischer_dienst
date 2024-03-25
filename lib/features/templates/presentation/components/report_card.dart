import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../Constants/asset_images.dart';

class ReportCard extends StatelessWidget {
  final String reportTitle;

  final Function() onTap;
  final Function() onEdit;
  final Function() onDelete;
  final Function() pickImage;
  final String image;

  final double height;
  final double width;

  const ReportCard({
    super.key,
    required this.reportTitle,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.pickImage,
    required this.image,
    this.width = 300,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: onTap,
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: image,
                  placeholder: (context, url) => Image.asset(
                    AssetImages.noImageTemplate,
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    AssetImages.noImageTemplate,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  width: width,
                  height: height * 0.15,
                  bottom: 0,
                  child: Container(
                    color: Colors.white70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(reportTitle),
                        PopupMenuButton(
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    onTap: onEdit,
                                    child: const Text("Bearbeiten"),
                                  ),
                                  PopupMenuItem(
                                    onTap: onDelete,
                                    child: const Text("Löschen"),
                                  ),
                                  PopupMenuItem(
                                      onTap: pickImage,
                                      child: const Text("Bild hinzufügen"))
                                ])
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
