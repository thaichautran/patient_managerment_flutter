import 'package:flutter_app/app/models/patient.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Patient.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async {
      await db.execute(
        '''CREATE TABLE Patient(
              id INTEGER PRIMARY KEY,
              hovaten TEXT,
              socon INTEGER,
              namsinh INTEGER,
              sohoso TEXT,
              diachi TEXT,
              gioitinh TEXT,
              nghenghiep TEXT,
              ngaytao TEXT,
              ngayketthuc TEXT,
              tuoi INTEGER,
              medicalRecords TEXT
            );''',
      );
    }, onUpgrade: (db, oldVersion, newVersion) async {
      await db.execute(
        '''CREATE TABLE Patient(
              id INTEGER PRIMARY KEY,
              hovaten TEXT,
              socon INTEGER,
              namsinh INTEGER,
              sohoso TEXT,
              diachi TEXT,
              gioitinh TEXT,
              nghenghiep TEXT,
              ngaytao TEXT,
              ngayketthuc TEXT,
              tuoi INTEGER,
              medicalRecords TEXT
            );''',
      );
    }, version: _version);
  }

  static Future<int> addPatient(Patient patient) async {
    final db = await _getDB();
    return await db.insert("Patient", patient.toText(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> addPatients(List<Patient> patients) async {
    final db = await _getDB();
    final batch = db.batch();

    for (var patient in patients) {
      batch.insert("Patient", patient.toText(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit();
  }

  static Future<void> updatePatients(List<Patient> patients) async {
    final db = await _getDB();
    final batch = db.batch();
    for (var patient in patients) {
      batch.update("Patient", patient.toText(),
          where: 'id = ?',
          whereArgs: [patient.id],
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit();
  }

  static Future<void> asyncPatients(List<Patient> patients) async {
    final db = await _getDB();
    final batch = db.batch();
    await db.delete("Patient");

    for (var patient in patients) {
      batch.insert("Patient", patient.toText(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit();
  }

  static Future<int> updatePatient(Patient patient) async {
    final db = await _getDB();

    return await db.update("Patient", patient.toText(),
        where: 'id = ?',
        whereArgs: [patient.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deleteDatabase(String path) =>
      databaseFactory.deleteDatabase(path);

  static Future<int> deletePatient(Patient patient) async {
    final db = await _getDB();
    return await db.delete(
      "Patient",
      where: 'id = ?',
      whereArgs: [patient.id],
    );
  }

  static Future<List<Patient>?> getAllPatient() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Patient");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Patient.fromText(maps[index]));
  }

  static Future<Patient?> getPatient(int patientId) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps =
        await db.query("Patient", where: 'id = ?', whereArgs: [patientId]);

    if (maps.isEmpty) {
      return null;
    }

    return Patient.fromText(maps.first);
  }
}
