import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:technischer_dienst/features/templates/domain/template.dart';

//Todo Cache Images

class TemplateRepository {
  final FirebaseFirestore firestore;
  late final CollectionReference<Template> _templatesRef;

  TemplateRepository({
    required this.firestore,
  }) {
    _templatesRef = firestore.collection('templates').withConverter(
        fromFirestore: Template.fromFirestore,
        toFirestore: (Template template, _) => template.toFirestore());
  }

  Future<void> add(Template template) async {
    try {
      await _templatesRef.add(template);
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<void> update(Template template, {File? file}) async {
    try {
     await _templatesRef.doc(template.id).set(template);
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
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
