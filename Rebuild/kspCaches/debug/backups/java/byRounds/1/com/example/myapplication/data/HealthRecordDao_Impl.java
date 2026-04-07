package com.example.myapplication.data;

import android.database.Cursor;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.room.CoroutinesRoom;
import androidx.room.EntityDeletionOrUpdateAdapter;
import androidx.room.EntityInsertionAdapter;
import androidx.room.RoomDatabase;
import androidx.room.RoomSQLiteQuery;
import androidx.room.util.CursorUtil;
import androidx.room.util.DBUtil;
import androidx.sqlite.db.SupportSQLiteStatement;
import java.lang.Class;
import java.lang.Exception;
import java.lang.Object;
import java.lang.Override;
import java.lang.String;
import java.lang.SuppressWarnings;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Callable;
import javax.annotation.processing.Generated;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlinx.coroutines.flow.Flow;

@Generated("androidx.room.RoomProcessor")
@SuppressWarnings({"unchecked", "deprecation"})
public final class HealthRecordDao_Impl implements HealthRecordDao {
  private final RoomDatabase __db;

  private final EntityInsertionAdapter<HealthRecord> __insertionAdapterOfHealthRecord;

  private final Converters __converters = new Converters();

  private final EntityDeletionOrUpdateAdapter<HealthRecord> __deletionAdapterOfHealthRecord;

  private final EntityDeletionOrUpdateAdapter<HealthRecord> __updateAdapterOfHealthRecord;

  public HealthRecordDao_Impl(@NonNull final RoomDatabase __db) {
    this.__db = __db;
    this.__insertionAdapterOfHealthRecord = new EntityInsertionAdapter<HealthRecord>(__db) {
      @Override
      @NonNull
      protected String createQuery() {
        return "INSERT OR REPLACE INTO `health_records` (`id`,`profileName`,`personalInfo`,`bloodType`,`allergies`,`medications`,`medicalConditions`,`medicalHistory`,`emergencyContact`,`insuranceInfo`,`doctorContacts`,`lastUpdated`) VALUES (nullif(?, 0),?,?,?,?,?,?,?,?,?,?,?)";
      }

      @Override
      protected void bind(@NonNull final SupportSQLiteStatement statement,
          @NonNull final HealthRecord entity) {
        statement.bindLong(1, entity.getId());
        statement.bindString(2, entity.getProfileName());
        final String _tmp = __converters.fromPersonalInfo(entity.getPersonalInfo());
        statement.bindString(3, _tmp);
        statement.bindString(4, entity.getBloodType());
        final String _tmp_1 = __converters.fromStringList(entity.getAllergies());
        statement.bindString(5, _tmp_1);
        final String _tmp_2 = __converters.fromMedicationList(entity.getMedications());
        statement.bindString(6, _tmp_2);
        final String _tmp_3 = __converters.fromStringList(entity.getMedicalConditions());
        statement.bindString(7, _tmp_3);
        final String _tmp_4 = __converters.fromStringList(entity.getMedicalHistory());
        statement.bindString(8, _tmp_4);
        final String _tmp_5 = __converters.fromEmergencyContact(entity.getEmergencyContact());
        if (_tmp_5 == null) {
          statement.bindNull(9);
        } else {
          statement.bindString(9, _tmp_5);
        }
        final String _tmp_6 = __converters.fromInsuranceInfo(entity.getInsuranceInfo());
        if (_tmp_6 == null) {
          statement.bindNull(10);
        } else {
          statement.bindString(10, _tmp_6);
        }
        final String _tmp_7 = __converters.fromDoctorContactList(entity.getDoctorContacts());
        statement.bindString(11, _tmp_7);
        statement.bindLong(12, entity.getLastUpdated());
      }
    };
    this.__deletionAdapterOfHealthRecord = new EntityDeletionOrUpdateAdapter<HealthRecord>(__db) {
      @Override
      @NonNull
      protected String createQuery() {
        return "DELETE FROM `health_records` WHERE `id` = ?";
      }

      @Override
      protected void bind(@NonNull final SupportSQLiteStatement statement,
          @NonNull final HealthRecord entity) {
        statement.bindLong(1, entity.getId());
      }
    };
    this.__updateAdapterOfHealthRecord = new EntityDeletionOrUpdateAdapter<HealthRecord>(__db) {
      @Override
      @NonNull
      protected String createQuery() {
        return "UPDATE OR ABORT `health_records` SET `id` = ?,`profileName` = ?,`personalInfo` = ?,`bloodType` = ?,`allergies` = ?,`medications` = ?,`medicalConditions` = ?,`medicalHistory` = ?,`emergencyContact` = ?,`insuranceInfo` = ?,`doctorContacts` = ?,`lastUpdated` = ? WHERE `id` = ?";
      }

      @Override
      protected void bind(@NonNull final SupportSQLiteStatement statement,
          @NonNull final HealthRecord entity) {
        statement.bindLong(1, entity.getId());
        statement.bindString(2, entity.getProfileName());
        final String _tmp = __converters.fromPersonalInfo(entity.getPersonalInfo());
        statement.bindString(3, _tmp);
        statement.bindString(4, entity.getBloodType());
        final String _tmp_1 = __converters.fromStringList(entity.getAllergies());
        statement.bindString(5, _tmp_1);
        final String _tmp_2 = __converters.fromMedicationList(entity.getMedications());
        statement.bindString(6, _tmp_2);
        final String _tmp_3 = __converters.fromStringList(entity.getMedicalConditions());
        statement.bindString(7, _tmp_3);
        final String _tmp_4 = __converters.fromStringList(entity.getMedicalHistory());
        statement.bindString(8, _tmp_4);
        final String _tmp_5 = __converters.fromEmergencyContact(entity.getEmergencyContact());
        if (_tmp_5 == null) {
          statement.bindNull(9);
        } else {
          statement.bindString(9, _tmp_5);
        }
        final String _tmp_6 = __converters.fromInsuranceInfo(entity.getInsuranceInfo());
        if (_tmp_6 == null) {
          statement.bindNull(10);
        } else {
          statement.bindString(10, _tmp_6);
        }
        final String _tmp_7 = __converters.fromDoctorContactList(entity.getDoctorContacts());
        statement.bindString(11, _tmp_7);
        statement.bindLong(12, entity.getLastUpdated());
        statement.bindLong(13, entity.getId());
      }
    };
  }

  @Override
  public Object insertHealthRecord(final HealthRecord record,
      final Continuation<? super Unit> $completion) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      @NonNull
      public Unit call() throws Exception {
        __db.beginTransaction();
        try {
          __insertionAdapterOfHealthRecord.insert(record);
          __db.setTransactionSuccessful();
          return Unit.INSTANCE;
        } finally {
          __db.endTransaction();
        }
      }
    }, $completion);
  }

  @Override
  public Object deleteHealthRecord(final HealthRecord record,
      final Continuation<? super Unit> $completion) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      @NonNull
      public Unit call() throws Exception {
        __db.beginTransaction();
        try {
          __deletionAdapterOfHealthRecord.handle(record);
          __db.setTransactionSuccessful();
          return Unit.INSTANCE;
        } finally {
          __db.endTransaction();
        }
      }
    }, $completion);
  }

  @Override
  public Object updateHealthRecord(final HealthRecord record,
      final Continuation<? super Unit> $completion) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      @NonNull
      public Unit call() throws Exception {
        __db.beginTransaction();
        try {
          __updateAdapterOfHealthRecord.handle(record);
          __db.setTransactionSuccessful();
          return Unit.INSTANCE;
        } finally {
          __db.endTransaction();
        }
      }
    }, $completion);
  }

  @Override
  public Flow<List<HealthRecord>> getAllHealthRecords() {
    final String _sql = "SELECT * FROM health_records";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 0);
    return CoroutinesRoom.createFlow(__db, false, new String[] {"health_records"}, new Callable<List<HealthRecord>>() {
      @Override
      @NonNull
      public List<HealthRecord> call() throws Exception {
        final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
        try {
          final int _cursorIndexOfId = CursorUtil.getColumnIndexOrThrow(_cursor, "id");
          final int _cursorIndexOfProfileName = CursorUtil.getColumnIndexOrThrow(_cursor, "profileName");
          final int _cursorIndexOfPersonalInfo = CursorUtil.getColumnIndexOrThrow(_cursor, "personalInfo");
          final int _cursorIndexOfBloodType = CursorUtil.getColumnIndexOrThrow(_cursor, "bloodType");
          final int _cursorIndexOfAllergies = CursorUtil.getColumnIndexOrThrow(_cursor, "allergies");
          final int _cursorIndexOfMedications = CursorUtil.getColumnIndexOrThrow(_cursor, "medications");
          final int _cursorIndexOfMedicalConditions = CursorUtil.getColumnIndexOrThrow(_cursor, "medicalConditions");
          final int _cursorIndexOfMedicalHistory = CursorUtil.getColumnIndexOrThrow(_cursor, "medicalHistory");
          final int _cursorIndexOfEmergencyContact = CursorUtil.getColumnIndexOrThrow(_cursor, "emergencyContact");
          final int _cursorIndexOfInsuranceInfo = CursorUtil.getColumnIndexOrThrow(_cursor, "insuranceInfo");
          final int _cursorIndexOfDoctorContacts = CursorUtil.getColumnIndexOrThrow(_cursor, "doctorContacts");
          final int _cursorIndexOfLastUpdated = CursorUtil.getColumnIndexOrThrow(_cursor, "lastUpdated");
          final List<HealthRecord> _result = new ArrayList<HealthRecord>(_cursor.getCount());
          while (_cursor.moveToNext()) {
            final HealthRecord _item;
            final int _tmpId;
            _tmpId = _cursor.getInt(_cursorIndexOfId);
            final String _tmpProfileName;
            _tmpProfileName = _cursor.getString(_cursorIndexOfProfileName);
            final PersonalInfo _tmpPersonalInfo;
            final String _tmp;
            _tmp = _cursor.getString(_cursorIndexOfPersonalInfo);
            _tmpPersonalInfo = __converters.toPersonalInfo(_tmp);
            final String _tmpBloodType;
            _tmpBloodType = _cursor.getString(_cursorIndexOfBloodType);
            final List<String> _tmpAllergies;
            final String _tmp_1;
            _tmp_1 = _cursor.getString(_cursorIndexOfAllergies);
            _tmpAllergies = __converters.toStringList(_tmp_1);
            final List<Medication> _tmpMedications;
            final String _tmp_2;
            _tmp_2 = _cursor.getString(_cursorIndexOfMedications);
            _tmpMedications = __converters.toMedicationList(_tmp_2);
            final List<String> _tmpMedicalConditions;
            final String _tmp_3;
            _tmp_3 = _cursor.getString(_cursorIndexOfMedicalConditions);
            _tmpMedicalConditions = __converters.toStringList(_tmp_3);
            final List<String> _tmpMedicalHistory;
            final String _tmp_4;
            _tmp_4 = _cursor.getString(_cursorIndexOfMedicalHistory);
            _tmpMedicalHistory = __converters.toStringList(_tmp_4);
            final EmergencyContact _tmpEmergencyContact;
            final String _tmp_5;
            if (_cursor.isNull(_cursorIndexOfEmergencyContact)) {
              _tmp_5 = null;
            } else {
              _tmp_5 = _cursor.getString(_cursorIndexOfEmergencyContact);
            }
            if (_tmp_5 == null) {
              _tmpEmergencyContact = null;
            } else {
              _tmpEmergencyContact = __converters.toEmergencyContact(_tmp_5);
            }
            final InsuranceInfo _tmpInsuranceInfo;
            final String _tmp_6;
            if (_cursor.isNull(_cursorIndexOfInsuranceInfo)) {
              _tmp_6 = null;
            } else {
              _tmp_6 = _cursor.getString(_cursorIndexOfInsuranceInfo);
            }
            if (_tmp_6 == null) {
              _tmpInsuranceInfo = null;
            } else {
              _tmpInsuranceInfo = __converters.toInsuranceInfo(_tmp_6);
            }
            final List<DoctorContact> _tmpDoctorContacts;
            final String _tmp_7;
            _tmp_7 = _cursor.getString(_cursorIndexOfDoctorContacts);
            _tmpDoctorContacts = __converters.toDoctorContactList(_tmp_7);
            final long _tmpLastUpdated;
            _tmpLastUpdated = _cursor.getLong(_cursorIndexOfLastUpdated);
            _item = new HealthRecord(_tmpId,_tmpProfileName,_tmpPersonalInfo,_tmpBloodType,_tmpAllergies,_tmpMedications,_tmpMedicalConditions,_tmpMedicalHistory,_tmpEmergencyContact,_tmpInsuranceInfo,_tmpDoctorContacts,_tmpLastUpdated);
            _result.add(_item);
          }
          return _result;
        } finally {
          _cursor.close();
        }
      }

      @Override
      protected void finalize() {
        _statement.release();
      }
    });
  }

  @Override
  public Flow<HealthRecord> getHealthRecordById(final int id) {
    final String _sql = "SELECT * FROM health_records WHERE id = ?";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 1);
    int _argIndex = 1;
    _statement.bindLong(_argIndex, id);
    return CoroutinesRoom.createFlow(__db, false, new String[] {"health_records"}, new Callable<HealthRecord>() {
      @Override
      @Nullable
      public HealthRecord call() throws Exception {
        final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
        try {
          final int _cursorIndexOfId = CursorUtil.getColumnIndexOrThrow(_cursor, "id");
          final int _cursorIndexOfProfileName = CursorUtil.getColumnIndexOrThrow(_cursor, "profileName");
          final int _cursorIndexOfPersonalInfo = CursorUtil.getColumnIndexOrThrow(_cursor, "personalInfo");
          final int _cursorIndexOfBloodType = CursorUtil.getColumnIndexOrThrow(_cursor, "bloodType");
          final int _cursorIndexOfAllergies = CursorUtil.getColumnIndexOrThrow(_cursor, "allergies");
          final int _cursorIndexOfMedications = CursorUtil.getColumnIndexOrThrow(_cursor, "medications");
          final int _cursorIndexOfMedicalConditions = CursorUtil.getColumnIndexOrThrow(_cursor, "medicalConditions");
          final int _cursorIndexOfMedicalHistory = CursorUtil.getColumnIndexOrThrow(_cursor, "medicalHistory");
          final int _cursorIndexOfEmergencyContact = CursorUtil.getColumnIndexOrThrow(_cursor, "emergencyContact");
          final int _cursorIndexOfInsuranceInfo = CursorUtil.getColumnIndexOrThrow(_cursor, "insuranceInfo");
          final int _cursorIndexOfDoctorContacts = CursorUtil.getColumnIndexOrThrow(_cursor, "doctorContacts");
          final int _cursorIndexOfLastUpdated = CursorUtil.getColumnIndexOrThrow(_cursor, "lastUpdated");
          final HealthRecord _result;
          if (_cursor.moveToFirst()) {
            final int _tmpId;
            _tmpId = _cursor.getInt(_cursorIndexOfId);
            final String _tmpProfileName;
            _tmpProfileName = _cursor.getString(_cursorIndexOfProfileName);
            final PersonalInfo _tmpPersonalInfo;
            final String _tmp;
            _tmp = _cursor.getString(_cursorIndexOfPersonalInfo);
            _tmpPersonalInfo = __converters.toPersonalInfo(_tmp);
            final String _tmpBloodType;
            _tmpBloodType = _cursor.getString(_cursorIndexOfBloodType);
            final List<String> _tmpAllergies;
            final String _tmp_1;
            _tmp_1 = _cursor.getString(_cursorIndexOfAllergies);
            _tmpAllergies = __converters.toStringList(_tmp_1);
            final List<Medication> _tmpMedications;
            final String _tmp_2;
            _tmp_2 = _cursor.getString(_cursorIndexOfMedications);
            _tmpMedications = __converters.toMedicationList(_tmp_2);
            final List<String> _tmpMedicalConditions;
            final String _tmp_3;
            _tmp_3 = _cursor.getString(_cursorIndexOfMedicalConditions);
            _tmpMedicalConditions = __converters.toStringList(_tmp_3);
            final List<String> _tmpMedicalHistory;
            final String _tmp_4;
            _tmp_4 = _cursor.getString(_cursorIndexOfMedicalHistory);
            _tmpMedicalHistory = __converters.toStringList(_tmp_4);
            final EmergencyContact _tmpEmergencyContact;
            final String _tmp_5;
            if (_cursor.isNull(_cursorIndexOfEmergencyContact)) {
              _tmp_5 = null;
            } else {
              _tmp_5 = _cursor.getString(_cursorIndexOfEmergencyContact);
            }
            if (_tmp_5 == null) {
              _tmpEmergencyContact = null;
            } else {
              _tmpEmergencyContact = __converters.toEmergencyContact(_tmp_5);
            }
            final InsuranceInfo _tmpInsuranceInfo;
            final String _tmp_6;
            if (_cursor.isNull(_cursorIndexOfInsuranceInfo)) {
              _tmp_6 = null;
            } else {
              _tmp_6 = _cursor.getString(_cursorIndexOfInsuranceInfo);
            }
            if (_tmp_6 == null) {
              _tmpInsuranceInfo = null;
            } else {
              _tmpInsuranceInfo = __converters.toInsuranceInfo(_tmp_6);
            }
            final List<DoctorContact> _tmpDoctorContacts;
            final String _tmp_7;
            _tmp_7 = _cursor.getString(_cursorIndexOfDoctorContacts);
            _tmpDoctorContacts = __converters.toDoctorContactList(_tmp_7);
            final long _tmpLastUpdated;
            _tmpLastUpdated = _cursor.getLong(_cursorIndexOfLastUpdated);
            _result = new HealthRecord(_tmpId,_tmpProfileName,_tmpPersonalInfo,_tmpBloodType,_tmpAllergies,_tmpMedications,_tmpMedicalConditions,_tmpMedicalHistory,_tmpEmergencyContact,_tmpInsuranceInfo,_tmpDoctorContacts,_tmpLastUpdated);
          } else {
            _result = null;
          }
          return _result;
        } finally {
          _cursor.close();
        }
      }

      @Override
      protected void finalize() {
        _statement.release();
      }
    });
  }

  @Override
  public Flow<HealthRecord> getHealthRecord() {
    final String _sql = "SELECT * FROM health_records LIMIT 1";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 0);
    return CoroutinesRoom.createFlow(__db, false, new String[] {"health_records"}, new Callable<HealthRecord>() {
      @Override
      @Nullable
      public HealthRecord call() throws Exception {
        final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
        try {
          final int _cursorIndexOfId = CursorUtil.getColumnIndexOrThrow(_cursor, "id");
          final int _cursorIndexOfProfileName = CursorUtil.getColumnIndexOrThrow(_cursor, "profileName");
          final int _cursorIndexOfPersonalInfo = CursorUtil.getColumnIndexOrThrow(_cursor, "personalInfo");
          final int _cursorIndexOfBloodType = CursorUtil.getColumnIndexOrThrow(_cursor, "bloodType");
          final int _cursorIndexOfAllergies = CursorUtil.getColumnIndexOrThrow(_cursor, "allergies");
          final int _cursorIndexOfMedications = CursorUtil.getColumnIndexOrThrow(_cursor, "medications");
          final int _cursorIndexOfMedicalConditions = CursorUtil.getColumnIndexOrThrow(_cursor, "medicalConditions");
          final int _cursorIndexOfMedicalHistory = CursorUtil.getColumnIndexOrThrow(_cursor, "medicalHistory");
          final int _cursorIndexOfEmergencyContact = CursorUtil.getColumnIndexOrThrow(_cursor, "emergencyContact");
          final int _cursorIndexOfInsuranceInfo = CursorUtil.getColumnIndexOrThrow(_cursor, "insuranceInfo");
          final int _cursorIndexOfDoctorContacts = CursorUtil.getColumnIndexOrThrow(_cursor, "doctorContacts");
          final int _cursorIndexOfLastUpdated = CursorUtil.getColumnIndexOrThrow(_cursor, "lastUpdated");
          final HealthRecord _result;
          if (_cursor.moveToFirst()) {
            final int _tmpId;
            _tmpId = _cursor.getInt(_cursorIndexOfId);
            final String _tmpProfileName;
            _tmpProfileName = _cursor.getString(_cursorIndexOfProfileName);
            final PersonalInfo _tmpPersonalInfo;
            final String _tmp;
            _tmp = _cursor.getString(_cursorIndexOfPersonalInfo);
            _tmpPersonalInfo = __converters.toPersonalInfo(_tmp);
            final String _tmpBloodType;
            _tmpBloodType = _cursor.getString(_cursorIndexOfBloodType);
            final List<String> _tmpAllergies;
            final String _tmp_1;
            _tmp_1 = _cursor.getString(_cursorIndexOfAllergies);
            _tmpAllergies = __converters.toStringList(_tmp_1);
            final List<Medication> _tmpMedications;
            final String _tmp_2;
            _tmp_2 = _cursor.getString(_cursorIndexOfMedications);
            _tmpMedications = __converters.toMedicationList(_tmp_2);
            final List<String> _tmpMedicalConditions;
            final String _tmp_3;
            _tmp_3 = _cursor.getString(_cursorIndexOfMedicalConditions);
            _tmpMedicalConditions = __converters.toStringList(_tmp_3);
            final List<String> _tmpMedicalHistory;
            final String _tmp_4;
            _tmp_4 = _cursor.getString(_cursorIndexOfMedicalHistory);
            _tmpMedicalHistory = __converters.toStringList(_tmp_4);
            final EmergencyContact _tmpEmergencyContact;
            final String _tmp_5;
            if (_cursor.isNull(_cursorIndexOfEmergencyContact)) {
              _tmp_5 = null;
            } else {
              _tmp_5 = _cursor.getString(_cursorIndexOfEmergencyContact);
            }
            if (_tmp_5 == null) {
              _tmpEmergencyContact = null;
            } else {
              _tmpEmergencyContact = __converters.toEmergencyContact(_tmp_5);
            }
            final InsuranceInfo _tmpInsuranceInfo;
            final String _tmp_6;
            if (_cursor.isNull(_cursorIndexOfInsuranceInfo)) {
              _tmp_6 = null;
            } else {
              _tmp_6 = _cursor.getString(_cursorIndexOfInsuranceInfo);
            }
            if (_tmp_6 == null) {
              _tmpInsuranceInfo = null;
            } else {
              _tmpInsuranceInfo = __converters.toInsuranceInfo(_tmp_6);
            }
            final List<DoctorContact> _tmpDoctorContacts;
            final String _tmp_7;
            _tmp_7 = _cursor.getString(_cursorIndexOfDoctorContacts);
            _tmpDoctorContacts = __converters.toDoctorContactList(_tmp_7);
            final long _tmpLastUpdated;
            _tmpLastUpdated = _cursor.getLong(_cursorIndexOfLastUpdated);
            _result = new HealthRecord(_tmpId,_tmpProfileName,_tmpPersonalInfo,_tmpBloodType,_tmpAllergies,_tmpMedications,_tmpMedicalConditions,_tmpMedicalHistory,_tmpEmergencyContact,_tmpInsuranceInfo,_tmpDoctorContacts,_tmpLastUpdated);
          } else {
            _result = null;
          }
          return _result;
        } finally {
          _cursor.close();
        }
      }

      @Override
      protected void finalize() {
        _statement.release();
      }
    });
  }

  @NonNull
  public static List<Class<?>> getRequiredConverters() {
    return Collections.emptyList();
  }
}
