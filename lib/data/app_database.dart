import 'package:drift/drift.dart';
import 'connection/connection.dart';

part 'app_database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get fullName => text()();
  TextColumn get username => text()();
  TextColumn get email => text()();

  TextColumn get password => text()();
  TextColumn get avatarPath => text().nullable()();
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

class UserCultivos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();

  TextColumn get nombre => text().withDefault(const Constant(''))();
  TextColumn get tipo => text().withDefault(const Constant(''))();
  IntColumn get cosechaMeses => integer().withDefault(const Constant(0))();
  TextColumn get estacion => text().withDefault(const Constant(''))();
  TextColumn get imagePath => text().nullable()();

  TextColumn get payloadJson => text().named('data')();
}

class SharedCultivos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();

  TextColumn get nombre => text().withDefault(const Constant(''))();
  TextColumn get tipo => text().withDefault(const Constant(''))();
  IntColumn get cosechaMeses => integer().withDefault(const Constant(0))();
  TextColumn get estacion => text().withDefault(const Constant(''))();
  TextColumn get imagePath => text().nullable()();

  TextColumn get payloadJson => text()();
}

@DriftDatabase(tables: [Users, Sessions, UserCultivos, SharedCultivos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  @override
  int get schemaVersion => 4;

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
          if (from < 3) {
            await m.createTable(userCultivos);
          }
          if (from < 4) {
            await m.addColumn(users, users.avatarPath);
            await m.addColumn(userCultivos, userCultivos.nombre);
            await m.addColumn(userCultivos, userCultivos.tipo);
            await m.addColumn(userCultivos, userCultivos.cosechaMeses);
            await m.addColumn(userCultivos, userCultivos.estacion);
            await m.addColumn(userCultivos, userCultivos.imagePath);
            await m.createTable(sharedCultivos);
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

  Future<void> updateUserAvatar(int userId, String? path) {
    return (update(users)..where((t) => t.id.equals(userId))).write(
      UsersCompanion(avatarPath: Value(path)),
    );
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

  // ---------------------------
  // CULTIVOS DEL USUARIO
  // ---------------------------
  Future<List<UserCultivo>> getUserCultivos(int userId) {
    return (select(userCultivos)..where((t) => t.userId.equals(userId))).get();
  }

  Future<int> insertUserCultivo({
    required int userId,
    required String nombre,
    required String tipo,
    required int cosechaMeses,
    required String estacion,
    required String? imagePath,
    required String payloadJson,
  }) {
    return into(userCultivos).insert(
      UserCultivosCompanion.insert(
        userId: userId,
        nombre: Value(nombre),
        tipo: Value(tipo),
        cosechaMeses: Value(cosechaMeses),
        estacion: Value(estacion),
        imagePath: Value(imagePath),
        payloadJson: payloadJson,
      ),
    );
  }

  Future<void> updateUserCultivo({
    required int id,
    required String nombre,
    required String tipo,
    required int cosechaMeses,
    required String estacion,
    required String? imagePath,
    required String payloadJson,
  }) {
    return (update(userCultivos)..where((t) => t.id.equals(id))).write(
      UserCultivosCompanion(
        nombre: Value(nombre),
        tipo: Value(tipo),
        cosechaMeses: Value(cosechaMeses),
        estacion: Value(estacion),
        imagePath: Value(imagePath),
        payloadJson: Value(payloadJson),
      ),
    );
  }

  Future<void> deleteUserCultivo(int id) {
    return (delete(userCultivos)..where((t) => t.id.equals(id))).go();
  }

  // ---------------------------
  // CULTIVOS COMPARTIDOS
  // ---------------------------
  Future<List<SharedCultivo>> getSharedCultivos(int userId) {
    return (select(sharedCultivos)..where((t) => t.userId.equals(userId))).get();
  }

  Future<int> insertSharedCultivo({
    required int userId,
    required String nombre,
    required String tipo,
    required int cosechaMeses,
    required String estacion,
    required String? imagePath,
    required String payloadJson,
  }) {
    return into(sharedCultivos).insert(
      SharedCultivosCompanion.insert(
        userId: userId,
        nombre: Value(nombre),
        tipo: Value(tipo),
        cosechaMeses: Value(cosechaMeses),
        estacion: Value(estacion),
        imagePath: Value(imagePath),
        payloadJson: payloadJson,
      ),
    );
  }

  Future<void> deleteSharedCultivo(int id) {
    return (delete(sharedCultivos)..where((t) => t.id.equals(id))).go();
  }
}