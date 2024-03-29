import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:technischer_dienst/enums/roles.dart';
import 'package:technischer_dienst/features/authentication/domain/Appuser.dart';
import 'package:technischer_dienst/features/templates/application/templateBloc/template_bloc.dart';
import 'package:technischer_dienst/features/templates/domain/template.dart';
import 'package:technischer_dienst/features/templates/presentation/components/report_card.dart';
import 'package:technischer_dienst/shared/presentation/components/td_navigation_drawer.dart';
import '../../../Constants/asset_images.dart';
import '../../../shared/presentation/components/dialog.dart';
import '../../authentication/application/AuthBloc/auth_bloc.dart';
import '../../reports/presentation/create_reports.dart';
import '../application/editTemplateBloc/edit_template_bloc.dart';
import 'edit_templates.dart';

class ShowTemplates extends StatefulWidget {
  const ShowTemplates({super.key, required this.title});

  final String title;

  @override
  State<ShowTemplates> createState() => _ShowTemplatesState();
}

class _ShowTemplatesState extends State<ShowTemplates> {
  final formKey = GlobalKey<FormState>();
  late final AppUser user;

  @override
  initState(){
    super.initState();
    final state = context.read<AuthBloc>().state;
    if(state is Authenticated){
      user = state.user;
    }
  }

  Future<void> buildDialog() {
    TextEditingController addController = TextEditingController();
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              onSave: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditTemplatePage(
                      template: Template(
                        id: Random().nextInt(10000).toString(),
                        name: addController.text,
                        categories: [],
                      ),
                    ),
                  ));
                }
              },
              onAbort: () {
                Navigator.of(context).pop();
              },
              title: "Neue Vorlage",
              child: Form(
                key: formKey,
                child: TextFormField(
                  controller: addController,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Titel darf nicht leer sein";
                    }
                    return null;
                  },
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return TdNavigationDrawer(
              selectedIndex: 0,
              currentUser: state.user,
            );
          } else {
            return const TdNavigationDrawer(
              selectedIndex: 0,
              currentUser: null,
            );
          }
        },
      ),
      body: BlocBuilder<TemplateBloc, TemplateState>(builder: (context, state) {
        if (state is TemplatesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TemplatesLoaded) {
          if (state is TemplateActionFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 3),
            ));
          }

          return Center(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      for (Template tmp in state.templates) ...{
                        ReportCard(
                          reportTitle: tmp.name,
                          image: tmp.image,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CreateReportPage(
                                template: tmp,
                              ),
                            ));
                          },
                          onEdit: () {
                            if (user.role == Role.admin.value || user.role == Role.wart.value) {
                              context
                                  .read<EditTemplateBloc>()
                                  .add(EditTemplateLoad(template: tmp));
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => EditTemplatePage(
                                          template: tmp,
                                          templateExists: true,
                                        )),
                              );
                            }
                          },
                          onDelete: () {
                            if (user.role == Role.admin.value || user.role == Role.wart.value) {
                              context
                                  .read<TemplateBloc>()
                                  .add(DeleteTemplate(template: tmp));
                            }
                          },
                          pickImage: () {
                            if(user.role == Role.admin.value || user.role == Role.wart.value){
                              chooseImageSource(tmp);
                            }

                          },
                        ),
                      }
                    ],
                  ),
                ),
                const SizedBox(height: 70,)
              ],
            ),
          );
        }

        if (state is TemplatesError) {
          debugPrint(state.message);
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('Etwas ist schief gelaufen'));
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          buildDialog();
        },
        tooltip: 'Berichtsvorlage erstellen',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  chooseImageSource(Template tmp) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      context.read<TemplateBloc>().add(AddImage(template: tmp, source: ImageSource.camera));
                    },
                    child: const Column(
                      children: [Icon(Icons.camera_alt), Text("Kamera")],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      context.read<TemplateBloc>().add(
                          AddImage(template: tmp, source: ImageSource.gallery));
                    },
                    child: const Column(
                      children: [Icon(Icons.image), Text("Gallerie")],
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}
