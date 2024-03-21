import 'package:flutter/material.dart';

import '../../../enums/roles.dart';
import '../../../shared/presentation/components/td_circle_avatar.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController role = TextEditingController();
  final TextEditingController organisation = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController repeatPassword = TextEditingController();

  String path = "";

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    role.dispose();
    email.dispose();
    username.dispose();
    password.dispose();
    organisation.dispose();
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
                    url: path,
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
                    ),
                    TextField(
                      controller: email,
                    ),
                    DropdownMenu<Role>(
                      controller: role,
                      dropdownMenuEntries:
                          Role.values.map<DropdownMenuEntry<Role>>((Role role) {
                        return DropdownMenuEntry(
                            value: role, label: role.label);
                      }).toList(),
                    ),
                    TextField(
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      controller: password,
                    ),

                    TextField(
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      controller: repeatPassword,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //TODO validate form and create user if validate
        onPressed: (){},
      ),
    );
  }


}
