part of 'sqlite_bloc.dart';

abstract class SqliteEvent extends Equatable {
  const SqliteEvent();
  @override
  List<Object?> get props => [];
}

class SqliteEventQuery extends SqliteEvent {}

class SqliteEventInsert extends SqliteEvent {
  final SqliteModel payload;
  SqliteEventInsert(this.payload);
}
