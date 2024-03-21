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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Benutzername",
                          ),
                          controller: username,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Email",
                          ),
                          controller: email,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: DropdownMenu<Role>(
                          expandedInsets: EdgeInsets.zero,
                          controller: role,
                          initialSelection: Role.user,
                          label: const Text("Funktion"),
                          dropdownMenuEntries: Role.values
                              .map<DropdownMenuEntry<Role>>((Role role) {
                            return DropdownMenuEntry(
                                value: role, label: role.label);
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Passwort",
                          ),
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          controller: password,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Passwort wiederholen",
                          ),
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          controller: repeatPassword,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("Speichern", style: TextStyle(fontWeight: FontWeight.bold),),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                            foregroundColor: Colors.black54),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
