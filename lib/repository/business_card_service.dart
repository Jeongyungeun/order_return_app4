import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_return_app4/constant/firebase_key.dart';
import 'package:order_return_app4/model/contact_model.dart';

class BusinessCardService {
  static final BusinessCardService _businessCardService =
      BusinessCardService._internal();
  BusinessCardService._internal();
  factory BusinessCardService() => _businessCardService;

  //명함 생성 => database에 넣어준다.
  Future createNewCard(
      ContactModel contactModel, String cardKey, String userKey) async {
    DocumentReference<Map<String, dynamic>> cardDocReference =
        FirebaseFirestore.instance.collection(COL_CARDS).doc(cardKey);

    DocumentReference<Map<String, dynamic>> userCardDocReference =
        FirebaseFirestore.instance
            .collection(COL_USERS)
            .doc(userKey)
            .collection(COL_USER_CARDS)
            .doc(cardKey);

    final DocumentSnapshot documentSnapshot = await cardDocReference.get();

    //존재하지 않으면 넣어준다.
    //transaction  해준다
    if (!documentSnapshot.exists) {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(cardDocReference, contactModel.toJson());
        transaction.set(userCardDocReference, contactModel.toJson());
      });
    }
  }

  Future<List<ContactModel>> getContact(String userKey) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance
            .collection(COL_USERS)
            .doc(userKey)
            .collection(COL_USER_CARDS);
    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionReference
        .get();

    List<ContactModel> contacts=[];
    for (int i =0; i< snapshots.size; i++){
      ContactModel contactModel = ContactModel.fromQuerySnapshot(snapshots.docs[i]);
      contacts.add(contactModel);
    }
    return contacts;
  }
}
