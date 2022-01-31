import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ledger/services/services.dart';
import 'dart:async';
import './globals.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('Test');

class Database {
  static Future<void> addItem({
    String title,
    String description,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc('12345678').collection('items').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }
}

class Document<T> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;
  DocumentReference ref;

  Document({this.path}) {
    ref = _db.doc(path);
  }

  Future<T> getData() {
    return ref.get().then((v) => Global.models[T](v.data) as T);
  }

  Stream<T> streamData() {
    return ref.snapshots().map((v) => Global.models[T](v.data) as T);
  }

  Future<void> upsert(Map data) {
    return ref.set(Map<String, dynamic>.from(data), SetOptions(merge: true));
  }
}

class Collection<T> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;
  final List searchText;
  final List endSearchList;
  CollectionReference ref;

  Collection({this.path, this.searchText, this.endSearchList}) {
    ref = _db.collection(path);
  }

  Future<List<T>> getData() async {
    var snapshots = await ref.get();
    return snapshots.docs
        .map((doc) => Global.models[T](doc.data) as T)
        .toList();
  }

  Future<List<T>> getName() async {
    var snapshot = await ref
        .orderBy('insense_name')
        .startAt(searchText)
        .endAt(endSearchList)
        .get();
    return snapshot.docs.map((doc) => Global.models[T](doc.data) as T).toList();
  }

  Future<List<T>> getUsers() async {
    var snapshot = await ref.orderBy('insense_name', descending: false).get();
    return snapshot.docs.map((doc) => Global.models[T](doc.data) as T).toList();
  }

  Future<List<T>> getHosts() async {
    var snapshot = await ref.where('epaystatus', isEqualTo: true).get();
    return snapshot.docs.map((doc) => Global.models[T](doc.data) as T).toList();
  }

  Future<List<T>> getOwed() async {
    var snapshot = await ref.where('balance', isGreaterThan: 0).get();
    return snapshot.docs.map((doc) => Global.models[T](doc.data) as T).toList();
  }

  Future<List<T>> getOwes() async {
    var snapshot = await ref.where('balance', isLessThan: 0).get();
    return snapshot.docs.map((doc) => Global.models[T](doc.data) as T).toList();
  }

  Future<List<T>> getSplits() async {
    var snapshot = await ref.where('split', isGreaterThan: 0).get();
    return snapshot.docs.map((doc) => Global.models[T](doc.data) as T).toList();
  }

  Future<List<T>> getHistory() async {
    var snapshot = await ref.orderBy('historyDate', descending: true).get();
    return snapshot.docs.map((doc) => Global.models[T](doc.data) as T).toList();
  }

  Future<List<T>> getExpenseHistory() async {
    var snapshot =
        await ref.where('historyTransaction', isEqualTo: 'EXPENSE').get();
    return snapshot.docs.map((doc) => Global.models[T](doc.data) as T).toList();
  }

  Future<List<T>> getDonationHistory() async {
    var snapshot =
        await ref.where('historyTransaction', isEqualTo: 'DONATION').get();
    return snapshot.docs.map((doc) => Global.models[T](doc.data) as T).toList();
  }

  Future<List<T>> getTipHistory() async {
    var snapshot = await ref.where('historyTransaction',
        whereIn: ['TURN IN TIPS', 'TRANSFER TIPS']).get();
    return snapshot.docs.map((doc) => Global.models[T](doc.data) as T).toList();
  }

  Future<List<T>> getUserHistory(String uid) async {
    var snapshot = await ref
        .where('uid', isEqualTo: uid)
        .orderBy('historyDate', descending: true)
        .get();
    return snapshot.docs.map((doc) => Global.models[T](doc.data) as T).toList();
  }

  Future<List<T>> getUserBuyInHistory(String uid) async {
    var snapshot = await ref.where('uid', isEqualTo: uid).where(
        'historyTransaction',
        whereIn: ['CASH BUY', 'MARKER BUY', 'E-CASH BUY']).get();
    return snapshot.docs.map((doc) => Global.models[T](doc.data) as T).toList();
  }

  Future<List<T>> getUserChipTurnInHistory(String uid) async {
    var snapshot = await ref
        .where('uid', isEqualTo: uid)
        .where('historyTransaction', isEqualTo: 'CHIP TURN IN')
        .get();
    return snapshot.docs.map((doc) => Global.models[T](doc.data) as T).toList();
  }

  Future<List<T>> getUserPayBalanceHistory(String uid) async {
    var snapshot = await ref
        .where('uid', isEqualTo: uid)
        .where('historyTransaction', whereIn: [
      'DEPOSIT CASH',
      'DEPOSIT E-CASH',
      'WITHDRAWL CASH',
      'WITHDRAWL E-CASH',
    ]).get();
    return snapshot.docs.map((doc) => Global.models[T](doc.data) as T).toList();
  }

  Future<List<T>> getUserTipsHistory(String uid) async {
    var snapshot = await ref.where('uid', isEqualTo: uid).where(
        'historyTransaction',
        whereIn: ['TURN IN TIPS', 'TRANSFER TIPS']).get();
    return snapshot.docs.map((doc) => Global.models[T](doc.data) as T).toList();
  }

  Future<List<T>> getUserDonationHistory(String uid) async {
    var snapshot = await ref
        .where('uid', isEqualTo: uid)
        .where('historyTransaction', isEqualTo: 'DONATION')
        .get();
    return snapshot.docs.map((doc) => Global.models[T](doc.data) as T).toList();
  }

  Future<List<T>> getUserExpenseHistory(String uid) async {
    var snapshot = await ref
        .where('uid', isEqualTo: uid)
        .where('historyTransaction', isEqualTo: 'EXPENSE')
        .get();
    return snapshot.docs.map((doc) => Global.models[T](doc.data) as T).toList();
  }

  Stream<List<T>> streamData() {
    return ref
        .snapshots()
        .map((list) => list.docs.map((doc) => Global.models[T](doc.data) as T));
  }

  Stream<List<History>> streamHistory() {
    return ref.orderBy('historyDate', descending: true).snapshots().map(
        (list) => list.docs.map((doc) => History.fromFirestore(doc)).toList());
  }
}
