// Mocks generated by Mockito 5.3.2 from annotations
// in fit_db_project/test/widget_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:fit_db_project/exercise_model.dart' as _i4;
import 'package:fit_db_project/sqflite_db.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [FitDatabase].
///
/// See the documentation for Mockito's code generation for more information.
class MockFitDatabase extends _i1.Mock implements _i2.FitDatabase {
  MockFitDatabase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get dbName => (super.noSuchMethod(
        Invocation.getter(#dbName),
        returnValue: '',
      ) as String);
  @override
  set dbName(String? _dbName) => super.noSuchMethod(
        Invocation.setter(
          #dbName,
          _dbName,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set database(dynamic _database) => super.noSuchMethod(
        Invocation.setter(
          #database,
          _database,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i3.Future<void> openDB() => (super.noSuchMethod(
        Invocation.method(
          #openDB,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> insertExercise(_i4.Exercise? exercise) =>
      (super.noSuchMethod(
        Invocation.method(
          #insertExercise,
          [exercise],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> insertChartData(
    _i4.Exercise? exercise,
    int? progress,
    String? progressTimes,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #insertChartData,
          [
            exercise,
            progress,
            progressTimes,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> updateChartData(
    _i4.Exercise? exercise,
    int? progress,
    String? progressTimes,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateChartData,
          [
            exercise,
            progress,
            progressTimes,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<List<_i4.Exercise>> getExercises() => (super.noSuchMethod(
        Invocation.method(
          #getExercises,
          [],
        ),
        returnValue: _i3.Future<List<_i4.Exercise>>.value(<_i4.Exercise>[]),
      ) as _i3.Future<List<_i4.Exercise>>);
  @override
  _i3.Future<void> updateExercise(_i4.Exercise? exercise) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateExercise,
          [exercise],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> deleteExercise(int? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteExercise,
          [id],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  Map<String, dynamic> mapChart(
    int? exercise,
    int? progress,
    String? progressTimes,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #mapChart,
          [
            exercise,
            progress,
            progressTimes,
          ],
        ),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);
  @override
  _i3.Future<void> deleteDatabase() => (super.noSuchMethod(
        Invocation.method(
          #deleteDatabase,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
