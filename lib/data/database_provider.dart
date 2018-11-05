
import 'package:flutter/widgets.dart';
import 'package:reminder/data/bloc/database_bloc.dart';
import 'package:reminder/data/bloc/firebase_database_bloc.dart';
import 'package:reminder/data/bloc/memory_database_bloc.dart';

enum DatabaseType {
  memory, firestore
}

class _DatabaseWidget extends InheritedWidget {
  final DatabaseBloc _bloc;
  _DatabaseWidget({Widget child, @required DatabaseBloc bloc}): this._bloc = bloc, assert(bloc != null), super(child: child);

  static DatabaseBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_DatabaseWidget) as _DatabaseWidget)._bloc;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

class DatabaseProvider extends StatefulWidget {
  final Widget child;
  final String uuid;
  DatabaseProvider({Key key, this.child, this.uuid}) : super(key: key);
  @override
  DatabaseProviderState createState() {
    return new DatabaseProviderState(uuid: this.uuid);
  }

  static DatabaseBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_DatabaseWidget) as _DatabaseWidget)._bloc;
  }
}

class DatabaseProviderState extends State<DatabaseProvider> {
  static final DatabaseType database = DatabaseType.memory;
  final String uuid;
  final DatabaseBloc bloc;
  
  DatabaseProviderState({this.uuid}):
  this.bloc = database == DatabaseType.firestore ? FirebaseDatabaseBloc(uuid: uuid) : MemoryDatabaseBloc();

  @override
  Widget build(BuildContext context) {
    return _DatabaseWidget(bloc: this.bloc, child: this.widget.child);
  }
}