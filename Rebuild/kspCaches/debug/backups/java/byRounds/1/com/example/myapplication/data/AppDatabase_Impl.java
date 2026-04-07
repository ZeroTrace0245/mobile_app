package com.example.myapplication.data;

import androidx.annotation.NonNull;
import androidx.room.DatabaseConfiguration;
import androidx.room.InvalidationTracker;
import androidx.room.RoomDatabase;
import androidx.room.RoomOpenHelper;
import androidx.room.migration.AutoMigrationSpec;
import androidx.room.migration.Migration;
import androidx.room.util.DBUtil;
import androidx.room.util.TableInfo;
import androidx.sqlite.db.SupportSQLiteDatabase;
import androidx.sqlite.db.SupportSQLiteOpenHelper;
import java.lang.Class;
import java.lang.Override;
import java.lang.String;
import java.lang.SuppressWarnings;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.annotation.processing.Generated;

@Generated("androidx.room.RoomProcessor")
@SuppressWarnings({"unchecked", "deprecation"})
public final class AppDatabase_Impl extends AppDatabase {
  private volatile HealthRecordDao _healthRecordDao;

  private volatile JournalEntryDao _journalEntryDao;

  private volatile WellnessMetricDao _wellnessMetricDao;

  @Override
  @NonNull
  protected SupportSQLiteOpenHelper createOpenHelper(@NonNull final DatabaseConfiguration config) {
    final SupportSQLiteOpenHelper.Callback _openCallback = new RoomOpenHelper(config, new RoomOpenHelper.Delegate(1) {
      @Override
      public void createAllTables(@NonNull final SupportSQLiteDatabase db) {
        db.execSQL("CREATE TABLE IF NOT EXISTS `health_records` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `profileName` TEXT NOT NULL, `personalInfo` TEXT NOT NULL, `bloodType` TEXT NOT NULL, `allergies` TEXT NOT NULL, `medications` TEXT NOT NULL, `medicalConditions` TEXT NOT NULL, `medicalHistory` TEXT NOT NULL, `emergencyContact` TEXT, `insuranceInfo` TEXT, `doctorContacts` TEXT NOT NULL, `lastUpdated` INTEGER NOT NULL)");
        db.execSQL("CREATE TABLE IF NOT EXISTS `journal_entries` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `date` INTEGER NOT NULL, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `mood` TEXT NOT NULL, `tags` TEXT NOT NULL, `prompt` TEXT)");
        db.execSQL("CREATE TABLE IF NOT EXISTS `wellness_metrics` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `date` INTEGER NOT NULL, `stressLevel` INTEGER NOT NULL, `sleepHours` REAL NOT NULL, `exerciseMinutes` INTEGER NOT NULL, `waterIntakeL` REAL NOT NULL, `notes` TEXT NOT NULL)");
        db.execSQL("CREATE TABLE IF NOT EXISTS room_master_table (id INTEGER PRIMARY KEY,identity_hash TEXT)");
        db.execSQL("INSERT OR REPLACE INTO room_master_table (id,identity_hash) VALUES(42, '49eee46fa02cd0a4f392a4c9fa98406a')");
      }

      @Override
      public void dropAllTables(@NonNull final SupportSQLiteDatabase db) {
        db.execSQL("DROP TABLE IF EXISTS `health_records`");
        db.execSQL("DROP TABLE IF EXISTS `journal_entries`");
        db.execSQL("DROP TABLE IF EXISTS `wellness_metrics`");
        final List<? extends RoomDatabase.Callback> _callbacks = mCallbacks;
        if (_callbacks != null) {
          for (RoomDatabase.Callback _callback : _callbacks) {
            _callback.onDestructiveMigration(db);
          }
        }
      }

      @Override
      public void onCreate(@NonNull final SupportSQLiteDatabase db) {
        final List<? extends RoomDatabase.Callback> _callbacks = mCallbacks;
        if (_callbacks != null) {
          for (RoomDatabase.Callback _callback : _callbacks) {
            _callback.onCreate(db);
          }
        }
      }

      @Override
      public void onOpen(@NonNull final SupportSQLiteDatabase db) {
        mDatabase = db;
        internalInitInvalidationTracker(db);
        final List<? extends RoomDatabase.Callback> _callbacks = mCallbacks;
        if (_callbacks != null) {
          for (RoomDatabase.Callback _callback : _callbacks) {
            _callback.onOpen(db);
          }
        }
      }

      @Override
      public void onPreMigrate(@NonNull final SupportSQLiteDatabase db) {
        DBUtil.dropFtsSyncTriggers(db);
      }

      @Override
      public void onPostMigrate(@NonNull final SupportSQLiteDatabase db) {
      }

      @Override
      @NonNull
      public RoomOpenHelper.ValidationResult onValidateSchema(
          @NonNull final SupportSQLiteDatabase db) {
        final HashMap<String, TableInfo.Column> _columnsHealthRecords = new HashMap<String, TableInfo.Column>(12);
        _columnsHealthRecords.put("id", new TableInfo.Column("id", "INTEGER", true, 1, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsHealthRecords.put("profileName", new TableInfo.Column("profileName", "TEXT", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsHealthRecords.put("personalInfo", new TableInfo.Column("personalInfo", "TEXT", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsHealthRecords.put("bloodType", new TableInfo.Column("bloodType", "TEXT", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsHealthRecords.put("allergies", new TableInfo.Column("allergies", "TEXT", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsHealthRecords.put("medications", new TableInfo.Column("medications", "TEXT", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsHealthRecords.put("medicalConditions", new TableInfo.Column("medicalConditions", "TEXT", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsHealthRecords.put("medicalHistory", new TableInfo.Column("medicalHistory", "TEXT", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsHealthRecords.put("emergencyContact", new TableInfo.Column("emergencyContact", "TEXT", false, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsHealthRecords.put("insuranceInfo", new TableInfo.Column("insuranceInfo", "TEXT", false, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsHealthRecords.put("doctorContacts", new TableInfo.Column("doctorContacts", "TEXT", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsHealthRecords.put("lastUpdated", new TableInfo.Column("lastUpdated", "INTEGER", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        final HashSet<TableInfo.ForeignKey> _foreignKeysHealthRecords = new HashSet<TableInfo.ForeignKey>(0);
        final HashSet<TableInfo.Index> _indicesHealthRecords = new HashSet<TableInfo.Index>(0);
        final TableInfo _infoHealthRecords = new TableInfo("health_records", _columnsHealthRecords, _foreignKeysHealthRecords, _indicesHealthRecords);
        final TableInfo _existingHealthRecords = TableInfo.read(db, "health_records");
        if (!_infoHealthRecords.equals(_existingHealthRecords)) {
          return new RoomOpenHelper.ValidationResult(false, "health_records(com.example.myapplication.data.HealthRecord).\n"
                  + " Expected:\n" + _infoHealthRecords + "\n"
                  + " Found:\n" + _existingHealthRecords);
        }
        final HashMap<String, TableInfo.Column> _columnsJournalEntries = new HashMap<String, TableInfo.Column>(7);
        _columnsJournalEntries.put("id", new TableInfo.Column("id", "INTEGER", true, 1, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsJournalEntries.put("date", new TableInfo.Column("date", "INTEGER", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsJournalEntries.put("title", new TableInfo.Column("title", "TEXT", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsJournalEntries.put("content", new TableInfo.Column("content", "TEXT", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsJournalEntries.put("mood", new TableInfo.Column("mood", "TEXT", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsJournalEntries.put("tags", new TableInfo.Column("tags", "TEXT", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsJournalEntries.put("prompt", new TableInfo.Column("prompt", "TEXT", false, 0, null, TableInfo.CREATED_FROM_ENTITY));
        final HashSet<TableInfo.ForeignKey> _foreignKeysJournalEntries = new HashSet<TableInfo.ForeignKey>(0);
        final HashSet<TableInfo.Index> _indicesJournalEntries = new HashSet<TableInfo.Index>(0);
        final TableInfo _infoJournalEntries = new TableInfo("journal_entries", _columnsJournalEntries, _foreignKeysJournalEntries, _indicesJournalEntries);
        final TableInfo _existingJournalEntries = TableInfo.read(db, "journal_entries");
        if (!_infoJournalEntries.equals(_existingJournalEntries)) {
          return new RoomOpenHelper.ValidationResult(false, "journal_entries(com.example.myapplication.data.JournalEntry).\n"
                  + " Expected:\n" + _infoJournalEntries + "\n"
                  + " Found:\n" + _existingJournalEntries);
        }
        final HashMap<String, TableInfo.Column> _columnsWellnessMetrics = new HashMap<String, TableInfo.Column>(7);
        _columnsWellnessMetrics.put("id", new TableInfo.Column("id", "INTEGER", true, 1, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsWellnessMetrics.put("date", new TableInfo.Column("date", "INTEGER", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsWellnessMetrics.put("stressLevel", new TableInfo.Column("stressLevel", "INTEGER", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsWellnessMetrics.put("sleepHours", new TableInfo.Column("sleepHours", "REAL", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsWellnessMetrics.put("exerciseMinutes", new TableInfo.Column("exerciseMinutes", "INTEGER", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsWellnessMetrics.put("waterIntakeL", new TableInfo.Column("waterIntakeL", "REAL", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        _columnsWellnessMetrics.put("notes", new TableInfo.Column("notes", "TEXT", true, 0, null, TableInfo.CREATED_FROM_ENTITY));
        final HashSet<TableInfo.ForeignKey> _foreignKeysWellnessMetrics = new HashSet<TableInfo.ForeignKey>(0);
        final HashSet<TableInfo.Index> _indicesWellnessMetrics = new HashSet<TableInfo.Index>(0);
        final TableInfo _infoWellnessMetrics = new TableInfo("wellness_metrics", _columnsWellnessMetrics, _foreignKeysWellnessMetrics, _indicesWellnessMetrics);
        final TableInfo _existingWellnessMetrics = TableInfo.read(db, "wellness_metrics");
        if (!_infoWellnessMetrics.equals(_existingWellnessMetrics)) {
          return new RoomOpenHelper.ValidationResult(false, "wellness_metrics(com.example.myapplication.data.WellnessMetric).\n"
                  + " Expected:\n" + _infoWellnessMetrics + "\n"
                  + " Found:\n" + _existingWellnessMetrics);
        }
        return new RoomOpenHelper.ValidationResult(true, null);
      }
    }, "49eee46fa02cd0a4f392a4c9fa98406a", "79991dbb4c16a467c147339339785b02");
    final SupportSQLiteOpenHelper.Configuration _sqliteConfig = SupportSQLiteOpenHelper.Configuration.builder(config.context).name(config.name).callback(_openCallback).build();
    final SupportSQLiteOpenHelper _helper = config.sqliteOpenHelperFactory.create(_sqliteConfig);
    return _helper;
  }

  @Override
  @NonNull
  protected InvalidationTracker createInvalidationTracker() {
    final HashMap<String, String> _shadowTablesMap = new HashMap<String, String>(0);
    final HashMap<String, Set<String>> _viewTables = new HashMap<String, Set<String>>(0);
    return new InvalidationTracker(this, _shadowTablesMap, _viewTables, "health_records","journal_entries","wellness_metrics");
  }

  @Override
  public void clearAllTables() {
    super.assertNotMainThread();
    final SupportSQLiteDatabase _db = super.getOpenHelper().getWritableDatabase();
    try {
      super.beginTransaction();
      _db.execSQL("DELETE FROM `health_records`");
      _db.execSQL("DELETE FROM `journal_entries`");
      _db.execSQL("DELETE FROM `wellness_metrics`");
      super.setTransactionSuccessful();
    } finally {
      super.endTransaction();
      _db.query("PRAGMA wal_checkpoint(FULL)").close();
      if (!_db.inTransaction()) {
        _db.execSQL("VACUUM");
      }
    }
  }

  @Override
  @NonNull
  protected Map<Class<?>, List<Class<?>>> getRequiredTypeConverters() {
    final HashMap<Class<?>, List<Class<?>>> _typeConvertersMap = new HashMap<Class<?>, List<Class<?>>>();
    _typeConvertersMap.put(HealthRecordDao.class, HealthRecordDao_Impl.getRequiredConverters());
    _typeConvertersMap.put(JournalEntryDao.class, JournalEntryDao_Impl.getRequiredConverters());
    _typeConvertersMap.put(WellnessMetricDao.class, WellnessMetricDao_Impl.getRequiredConverters());
    return _typeConvertersMap;
  }

  @Override
  @NonNull
  public Set<Class<? extends AutoMigrationSpec>> getRequiredAutoMigrationSpecs() {
    final HashSet<Class<? extends AutoMigrationSpec>> _autoMigrationSpecsSet = new HashSet<Class<? extends AutoMigrationSpec>>();
    return _autoMigrationSpecsSet;
  }

  @Override
  @NonNull
  public List<Migration> getAutoMigrations(
      @NonNull final Map<Class<? extends AutoMigrationSpec>, AutoMigrationSpec> autoMigrationSpecs) {
    final List<Migration> _autoMigrations = new ArrayList<Migration>();
    return _autoMigrations;
  }

  @Override
  public HealthRecordDao healthRecordDao() {
    if (_healthRecordDao != null) {
      return _healthRecordDao;
    } else {
      synchronized(this) {
        if(_healthRecordDao == null) {
          _healthRecordDao = new HealthRecordDao_Impl(this);
        }
        return _healthRecordDao;
      }
    }
  }

  @Override
  public JournalEntryDao journalEntryDao() {
    if (_journalEntryDao != null) {
      return _journalEntryDao;
    } else {
      synchronized(this) {
        if(_journalEntryDao == null) {
          _journalEntryDao = new JournalEntryDao_Impl(this);
        }
        return _journalEntryDao;
      }
    }
  }

  @Override
  public WellnessMetricDao wellnessMetricDao() {
    if (_wellnessMetricDao != null) {
      return _wellnessMetricDao;
    } else {
      synchronized(this) {
        if(_wellnessMetricDao == null) {
          _wellnessMetricDao = new WellnessMetricDao_Impl(this);
        }
        return _wellnessMetricDao;
      }
    }
  }
}
