import 'package:flutter/widgets.dart';
import 'package:reminder/data/bloc/database_bloc.dart';
import 'package:reminder/data/firestore_provider.dart';
import 'package:reminder/data/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FirebaseDatabaseBloc extends DatabaseBloc {
  FirestoreBloc _firestore;
  String uuid;
  String get _remindersPath => this.uuid.length > 0 ? "data/$uuid/reminders/" : "reminders";

  FirebaseDatabaseBloc({this.uuid});

  Future _loader;
  Future loader(BuildContext context) {
    if (_loader == null) {
      _loader = _load(context);
    }
    return _loader;
  }

  Future _load(BuildContext context) async {
    if (this.uuid == null) {
      final prefs = await SharedPreferences.getInstance();
      this.uuid = prefs.getString("uuid") ?? Uuid().v1();
      await prefs.setString("uuid", this.uuid);
    }

    this._firestore = FirestoreProvider.of(context);
    await _firestore.loader(context);
    return;
  }

  // TODO: implement remindersStream
  @override
  Stream<List<ReminderBase>> get remindersStream => this._firestore.instance.collection(this._remindersPath).snapshots().map(
    (snapshot) {
      return snapshot.documents.map((document) {
        final json = document.data;
        json["id"] = document.reference.path;
        final ReminderBase reminder = Reminder.fromJson(json);
        return reminder;
      }).toList();
    }
  );

  @override
  Future update({ReminderBase reminder}) {
    return this._firestore.instance.document(reminder.id).setData(reminder.toJson());
  }

}