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
                          controller: username,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Benutzername",
                          ),
                          validator: (input) {
                            if (input != null && input.isNotEmpty) return null;
                            return "Benutzername darf nicht leer sein";
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                            controller: email,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Email",
                            ),
                            validator: (input) {
                              if (input != null && input.isNotEmpty) {
                                return null;
                              }
                              return "Email darf nicht leer sein";
                            }),
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
                            controller: password,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Passwort",
                            ),
                            obscureText: true,
                            autocorrect: false,
                            enableSuggestions: false,
                            validator: (input) {
                              if (input != null && input.isNotEmpty) {
                                return null;
                              }
                              return "Passwort darf nicht leer sein";
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                            controller: repeatPassword,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Passwort wiederholen",
                            ),
                            obscureText: true,
                            autocorrect: false,
                            enableSuggestions: false,
                            validator: (input) {
                              if (input == password.text) {
                                return null;
                              }
                              return "Passwörter stimmen nicht überein";
                            }),
                      ),
                      TextButton(
                        onPressed: () {
                          if(formKey.currentState!.validate()){
                            debugPrint("validate");
                          }
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                            foregroundColor: Colors.black),
                        child: const Text(
                          "Speichern",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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
  
  bool _checkPassword(String password){
    //TODO regex for passwort security
    return password.length >= 8;
  }
}
