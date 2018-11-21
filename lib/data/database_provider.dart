
import 'package:flutter/widgets.dart';
import 'package:reminder/data/bloc/database_bloc.dart';
import 'package:reminder/data/bloc/firebase_database_bloc.dart';
import 'package:reminder/data/bloc/memory_database_bloc.dart';
import 'package:reminder/data/firestore_provider.dart';

enum DatabaseType {
  memory, firestore
}

/// This widget is only used to facilitate Widget lookups for the 
/// [DatabaseProvider].
class _DatabaseWidget extends InheritedWidget {
  final DatabaseBloc _bloc;
  _DatabaseWidget({Widget child, @required DatabaseBloc bloc}): this._bloc = bloc, assert(bloc != null), super(child: child);

  static DatabaseBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_DatabaseWidget) as _DatabaseWidget)._bloc;
  }

  /// The "inheritance" features of this widget are not actually used.
  /// Therefore we can safely always return [false] here.
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

/// This Widget provides the database as a bloc. 
/// 
/// It uses a private InheritedWidget to ensure that lookup can be
/// fast.
class DatabaseProvider extends StatefulWidget {
  final Widget child;
  /// The uuid to be used with firestore to keep data pertaining to
  /// different devices separated. If you want to share data between
  /// two different devices then they should use the same value. It 
  /// does not have to be an actual uuid, but at least a string without
  /// any special characters.
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
    final child =  _DatabaseWidget(bloc: this.bloc, child: this.widget.child);
    if (database == DatabaseType.firestore) {
      return FirestoreProvider(child: child);
    } else {
      return child;
    }
  }
}