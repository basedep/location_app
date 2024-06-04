import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_app/FriendsList.dart';

Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('664f69c700372272fd48')
    .setSelfSigned(status: true);

Account account  = Account(client);
Databases database = Databases(client);


Future<String> createUser(String name, String email, String password) async{
  try{
      await account.create(userId: ID.unique(), email: email, password: password, name: name);
      return "success";
  } on AppwriteException catch(e){
    return e.message.toString();
  }
}


Future<String> createUserDocument(String name, String email, String password) async{
  try{
    var id = ID.unique();
    var friendsList = {
      'user_id': id,
    };

    var user = {
      'name': name,
      'latitude': 0.0,
      'longitude': 0.0,
      'friendsListId': id
    };
    await database.createDocument(databaseId: "664f77020036e01a3de9", collectionId: "664f824f000015cf6b6f", documentId: id, data: user);
    await database.createDocument(databaseId: "664f77020036e01a3de9", collectionId: "6654c76500373a6edd5f", documentId: id, data: friendsList);
    return "success";
  } on AppwriteException catch(e){
    return e.message.toString();
  }
}

Future<DocumentList?> getAddedFriend(List<dynamic> id) async{
 try{
   final response = await database.listDocuments(databaseId: "664f77020036e01a3de9", collectionId: "664f824f000015cf6b6f",queries: [Query.equal("\$id", id)]);
   return response;
  } on AppwriteException catch(e){
    return null;
  }
}


Future updateFriendsList(FriendsList friends) async{
  try{

    var friendsList = {
      'arrayOfFriendsId': friends.arrayOfFriendsId,
    };

    final user = await getUser();
    final userDocumentId = await getDocumentId(user!.name);
    final response = await database.updateDocument(
        databaseId: "664f77020036e01a3de9",
        collectionId: "6654c76500373a6edd5f",
        documentId: userDocumentId,
        data: friendsList
    );

  } on AppwriteException catch(e){
    return e.message.toString();
  }
}

// Login and create new session
Future<String> loginUser(String email, String password) async {
  try {
    await account.createEmailPasswordSession(email: email, password: password);
    return "success";
  } on AppwriteException catch (e) {
    return e.message.toString();
  }
}

// check if user session is active or not
Future<bool> checkSessions() async {
  try {
    await account.getSession(sessionId: "current");
    return true;
  } catch (e) {
    return false;
  }
}

// logout the user delete the session
Future logoutUser() async {
  await account.deleteSession(sessionId: "current");
}

// get details of the user logged in
Future<User?> getUser() async {
  try {
    final user = await account.get();
    return user;
  } catch (e) {
    return null;
  }
}

// send verification mail to the user
Future<bool> sendVerificationMail() async {
  try {
    await account.createVerification(
        url:
        "https://reset-password-and-verify-email-appwrite.onrender.com/verify");
    return true;
  } catch (e) {
    return false;
  }
}

// send recovery mail to the user
Future<bool> sendRecoveryMail(String email) async {
  try {
    await account.createRecovery(
        email: email,
        url:
        "https://reset-password-and-verify-email-appwrite.onrender.com/recovery");
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

// continue with google
Future<bool> continueWithGoogle() async {
  try {
    final response = await account
        .createOAuth2Session(provider: OAuthProvider.google, scopes: ["profile", "email"]);
    print(response);
    return true;
  } catch (e) {
    print("error : ${e.toString()}");
    return false;
  }
}


Future<String> getDocumentId(String username) async {
  try {
    final response = await database.listDocuments(databaseId: "664f77020036e01a3de9", collectionId: "664f824f000015cf6b6f", queries: [Query.equal("name", username)]);
    return response.documents.first.$id;
  } catch (e) {
    return "";
  }
}


Future<DocumentList?> getAllUsers() async {
  try {
    final response = await database.listDocuments(databaseId: "664f77020036e01a3de9", collectionId: "664f824f000015cf6b6f");
    return response;
  } catch (e) {
    return null;
  }
}

Future<DocumentList?> getFriendsList() async {
  try {
    final user = await getUser();
    final userDocumentId = await getDocumentId(user!.name);
    final response = await database.listDocuments(databaseId: "664f77020036e01a3de9", collectionId: "6654c76500373a6edd5f",queries: [Query.equal("user_id", userDocumentId)]);
    return response;
  } catch (e) {
    print("error : ${e.toString()}");
    return null;
  }
}

Future updateUserLocation(LatLng location) async {
  try {

    var newLocation = {
      'latitude': location.latitude,
      'longitude': location.longitude
    };

    final user = await getUser();
    final userDocumentId = await getDocumentId(user!.name);
    final response = await database.updateDocument(
      databaseId: "664f77020036e01a3de9",
      collectionId: "664f824f000015cf6b6f",
      documentId: userDocumentId,
      data: newLocation
      );
  } catch (e) {
    print("error : ${e.toString()}");
  }
}

