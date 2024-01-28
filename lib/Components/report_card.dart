import 'package:flutter/material.dart';

class CardExample extends StatelessWidget {
  const CardExample({
    super.key,
    required this.reportTitle,
    required this.onEdit,
    required this.onDelete,
  });

  final String reportTitle;

  final Function() onEdit;
  final Function() onDelete;

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
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage('https://picsum.photos/200/300'))),
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
                                child: Text("Bearbeiten"),
                                onTap: onEdit,
                              ),
                              PopupMenuItem(
                                child: const Text("Löschen"),
                                onTap: onDelete,
                              ),
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
