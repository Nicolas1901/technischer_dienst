import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technischer_dienst/Constants/asset_images.dart';
import 'package:technischer_dienst/features/templates/presentation/show_templates.dart';

import '../application/AuthBloc/auth_bloc.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool inputIsObscured = true;
  bool loginFailed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          heightFactor: 1,
          widthFactor: 0.8,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: 200,
                    child: Image.asset(
                      AssetImages.logo,
                      fit: BoxFit.contain,
                    )),
                Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: "Name oder Email-Adresse",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Name oder Email eingeben";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: inputIsObscured,
                          autocorrect: false,
                          enableSuggestions: false,
                          decoration: InputDecoration(
                            hintText: "Passwort",
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    inputIsObscured = !inputIsObscured;
                                  });
                                },
                                child: const Icon(Icons.remove_red_eye)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Passwort eingeben";
                            }
                            return null;
                          },
                        ),
                        if (loginFailed == true)
                          const Text(
                              style: TextStyle(color: Colors.red),
                              "Benutzername oder Passwort ist falsch"),
                        BlocListener<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is Authenticated) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const ShowTemplates(
                                          title: "Vorlagen")));
                            }
                            if (state is LoginFailed) {
                              debugPrint(state.message);
                              setState(() {
                                loginFailed = true;
                              });
                            }
                          },
                          child: TextButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  debugPrint("login");
                                  context
                                      .read<AuthBloc>()
                                      .add(Authentication(
                                      usernameOrEmail: emailController.text.trim(),
                                      password: passwordController.text)
                                  );
                                }
                              },
                              child: const Text("Einloggen")),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
