package com.example.myapplication.data;

import android.database.Cursor;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.room.CoroutinesRoom;
import androidx.room.EntityDeletionOrUpdateAdapter;
import androidx.room.EntityInsertionAdapter;
import androidx.room.RoomDatabase;
import androidx.room.RoomSQLiteQuery;
import androidx.room.SharedSQLiteStatement;
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
public final class JournalEntryDao_Impl implements JournalEntryDao {
  private final RoomDatabase __db;

  private final EntityInsertionAdapter<JournalEntry> __insertionAdapterOfJournalEntry;

  private final Converters __converters = new Converters();

  private final EntityDeletionOrUpdateAdapter<JournalEntry> __deletionAdapterOfJournalEntry;

  private final EntityDeletionOrUpdateAdapter<JournalEntry> __updateAdapterOfJournalEntry;

  private final SharedSQLiteStatement __preparedStmtOfDeleteOldEntries;

  public JournalEntryDao_Impl(@NonNull final RoomDatabase __db) {
    this.__db = __db;
    this.__insertionAdapterOfJournalEntry = new EntityInsertionAdapter<JournalEntry>(__db) {
      @Override
      @NonNull
      protected String createQuery() {
        return "INSERT OR REPLACE INTO `journal_entries` (`id`,`date`,`title`,`content`,`mood`,`tags`,`prompt`) VALUES (nullif(?, 0),?,?,?,?,?,?)";
      }

      @Override
      protected void bind(@NonNull final SupportSQLiteStatement statement,
          @NonNull final JournalEntry entity) {
        statement.bindLong(1, entity.getId());
        statement.bindLong(2, entity.getDate());
        statement.bindString(3, entity.getTitle());
        statement.bindString(4, entity.getContent());
        final String _tmp = __converters.fromMood(entity.getMood());
        statement.bindString(5, _tmp);
        final String _tmp_1 = __converters.fromStringList(entity.getTags());
        statement.bindString(6, _tmp_1);
        if (entity.getPrompt() == null) {
          statement.bindNull(7);
        } else {
          statement.bindString(7, entity.getPrompt());
        }
      }
    };
    this.__deletionAdapterOfJournalEntry = new EntityDeletionOrUpdateAdapter<JournalEntry>(__db) {
      @Override
      @NonNull
      protected String createQuery() {
        return "DELETE FROM `journal_entries` WHERE `id` = ?";
      }

      @Override
      protected void bind(@NonNull final SupportSQLiteStatement statement,
          @NonNull final JournalEntry entity) {
        statement.bindLong(1, entity.getId());
      }
    };
    this.__updateAdapterOfJournalEntry = new EntityDeletionOrUpdateAdapter<JournalEntry>(__db) {
      @Override
      @NonNull
      protected String createQuery() {
        return "UPDATE OR ABORT `journal_entries` SET `id` = ?,`date` = ?,`title` = ?,`content` = ?,`mood` = ?,`tags` = ?,`prompt` = ? WHERE `id` = ?";
      }

      @Override
      protected void bind(@NonNull final SupportSQLiteStatement statement,
          @NonNull final JournalEntry entity) {
        statement.bindLong(1, entity.getId());
        statement.bindLong(2, entity.getDate());
        statement.bindString(3, entity.getTitle());
        statement.bindString(4, entity.getContent());
        final String _tmp = __converters.fromMood(entity.getMood());
        statement.bindString(5, _tmp);
        final String _tmp_1 = __converters.fromStringList(entity.getTags());
        statement.bindString(6, _tmp_1);
        if (entity.getPrompt() == null) {
          statement.bindNull(7);
        } else {
          statement.bindString(7, entity.getPrompt());
        }
        statement.bindLong(8, entity.getId());
      }
    };
    this.__preparedStmtOfDeleteOldEntries = new SharedSQLiteStatement(__db) {
      @Override
      @NonNull
      public String createQuery() {
        final String _query = "DELETE FROM journal_entries WHERE date < ?";
        return _query;
      }
    };
  }

  @Override
  public Object insertJournalEntry(final JournalEntry entry,
      final Continuation<? super Unit> $completion) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      @NonNull
      public Unit call() throws Exception {
        __db.beginTransaction();
        try {
          __insertionAdapterOfJournalEntry.insert(entry);
          __db.setTransactionSuccessful();
          return Unit.INSTANCE;
        } finally {
          __db.endTransaction();
        }
      }
    }, $completion);
  }

  @Override
  public Object deleteJournalEntry(final JournalEntry entry,
      final Continuation<? super Unit> $completion) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      @NonNull
      public Unit call() throws Exception {
        __db.beginTransaction();
        try {
          __deletionAdapterOfJournalEntry.handle(entry);
          __db.setTransactionSuccessful();
          return Unit.INSTANCE;
        } finally {
          __db.endTransaction();
        }
      }
    }, $completion);
  }

  @Override
  public Object updateJournalEntry(final JournalEntry entry,
      final Continuation<? super Unit> $completion) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      @NonNull
      public Unit call() throws Exception {
        __db.beginTransaction();
        try {
          __updateAdapterOfJournalEntry.handle(entry);
          __db.setTransactionSuccessful();
          return Unit.INSTANCE;
        } finally {
          __db.endTransaction();
        }
      }
    }, $completion);
  }

  @Override
  public Object deleteOldEntries(final long olderThanTimestamp,
      final Continuation<? super Unit> $completion) {
    return CoroutinesRoom.execute(__db, true, new Callable<Unit>() {
      @Override
      @NonNull
      public Unit call() throws Exception {
        final SupportSQLiteStatement _stmt = __preparedStmtOfDeleteOldEntries.acquire();
        int _argIndex = 1;
        _stmt.bindLong(_argIndex, olderThanTimestamp);
        try {
          __db.beginTransaction();
          try {
            _stmt.executeUpdateDelete();
            __db.setTransactionSuccessful();
            return Unit.INSTANCE;
          } finally {
            __db.endTransaction();
          }
        } finally {
          __preparedStmtOfDeleteOldEntries.release(_stmt);
        }
      }
    }, $completion);
  }

  @Override
  public Flow<List<JournalEntry>> getAllJournalEntries() {
    final String _sql = "SELECT * FROM journal_entries ORDER BY date DESC";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 0);
    return CoroutinesRoom.createFlow(__db, false, new String[] {"journal_entries"}, new Callable<List<JournalEntry>>() {
      @Override
      @NonNull
      public List<JournalEntry> call() throws Exception {
        final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
        try {
          final int _cursorIndexOfId = CursorUtil.getColumnIndexOrThrow(_cursor, "id");
          final int _cursorIndexOfDate = CursorUtil.getColumnIndexOrThrow(_cursor, "date");
          final int _cursorIndexOfTitle = CursorUtil.getColumnIndexOrThrow(_cursor, "title");
          final int _cursorIndexOfContent = CursorUtil.getColumnIndexOrThrow(_cursor, "content");
          final int _cursorIndexOfMood = CursorUtil.getColumnIndexOrThrow(_cursor, "mood");
          final int _cursorIndexOfTags = CursorUtil.getColumnIndexOrThrow(_cursor, "tags");
          final int _cursorIndexOfPrompt = CursorUtil.getColumnIndexOrThrow(_cursor, "prompt");
          final List<JournalEntry> _result = new ArrayList<JournalEntry>(_cursor.getCount());
          while (_cursor.moveToNext()) {
            final JournalEntry _item;
            final int _tmpId;
            _tmpId = _cursor.getInt(_cursorIndexOfId);
            final long _tmpDate;
            _tmpDate = _cursor.getLong(_cursorIndexOfDate);
            final String _tmpTitle;
            _tmpTitle = _cursor.getString(_cursorIndexOfTitle);
            final String _tmpContent;
            _tmpContent = _cursor.getString(_cursorIndexOfContent);
            final Mood _tmpMood;
            final String _tmp;
            _tmp = _cursor.getString(_cursorIndexOfMood);
            _tmpMood = __converters.toMood(_tmp);
            final List<String> _tmpTags;
            final String _tmp_1;
            _tmp_1 = _cursor.getString(_cursorIndexOfTags);
            _tmpTags = __converters.toStringList(_tmp_1);
            final String _tmpPrompt;
            if (_cursor.isNull(_cursorIndexOfPrompt)) {
              _tmpPrompt = null;
            } else {
              _tmpPrompt = _cursor.getString(_cursorIndexOfPrompt);
            }
            _item = new JournalEntry(_tmpId,_tmpDate,_tmpTitle,_tmpContent,_tmpMood,_tmpTags,_tmpPrompt);
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
  public Flow<JournalEntry> getJournalEntry(final int id) {
    final String _sql = "SELECT * FROM journal_entries WHERE id = ?";
    final RoomSQLiteQuery _statement = RoomSQLiteQuery.acquire(_sql, 1);
    int _argIndex = 1;
    _statement.bindLong(_argIndex, id);
    return CoroutinesRoom.createFlow(__db, false, new String[] {"journal_entries"}, new Callable<JournalEntry>() {
      @Override
      @Nullable
      public JournalEntry call() throws Exception {
        final Cursor _cursor = DBUtil.query(__db, _statement, false, null);
        try {
          final int _cursorIndexOfId = CursorUtil.getColumnIndexOrThrow(_cursor, "id");
          final int _cursorIndexOfDate = CursorUtil.getColumnIndexOrThrow(_cursor, "date");
          final int _cursorIndexOfTitle = CursorUtil.getColumnIndexOrThrow(_cursor, "title");
          final int _cursorIndexOfContent = CursorUtil.getColumnIndexOrThrow(_cursor, "content");
          final int _cursorIndexOfMood = CursorUtil.getColumnIndexOrThrow(_cursor, "mood");
          final int _cursorIndexOfTags = CursorUtil.getColumnIndexOrThrow(_cursor, "tags");
          final int _cursorIndexOfPrompt = CursorUtil.getColumnIndexOrThrow(_cursor, "prompt");
          final JournalEntry _result;
          if (_cursor.moveToFirst()) {
            final int _tmpId;
            _tmpId = _cursor.getInt(_cursorIndexOfId);
            final long _tmpDate;
            _tmpDate = _cursor.getLong(_cursorIndexOfDate);
            final String _tmpTitle;
            _tmpTitle = _cursor.getString(_cursorIndexOfTitle);
            final String _tmpContent;
            _tmpContent = _cursor.getString(_cursorIndexOfContent);
            final Mood _tmpMood;
            final String _tmp;
            _tmp = _cursor.getString(_cursorIndexOfMood);
            _tmpMood = __converters.toMood(_tmp);
            final List<String> _tmpTags;
            final String _tmp_1;
            _tmp_1 = _cursor.getString(_cursorIndexOfTags);
            _tmpTags = __converters.toStringList(_tmp_1);
            final String _tmpPrompt;
            if (_cursor.isNull(_cursorIndexOfPrompt)) {
              _tmpPrompt = null;
            } else {
              _tmpPrompt = _cursor.getString(_cursorIndexOfPrompt);
            }
            _result = new JournalEntry(_tmpId,_tmpDate,_tmpTitle,_tmpContent,_tmpMood,_tmpTags,_tmpPrompt);
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
