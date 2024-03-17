import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:technischer_dienst/features/templates/domain/template.dart';

//Todo Cache Images

class TemplateRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  late final CollectionReference<Template> _templatesRef;
  late final Reference _storageRef;

  TemplateRepository({
    required this.firestore,
    required this.storage,
  }) {
    _templatesRef = firestore.collection('templates').withConverter(
        fromFirestore: Template.fromFirestore,
        toFirestore: (Template template, _) => template.toFirestore());

    _storageRef = storage.ref();
  }

  Future<DocumentReference<Template>> add(Template template) async {
    try {
      return await _templatesRef.add(template);
    } on Exception catch (e) {
      rethrow;
    }
  }
  //TODO throw error if upload fails
  Future<void> update(Template template, {File? file}) async {
    if(file != null){
      try{
        //upload File to Firebase Storage
        final templateRef = _storageRef.child(template.id);
        final uploadTask =  templateRef.putFile(file);
        uploadTask.whenComplete(() async {
          String path = await templateRef.getDownloadURL();

          Template templateWithImage = template.copyWith(image: path);

          await _templatesRef.doc(template.id).set(templateWithImage);
        });
        debugPrint("File uploaded");
        //set path of File to image attribute of given Template object

      }on Exception catch(e){
        rethrow;
      }

    } else{
      try {
        await _templatesRef.doc(template.id).set(template);
      } on Exception catch (e) {
        rethrow;
      }
    }


  }

  Future<void> delete(String id) async {
    try {
      _storageRef.child(id).delete();
     await _templatesRef.doc(id).delete();
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<Template> get(String id) async {
   try {
     final snapshot = await firestore.collection('templates').doc(id).get();

     Template template = Template.fromFirestore(snapshot, null);

     return template;
   } on Exception catch (e) {
     rethrow;
   }
  }

  Future<List<Template>> getAll() async {
    try {
      final templatesQuery = await _templatesRef.get();

      final List<Template> templates = List.empty(growable: true);

      for(QueryDocumentSnapshot<Template> snapshot in templatesQuery.docs){
        templates.add(snapshot.data());
      }
      return templates;
    }catch (e) {
      rethrow;
    }
  }
}
