import 'package:flutter_app/app/models/patient.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Patient.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async =>
            await db.execute('''CREATE TABLE Patient(
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
              medicalRecords JSON DEFAULT('[]'));
            );'''),
        version: _version);
  }

  static Future<int> addPatient(Patient patient) async {
    final db = await _getDB();
    return await db.insert("Patient", patient.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> addPatients(List<Patient> patients) async {
    final db = await _getDB();
    final batch = db.batch();

    for (var patient in patients) {
      batch.insert("Patient", patient.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit();
  }

  static Future<int> updatePatient(Patient patient) async {
    final db = await _getDB();
    return await db.update("Patient", patient.toJson(),
        where: 'id = ?',
        whereArgs: [patient.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // static Future<int> deletePatient(Patient patient) async {
  //   final db = await _getDB();
  //   return await db.delete(
  //     "Patient",
  //     where: 'id = ?',
  //     whereArgs: [patient.id],
  //   );
  // }

  static Future<List<Patient>?> getAllPatient() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Patient");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Patient.fromJson(maps[index]));
  }

  static Future<Patient?> getPatient(int patientId) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps =
        await db.query("Patient", where: 'id = ?', whereArgs: [patientId]);

    if (maps.isEmpty) {
      return null;
    }

    return Patient.fromJson(maps.first);
  }
}
