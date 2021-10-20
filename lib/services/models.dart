import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String uid;
  String name;
  String insenseName;
  String description;
  String telegram;
  String color;
  bool employeestatus;
  bool epaystatus;
  bool active;
  int balance;
  int ebalance;
  int tips;
  int split;

  Report(
      {this.uid,
      this.name,
      this.insenseName,
      this.description,
      this.employeestatus,
      this.epaystatus,
      this.telegram,
      this.color,
      this.active,
      this.balance,
      this.ebalance,
      this.tips,
      this.split});

  factory Report.fromMap(Map data) {
    return Report(
      uid: data['uid'],
      name: data['name'],
      insenseName: data['insense_name'],
      description: data['description'] ?? '',
      employeestatus: data['employeestatus'] ?? false,
      epaystatus: data['epaystatus'] ?? false,
      telegram: data['telegram'] ?? '',
      color: data['color'],
      active: data['active'] ?? false,
      balance: data['balance'],
      ebalance: data['ebalance'],
      tips: data['tips'],
      split: data['split'],
    );
  }
}

class Owes {
  String insenseName;
  int balance;

  Owes({
    this.insenseName,
    this.balance,
  });

  factory Owes.fromMap(Map data) {
    return Owes(
      insenseName: data['insense_name'],
      balance: data['balance'],
    );
  }
}

class Owed {
  String insenseName;
  int balance;

  Owed({
    this.insenseName,
    this.balance,
  });

  factory Owed.fromMap(Map data) {
    return Owed(
      insenseName: data['insense_name'],
      balance: data['balance'],
    );
  }
}

class Game {
  int cashOH;
  int chipsOH;
  int ecashOH;
  int donation;
  int expenses;
  int tax;
  int gameNumber;
  bool gameSwitch;
  Map hosts;

  Game({
    this.cashOH,
    this.chipsOH,
    this.ecashOH,
    this.donation,
    this.expenses,
    this.tax,
    this.gameNumber,
    this.gameSwitch,
    this.hosts,
  });

  factory Game.fromMap(Map data) {
    return Game(
      cashOH: data['cashOH'],
      chipsOH: data['chipsOH'],
      ecashOH: data['ecashOH'],
      donation: data['donation'],
      expenses: data['expenses'],
      tax: data['tax'],
      gameNumber: data['gameNumber'],
      gameSwitch: data['gameSwitch'] ?? false,
      hosts: data['hosts'],
    );
  }
}

class History {
  String historyTransaction;
  String historyPlayer;
  String historyEpay;
  dynamic historyDate;
  String historyAmount;
  String uid;
  String note;
  String date;

  History({
    this.historyTransaction,
    this.historyPlayer,
    this.historyEpay,
    this.historyDate,
    this.historyAmount,
    this.uid,
    this.note,
    this.date,
  });

  factory History.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return History(
      historyTransaction: data['historyTransaction'],
      historyPlayer: data['historyPlayer'],
      historyEpay: data['historyEpay'],
      historyDate: data['historyDate'],
      historyAmount: data['historyAmount'],
      uid: data['uid'],
      note: data['note'],
      date: data['date'],
    );
  }

  factory History.fromMap(Map data) {
    return History(
      historyTransaction: data['historyTransaction'],
      historyPlayer: data['historyPlayer'],
      historyEpay: data['historyEpay'],
      historyDate: data['historyDate'],
      historyAmount: data['historyAmount'],
      uid: data['uid'],
      note: data['note'],
      date: data['date'],
    );
  }
}

class ExpenseHistory {
  String historyTransaction;
  String historyPlayer;
  String historyEpay;
  dynamic historyDate;
  String historyAmount;
  String uid;
  String note;
  String date;

  ExpenseHistory({
    this.historyTransaction,
    this.historyPlayer,
    this.historyEpay,
    this.historyDate,
    this.historyAmount,
    this.uid,
    this.note,
    this.date,
  });

  factory ExpenseHistory.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return ExpenseHistory(
      historyTransaction: data['historyTransaction'],
      historyPlayer: data['historyPlayer'],
      historyEpay: data['historyEpay'],
      historyDate: data['historyDate'],
      historyAmount: data['historyAmount'],
      uid: data['uid'],
      note: data['note'],
      date: data['date'],
    );
  }

  factory ExpenseHistory.fromMap(Map data) {
    return ExpenseHistory(
      historyTransaction: data['historyTransaction'],
      historyPlayer: data['historyPlayer'],
      historyEpay: data['historyEpay'],
      historyDate: data['historyDate'],
      historyAmount: data['historyAmount'],
      uid: data['uid'],
      note: data['note'],
      date: data['date'],
    );
  }
}

class HostSetup {
  String username;
  String password;
  String gameName;

  HostSetup({
    this.username,
    this.password,
    this.gameName,
  });

  factory HostSetup.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return HostSetup(
      username: data['username'],
      password: data['password'],
      gameName: data['gameName'],
    );
  }

  factory HostSetup.fromMap(Map data) {
    return HostSetup(
      username: data['username'],
      password: data['password'],
      gameName: data['gameName'],
    );
  }
}

class Chips {
  int amount_5;
  bool status_5;
  int amount_25;
  bool status_25;
  int amount_100;
  bool status_100;
  int amount_500;
  bool status_500;
  int amount_1000;
  bool status_1000;
  int amount_5000;
  bool status_5000;
  int amount_10000;
  bool status_10000;

  Chips({
    this.amount_5,
    this.status_5,
    this.amount_25,
    this.status_25,
    this.amount_100,
    this.status_100,
    this.amount_500,
    this.status_500,
    this.amount_1000,
    this.status_1000,
    this.amount_5000,
    this.status_5000,
    this.amount_10000,
    this.status_10000,
  });

  factory Chips.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return Chips(
      amount_5: data['5count'],
      amount_25: data['25count'],
      amount_100: data['100count'],
      amount_500: data['500count'],
      amount_1000: data['1000count'],
      amount_5000: data['5000count'],
      amount_10000: data['10000count'],
      status_5: data['5status'],
      status_25: data['25status'],
      status_100: data['100status'],
      status_500: data['500status'],
      status_1000: data['1000status'],
      status_5000: data['5000status'],
      status_10000: data['10000status'],
    );
  }

  factory Chips.fromMap(Map data) {
    return Chips(
      amount_5: data['5count'],
      amount_25: data['25count'],
      amount_100: data['100count'],
      amount_500: data['500count'],
      amount_1000: data['1000count'],
      amount_5000: data['5000count'],
      amount_10000: data['10000count'],
      status_5: data['5status'],
      status_25: data['25status'],
      status_100: data['100status'],
      status_500: data['500status'],
      status_1000: data['1000status'],
      status_5000: data['5000status'],
      status_10000: data['10000status'],
    );
  }
}

class HostSplits {
  String uid;
  String name;
  String insenseName;
  String description;
  String telegram;
  String color;
  bool employeestatus;
  bool epaystatus;
  bool active;
  int balance;
  int ebalance;
  int tips;
  int split;

  HostSplits(
      {this.uid,
      this.name,
      this.insenseName,
      this.description,
      this.employeestatus,
      this.epaystatus,
      this.telegram,
      this.color,
      this.active,
      this.balance,
      this.ebalance,
      this.tips,
      this.split});

  factory HostSplits.fromMap(Map data) {
    return HostSplits(
      uid: data['uid'],
      name: data['name'],
      insenseName: data['insense_name'],
      description: data['description'] ?? '',
      employeestatus: data['employeestatus'] ?? false,
      epaystatus: data['epaystatus'] ?? false,
      telegram: data['telegram'] ?? '',
      color: data['color'],
      active: data['active'] ?? false,
      balance: data['balance'],
      ebalance: data['ebalance'],
      tips: data['tips'],
      split: data['split'],
    );
  }
}
