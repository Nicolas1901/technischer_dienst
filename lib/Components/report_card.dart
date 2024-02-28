import 'package:flutter/material.dart';

class CardExample extends StatelessWidget {
  const CardExample({
    super.key,
    required this.reportTitle,
    required this.onEdit,
    required this.onDelete, required this.pickImage, required this.image,
  });

  final String reportTitle;

  final Function() onEdit;
  final Function() onDelete;
  final Function() pickImage;
  final ImageProvider image;

  final double height = 200;
  final double width = 300;



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: image)),
            child: SizedBox(
              height: height * 0.15,
              width: width,
              child: Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Colors.white70,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        reportTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
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
            ),
          ),
        ),
      ),
    );
  }
}
