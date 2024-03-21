import 'package:flutter/material.dart';
import 'package:technischer_dienst/Constants/asset_images.dart';

class TdCircleAvatar extends StatefulWidget {
  final String url;
  double? radius;

  TdCircleAvatar({super.key, required this.url, this.radius});

  @override
  State<TdCircleAvatar> createState() => _TdCircleAvatarState();
}

class _TdCircleAvatarState extends State<TdCircleAvatar> {
  ImageProvider backgroundImage = const AssetImage(AssetImages.noImageUser);


  @override
  Widget build(BuildContext context) {
    return CircleAvatar(backgroundImage: backgroundImage, foregroundImage: _resolveImage(widget.url), radius: widget.radius,);
  }

  ImageProvider? _resolveImage(String url){
    if(url.isNotEmpty){
      try{
        return NetworkImage(url);
      }catch(e){
        debugPrint(e.toString());
      }
    }
    return null;
  }
}
