import 'package:flutter/material.dart';
import 'sqflite_db.dart';

class DbProvider with ChangeNotifier {
  final FitDatabase db;

  DbProvider(this.db);
}
