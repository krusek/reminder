import 'package:flutter/widgets.dart';
import 'package:reminder/data/bloc/database_bloc.dart';

class FirebaseDatabaseBloc extends DatabaseBloc {
  final String uuid;
  FirebaseDatabaseBloc({this.uuid});

  Future _loader;
  Future loader(BuildContext context) {
    if (_loader == null) {
      _loader = _load(context);
    }
    return _loader;
  }

  Future _load(BuildContext context) async {
    return;
  }

}