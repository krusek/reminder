import 'package:flutter/widgets.dart';
import 'package:reminder/data/bloc/database_bloc.dart';

class MemoryDatabaseBloc extends DatabaseBloc {

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