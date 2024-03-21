import 'package:flutter/material.dart';
import 'package:technischer_dienst/shared/presentation/components/td_circle_avatar.dart';

import '../../authentication/domain/Appuser.dart';

class UserDetails extends StatefulWidget {
  final AppUser user;

  const UserDetails({super.key, required this.user});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController uid = TextEditingController();
  bool isEditingMode = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    username.text = widget.user.username;
    email.text = widget.user.email;
    uid.text = widget.user.uid;
  }

  @override
  void dispose() {
    super.dispose();

    username.dispose();
    email.dispose();
    uid.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Stack(
                children: [
                  TdCircleAvatar(
                    url: widget.user.profileImage,
                    radius: 110,
                  ),
                  Positioned(
                      right: 0,
                      top: 0,
                      child: MaterialButton(
                        onPressed: () {},
                        color: Colors.grey,
                        padding: const EdgeInsets.all(16),
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 24,
                        ),
                      ),
                  ),
                ],
              ),
              const Divider(),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextField(
                      controller: username,
                      readOnly: !isEditingMode,
                    ),
                    TextField(
                      controller: email,
                      readOnly: !isEditingMode,
                    ),
                    TextField(
                      controller: uid,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: isEditingMode
              ? Colors.lightGreen
              : Theme.of(context).primaryColor,
          onPressed: () {
            if (isEditingMode) {
              setState(() {
                isEditingMode = false;
              });
            } else {
              isEditingMode = true;
              setState(() {
                isEditingMode = true;
              });
            }
          },
          child:
              isEditingMode ? const Icon(Icons.check) : const Icon(Icons.edit)),
    );
  }
}
