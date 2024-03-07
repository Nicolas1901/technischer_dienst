import 'package:pocketbase/pocketbase.dart';
import 'package:technischer_dienst/Constants/db_connection.dart';

class dbContext {

  static final PocketBase pb = PocketBase(DbConnectionString.url);

  factory dbContext(String url){
    return dbContext._(url);
  }

  dbContext._(String url);
}