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
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  TextColumn get notificationSound =>
      text().withDefault(const Constant('default'))();

  TextColumn get securityQuestion =>
      text().withDefault(const Constant(''))();
  TextColumn get securityAnswer =>
      text().withDefault(const Constant(''))();

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

class UserFertilizantes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get nombre => text().withDefault(const Constant(''))();
  TextColumn get tipo => text().withDefault(const Constant(''))();
  TextColumn get imagePath => text().nullable()();
  TextColumn get payloadJson => text()();
}

class SharedFertilizantes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get nombre => text().withDefault(const Constant(''))();
  TextColumn get tipo => text().withDefault(const Constant(''))();
  TextColumn get imagePath => text().nullable()();
  TextColumn get payloadJson => text()();
}

class UserPlagas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get nombre => text().withDefault(const Constant(''))();
  TextColumn get cientifico => text().withDefault(const Constant(''))();
  TextColumn get imagePath => text().nullable()();
  TextColumn get payloadJson => text()();
}

class SharedPlagas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get nombre => text().withDefault(const Constant(''))();
  TextColumn get cientifico => text().withDefault(const Constant(''))();
  TextColumn get imagePath => text().nullable()();
  TextColumn get payloadJson => text()();
}

class UserPesticidas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get nombre => text().withDefault(const Constant(''))();
  TextColumn get tipo => text().withDefault(const Constant(''))();
  TextColumn get imagePath => text().nullable()();
  TextColumn get payloadJson => text()();
}

class SharedPesticidas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get nombre => text().withDefault(const Constant(''))();
  TextColumn get tipo => text().withDefault(const Constant(''))();
  TextColumn get imagePath => text().nullable()();
  TextColumn get payloadJson => text()();
}

class UserEnfermedades extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get nombre => text().withDefault(const Constant(''))();
  TextColumn get tipo => text().withDefault(const Constant(''))();
  TextColumn get imagePath => text().nullable()();
  TextColumn get payloadJson => text()();
}

class SharedEnfermedades extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get nombre => text().withDefault(const Constant(''))();
  TextColumn get tipo => text().withDefault(const Constant(''))();
  TextColumn get imagePath => text().nullable()();
  TextColumn get payloadJson => text()();
}

class CropPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get cropName => text()();
  TextColumn get nickname => text().nullable()();
  IntColumn get colorValue => integer().nullable()();
  DateTimeColumn get startDate => dateTime()();
  TextColumn get preferredTime => text()(); // HH:mm
  TextColumn get payloadJson => text()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  TextColumn get status => text().withDefault(const Constant('active'))(); // active, finalized
}

class CalendarTasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planId => integer().nullable()(); // null if manual task
  IntColumn get userId => integer()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text()(); // riego, fertilización, etc.
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

class NotificationLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get read => boolean().withDefault(const Constant(false))();
  // unread, read, completed
  TextColumn get status => text().withDefault(const Constant('unread'))();
  IntColumn get taskId => integer().nullable()();
}

class Observations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  IntColumn get planId => integer().nullable()();
  TextColumn get cropName => text()();
  TextColumn get cropImagePath => text().nullable()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get content => text()();
  TextColumn get plantStatus => text().nullable()();
  TextColumn get stage => text().nullable()();
  BoolColumn get hasIrrigation => boolean().withDefault(const Constant(false))();
  BoolColumn get hasPest => boolean().withDefault(const Constant(false))();
  BoolColumn get hasTransplantOrFertilization => boolean().withDefault(const Constant(false))();
  BoolColumn get hasFertilization => boolean().withDefault(const Constant(false))();
  BoolColumn get hasTransplant => boolean().withDefault(const Constant(false))();
}

class SoilPreparations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get cropName => text().nullable()();
  DateTimeColumn get fechaListaSuelo => dateTime().nullable()();
  BoolColumn get completado => boolean().withDefault(const Constant(false))();
  BoolColumn get riesgo => boolean().withDefault(const Constant(false))();
  TextColumn get status => text().withDefault(const Constant('active'))(); // active, completed
  TextColumn get payloadJson => text()(); // Stores serialized TareaPreparacion list
}

@DriftDatabase(tables: [
  Users,
  Sessions,
  UserCultivos,
  SharedCultivos,
  UserFertilizantes,
  SharedFertilizantes,
  UserPlagas,
  SharedPlagas,
  UserPesticidas,
  SharedPesticidas,
  UserEnfermedades,
  SharedEnfermedades,
  CropPlans,
  CalendarTasks,
  NotificationLogs,
  Observations,
  SoilPreparations
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  @override
  int get schemaVersion => 14;

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
            // Guard: If from < 3, userCultivos was created in the block above
            // with the current schema (including these columns).
            if (from >= 3) {
              await m.addColumn(userCultivos, userCultivos.nombre);
              await m.addColumn(userCultivos, userCultivos.tipo);
              await m.addColumn(userCultivos, userCultivos.cosechaMeses);
              await m.addColumn(userCultivos, userCultivos.estacion);
              await m.addColumn(userCultivos, userCultivos.imagePath);
            }
            await m.createTable(sharedCultivos);
          }
          if (from < 5) {
            await m.createTable(userFertilizantes);
            await m.createTable(sharedFertilizantes);
            await m.createTable(userPlagas);
            await m.createTable(sharedPlagas);
          }
          if (from < 6) {
            await m.createTable(userPesticidas);
            await m.createTable(sharedPesticidas);
          }
          if (from < 7) {
            await m.createTable(cropPlans);
            await m.createTable(calendarTasks);
            await m.createTable(notificationLogs);
          }
          if (from < 8) {
            await m.createTable(observations);
            // Guard: If from < 7, notificationLogs was created in the block above
            // with the current schema (including these columns).
            if (from >= 7) {
              await m.addColumn(notificationLogs, notificationLogs.status);
              await m.addColumn(notificationLogs, notificationLogs.taskId);
            }
          }
          if (from < 9) {
            // Guard: If from < 7, cropPlans was created in the block above
            // with the current schema (including these columns).
            if (from >= 7) {
              await m.addColumn(cropPlans, cropPlans.nickname);
              await m.addColumn(cropPlans, cropPlans.colorValue);
            }
          }
          if (from < 10) {
            await m.addColumn(users, users.notificationsEnabled);
            await m.addColumn(users, users.notificationSound);
          }
          if (from < 11) {
            // We must try to add columns if the table exists.
            // If from < 7, cropPlans doesn't exist yet, it will be created by m.createTable(cropPlans) with all columns.
            // If from >= 7, cropPlans exists and we need to add 'status'.
            if (from >= 7) {
              await m.addColumn(cropPlans, cropPlans.status);
            }
            // If from < 8, observations doesn't exist yet.
            // If from >= 8, observations exists and we need to add the new columns.
            if (from >= 8) {
              await m.addColumn(observations, observations.planId);
              await m.addColumn(observations, observations.hasFertilization);
              await m.addColumn(observations, observations.hasTransplant);
            }
          }
          if (from < 12) {
            await m.createTable(userEnfermedades);
            await m.createTable(sharedEnfermedades);
          }
          if (from < 13) {
            await m.createTable(soilPreparations);
          }
          if (from < 14) {
            await m.addColumn(users, users.securityQuestion);
            await m.addColumn(users, users.securityAnswer);
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
    required String securityQuestion,
    required String securityAnswer,
  }) async {
    return into(users).insert(
      UsersCompanion.insert(
        fullName: fullName,
        username: username,
        email: email,
        password: password,
        securityQuestion: Value(securityQuestion),
        securityAnswer: Value(securityAnswer),
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

  Future<User?> getUserById(int userId) {
    return (select(users)..where((u) => u.id.equals(userId))).getSingleOrNull();
  }

  Future<void> updateUserAvatar(int userId, String? path) {
    return (update(users)..where((t) => t.id.equals(userId))).write(
      UsersCompanion(avatarPath: Value(path)),
    );
  }

  Future<void> updateUserName(int userId, String fullName) {
    return (update(users)..where((t) => t.id.equals(userId))).write(
      UsersCompanion(fullName: Value(fullName)),
    );
  }

  Future<void> updateUserPassword(int userId, String password) {
    return (update(users)..where((t) => t.id.equals(userId))).write(
      UsersCompanion(password: Value(password)),
    );
  }

  Future<void> updateUserNotificationSettings(
      int userId, bool enabled, String sound) {
    return (update(users)..where((t) => t.id.equals(userId))).write(
      UsersCompanion(
        notificationsEnabled: Value(enabled),
        notificationSound: Value(sound),
      ),
    );
  }

  // ---------------------------
  // ENFERMEDADES
  // ---------------------------
  Future<List<UserEnfermedade>> getUserEnfermedades(int userId) {
    return (select(userEnfermedades)..where((t) => t.userId.equals(userId))).get();
  }

  Future<int> insertUserEnfermedad({
    required int userId,
    required String nombre,
    required String tipo,
    required String? imagePath,
    required String payloadJson,
  }) {
    return into(userEnfermedades).insert(
      UserEnfermedadesCompanion.insert(
        userId: userId,
        nombre: Value(nombre),
        tipo: Value(tipo),
        imagePath: Value(imagePath),
        payloadJson: payloadJson,
      ),
    );
  }

  Future<void> updateUserEnfermedad({
    required int id,
    required String nombre,
    required String tipo,
    required String? imagePath,
    required String payloadJson,
  }) {
    return (update(userEnfermedades)..where((t) => t.id.equals(id))).write(
      UserEnfermedadesCompanion(
        nombre: Value(nombre),
        tipo: Value(tipo),
        imagePath: Value(imagePath),
        payloadJson: Value(payloadJson),
      ),
    );
  }

  Future<void> deleteUserEnfermedad(int id) {
    return (delete(userEnfermedades)..where((t) => t.id.equals(id))).go();
  }

  Future<List<SharedEnfermedade>> getSharedEnfermedades(int userId) {
    return (select(sharedEnfermedades)..where((t) => t.userId.equals(userId))).get();
  }

  Future<int> insertSharedEnfermedad({
    required int userId,
    required String nombre,
    required String tipo,
    required String? imagePath,
    required String payloadJson,
  }) {
    return into(sharedEnfermedades).insert(
      SharedEnfermedadesCompanion.insert(
        userId: userId,
        nombre: Value(nombre),
        tipo: Value(tipo),
        imagePath: Value(imagePath),
        payloadJson: payloadJson,
      ),
    );
  }

  Future<void> deleteSharedEnfermedad(int id) {
    return (delete(sharedEnfermedades)..where((t) => t.id.equals(id))).go();
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

  // ---------------------------
  // FERTILIZANTES
  // ---------------------------
  Future<List<UserFertilizante>> getUserFertilizantes(int userId) {
    return (select(userFertilizantes)..where((t) => t.userId.equals(userId))).get();
  }

  Future<int> insertUserFertilizante({
    required int userId,
    required String nombre,
    required String tipo,
    required String? imagePath,
    required String payloadJson,
  }) {
    return into(userFertilizantes).insert(
      UserFertilizantesCompanion.insert(
        userId: userId,
        nombre: Value(nombre),
        tipo: Value(tipo),
        imagePath: Value(imagePath),
        payloadJson: payloadJson,
      ),
    );
  }

  Future<void> updateUserFertilizante({
    required int id,
    required String nombre,
    required String tipo,
    required String? imagePath,
    required String payloadJson,
  }) {
    return (update(userFertilizantes)..where((t) => t.id.equals(id))).write(
      UserFertilizantesCompanion(
        nombre: Value(nombre),
        tipo: Value(tipo),
        imagePath: Value(imagePath),
        payloadJson: Value(payloadJson),
      ),
    );
  }

  Future<void> deleteUserFertilizante(int id) {
    return (delete(userFertilizantes)..where((t) => t.id.equals(id))).go();
  }

  Future<List<SharedFertilizante>> getSharedFertilizantes(int userId) {
    return (select(sharedFertilizantes)..where((t) => t.userId.equals(userId))).get();
  }

  Future<int> insertSharedFertilizante({
    required int userId,
    required String nombre,
    required String tipo,
    required String? imagePath,
    required String payloadJson,
  }) {
    return into(sharedFertilizantes).insert(
      SharedFertilizantesCompanion.insert(
        userId: userId,
        nombre: Value(nombre),
        tipo: Value(tipo),
        imagePath: Value(imagePath),
        payloadJson: payloadJson,
      ),
    );
  }

  Future<void> deleteSharedFertilizante(int id) {
    return (delete(sharedFertilizantes)..where((t) => t.id.equals(id))).go();
  }

  // ---------------------------
  // PLAGAS
  // ---------------------------
  Future<List<UserPlaga>> getUserPlagas(int userId) {
    return (select(userPlagas)..where((t) => t.userId.equals(userId))).get();
  }

  Future<int> insertUserPlaga({
    required int userId,
    required String nombre,
    required String cientifico,
    required String? imagePath,
    required String payloadJson,
  }) {
    return into(userPlagas).insert(
      UserPlagasCompanion.insert(
        userId: userId,
        nombre: Value(nombre),
        cientifico: Value(cientifico),
        imagePath: Value(imagePath),
        payloadJson: payloadJson,
      ),
    );
  }

  Future<void> updateUserPlaga({
    required int id,
    required String nombre,
    required String cientifico,
    required String? imagePath,
    required String payloadJson,
  }) {
    return (update(userPlagas)..where((t) => t.id.equals(id))).write(
      UserPlagasCompanion(
        nombre: Value(nombre),
        cientifico: Value(cientifico),
        imagePath: Value(imagePath),
        payloadJson: Value(payloadJson),
      ),
    );
  }

  Future<void> deleteUserPlaga(int id) {
    return (delete(userPlagas)..where((t) => t.id.equals(id))).go();
  }

  Future<List<SharedPlaga>> getSharedPlagas(int userId) {
    return (select(sharedPlagas)..where((t) => t.userId.equals(userId))).get();
  }

  Future<int> insertSharedPlaga({
    required int userId,
    required String nombre,
    required String cientifico,
    required String? imagePath,
    required String payloadJson,
  }) {
    return into(sharedPlagas).insert(
      SharedPlagasCompanion.insert(
        userId: userId,
        nombre: Value(nombre),
        cientifico: Value(cientifico),
        imagePath: Value(imagePath),
        payloadJson: payloadJson,
      ),
    );
  }

  Future<void> deleteSharedPlaga(int id) {
    return (delete(sharedPlagas)..where((t) => t.id.equals(id))).go();
  }

  // ---------------------------
  // PESTICIDAS
  // ---------------------------
  Future<List<UserPesticida>> getUserPesticidas(int userId) {
    return (select(userPesticidas)..where((t) => t.userId.equals(userId))).get();
  }

  Future<int> insertUserPesticida({
    required int userId,
    required String nombre,
    required String tipo,
    required String? imagePath,
    required String payloadJson,
  }) {
    return into(userPesticidas).insert(
      UserPesticidasCompanion.insert(
        userId: userId,
        nombre: Value(nombre),
        tipo: Value(tipo),
        imagePath: Value(imagePath),
        payloadJson: payloadJson,
      ),
    );
  }

  Future<void> updateUserPesticida({
    required int id,
    required String nombre,
    required String tipo,
    required String? imagePath,
    required String payloadJson,
  }) {
    return (update(userPesticidas)..where((t) => t.id.equals(id))).write(
      UserPesticidasCompanion(
        nombre: Value(nombre),
        tipo: Value(tipo),
        imagePath: Value(imagePath),
        payloadJson: Value(payloadJson),
      ),
    );
  }

  Future<void> deleteUserPesticida(int id) {
    return (delete(userPesticidas)..where((t) => t.id.equals(id))).go();
  }

  Future<List<SharedPesticida>> getSharedPesticidas(int userId) {
    return (select(sharedPesticidas)..where((t) => t.userId.equals(userId))).get();
  }

  Future<int> insertSharedPesticida({
    required int userId,
    required String nombre,
    required String tipo,
    required String? imagePath,
    required String payloadJson,
  }) {
    return into(sharedPesticidas).insert(
      SharedPesticidasCompanion.insert(
        userId: userId,
        nombre: Value(nombre),
        tipo: Value(tipo),
        imagePath: Value(imagePath),
        payloadJson: payloadJson,
      ),
    );
  }

  Future<void> deleteSharedPesticida(int id) {
    return (delete(sharedPesticidas)..where((t) => t.id.equals(id))).go();
  }

  // ---------------------------
  // CALENDARIO Y PLANES
  // ---------------------------
  Future<List<CropPlan>> getUserCropPlans(int userId) {
    return (select(cropPlans)..where((t) => t.userId.equals(userId) & t.active.equals(true))).get();
  }

  Future<List<CropPlan>> getAllUserCropPlans(int userId) {
    return (select(cropPlans)..where((t) => t.userId.equals(userId))).get();
  }

  Future<int> insertCropPlan(CropPlansCompanion companion) {
    return into(cropPlans).insert(companion);
  }

  Future<void> deleteCropPlan(int id) {
    return (update(cropPlans)..where((t) => t.id.equals(id))).write(const CropPlansCompanion(active: Value(false)));
  }

  Future<void> deleteCropPlanPermanently(int planId) async {
    // 1. Find all tasks for this plan
    final tasks = await (select(calendarTasks)..where((t) => t.planId.equals(planId))).get();
    final taskIds = tasks.map((t) => t.id).toList();

    // 2. Delete all notification logs for these tasks
    if (taskIds.isNotEmpty) {
      await (delete(notificationLogs)..where((t) => t.taskId.isIn(taskIds))).go();
    }

    // 3. Delete all tasks for this plan
    await (delete(calendarTasks)..where((t) => t.planId.equals(planId))).go();

    // 4. Delete all observations for this plan
    await (delete(observations)..where((t) => t.planId.equals(planId))).go();

    // 5. Delete the plan itself
    await (delete(cropPlans)..where((t) => t.id.equals(planId))).go();
  }

  Future<List<CalendarTask>> getUserTasks(int userId) {
    return (select(calendarTasks)..where((t) => t.userId.equals(userId))).get();
  }

  Future<void> insertTasks(List<CalendarTasksCompanion> companions) async {
    await batch((batch) {
      batch.insertAll(calendarTasks, companions);
    });
  }

  Future<void> updateTaskStatus(int id, bool completed) {
    return (update(calendarTasks)..where((t) => t.id.equals(id))).write(
      CalendarTasksCompanion(
        completed: Value(completed),
        completedAt: Value(completed ? DateTime.now() : null),
      ),
    );
  }

  Future<void> deleteTask(int id) {
    return (delete(calendarTasks)..where((t) => t.id.equals(id))).go();
  }

  // ---------------------------
  // NOTIFICACIONES
  // ---------------------------
  Future<List<NotificationLog>> getNotificationLogs(int userId) {
    return (select(notificationLogs)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)]))
        .get();
  }

  Future<int> insertNotificationLog(NotificationLogsCompanion companion) {
    return into(notificationLogs).insert(companion);
  }

  Future<void> markNotificationAsRead(int id) {
    return (update(notificationLogs)..where((t) => t.id.equals(id))).write(
      const NotificationLogsCompanion(read: Value(true), status: Value('read')),
    );
  }

  Future<void> updateNotificationStatus(int id, String status) {
    return (update(notificationLogs)..where((t) => t.id.equals(id))).write(
      NotificationLogsCompanion(status: Value(status), read: Value(status != 'unread')),
    );
  }

  Future<void> updateNotificationStatusByTask(int taskId, String status) {
    return (update(notificationLogs)..where((t) => t.taskId.equals(taskId))).write(
      NotificationLogsCompanion(status: Value(status), read: Value(status != 'unread')),
    );
  }

  Future<NotificationLog?> getUnreadLogByTask(int taskId) {
    return (select(notificationLogs)
          ..where((t) => t.taskId.equals(taskId) & t.status.equals('unread')))
        .getSingleOrNull();
  }

  Future<void> clearReadNotifications(int userId) {
    return (delete(notificationLogs)..where((t) => t.userId.equals(userId) & t.read.equals(true))).go();
  }

  // ---------------------------
  // OBSERVACIONES / DIARIO
  // ---------------------------
  Future<List<Observation>> getUserObservations(int userId) {
    return (select(observations)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .get();
  }

  Future<int> insertObservation(ObservationsCompanion companion) {
    return into(observations).insert(companion);
  }

  Future<int> deleteObservationsByCropName(int userId, String cropName) {
    return (delete(observations)
          ..where((t) => t.userId.equals(userId) & t.cropName.equals(cropName)))
        .go();
  }

  // ---------------------------
  // PREPARACIÓN DEL SUELO
  // ---------------------------
  Future<List<SoilPreparation>> getUserSoilPreparations(int userId) {
    return (select(soilPreparations)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)]))
        .get();
  }

  Future<SoilPreparation?> getActiveSoilPreparation(int userId, String? cropName) {
    final q = select(soilPreparations)
      ..where((t) => t.userId.equals(userId) & t.status.equals('active'));
    if (cropName != null) {
      q.where((t) => t.cropName.equals(cropName));
    } else {
      q.where((t) => t.cropName.isNull());
    }
    return q.getSingleOrNull();
  }

  Future<int> insertSoilPreparation(SoilPreparationsCompanion companion) {
    return into(soilPreparations).insert(companion);
  }

  Future<void> updateSoilPreparation(SoilPreparationsCompanion companion) {
    return (update(soilPreparations)..where((t) => t.id.equals(companion.id.value))).write(companion);
  }

  Future<void> deleteSoilPreparation(int id) {
    return (delete(soilPreparations)..where((t) => t.id.equals(id))).go();
  }

  // Additional methods for CropPlans
  Future<void> deactivateCropPlan(int planId) {
    return (update(cropPlans)..where((t) => t.id.equals(planId))).write(
      const CropPlansCompanion(active: Value(false)),
    );
  }

  Future<void> finalizeCropPlan(int planId) {
    return (update(cropPlans)..where((t) => t.id.equals(planId))).write(
      const CropPlansCompanion(
        status: Value('finalized'),
        active: Value(false),
      ),
    );
  }

  Future<List<CropPlan>> getFinalizedCropPlans(int userId) {
    return (select(cropPlans)
          ..where((t) => t.userId.equals(userId) & t.status.equals('finalized')))
        .get();
  }

  Future<void> deleteTasksByPlan(int planId) {
    return (delete(calendarTasks)..where((t) => t.planId.equals(planId))).go();
  }

  Future<void> hardDeleteCropPlan(int planId) {
    return (delete(cropPlans)..where((t) => t.id.equals(planId))).go();
  }

  Future<void> deleteLogsByTaskId(int taskId) {
    return (delete(notificationLogs)..where((t) => t.taskId.equals(taskId))).go();
  }

  Future<List<CalendarTask>> getTasksByPlan(int planId) {
    return (select(calendarTasks)..where((t) => t.planId.equals(planId))).get();
  }

  Future<List<CropPlan>> getAllPlansByCropName(int userId, String cropName) {
    return (select(cropPlans)
          ..where((t) => t.userId.equals(userId) & t.cropName.equals(cropName)))
        .get();
  }

  // ---------------------------
  // OPTIMIZACIÓN Y LIMPIEZA
  // ---------------------------

  Future<int> optimizeData(int userId) async {
    int deletedCount = 0;

    // 1. Eliminar notificaciones leídas de más de 7 días
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    deletedCount += await (delete(notificationLogs)
          ..where((t) =>
              t.userId.equals(userId) &
              t.read.equals(true) &
              t.timestamp.isSmallerThanValue(sevenDaysAgo)))
        .go();

    // 2. Eliminar planes de cultivo inactivos y sus tareas/logs/observaciones asociados
    final inactivePlans = await (select(cropPlans)
          ..where((t) => t.userId.equals(userId) & t.active.equals(false)))
        .get();

    for (final plan in inactivePlans) {
      await deleteCropPlanPermanently(plan.id);
      deletedCount++;
    }

    // 3. Eliminar tareas huérfanas (con planId que ya no existe)
    final allPlanIds = (await select(cropPlans).get()).map((p) => p.id).toSet();
    final potentialOrphans = await (select(calendarTasks)
          ..where((t) => t.userId.equals(userId) & t.planId.isNotNull()))
        .get();

    for (final task in potentialOrphans) {
      if (!allPlanIds.contains(task.planId)) {
        await (delete(notificationLogs)..where((t) => t.taskId.equals(task.id)))
            .go();
        await (delete(calendarTasks)..where((t) => t.id.equals(task.id))).go();
        deletedCount++;
      }
    }

    return deletedCount;
  }

  Future<List<String>> getAllUserImagePaths(int userId) async {
    final paths = <String>[];

    final cultivos =
        await (select(userCultivos)..where((t) => t.userId.equals(userId)))
            .get();
    paths.addAll(cultivos.map((e) => e.imagePath).whereType<String>());

    final sharedCultivosList =
        await (select(sharedCultivos)..where((t) => t.userId.equals(userId)))
            .get();
    paths.addAll(sharedCultivosList.map((e) => e.imagePath).whereType<String>());

    final ferts =
        await (select(userFertilizantes)..where((t) => t.userId.equals(userId)))
            .get();
    paths.addAll(ferts.map((e) => e.imagePath).whereType<String>());

    final sharedFerts = await (select(sharedFertilizantes)
          ..where((t) => t.userId.equals(userId)))
        .get();
    paths.addAll(sharedFerts.map((e) => e.imagePath).whereType<String>());

    final plagas =
        await (select(userPlagas)..where((t) => t.userId.equals(userId))).get();
    paths.addAll(plagas.map((e) => e.imagePath).whereType<String>());

    final sharedPlagasList =
        await (select(sharedPlagas)..where((t) => t.userId.equals(userId)))
            .get();
    paths.addAll(sharedPlagasList.map((e) => e.imagePath).whereType<String>());

    final pests =
        await (select(userPesticidas)..where((t) => t.userId.equals(userId)))
            .get();
    paths.addAll(pests.map((e) => e.imagePath).whereType<String>());

    final sharedPests =
        await (select(sharedPesticidas)..where((t) => t.userId.equals(userId)))
            .get();
    paths.addAll(sharedPests.map((e) => e.imagePath).whereType<String>());

    final enfermedades =
        await (select(userEnfermedades)..where((t) => t.userId.equals(userId)))
            .get();
    paths.addAll(enfermedades.map((e) => e.imagePath).whereType<String>());

    final sharedEnfermedadesList =
        await (select(sharedEnfermedades)..where((t) => t.userId.equals(userId)))
            .get();
    paths.addAll(sharedEnfermedadesList.map((e) => e.imagePath).whereType<String>());

    final obs =
        await (select(observations)..where((t) => t.userId.equals(userId)))
            .get();
    paths.addAll(obs.map((e) => e.cropImagePath).whereType<String>());

    return paths.toSet().toList();
  }

  Future<void> deleteAllUserData(int userId) async {
    await transaction(() async {
      await (delete(userCultivos)..where((t) => t.userId.equals(userId))).go();
      await (delete(sharedCultivos)..where((t) => t.userId.equals(userId))).go();
      await (delete(userFertilizantes)..where((t) => t.userId.equals(userId)))
          .go();
      await (delete(sharedFertilizantes)..where((t) => t.userId.equals(userId)))
          .go();
      await (delete(userPlagas)..where((t) => t.userId.equals(userId))).go();
      await (delete(sharedPlagas)..where((t) => t.userId.equals(userId))).go();
      await (delete(userPesticidas)..where((t) => t.userId.equals(userId))).go();
      await (delete(sharedPesticidas)..where((t) => t.userId.equals(userId)))
          .go();
      await (delete(userEnfermedades)..where((t) => t.userId.equals(userId)))
          .go();
      await (delete(sharedEnfermedades)..where((t) => t.userId.equals(userId)))
          .go();
      await (delete(notificationLogs)..where((t) => t.userId.equals(userId)))
          .go();
      await (delete(calendarTasks)..where((t) => t.userId.equals(userId))).go();
      await (delete(cropPlans)..where((t) => t.userId.equals(userId))).go();
      await (delete(observations)..where((t) => t.userId.equals(userId))).go();
      await (delete(soilPreparations)..where((t) => t.userId.equals(userId))).go();
    });
  }
}