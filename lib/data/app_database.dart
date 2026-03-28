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
  TextColumn get cropName => text()();
  TextColumn get cropImagePath => text().nullable()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get content => text()();
  TextColumn get plantStatus => text().nullable()();
  TextColumn get stage => text().nullable()();
  BoolColumn get hasIrrigation => boolean().withDefault(const Constant(false))();
  BoolColumn get hasPest => boolean().withDefault(const Constant(false))();
  BoolColumn get hasTransplantOrFertilization => boolean().withDefault(const Constant(false))();
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
  CropPlans,
  CalendarTasks,
  NotificationLogs,
  Observations
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  @override
  int get schemaVersion => 9;

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

    // 4. Delete the plan itself
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

  Future<void> deleteObservationsByCropName(int userId, String cropName) {
    return (delete(observations)..where((t) => t.userId.equals(userId) & t.cropName.equals(cropName))).go();
  }

  // Additional methods for CropPlans
  Future<void> deactivateCropPlan(int planId) {
    return (update(cropPlans)..where((t) => t.id.equals(planId))).write(
      const CropPlansCompanion(active: Value(false)),
    );
  }

  Future<void> deleteTasksByPlan(int planId) {
    return (delete(calendarTasks)..where((t) => t.planId.equals(planId))).go();
  }
}