package com.example.myapplication.data;

import android.database.Cursor;
import androidx.annotation.NonNull;
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
public final class WellnessMetricDao_Impl implements WellnessMetricDao {
  private final RoomDatabase __db;

  private final EntityInsertionAdapter<WellnessMetric> __insertionAdapterOfWellnessMetric;

  private final EntityDeletionOrUpdateAdapter<WellnessMetric> __deletionAdapterOfWellnessMetric;

  private final EntityDeletionOrUpdateAdapter<WellnessMetric> __updateAdapterOfWellnessMetric;

  public WellnessMetricDao_Impl(@NonNull final RoomDatabase __db) {
    this.__db = __db;
    this.__insertionAdapterOfWellnessMetric = new EntityInsertionAdapter<WellnessMetric>(__db) {
      @Override
      @NonNull
      protected String createQuery() {
        return "INSERT OR REPLACE INTO `wellness_metrics` (`id`,`date`,`stressLevel`,`sleepHours`,`exerciseMinutes`,`waterIntakeL`,`notes`) VALUES (nullif(?, 0),?,?,?,?,?,?)";
      }

      @Override
      protected void bind(@NonNull final SupportSQLiteStatement statement,
          @NonNull final WellnessMetric entity) {
        statement.bindLong(1, entity.getId());
        statement.bindLong(2, entity.getDate());
        statement.bindLong(3, entity.getStressLevel());
        statement.bindDouble(4, entity.getSleepHours());
        statement.bindLong(5, entity.getExerciseMinutes());
        statement.bindDouble(6, entity.getWaterIntakeL());
        statement.bindString(7, entity.getNotes());
      }
    };
    this.__deletionAdapterOfWellnessMetric = new EntityDeletionOrUpdateAdapter<WellnessMetric>(__db) {
      @Override
      @NonNull
      protected String createQuery() {
        return "DELETE FROM `wellness_metrics` WHERE `id` = ?";
      }

      @Override
      protected void bind(@NonNull final SupportSQLiteStatement statement,
          @NonNull final WellnessMetric entity) {
        statement.bindLong(1, entity.getId());
      }
    };
    this.__updateAdapterOfWellnessMetric = new EntityDeletionOrUpdateAdapter<WellnessMetric>(__db) {
      @Override
      @NonNull
      protected String createQuery() {
        return "UPDATE OR ABORT `wellness_metrics` SET `id` = ?,`date` = ?,`stressLevel` = ?,`sleepHours` = ?,`exerciseMinutes` = ?,`waterIntakeL` = ?,`notes` = ? WHERE `id` = ?";
      }

      @Override
      protected void bind(@NonNull final SupportSQLiteStatement statement,
          @NonNull final WellnessMetric entity) {
        statement.bindLong(1, entity.getId());
        statement.bindLong(2, entity.getDate());
        statement.bindLong(3, entity.getStressLevel());
        statement.bindDouble(4, entity.getSleepHours());
        statement.bindLong(5, entity.getExerciseMinutes());
        statement.bindDouble(6, entity.getWaterIntakeL());
        statement.bindString(7, entity.getNotes());
        statement.bindLong(8, entity.getId());
      }
    };
  }

  @Override
  public Object insertMetric(final WellnessMetric metric,
      final Continuation<? super Unit> $completion) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      @NonNull
      public Unit call() throws Exception {
        __db.beginTransaction();
        try {
          __insertionAdapterOfWellnessMetric.insert(metric);
          __db.setTransactionSuccessful();
          return Unit.INSTANCE;
        } finally {
          __db.endTransaction();
        }
      }
    }, $completion);
  }

  @Override
  public Object deleteMetric(final WellnessMetric metric,
      final Continuation<? super Unit> $completion) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      @NonNull
      public Unit call() throws Exception {
        __db.beginTransaction();
        try {
          __deletionAdapterOfWellnessMetric.handle(metric);
          __db.setTransactionSuccessful();
          return Unit.INSTANCE;
        } finally {
          __db.endTransaction();
        }
      }
    }, $completion);
  }

  @Override
  public Object updateMetric(final WellnessMetric metric,
      final Continuation<? super Unit> $completion) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      @NonNull
      public Unit call() throws Exception {
        __db.beginTransaction();
        try {
          __updateAdapterOfWellnessMetric.handle(metric);
          __db.setTransactionSuccessful();
          return Unit.INSTANCE;
        } finally {
          __db.endTransaction();
        }
      }
    }, $completion);
  }

  @Override
  public Flow<List<WellnessMetric>> getAllMetrics() {
    final String _sql = "SELECT * FROM wellness_metrics ORDER BY date DESC";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 0);
    return CoroutinesRoom.createFlow(__db, false, new String[] {"wellness_metrics"}, new Callable<List<WellnessMetric>>() {
      @Override
      @NonNull
      public List<WellnessMetric> call() throws Exception {
        final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
        try {
          final int _cursorIndexOfId = CursorUtil.getColumnIndexOrThrow(_cursor, "id");
          final int _cursorIndexOfDate = CursorUtil.getColumnIndexOrThrow(_cursor, "date");
          final int _cursorIndexOfStressLevel = CursorUtil.getColumnIndexOrThrow(_cursor, "stressLevel");
          final int _cursorIndexOfSleepHours = CursorUtil.getColumnIndexOrThrow(_cursor, "sleepHours");
          final int _cursorIndexOfExerciseMinutes = CursorUtil.getColumnIndexOrThrow(_cursor, "exerciseMinutes");
          final int _cursorIndexOfWaterIntakeL = CursorUtil.getColumnIndexOrThrow(_cursor, "waterIntakeL");
          final int _cursorIndexOfNotes = CursorUtil.getColumnIndexOrThrow(_cursor, "notes");
          final List<WellnessMetric> _result = new ArrayList<WellnessMetric>(_cursor.getCount());
          while (_cursor.moveToNext()) {
            final WellnessMetric _item;
            final int _tmpId;
            _tmpId = _cursor.getInt(_cursorIndexOfId);
            final long _tmpDate;
            _tmpDate = _cursor.getLong(_cursorIndexOfDate);
            final int _tmpStressLevel;
            _tmpStressLevel = _cursor.getInt(_cursorIndexOfStressLevel);
            final double _tmpSleepHours;
            _tmpSleepHours = _cursor.getDouble(_cursorIndexOfSleepHours);
            final int _tmpExerciseMinutes;
            _tmpExerciseMinutes = _cursor.getInt(_cursorIndexOfExerciseMinutes);
            final double _tmpWaterIntakeL;
            _tmpWaterIntakeL = _cursor.getDouble(_cursorIndexOfWaterIntakeL);
            final String _tmpNotes;
            _tmpNotes = _cursor.getString(_cursorIndexOfNotes);
            _item = new WellnessMetric(_tmpId,_tmpDate,_tmpStressLevel,_tmpSleepHours,_tmpExerciseMinutes,_tmpWaterIntakeL,_tmpNotes);
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
  public Flow<List<WellnessMetric>> getMetricsInDateRange(final long startDate,
      final long endDate) {
    final String _sql = "SELECT * FROM wellness_metrics WHERE date BETWEEN ? AND ? ORDER BY date DESC";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 2);
    int _argIndex = 1;
    _statement.bindLong(_argIndex, startDate);
    _argIndex = 2;
    _statement.bindLong(_argIndex, endDate);
    return CoroutinesRoom.createFlow(__db, false, new String[] {"wellness_metrics"}, new Callable<List<WellnessMetric>>() {
      @Override
      @NonNull
      public List<WellnessMetric> call() throws Exception {
        final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
        try {
          final int _cursorIndexOfId = CursorUtil.getColumnIndexOrThrow(_cursor, "id");
          final int _cursorIndexOfDate = CursorUtil.getColumnIndexOrThrow(_cursor, "date");
          final int _cursorIndexOfStressLevel = CursorUtil.getColumnIndexOrThrow(_cursor, "stressLevel");
          final int _cursorIndexOfSleepHours = CursorUtil.getColumnIndexOrThrow(_cursor, "sleepHours");
          final int _cursorIndexOfExerciseMinutes = CursorUtil.getColumnIndexOrThrow(_cursor, "exerciseMinutes");
          final int _cursorIndexOfWaterIntakeL = CursorUtil.getColumnIndexOrThrow(_cursor, "waterIntakeL");
          final int _cursorIndexOfNotes = CursorUtil.getColumnIndexOrThrow(_cursor, "notes");
          final List<WellnessMetric> _result = new ArrayList<WellnessMetric>(_cursor.getCount());
          while (_cursor.moveToNext()) {
            final WellnessMetric _item;
            final int _tmpId;
            _tmpId = _cursor.getInt(_cursorIndexOfId);
            final long _tmpDate;
            _tmpDate = _cursor.getLong(_cursorIndexOfDate);
            final int _tmpStressLevel;
            _tmpStressLevel = _cursor.getInt(_cursorIndexOfStressLevel);
            final double _tmpSleepHours;
            _tmpSleepHours = _cursor.getDouble(_cursorIndexOfSleepHours);
            final int _tmpExerciseMinutes;
            _tmpExerciseMinutes = _cursor.getInt(_cursorIndexOfExerciseMinutes);
            final double _tmpWaterIntakeL;
            _tmpWaterIntakeL = _cursor.getDouble(_cursorIndexOfWaterIntakeL);
            final String _tmpNotes;
            _tmpNotes = _cursor.getString(_cursorIndexOfNotes);
            _item = new WellnessMetric(_tmpId,_tmpDate,_tmpStressLevel,_tmpSleepHours,_tmpExerciseMinutes,_tmpWaterIntakeL,_tmpNotes);
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

  @NonNull
  public static List<Class<?>> getRequiredConverters() {
    return Collections.emptyList();
  }
}
