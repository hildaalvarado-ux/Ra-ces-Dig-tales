import 'package:drift/drift.dart';
import 'connection/connection.dart';

part 'app_database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get fullName => text()();
  TextColumn get username => text()();
  TextColumn get email => text()();

  TextColumn get password => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {username},
        {email},
      ];
}

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Users, Sessions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  @override
  int get schemaVersion => 2;

  // ✅ ESTO ES LO QUE TE FALTA:
  // Le dice a Drift qué hacer cuando cambias schemaVersion
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          // Si es instalación nueva
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // Si ya existía la BD y cambió la versión
          // Ejemplo: de 1 -> 2 agregamos Sessions
          if (from < 2) {
            await m.createTable(sessions);
          }
        },
        beforeOpen: (details) async {
          // Opcional: puedes activar foreign_keys si luego lo ocupas
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // ---------------------------
  // USERS
  // ---------------------------
  Future<int> createUser({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    return into(users).insert(
      UsersCompanion.insert(
        fullName: fullName,
        username: username,
        email: email,
        password: password,
      ),
    );
  }

  Future<User?> findUserByUsernameOrEmail(String input) async {
    final q = select(users)
      ..where((u) => u.username.equals(input) | u.email.equals(input));
    return q.getSingleOrNull();
  }

  Future<User?> authenticate({
    required String userOrEmail,
    required String password,
  }) async {
    final q = select(users)
      ..where((u) =>
          (u.username.equals(userOrEmail) | u.email.equals(userOrEmail)) &
          u.password.equals(password));
    return q.getSingleOrNull();
  }

  // ---------------------------
  // SESSION
  // ---------------------------
  Future<void> saveSession(int userId) async {
    await delete(sessions).go();
    await into(sessions).insert(SessionsCompanion.insert(userId: userId));
  }

  Future<int?> getActiveUserId() async {
    final s = await select(sessions).getSingleOrNull();
    return s?.userId;
  }

  Future<void> clearSession() async {
    await delete(sessions).go();
  }
}