import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupnotes/core/constants/cloudFireStore/cloud_fire_store_constants.dart';
import 'package:groupnotes/core/constants/enums/locale_keys_enum.dart';
import 'package:groupnotes/core/init/cache/locale_manager.dart';
import 'package:groupnotes/services/cloudnote/cloud_storage_exceptions.dart';
import 'package:groupnotes/views/home/createcharacter/model/user_model.dart';

class CreateUserFirebaseCloudStorage {
  final users = FirebaseFirestore.instance.collection('users');

  static final CreateUserFirebaseCloudStorage _shared = CreateUserFirebaseCloudStorage._sharedInstance();
  CreateUserFirebaseCloudStorage._sharedInstance();
  factory CreateUserFirebaseCloudStorage() => _shared;

  Future<void> deleteUser({required String documentId}) async {
    try {
      await users.doc(documentId).delete();
    } catch (e) {
      throw CouldNoteDeleteNoteException();
    }
  }

  Future<UserModel> createUser({required String ownerUserId, required String name, required String surName}) async {
    final document = await users.add({
      FirestoreDatabaseTextFields.ownerUserIdFieldName: ownerUserId,
      FirestoreDatabaseTextFields.textFieldGender: false,
      FirestoreDatabaseTextFields.textFieldGroupNames: <dynamic>[],
      FirestoreDatabaseTextFields.textFieldName: name,
      FirestoreDatabaseTextFields.textFieldSurName: surName,
    });
    final fetchedUser = await document.get();
    UserModel user = UserModel(
      documentId: fetchedUser.id,
      ownerUsedId: ownerUserId,
      name: fetchedUser['name'] as String,
      surName: fetchedUser['surName'] as String,
      groupNames: fetchedUser['groupNames'] as List<dynamic>,
      gender: fetchedUser['gender'] as bool,
    );
    LocaleManager.instance.setStringValue(PreferencesKeys.DOCUMENTID, fetchedUser.id);
    return user;
  }

  // Future<UserModel> updateUser(bool gender,List<dynamic> groupNames,String name,String surnName) async {

  // }
}