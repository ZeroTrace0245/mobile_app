import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'data_models.dart';
import 'journal_screen.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mediplus.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Health Records Table
    await db.execute('''
      CREATE TABLE health_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profileName TEXT,
        data TEXT
      )
    ''');

    // Journal Table
    await db.execute('''
      CREATE TABLE journal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        mood TEXT,
        date TEXT
      )
    ''');

    // Appointments Table
    await db.execute('''
      CREATE TABLE appointments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        doctorName TEXT,
        location TEXT,
        dateTime INTEGER,
        notes TEXT
      )
    ''');

    // Medications Table
    await db.execute('''
      CREATE TABLE medications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        dosage TEXT,
        frequency TEXT,
        time TEXT,
        isTaken INTEGER
      )
    ''');
  }

  // --- Health Records ---
  Future<int> insertHealthRecord(HealthRecord record) async {
    Database db = await database;
    int id = await db.insert('health_records', {
      'profileName': record.profileName,
      'data': '', // Placeholder
    });
    // Update with real ID in the JSON
    final updatedRecord = HealthRecord(
      id: id,
      profileName: record.profileName,
      personalInfo: record.personalInfo,
      bloodType: record.bloodType,
      allergies: record.allergies,
      medicalConditions: record.medicalConditions,
      emergencyContact: record.emergencyContact,
      insuranceInfo: record.insuranceInfo,
    );
    await db.update('health_records', {'data': updatedRecord.toJson()}, where: 'id = ?', whereArgs: [id]);
    return id;
  }

  Future<List<HealthRecord>> getHealthRecords() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('health_records');
    return maps.map((item) {
      final record = HealthRecord.fromJson(item['data']);
      // Ensure the ID from the database is used
      return HealthRecord(
        id: item['id'],
        profileName: record.profileName,
        personalInfo: record.personalInfo,
        bloodType: record.bloodType,
        allergies: record.allergies,
        medicalConditions: record.medicalConditions,
        emergencyContact: record.emergencyContact,
        insuranceInfo: record.insuranceInfo,
      );
    }).toList();
  }

  Future<int> updateHealthRecord(HealthRecord record) async {
    Database db = await database;
    return await db.update(
      'health_records',
      {'data': record.toJson()},
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteHealthRecord(int id) async {
    Database db = await database;
    return await db.delete('health_records', where: 'id = ?', whereArgs: [id]);
  }

  // --- Journal ---
  Future<int> insertJournalEntry(JournalEntry entry) async {
    Database db = await database;
    return await db.insert('journal', {
      'title': entry.title,
      'content': entry.content,
      'mood': entry.mood,
      'date': entry.date.toIso8601String(),
    });
  }

  Future<List<JournalEntry>> getJournalEntries() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('journal', orderBy: 'date DESC');
    return maps.map((item) => JournalEntry(
      id: item['id'],
      title: item['title'],
      content: item['content'],
      mood: item['mood'],
      date: DateTime.parse(item['date']),
    )).toList();
  }

  // --- Appointments ---
  Future<int> insertAppointment(Appointment app) async {
    Database db = await database;
    return await db.insert(
      'appointments',
      app.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Appointment>> getAppointments() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('appointments', orderBy: 'dateTime ASC');
    return maps.map((item) => Appointment.fromMap(item)).toList();
  }

  Future<int> deleteAppointment(int id) async {
    Database db = await database;
    return await db.delete('appointments', where: 'id = ?', whereArgs: [id]);
  }

  // --- Medications ---
  Future<int> insertMedication(Medication med) async {
    Database db = await database;
    return await db.insert('medications', med.toMap());
  }

  Future<List<Medication>> getMedications() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('medications');
    return maps.map((item) => Medication.fromMap(item)).toList();
  }

  Future<int> updateMedication(Medication med) async {
    Database db = await database;
    return await db.update('medications', med.toMap(), where: 'id = ?', whereArgs: [med.id]);
  }

  Future<int> deleteMedication(int id) async {
    Database db = await database;
    return await db.delete('medications', where: 'id = ?', whereArgs: [id]);
  }
}
