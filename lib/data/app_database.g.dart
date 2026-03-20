// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarPathMeta = const VerificationMeta(
    'avatarPath',
  );
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
    'avatar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fullName,
    username,
    email,
    password,
    avatarPath,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
        _avatarPathMeta,
        avatarPath.isAcceptableOrUnknown(data['avatar_path']!, _avatarPathMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {username},
    {email},
  ];
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      )!,
      avatarPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String fullName;
  final String username;
  final String email;
  final String password;
  final String? avatarPath;
  final DateTime createdAt;
  const User({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
    this.avatarPath,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['full_name'] = Variable<String>(fullName);
    map['username'] = Variable<String>(username);
    map['email'] = Variable<String>(email);
    map['password'] = Variable<String>(password);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      fullName: Value(fullName),
      username: Value(username),
      email: Value(email),
      password: Value(password),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      username: serializer.fromJson<String>(json['username']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String>(json['password']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fullName': serializer.toJson<String>(fullName),
      'username': serializer.toJson<String>(username),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith({
    int? id,
    String? fullName,
    String? username,
    String? email,
    String? password,
    Value<String?> avatarPath = const Value.absent(),
    DateTime? createdAt,
  }) => User(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    username: username ?? this.username,
    email: email ?? this.email,
    password: password ?? this.password,
    avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
    createdAt: createdAt ?? this.createdAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      username: data.username.present ? data.username.value : this.username,
      email: data.email.present ? data.email.value : this.email,
      password: data.password.present ? data.password.value : this.password,
      avatarPath: data.avatarPath.present
          ? data.avatarPath.value
          : this.avatarPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fullName,
    username,
    email,
    password,
    avatarPath,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.username == this.username &&
          other.email == this.email &&
          other.password == this.password &&
          other.avatarPath == this.avatarPath &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> fullName;
  final Value<String> username;
  final Value<String> email;
  final Value<String> password;
  final Value<String?> avatarPath;
  final Value<DateTime> createdAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String fullName,
    required String username,
    required String email,
    required String password,
    this.avatarPath = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : fullName = Value(fullName),
       username = Value(username),
       email = Value(email),
       password = Value(password);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? fullName,
    Expression<String>? username,
    Expression<String>? email,
    Expression<String>? password,
    Expression<String>? avatarPath,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? fullName,
    Value<String>? username,
    Value<String>? email,
    Value<String>? password,
    Value<String?>? avatarPath,
    Value<DateTime>? createdAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      avatarPath: avatarPath ?? this.avatarPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, userId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final int userId;
  final DateTime createdAt;
  const Session({
    required this.id,
    required this.userId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      createdAt: Value(createdAt),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Session copyWith({int? id, int? userId, DateTime? createdAt}) => Session(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    createdAt: createdAt ?? this.createdAt,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<int> userId;
  final Value<DateTime> createdAt;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.createdAt = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<DateTime>? createdAt,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UserCultivosTable extends UserCultivos
    with TableInfo<$UserCultivosTable, UserCultivo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserCultivosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cosechaMesesMeta = const VerificationMeta(
    'cosechaMeses',
  );
  @override
  late final GeneratedColumn<int> cosechaMeses = GeneratedColumn<int>(
    'cosecha_meses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _estacionMeta = const VerificationMeta(
    'estacion',
  );
  @override
  late final GeneratedColumn<String> estacion = GeneratedColumn<String>(
    'estacion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    nombre,
    tipo,
    cosechaMeses,
    estacion,
    imagePath,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_cultivos';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserCultivo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    }
    if (data.containsKey('cosecha_meses')) {
      context.handle(
        _cosechaMesesMeta,
        cosechaMeses.isAcceptableOrUnknown(
          data['cosecha_meses']!,
          _cosechaMesesMeta,
        ),
      );
    }
    if (data.containsKey('estacion')) {
      context.handle(
        _estacionMeta,
        estacion.isAcceptableOrUnknown(data['estacion']!, _estacionMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('data')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(data['data']!, _payloadJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserCultivo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserCultivo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      cosechaMeses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cosecha_meses'],
      )!,
      estacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estacion'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
    );
  }

  @override
  $UserCultivosTable createAlias(String alias) {
    return $UserCultivosTable(attachedDatabase, alias);
  }
}

class UserCultivo extends DataClass implements Insertable<UserCultivo> {
  final int id;
  final int userId;
  final String nombre;
  final String tipo;
  final int cosechaMeses;
  final String estacion;
  final String? imagePath;
  final String payloadJson;
  const UserCultivo({
    required this.id,
    required this.userId,
    required this.nombre,
    required this.tipo,
    required this.cosechaMeses,
    required this.estacion,
    this.imagePath,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['nombre'] = Variable<String>(nombre);
    map['tipo'] = Variable<String>(tipo);
    map['cosecha_meses'] = Variable<int>(cosechaMeses);
    map['estacion'] = Variable<String>(estacion);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['data'] = Variable<String>(payloadJson);
    return map;
  }

  UserCultivosCompanion toCompanion(bool nullToAbsent) {
    return UserCultivosCompanion(
      id: Value(id),
      userId: Value(userId),
      nombre: Value(nombre),
      tipo: Value(tipo),
      cosechaMeses: Value(cosechaMeses),
      estacion: Value(estacion),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      payloadJson: Value(payloadJson),
    );
  }

  factory UserCultivo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserCultivo(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      tipo: serializer.fromJson<String>(json['tipo']),
      cosechaMeses: serializer.fromJson<int>(json['cosechaMeses']),
      estacion: serializer.fromJson<String>(json['estacion']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'nombre': serializer.toJson<String>(nombre),
      'tipo': serializer.toJson<String>(tipo),
      'cosechaMeses': serializer.toJson<int>(cosechaMeses),
      'estacion': serializer.toJson<String>(estacion),
      'imagePath': serializer.toJson<String?>(imagePath),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  UserCultivo copyWith({
    int? id,
    int? userId,
    String? nombre,
    String? tipo,
    int? cosechaMeses,
    String? estacion,
    Value<String?> imagePath = const Value.absent(),
    String? payloadJson,
  }) => UserCultivo(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    nombre: nombre ?? this.nombre,
    tipo: tipo ?? this.tipo,
    cosechaMeses: cosechaMeses ?? this.cosechaMeses,
    estacion: estacion ?? this.estacion,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  UserCultivo copyWithCompanion(UserCultivosCompanion data) {
    return UserCultivo(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      cosechaMeses: data.cosechaMeses.present
          ? data.cosechaMeses.value
          : this.cosechaMeses,
      estacion: data.estacion.present ? data.estacion.value : this.estacion,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserCultivo(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('cosechaMeses: $cosechaMeses, ')
          ..write('estacion: $estacion, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    nombre,
    tipo,
    cosechaMeses,
    estacion,
    imagePath,
    payloadJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserCultivo &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.nombre == this.nombre &&
          other.tipo == this.tipo &&
          other.cosechaMeses == this.cosechaMeses &&
          other.estacion == this.estacion &&
          other.imagePath == this.imagePath &&
          other.payloadJson == this.payloadJson);
}

class UserCultivosCompanion extends UpdateCompanion<UserCultivo> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> nombre;
  final Value<String> tipo;
  final Value<int> cosechaMeses;
  final Value<String> estacion;
  final Value<String?> imagePath;
  final Value<String> payloadJson;
  const UserCultivosCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.cosechaMeses = const Value.absent(),
    this.estacion = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.payloadJson = const Value.absent(),
  });
  UserCultivosCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.cosechaMeses = const Value.absent(),
    this.estacion = const Value.absent(),
    this.imagePath = const Value.absent(),
    required String payloadJson,
  }) : userId = Value(userId),
       payloadJson = Value(payloadJson);
  static Insertable<UserCultivo> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? nombre,
    Expression<String>? tipo,
    Expression<int>? cosechaMeses,
    Expression<String>? estacion,
    Expression<String>? imagePath,
    Expression<String>? payloadJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (nombre != null) 'nombre': nombre,
      if (tipo != null) 'tipo': tipo,
      if (cosechaMeses != null) 'cosecha_meses': cosechaMeses,
      if (estacion != null) 'estacion': estacion,
      if (imagePath != null) 'image_path': imagePath,
      if (payloadJson != null) 'data': payloadJson,
    });
  }

  UserCultivosCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? nombre,
    Value<String>? tipo,
    Value<int>? cosechaMeses,
    Value<String>? estacion,
    Value<String?>? imagePath,
    Value<String>? payloadJson,
  }) {
    return UserCultivosCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      cosechaMeses: cosechaMeses ?? this.cosechaMeses,
      estacion: estacion ?? this.estacion,
      imagePath: imagePath ?? this.imagePath,
      payloadJson: payloadJson ?? this.payloadJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (cosechaMeses.present) {
      map['cosecha_meses'] = Variable<int>(cosechaMeses.value);
    }
    if (estacion.present) {
      map['estacion'] = Variable<String>(estacion.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (payloadJson.present) {
      map['data'] = Variable<String>(payloadJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserCultivosCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('cosechaMeses: $cosechaMeses, ')
          ..write('estacion: $estacion, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }
}

class $SharedCultivosTable extends SharedCultivos
    with TableInfo<$SharedCultivosTable, SharedCultivo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SharedCultivosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cosechaMesesMeta = const VerificationMeta(
    'cosechaMeses',
  );
  @override
  late final GeneratedColumn<int> cosechaMeses = GeneratedColumn<int>(
    'cosecha_meses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _estacionMeta = const VerificationMeta(
    'estacion',
  );
  @override
  late final GeneratedColumn<String> estacion = GeneratedColumn<String>(
    'estacion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    nombre,
    tipo,
    cosechaMeses,
    estacion,
    imagePath,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shared_cultivos';
  @override
  VerificationContext validateIntegrity(
    Insertable<SharedCultivo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    }
    if (data.containsKey('cosecha_meses')) {
      context.handle(
        _cosechaMesesMeta,
        cosechaMeses.isAcceptableOrUnknown(
          data['cosecha_meses']!,
          _cosechaMesesMeta,
        ),
      );
    }
    if (data.containsKey('estacion')) {
      context.handle(
        _estacionMeta,
        estacion.isAcceptableOrUnknown(data['estacion']!, _estacionMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SharedCultivo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SharedCultivo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      cosechaMeses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cosecha_meses'],
      )!,
      estacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estacion'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $SharedCultivosTable createAlias(String alias) {
    return $SharedCultivosTable(attachedDatabase, alias);
  }
}

class SharedCultivo extends DataClass implements Insertable<SharedCultivo> {
  final int id;
  final int userId;
  final String nombre;
  final String tipo;
  final int cosechaMeses;
  final String estacion;
  final String? imagePath;
  final String payloadJson;
  const SharedCultivo({
    required this.id,
    required this.userId,
    required this.nombre,
    required this.tipo,
    required this.cosechaMeses,
    required this.estacion,
    this.imagePath,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['nombre'] = Variable<String>(nombre);
    map['tipo'] = Variable<String>(tipo);
    map['cosecha_meses'] = Variable<int>(cosechaMeses);
    map['estacion'] = Variable<String>(estacion);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  SharedCultivosCompanion toCompanion(bool nullToAbsent) {
    return SharedCultivosCompanion(
      id: Value(id),
      userId: Value(userId),
      nombre: Value(nombre),
      tipo: Value(tipo),
      cosechaMeses: Value(cosechaMeses),
      estacion: Value(estacion),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      payloadJson: Value(payloadJson),
    );
  }

  factory SharedCultivo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SharedCultivo(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      tipo: serializer.fromJson<String>(json['tipo']),
      cosechaMeses: serializer.fromJson<int>(json['cosechaMeses']),
      estacion: serializer.fromJson<String>(json['estacion']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'nombre': serializer.toJson<String>(nombre),
      'tipo': serializer.toJson<String>(tipo),
      'cosechaMeses': serializer.toJson<int>(cosechaMeses),
      'estacion': serializer.toJson<String>(estacion),
      'imagePath': serializer.toJson<String?>(imagePath),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  SharedCultivo copyWith({
    int? id,
    int? userId,
    String? nombre,
    String? tipo,
    int? cosechaMeses,
    String? estacion,
    Value<String?> imagePath = const Value.absent(),
    String? payloadJson,
  }) => SharedCultivo(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    nombre: nombre ?? this.nombre,
    tipo: tipo ?? this.tipo,
    cosechaMeses: cosechaMeses ?? this.cosechaMeses,
    estacion: estacion ?? this.estacion,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  SharedCultivo copyWithCompanion(SharedCultivosCompanion data) {
    return SharedCultivo(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      cosechaMeses: data.cosechaMeses.present
          ? data.cosechaMeses.value
          : this.cosechaMeses,
      estacion: data.estacion.present ? data.estacion.value : this.estacion,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SharedCultivo(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('cosechaMeses: $cosechaMeses, ')
          ..write('estacion: $estacion, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    nombre,
    tipo,
    cosechaMeses,
    estacion,
    imagePath,
    payloadJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SharedCultivo &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.nombre == this.nombre &&
          other.tipo == this.tipo &&
          other.cosechaMeses == this.cosechaMeses &&
          other.estacion == this.estacion &&
          other.imagePath == this.imagePath &&
          other.payloadJson == this.payloadJson);
}

class SharedCultivosCompanion extends UpdateCompanion<SharedCultivo> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> nombre;
  final Value<String> tipo;
  final Value<int> cosechaMeses;
  final Value<String> estacion;
  final Value<String?> imagePath;
  final Value<String> payloadJson;
  const SharedCultivosCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.cosechaMeses = const Value.absent(),
    this.estacion = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.payloadJson = const Value.absent(),
  });
  SharedCultivosCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.cosechaMeses = const Value.absent(),
    this.estacion = const Value.absent(),
    this.imagePath = const Value.absent(),
    required String payloadJson,
  }) : userId = Value(userId),
       payloadJson = Value(payloadJson);
  static Insertable<SharedCultivo> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? nombre,
    Expression<String>? tipo,
    Expression<int>? cosechaMeses,
    Expression<String>? estacion,
    Expression<String>? imagePath,
    Expression<String>? payloadJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (nombre != null) 'nombre': nombre,
      if (tipo != null) 'tipo': tipo,
      if (cosechaMeses != null) 'cosecha_meses': cosechaMeses,
      if (estacion != null) 'estacion': estacion,
      if (imagePath != null) 'image_path': imagePath,
      if (payloadJson != null) 'payload_json': payloadJson,
    });
  }

  SharedCultivosCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? nombre,
    Value<String>? tipo,
    Value<int>? cosechaMeses,
    Value<String>? estacion,
    Value<String?>? imagePath,
    Value<String>? payloadJson,
  }) {
    return SharedCultivosCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      cosechaMeses: cosechaMeses ?? this.cosechaMeses,
      estacion: estacion ?? this.estacion,
      imagePath: imagePath ?? this.imagePath,
      payloadJson: payloadJson ?? this.payloadJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (cosechaMeses.present) {
      map['cosecha_meses'] = Variable<int>(cosechaMeses.value);
    }
    if (estacion.present) {
      map['estacion'] = Variable<String>(estacion.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SharedCultivosCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('cosechaMeses: $cosechaMeses, ')
          ..write('estacion: $estacion, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }
}

class $UserFertilizantesTable extends UserFertilizantes
    with TableInfo<$UserFertilizantesTable, UserFertilizante> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserFertilizantesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    nombre,
    tipo,
    imagePath,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_fertilizantes';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserFertilizante> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserFertilizante map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserFertilizante(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $UserFertilizantesTable createAlias(String alias) {
    return $UserFertilizantesTable(attachedDatabase, alias);
  }
}

class UserFertilizante extends DataClass
    implements Insertable<UserFertilizante> {
  final int id;
  final int userId;
  final String nombre;
  final String tipo;
  final String? imagePath;
  final String payloadJson;
  const UserFertilizante({
    required this.id,
    required this.userId,
    required this.nombre,
    required this.tipo,
    this.imagePath,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['nombre'] = Variable<String>(nombre);
    map['tipo'] = Variable<String>(tipo);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  UserFertilizantesCompanion toCompanion(bool nullToAbsent) {
    return UserFertilizantesCompanion(
      id: Value(id),
      userId: Value(userId),
      nombre: Value(nombre),
      tipo: Value(tipo),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      payloadJson: Value(payloadJson),
    );
  }

  factory UserFertilizante.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserFertilizante(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      tipo: serializer.fromJson<String>(json['tipo']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'nombre': serializer.toJson<String>(nombre),
      'tipo': serializer.toJson<String>(tipo),
      'imagePath': serializer.toJson<String?>(imagePath),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  UserFertilizante copyWith({
    int? id,
    int? userId,
    String? nombre,
    String? tipo,
    Value<String?> imagePath = const Value.absent(),
    String? payloadJson,
  }) => UserFertilizante(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    nombre: nombre ?? this.nombre,
    tipo: tipo ?? this.tipo,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  UserFertilizante copyWithCompanion(UserFertilizantesCompanion data) {
    return UserFertilizante(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserFertilizante(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, nombre, tipo, imagePath, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserFertilizante &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.nombre == this.nombre &&
          other.tipo == this.tipo &&
          other.imagePath == this.imagePath &&
          other.payloadJson == this.payloadJson);
}

class UserFertilizantesCompanion extends UpdateCompanion<UserFertilizante> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> nombre;
  final Value<String> tipo;
  final Value<String?> imagePath;
  final Value<String> payloadJson;
  const UserFertilizantesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.payloadJson = const Value.absent(),
  });
  UserFertilizantesCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.imagePath = const Value.absent(),
    required String payloadJson,
  }) : userId = Value(userId),
       payloadJson = Value(payloadJson);
  static Insertable<UserFertilizante> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? nombre,
    Expression<String>? tipo,
    Expression<String>? imagePath,
    Expression<String>? payloadJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (nombre != null) 'nombre': nombre,
      if (tipo != null) 'tipo': tipo,
      if (imagePath != null) 'image_path': imagePath,
      if (payloadJson != null) 'payload_json': payloadJson,
    });
  }

  UserFertilizantesCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? nombre,
    Value<String>? tipo,
    Value<String?>? imagePath,
    Value<String>? payloadJson,
  }) {
    return UserFertilizantesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      imagePath: imagePath ?? this.imagePath,
      payloadJson: payloadJson ?? this.payloadJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserFertilizantesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }
}

class $SharedFertilizantesTable extends SharedFertilizantes
    with TableInfo<$SharedFertilizantesTable, SharedFertilizante> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SharedFertilizantesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    nombre,
    tipo,
    imagePath,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shared_fertilizantes';
  @override
  VerificationContext validateIntegrity(
    Insertable<SharedFertilizante> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SharedFertilizante map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SharedFertilizante(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $SharedFertilizantesTable createAlias(String alias) {
    return $SharedFertilizantesTable(attachedDatabase, alias);
  }
}

class SharedFertilizante extends DataClass
    implements Insertable<SharedFertilizante> {
  final int id;
  final int userId;
  final String nombre;
  final String tipo;
  final String? imagePath;
  final String payloadJson;
  const SharedFertilizante({
    required this.id,
    required this.userId,
    required this.nombre,
    required this.tipo,
    this.imagePath,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['nombre'] = Variable<String>(nombre);
    map['tipo'] = Variable<String>(tipo);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  SharedFertilizantesCompanion toCompanion(bool nullToAbsent) {
    return SharedFertilizantesCompanion(
      id: Value(id),
      userId: Value(userId),
      nombre: Value(nombre),
      tipo: Value(tipo),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      payloadJson: Value(payloadJson),
    );
  }

  factory SharedFertilizante.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SharedFertilizante(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      tipo: serializer.fromJson<String>(json['tipo']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'nombre': serializer.toJson<String>(nombre),
      'tipo': serializer.toJson<String>(tipo),
      'imagePath': serializer.toJson<String?>(imagePath),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  SharedFertilizante copyWith({
    int? id,
    int? userId,
    String? nombre,
    String? tipo,
    Value<String?> imagePath = const Value.absent(),
    String? payloadJson,
  }) => SharedFertilizante(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    nombre: nombre ?? this.nombre,
    tipo: tipo ?? this.tipo,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  SharedFertilizante copyWithCompanion(SharedFertilizantesCompanion data) {
    return SharedFertilizante(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SharedFertilizante(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, nombre, tipo, imagePath, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SharedFertilizante &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.nombre == this.nombre &&
          other.tipo == this.tipo &&
          other.imagePath == this.imagePath &&
          other.payloadJson == this.payloadJson);
}

class SharedFertilizantesCompanion extends UpdateCompanion<SharedFertilizante> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> nombre;
  final Value<String> tipo;
  final Value<String?> imagePath;
  final Value<String> payloadJson;
  const SharedFertilizantesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.payloadJson = const Value.absent(),
  });
  SharedFertilizantesCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.imagePath = const Value.absent(),
    required String payloadJson,
  }) : userId = Value(userId),
       payloadJson = Value(payloadJson);
  static Insertable<SharedFertilizante> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? nombre,
    Expression<String>? tipo,
    Expression<String>? imagePath,
    Expression<String>? payloadJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (nombre != null) 'nombre': nombre,
      if (tipo != null) 'tipo': tipo,
      if (imagePath != null) 'image_path': imagePath,
      if (payloadJson != null) 'payload_json': payloadJson,
    });
  }

  SharedFertilizantesCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? nombre,
    Value<String>? tipo,
    Value<String?>? imagePath,
    Value<String>? payloadJson,
  }) {
    return SharedFertilizantesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      imagePath: imagePath ?? this.imagePath,
      payloadJson: payloadJson ?? this.payloadJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SharedFertilizantesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }
}

class $UserPlagasTable extends UserPlagas
    with TableInfo<$UserPlagasTable, UserPlaga> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPlagasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cientificoMeta = const VerificationMeta(
    'cientifico',
  );
  @override
  late final GeneratedColumn<String> cientifico = GeneratedColumn<String>(
    'cientifico',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    nombre,
    cientifico,
    imagePath,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_plagas';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserPlaga> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    }
    if (data.containsKey('cientifico')) {
      context.handle(
        _cientificoMeta,
        cientifico.isAcceptableOrUnknown(data['cientifico']!, _cientificoMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPlaga map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPlaga(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      cientifico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cientifico'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $UserPlagasTable createAlias(String alias) {
    return $UserPlagasTable(attachedDatabase, alias);
  }
}

class UserPlaga extends DataClass implements Insertable<UserPlaga> {
  final int id;
  final int userId;
  final String nombre;
  final String cientifico;
  final String? imagePath;
  final String payloadJson;
  const UserPlaga({
    required this.id,
    required this.userId,
    required this.nombre,
    required this.cientifico,
    this.imagePath,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['nombre'] = Variable<String>(nombre);
    map['cientifico'] = Variable<String>(cientifico);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  UserPlagasCompanion toCompanion(bool nullToAbsent) {
    return UserPlagasCompanion(
      id: Value(id),
      userId: Value(userId),
      nombre: Value(nombre),
      cientifico: Value(cientifico),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      payloadJson: Value(payloadJson),
    );
  }

  factory UserPlaga.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPlaga(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      cientifico: serializer.fromJson<String>(json['cientifico']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'nombre': serializer.toJson<String>(nombre),
      'cientifico': serializer.toJson<String>(cientifico),
      'imagePath': serializer.toJson<String?>(imagePath),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  UserPlaga copyWith({
    int? id,
    int? userId,
    String? nombre,
    String? cientifico,
    Value<String?> imagePath = const Value.absent(),
    String? payloadJson,
  }) => UserPlaga(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    nombre: nombre ?? this.nombre,
    cientifico: cientifico ?? this.cientifico,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  UserPlaga copyWithCompanion(UserPlagasCompanion data) {
    return UserPlaga(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      cientifico: data.cientifico.present
          ? data.cientifico.value
          : this.cientifico,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPlaga(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nombre: $nombre, ')
          ..write('cientifico: $cientifico, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, nombre, cientifico, imagePath, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPlaga &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.nombre == this.nombre &&
          other.cientifico == this.cientifico &&
          other.imagePath == this.imagePath &&
          other.payloadJson == this.payloadJson);
}

class UserPlagasCompanion extends UpdateCompanion<UserPlaga> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> nombre;
  final Value<String> cientifico;
  final Value<String?> imagePath;
  final Value<String> payloadJson;
  const UserPlagasCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.cientifico = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.payloadJson = const Value.absent(),
  });
  UserPlagasCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.nombre = const Value.absent(),
    this.cientifico = const Value.absent(),
    this.imagePath = const Value.absent(),
    required String payloadJson,
  }) : userId = Value(userId),
       payloadJson = Value(payloadJson);
  static Insertable<UserPlaga> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? nombre,
    Expression<String>? cientifico,
    Expression<String>? imagePath,
    Expression<String>? payloadJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (nombre != null) 'nombre': nombre,
      if (cientifico != null) 'cientifico': cientifico,
      if (imagePath != null) 'image_path': imagePath,
      if (payloadJson != null) 'payload_json': payloadJson,
    });
  }

  UserPlagasCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? nombre,
    Value<String>? cientifico,
    Value<String?>? imagePath,
    Value<String>? payloadJson,
  }) {
    return UserPlagasCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nombre: nombre ?? this.nombre,
      cientifico: cientifico ?? this.cientifico,
      imagePath: imagePath ?? this.imagePath,
      payloadJson: payloadJson ?? this.payloadJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (cientifico.present) {
      map['cientifico'] = Variable<String>(cientifico.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPlagasCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nombre: $nombre, ')
          ..write('cientifico: $cientifico, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }
}

class $SharedPlagasTable extends SharedPlagas
    with TableInfo<$SharedPlagasTable, SharedPlaga> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SharedPlagasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cientificoMeta = const VerificationMeta(
    'cientifico',
  );
  @override
  late final GeneratedColumn<String> cientifico = GeneratedColumn<String>(
    'cientifico',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    nombre,
    cientifico,
    imagePath,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shared_plagas';
  @override
  VerificationContext validateIntegrity(
    Insertable<SharedPlaga> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    }
    if (data.containsKey('cientifico')) {
      context.handle(
        _cientificoMeta,
        cientifico.isAcceptableOrUnknown(data['cientifico']!, _cientificoMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SharedPlaga map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SharedPlaga(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      cientifico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cientifico'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $SharedPlagasTable createAlias(String alias) {
    return $SharedPlagasTable(attachedDatabase, alias);
  }
}

class SharedPlaga extends DataClass implements Insertable<SharedPlaga> {
  final int id;
  final int userId;
  final String nombre;
  final String cientifico;
  final String? imagePath;
  final String payloadJson;
  const SharedPlaga({
    required this.id,
    required this.userId,
    required this.nombre,
    required this.cientifico,
    this.imagePath,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['nombre'] = Variable<String>(nombre);
    map['cientifico'] = Variable<String>(cientifico);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  SharedPlagasCompanion toCompanion(bool nullToAbsent) {
    return SharedPlagasCompanion(
      id: Value(id),
      userId: Value(userId),
      nombre: Value(nombre),
      cientifico: Value(cientifico),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      payloadJson: Value(payloadJson),
    );
  }

  factory SharedPlaga.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SharedPlaga(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      cientifico: serializer.fromJson<String>(json['cientifico']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'nombre': serializer.toJson<String>(nombre),
      'cientifico': serializer.toJson<String>(cientifico),
      'imagePath': serializer.toJson<String?>(imagePath),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  SharedPlaga copyWith({
    int? id,
    int? userId,
    String? nombre,
    String? cientifico,
    Value<String?> imagePath = const Value.absent(),
    String? payloadJson,
  }) => SharedPlaga(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    nombre: nombre ?? this.nombre,
    cientifico: cientifico ?? this.cientifico,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  SharedPlaga copyWithCompanion(SharedPlagasCompanion data) {
    return SharedPlaga(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      cientifico: data.cientifico.present
          ? data.cientifico.value
          : this.cientifico,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SharedPlaga(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nombre: $nombre, ')
          ..write('cientifico: $cientifico, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, nombre, cientifico, imagePath, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SharedPlaga &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.nombre == this.nombre &&
          other.cientifico == this.cientifico &&
          other.imagePath == this.imagePath &&
          other.payloadJson == this.payloadJson);
}

class SharedPlagasCompanion extends UpdateCompanion<SharedPlaga> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> nombre;
  final Value<String> cientifico;
  final Value<String?> imagePath;
  final Value<String> payloadJson;
  const SharedPlagasCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.cientifico = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.payloadJson = const Value.absent(),
  });
  SharedPlagasCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.nombre = const Value.absent(),
    this.cientifico = const Value.absent(),
    this.imagePath = const Value.absent(),
    required String payloadJson,
  }) : userId = Value(userId),
       payloadJson = Value(payloadJson);
  static Insertable<SharedPlaga> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? nombre,
    Expression<String>? cientifico,
    Expression<String>? imagePath,
    Expression<String>? payloadJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (nombre != null) 'nombre': nombre,
      if (cientifico != null) 'cientifico': cientifico,
      if (imagePath != null) 'image_path': imagePath,
      if (payloadJson != null) 'payload_json': payloadJson,
    });
  }

  SharedPlagasCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? nombre,
    Value<String>? cientifico,
    Value<String?>? imagePath,
    Value<String>? payloadJson,
  }) {
    return SharedPlagasCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nombre: nombre ?? this.nombre,
      cientifico: cientifico ?? this.cientifico,
      imagePath: imagePath ?? this.imagePath,
      payloadJson: payloadJson ?? this.payloadJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (cientifico.present) {
      map['cientifico'] = Variable<String>(cientifico.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SharedPlagasCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nombre: $nombre, ')
          ..write('cientifico: $cientifico, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }
}

class $UserPesticidasTable extends UserPesticidas
    with TableInfo<$UserPesticidasTable, UserPesticida> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPesticidasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    nombre,
    tipo,
    imagePath,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_pesticidas';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserPesticida> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPesticida map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPesticida(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $UserPesticidasTable createAlias(String alias) {
    return $UserPesticidasTable(attachedDatabase, alias);
  }
}

class UserPesticida extends DataClass implements Insertable<UserPesticida> {
  final int id;
  final int userId;
  final String nombre;
  final String tipo;
  final String? imagePath;
  final String payloadJson;
  const UserPesticida({
    required this.id,
    required this.userId,
    required this.nombre,
    required this.tipo,
    this.imagePath,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['nombre'] = Variable<String>(nombre);
    map['tipo'] = Variable<String>(tipo);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  UserPesticidasCompanion toCompanion(bool nullToAbsent) {
    return UserPesticidasCompanion(
      id: Value(id),
      userId: Value(userId),
      nombre: Value(nombre),
      tipo: Value(tipo),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      payloadJson: Value(payloadJson),
    );
  }

  factory UserPesticida.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPesticida(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      tipo: serializer.fromJson<String>(json['tipo']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'nombre': serializer.toJson<String>(nombre),
      'tipo': serializer.toJson<String>(tipo),
      'imagePath': serializer.toJson<String?>(imagePath),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  UserPesticida copyWith({
    int? id,
    int? userId,
    String? nombre,
    String? tipo,
    Value<String?> imagePath = const Value.absent(),
    String? payloadJson,
  }) => UserPesticida(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    nombre: nombre ?? this.nombre,
    tipo: tipo ?? this.tipo,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  UserPesticida copyWithCompanion(UserPesticidasCompanion data) {
    return UserPesticida(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPesticida(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, nombre, tipo, imagePath, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPesticida &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.nombre == this.nombre &&
          other.tipo == this.tipo &&
          other.imagePath == this.imagePath &&
          other.payloadJson == this.payloadJson);
}

class UserPesticidasCompanion extends UpdateCompanion<UserPesticida> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> nombre;
  final Value<String> tipo;
  final Value<String?> imagePath;
  final Value<String> payloadJson;
  const UserPesticidasCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.payloadJson = const Value.absent(),
  });
  UserPesticidasCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.imagePath = const Value.absent(),
    required String payloadJson,
  }) : userId = Value(userId),
       payloadJson = Value(payloadJson);
  static Insertable<UserPesticida> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? nombre,
    Expression<String>? tipo,
    Expression<String>? imagePath,
    Expression<String>? payloadJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (nombre != null) 'nombre': nombre,
      if (tipo != null) 'tipo': tipo,
      if (imagePath != null) 'image_path': imagePath,
      if (payloadJson != null) 'payload_json': payloadJson,
    });
  }

  UserPesticidasCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? nombre,
    Value<String>? tipo,
    Value<String?>? imagePath,
    Value<String>? payloadJson,
  }) {
    return UserPesticidasCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      imagePath: imagePath ?? this.imagePath,
      payloadJson: payloadJson ?? this.payloadJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPesticidasCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }
}

class $SharedPesticidasTable extends SharedPesticidas
    with TableInfo<$SharedPesticidasTable, SharedPesticida> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SharedPesticidasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    nombre,
    tipo,
    imagePath,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shared_pesticidas';
  @override
  VerificationContext validateIntegrity(
    Insertable<SharedPesticida> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SharedPesticida map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SharedPesticida(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $SharedPesticidasTable createAlias(String alias) {
    return $SharedPesticidasTable(attachedDatabase, alias);
  }
}

class SharedPesticida extends DataClass implements Insertable<SharedPesticida> {
  final int id;
  final int userId;
  final String nombre;
  final String tipo;
  final String? imagePath;
  final String payloadJson;
  const SharedPesticida({
    required this.id,
    required this.userId,
    required this.nombre,
    required this.tipo,
    this.imagePath,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['nombre'] = Variable<String>(nombre);
    map['tipo'] = Variable<String>(tipo);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  SharedPesticidasCompanion toCompanion(bool nullToAbsent) {
    return SharedPesticidasCompanion(
      id: Value(id),
      userId: Value(userId),
      nombre: Value(nombre),
      tipo: Value(tipo),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      payloadJson: Value(payloadJson),
    );
  }

  factory SharedPesticida.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SharedPesticida(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      tipo: serializer.fromJson<String>(json['tipo']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'nombre': serializer.toJson<String>(nombre),
      'tipo': serializer.toJson<String>(tipo),
      'imagePath': serializer.toJson<String?>(imagePath),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  SharedPesticida copyWith({
    int? id,
    int? userId,
    String? nombre,
    String? tipo,
    Value<String?> imagePath = const Value.absent(),
    String? payloadJson,
  }) => SharedPesticida(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    nombre: nombre ?? this.nombre,
    tipo: tipo ?? this.tipo,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  SharedPesticida copyWithCompanion(SharedPesticidasCompanion data) {
    return SharedPesticida(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SharedPesticida(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, nombre, tipo, imagePath, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SharedPesticida &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.nombre == this.nombre &&
          other.tipo == this.tipo &&
          other.imagePath == this.imagePath &&
          other.payloadJson == this.payloadJson);
}

class SharedPesticidasCompanion extends UpdateCompanion<SharedPesticida> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> nombre;
  final Value<String> tipo;
  final Value<String?> imagePath;
  final Value<String> payloadJson;
  const SharedPesticidasCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.payloadJson = const Value.absent(),
  });
  SharedPesticidasCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.imagePath = const Value.absent(),
    required String payloadJson,
  }) : userId = Value(userId),
       payloadJson = Value(payloadJson);
  static Insertable<SharedPesticida> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? nombre,
    Expression<String>? tipo,
    Expression<String>? imagePath,
    Expression<String>? payloadJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (nombre != null) 'nombre': nombre,
      if (tipo != null) 'tipo': tipo,
      if (imagePath != null) 'image_path': imagePath,
      if (payloadJson != null) 'payload_json': payloadJson,
    });
  }

  SharedPesticidasCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? nombre,
    Value<String>? tipo,
    Value<String?>? imagePath,
    Value<String>? payloadJson,
  }) {
    return SharedPesticidasCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      imagePath: imagePath ?? this.imagePath,
      payloadJson: payloadJson ?? this.payloadJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SharedPesticidasCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }
}

class $CropPlansTable extends CropPlans
    with TableInfo<$CropPlansTable, CropPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CropPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cropNameMeta = const VerificationMeta(
    'cropName',
  );
  @override
  late final GeneratedColumn<String> cropName = GeneratedColumn<String>(
    'crop_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _preferredTimeMeta = const VerificationMeta(
    'preferredTime',
  );
  @override
  late final GeneratedColumn<String> preferredTime = GeneratedColumn<String>(
    'preferred_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    cropName,
    startDate,
    preferredTime,
    payloadJson,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'crop_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<CropPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('crop_name')) {
      context.handle(
        _cropNameMeta,
        cropName.isAcceptableOrUnknown(data['crop_name']!, _cropNameMeta),
      );
    } else if (isInserting) {
      context.missing(_cropNameMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('preferred_time')) {
      context.handle(
        _preferredTimeMeta,
        preferredTime.isAcceptableOrUnknown(
          data['preferred_time']!,
          _preferredTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_preferredTimeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CropPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CropPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      cropName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop_name'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      preferredTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_time'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $CropPlansTable createAlias(String alias) {
    return $CropPlansTable(attachedDatabase, alias);
  }
}

class CropPlan extends DataClass implements Insertable<CropPlan> {
  final int id;
  final int userId;
  final String cropName;
  final DateTime startDate;
  final String preferredTime;
  final String payloadJson;
  final bool active;
  const CropPlan({
    required this.id,
    required this.userId,
    required this.cropName,
    required this.startDate,
    required this.preferredTime,
    required this.payloadJson,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['crop_name'] = Variable<String>(cropName);
    map['start_date'] = Variable<DateTime>(startDate);
    map['preferred_time'] = Variable<String>(preferredTime);
    map['payload_json'] = Variable<String>(payloadJson);
    map['active'] = Variable<bool>(active);
    return map;
  }

  CropPlansCompanion toCompanion(bool nullToAbsent) {
    return CropPlansCompanion(
      id: Value(id),
      userId: Value(userId),
      cropName: Value(cropName),
      startDate: Value(startDate),
      preferredTime: Value(preferredTime),
      payloadJson: Value(payloadJson),
      active: Value(active),
    );
  }

  factory CropPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CropPlan(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      cropName: serializer.fromJson<String>(json['cropName']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      preferredTime: serializer.fromJson<String>(json['preferredTime']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'cropName': serializer.toJson<String>(cropName),
      'startDate': serializer.toJson<DateTime>(startDate),
      'preferredTime': serializer.toJson<String>(preferredTime),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'active': serializer.toJson<bool>(active),
    };
  }

  CropPlan copyWith({
    int? id,
    int? userId,
    String? cropName,
    DateTime? startDate,
    String? preferredTime,
    String? payloadJson,
    bool? active,
  }) => CropPlan(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    cropName: cropName ?? this.cropName,
    startDate: startDate ?? this.startDate,
    preferredTime: preferredTime ?? this.preferredTime,
    payloadJson: payloadJson ?? this.payloadJson,
    active: active ?? this.active,
  );
  CropPlan copyWithCompanion(CropPlansCompanion data) {
    return CropPlan(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      cropName: data.cropName.present ? data.cropName.value : this.cropName,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      preferredTime: data.preferredTime.present
          ? data.preferredTime.value
          : this.preferredTime,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CropPlan(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('cropName: $cropName, ')
          ..write('startDate: $startDate, ')
          ..write('preferredTime: $preferredTime, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    cropName,
    startDate,
    preferredTime,
    payloadJson,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CropPlan &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.cropName == this.cropName &&
          other.startDate == this.startDate &&
          other.preferredTime == this.preferredTime &&
          other.payloadJson == this.payloadJson &&
          other.active == this.active);
}

class CropPlansCompanion extends UpdateCompanion<CropPlan> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> cropName;
  final Value<DateTime> startDate;
  final Value<String> preferredTime;
  final Value<String> payloadJson;
  final Value<bool> active;
  const CropPlansCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.cropName = const Value.absent(),
    this.startDate = const Value.absent(),
    this.preferredTime = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.active = const Value.absent(),
  });
  CropPlansCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String cropName,
    required DateTime startDate,
    required String preferredTime,
    required String payloadJson,
    this.active = const Value.absent(),
  }) : userId = Value(userId),
       cropName = Value(cropName),
       startDate = Value(startDate),
       preferredTime = Value(preferredTime),
       payloadJson = Value(payloadJson);
  static Insertable<CropPlan> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? cropName,
    Expression<DateTime>? startDate,
    Expression<String>? preferredTime,
    Expression<String>? payloadJson,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (cropName != null) 'crop_name': cropName,
      if (startDate != null) 'start_date': startDate,
      if (preferredTime != null) 'preferred_time': preferredTime,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (active != null) 'active': active,
    });
  }

  CropPlansCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? cropName,
    Value<DateTime>? startDate,
    Value<String>? preferredTime,
    Value<String>? payloadJson,
    Value<bool>? active,
  }) {
    return CropPlansCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cropName: cropName ?? this.cropName,
      startDate: startDate ?? this.startDate,
      preferredTime: preferredTime ?? this.preferredTime,
      payloadJson: payloadJson ?? this.payloadJson,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (cropName.present) {
      map['crop_name'] = Variable<String>(cropName.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (preferredTime.present) {
      map['preferred_time'] = Variable<String>(preferredTime.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CropPlansCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('cropName: $cropName, ')
          ..write('startDate: $startDate, ')
          ..write('preferredTime: $preferredTime, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $CalendarTasksTable extends CalendarTasks
    with TableInfo<$CalendarTasksTable, CalendarTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
    'plan_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planId,
    userId,
    title,
    description,
    date,
    type,
    completed,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalendarTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_id'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $CalendarTasksTable createAlias(String alias) {
    return $CalendarTasksTable(attachedDatabase, alias);
  }
}

class CalendarTask extends DataClass implements Insertable<CalendarTask> {
  final int id;
  final int? planId;
  final int userId;
  final String title;
  final String? description;
  final DateTime date;
  final String type;
  final bool completed;
  final DateTime? completedAt;
  const CalendarTask({
    required this.id,
    this.planId,
    required this.userId,
    required this.title,
    this.description,
    required this.date,
    required this.type,
    required this.completed,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || planId != null) {
      map['plan_id'] = Variable<int>(planId);
    }
    map['user_id'] = Variable<int>(userId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  CalendarTasksCompanion toCompanion(bool nullToAbsent) {
    return CalendarTasksCompanion(
      id: Value(id),
      planId: planId == null && nullToAbsent
          ? const Value.absent()
          : Value(planId),
      userId: Value(userId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      date: Value(date),
      type: Value(type),
      completed: Value(completed),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory CalendarTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarTask(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<int?>(json['planId']),
      userId: serializer.fromJson<int>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      completed: serializer.fromJson<bool>(json['completed']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<int?>(planId),
      'userId': serializer.toJson<int>(userId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
      'completed': serializer.toJson<bool>(completed),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  CalendarTask copyWith({
    int? id,
    Value<int?> planId = const Value.absent(),
    int? userId,
    String? title,
    Value<String?> description = const Value.absent(),
    DateTime? date,
    String? type,
    bool? completed,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => CalendarTask(
    id: id ?? this.id,
    planId: planId.present ? planId.value : this.planId,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    date: date ?? this.date,
    type: type ?? this.type,
    completed: completed ?? this.completed,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  CalendarTask copyWithCompanion(CalendarTasksCompanion data) {
    return CalendarTask(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      completed: data.completed.present ? data.completed.value : this.completed,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarTask(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    planId,
    userId,
    title,
    description,
    date,
    type,
    completed,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarTask &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.description == this.description &&
          other.date == this.date &&
          other.type == this.type &&
          other.completed == this.completed &&
          other.completedAt == this.completedAt);
}

class CalendarTasksCompanion extends UpdateCompanion<CalendarTask> {
  final Value<int> id;
  final Value<int?> planId;
  final Value<int> userId;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<bool> completed;
  final Value<DateTime?> completedAt;
  const CalendarTasksCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  CalendarTasksCompanion.insert({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    required int userId,
    required String title,
    this.description = const Value.absent(),
    required DateTime date,
    required String type,
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
  }) : userId = Value(userId),
       title = Value(title),
       date = Value(date),
       type = Value(type);
  static Insertable<CalendarTask> custom({
    Expression<int>? id,
    Expression<int>? planId,
    Expression<int>? userId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<bool>? completed,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (completed != null) 'completed': completed,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  CalendarTasksCompanion copyWith({
    Value<int>? id,
    Value<int?>? planId,
    Value<int>? userId,
    Value<String>? title,
    Value<String?>? description,
    Value<DateTime>? date,
    Value<String>? type,
    Value<bool>? completed,
    Value<DateTime?>? completedAt,
  }) {
    return CalendarTasksCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      type: type ?? this.type,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarTasksCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $NotificationLogsTable extends NotificationLogs
    with TableInfo<$NotificationLogsTable, NotificationLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _readMeta = const VerificationMeta('read');
  @override
  late final GeneratedColumn<bool> read = GeneratedColumn<bool>(
    'read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unread'),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    title,
    body,
    timestamp,
    read,
    status,
    taskId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    if (data.containsKey('read')) {
      context.handle(
        _readMeta,
        read.isAcceptableOrUnknown(data['read']!, _readMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      read: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}read'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      ),
    );
  }

  @override
  $NotificationLogsTable createAlias(String alias) {
    return $NotificationLogsTable(attachedDatabase, alias);
  }
}

class NotificationLog extends DataClass implements Insertable<NotificationLog> {
  final int id;
  final int userId;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool read;
  final String status;
  final int? taskId;
  const NotificationLog({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.read,
    required this.status,
    this.taskId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['read'] = Variable<bool>(read);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<int>(taskId);
    }
    return map;
  }

  NotificationLogsCompanion toCompanion(bool nullToAbsent) {
    return NotificationLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      body: Value(body),
      timestamp: Value(timestamp),
      read: Value(read),
      status: Value(status),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
    );
  }

  factory NotificationLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationLog(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      read: serializer.fromJson<bool>(json['read']),
      status: serializer.fromJson<String>(json['status']),
      taskId: serializer.fromJson<int?>(json['taskId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'read': serializer.toJson<bool>(read),
      'status': serializer.toJson<String>(status),
      'taskId': serializer.toJson<int?>(taskId),
    };
  }

  NotificationLog copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    DateTime? timestamp,
    bool? read,
    String? status,
    Value<int?> taskId = const Value.absent(),
  }) => NotificationLog(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    body: body ?? this.body,
    timestamp: timestamp ?? this.timestamp,
    read: read ?? this.read,
    status: status ?? this.status,
    taskId: taskId.present ? taskId.value : this.taskId,
  );
  NotificationLog copyWithCompanion(NotificationLogsCompanion data) {
    return NotificationLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      read: data.read.present ? data.read.value : this.read,
      status: data.status.present ? data.status.value : this.status,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp, ')
          ..write('read: $read, ')
          ..write('status: $status, ')
          ..write('taskId: $taskId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, title, body, timestamp, read, status, taskId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.body == this.body &&
          other.timestamp == this.timestamp &&
          other.read == this.read &&
          other.status == this.status &&
          other.taskId == this.taskId);
}

class NotificationLogsCompanion extends UpdateCompanion<NotificationLog> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> title;
  final Value<String> body;
  final Value<DateTime> timestamp;
  final Value<bool> read;
  final Value<String> status;
  final Value<int?> taskId;
  const NotificationLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.read = const Value.absent(),
    this.status = const Value.absent(),
    this.taskId = const Value.absent(),
  });
  NotificationLogsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String title,
    required String body,
    this.timestamp = const Value.absent(),
    this.read = const Value.absent(),
    this.status = const Value.absent(),
    this.taskId = const Value.absent(),
  }) : userId = Value(userId),
       title = Value(title),
       body = Value(body);
  static Insertable<NotificationLog> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? title,
    Expression<String>? body,
    Expression<DateTime>? timestamp,
    Expression<bool>? read,
    Expression<String>? status,
    Expression<int>? taskId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (timestamp != null) 'timestamp': timestamp,
      if (read != null) 'read': read,
      if (status != null) 'status': status,
      if (taskId != null) 'task_id': taskId,
    });
  }

  NotificationLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? title,
    Value<String>? body,
    Value<DateTime>? timestamp,
    Value<bool>? read,
    Value<String>? status,
    Value<int?>? taskId,
  }) {
    return NotificationLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      read: read ?? this.read,
      status: status ?? this.status,
      taskId: taskId ?? this.taskId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (read.present) {
      map['read'] = Variable<bool>(read.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp, ')
          ..write('read: $read, ')
          ..write('status: $status, ')
          ..write('taskId: $taskId')
          ..write(')'))
        .toString();
  }
}

class $ObservationsTable extends Observations
    with TableInfo<$ObservationsTable, Observation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ObservationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cropNameMeta = const VerificationMeta(
    'cropName',
  );
  @override
  late final GeneratedColumn<String> cropName = GeneratedColumn<String>(
    'crop_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cropImagePathMeta = const VerificationMeta(
    'cropImagePath',
  );
  @override
  late final GeneratedColumn<String> cropImagePath = GeneratedColumn<String>(
    'crop_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plantStatusMeta = const VerificationMeta(
    'plantStatus',
  );
  @override
  late final GeneratedColumn<String> plantStatus = GeneratedColumn<String>(
    'plant_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stageMeta = const VerificationMeta('stage');
  @override
  late final GeneratedColumn<String> stage = GeneratedColumn<String>(
    'stage',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasIrrigationMeta = const VerificationMeta(
    'hasIrrigation',
  );
  @override
  late final GeneratedColumn<bool> hasIrrigation = GeneratedColumn<bool>(
    'has_irrigation',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_irrigation" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasPestMeta = const VerificationMeta(
    'hasPest',
  );
  @override
  late final GeneratedColumn<bool> hasPest = GeneratedColumn<bool>(
    'has_pest',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_pest" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasTransplantOrFertilizationMeta =
      const VerificationMeta('hasTransplantOrFertilization');
  @override
  late final GeneratedColumn<bool> hasTransplantOrFertilization =
      GeneratedColumn<bool>(
        'has_transplant_or_fertilization',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_transplant_or_fertilization" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    cropName,
    cropImagePath,
    date,
    content,
    plantStatus,
    stage,
    hasIrrigation,
    hasPest,
    hasTransplantOrFertilization,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'observations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Observation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('crop_name')) {
      context.handle(
        _cropNameMeta,
        cropName.isAcceptableOrUnknown(data['crop_name']!, _cropNameMeta),
      );
    } else if (isInserting) {
      context.missing(_cropNameMeta);
    }
    if (data.containsKey('crop_image_path')) {
      context.handle(
        _cropImagePathMeta,
        cropImagePath.isAcceptableOrUnknown(
          data['crop_image_path']!,
          _cropImagePathMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('plant_status')) {
      context.handle(
        _plantStatusMeta,
        plantStatus.isAcceptableOrUnknown(
          data['plant_status']!,
          _plantStatusMeta,
        ),
      );
    }
    if (data.containsKey('stage')) {
      context.handle(
        _stageMeta,
        stage.isAcceptableOrUnknown(data['stage']!, _stageMeta),
      );
    }
    if (data.containsKey('has_irrigation')) {
      context.handle(
        _hasIrrigationMeta,
        hasIrrigation.isAcceptableOrUnknown(
          data['has_irrigation']!,
          _hasIrrigationMeta,
        ),
      );
    }
    if (data.containsKey('has_pest')) {
      context.handle(
        _hasPestMeta,
        hasPest.isAcceptableOrUnknown(data['has_pest']!, _hasPestMeta),
      );
    }
    if (data.containsKey('has_transplant_or_fertilization')) {
      context.handle(
        _hasTransplantOrFertilizationMeta,
        hasTransplantOrFertilization.isAcceptableOrUnknown(
          data['has_transplant_or_fertilization']!,
          _hasTransplantOrFertilizationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Observation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Observation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      cropName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop_name'],
      )!,
      cropImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop_image_path'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      plantStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plant_status'],
      ),
      stage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage'],
      ),
      hasIrrigation: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_irrigation'],
      )!,
      hasPest: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_pest'],
      )!,
      hasTransplantOrFertilization: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_transplant_or_fertilization'],
      )!,
    );
  }

  @override
  $ObservationsTable createAlias(String alias) {
    return $ObservationsTable(attachedDatabase, alias);
  }
}

class Observation extends DataClass implements Insertable<Observation> {
  final int id;
  final int userId;
  final String cropName;
  final String? cropImagePath;
  final DateTime date;
  final String content;
  final String? plantStatus;
  final String? stage;
  final bool hasIrrigation;
  final bool hasPest;
  final bool hasTransplantOrFertilization;
  const Observation({
    required this.id,
    required this.userId,
    required this.cropName,
    this.cropImagePath,
    required this.date,
    required this.content,
    this.plantStatus,
    this.stage,
    required this.hasIrrigation,
    required this.hasPest,
    required this.hasTransplantOrFertilization,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['crop_name'] = Variable<String>(cropName);
    if (!nullToAbsent || cropImagePath != null) {
      map['crop_image_path'] = Variable<String>(cropImagePath);
    }
    map['date'] = Variable<DateTime>(date);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || plantStatus != null) {
      map['plant_status'] = Variable<String>(plantStatus);
    }
    if (!nullToAbsent || stage != null) {
      map['stage'] = Variable<String>(stage);
    }
    map['has_irrigation'] = Variable<bool>(hasIrrigation);
    map['has_pest'] = Variable<bool>(hasPest);
    map['has_transplant_or_fertilization'] = Variable<bool>(
      hasTransplantOrFertilization,
    );
    return map;
  }

  ObservationsCompanion toCompanion(bool nullToAbsent) {
    return ObservationsCompanion(
      id: Value(id),
      userId: Value(userId),
      cropName: Value(cropName),
      cropImagePath: cropImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(cropImagePath),
      date: Value(date),
      content: Value(content),
      plantStatus: plantStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(plantStatus),
      stage: stage == null && nullToAbsent
          ? const Value.absent()
          : Value(stage),
      hasIrrigation: Value(hasIrrigation),
      hasPest: Value(hasPest),
      hasTransplantOrFertilization: Value(hasTransplantOrFertilization),
    );
  }

  factory Observation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Observation(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      cropName: serializer.fromJson<String>(json['cropName']),
      cropImagePath: serializer.fromJson<String?>(json['cropImagePath']),
      date: serializer.fromJson<DateTime>(json['date']),
      content: serializer.fromJson<String>(json['content']),
      plantStatus: serializer.fromJson<String?>(json['plantStatus']),
      stage: serializer.fromJson<String?>(json['stage']),
      hasIrrigation: serializer.fromJson<bool>(json['hasIrrigation']),
      hasPest: serializer.fromJson<bool>(json['hasPest']),
      hasTransplantOrFertilization: serializer.fromJson<bool>(
        json['hasTransplantOrFertilization'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'cropName': serializer.toJson<String>(cropName),
      'cropImagePath': serializer.toJson<String?>(cropImagePath),
      'date': serializer.toJson<DateTime>(date),
      'content': serializer.toJson<String>(content),
      'plantStatus': serializer.toJson<String?>(plantStatus),
      'stage': serializer.toJson<String?>(stage),
      'hasIrrigation': serializer.toJson<bool>(hasIrrigation),
      'hasPest': serializer.toJson<bool>(hasPest),
      'hasTransplantOrFertilization': serializer.toJson<bool>(
        hasTransplantOrFertilization,
      ),
    };
  }

  Observation copyWith({
    int? id,
    int? userId,
    String? cropName,
    Value<String?> cropImagePath = const Value.absent(),
    DateTime? date,
    String? content,
    Value<String?> plantStatus = const Value.absent(),
    Value<String?> stage = const Value.absent(),
    bool? hasIrrigation,
    bool? hasPest,
    bool? hasTransplantOrFertilization,
  }) => Observation(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    cropName: cropName ?? this.cropName,
    cropImagePath: cropImagePath.present
        ? cropImagePath.value
        : this.cropImagePath,
    date: date ?? this.date,
    content: content ?? this.content,
    plantStatus: plantStatus.present ? plantStatus.value : this.plantStatus,
    stage: stage.present ? stage.value : this.stage,
    hasIrrigation: hasIrrigation ?? this.hasIrrigation,
    hasPest: hasPest ?? this.hasPest,
    hasTransplantOrFertilization:
        hasTransplantOrFertilization ?? this.hasTransplantOrFertilization,
  );
  Observation copyWithCompanion(ObservationsCompanion data) {
    return Observation(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      cropName: data.cropName.present ? data.cropName.value : this.cropName,
      cropImagePath: data.cropImagePath.present
          ? data.cropImagePath.value
          : this.cropImagePath,
      date: data.date.present ? data.date.value : this.date,
      content: data.content.present ? data.content.value : this.content,
      plantStatus: data.plantStatus.present
          ? data.plantStatus.value
          : this.plantStatus,
      stage: data.stage.present ? data.stage.value : this.stage,
      hasIrrigation: data.hasIrrigation.present
          ? data.hasIrrigation.value
          : this.hasIrrigation,
      hasPest: data.hasPest.present ? data.hasPest.value : this.hasPest,
      hasTransplantOrFertilization: data.hasTransplantOrFertilization.present
          ? data.hasTransplantOrFertilization.value
          : this.hasTransplantOrFertilization,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Observation(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('cropName: $cropName, ')
          ..write('cropImagePath: $cropImagePath, ')
          ..write('date: $date, ')
          ..write('content: $content, ')
          ..write('plantStatus: $plantStatus, ')
          ..write('stage: $stage, ')
          ..write('hasIrrigation: $hasIrrigation, ')
          ..write('hasPest: $hasPest, ')
          ..write('hasTransplantOrFertilization: $hasTransplantOrFertilization')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    cropName,
    cropImagePath,
    date,
    content,
    plantStatus,
    stage,
    hasIrrigation,
    hasPest,
    hasTransplantOrFertilization,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Observation &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.cropName == this.cropName &&
          other.cropImagePath == this.cropImagePath &&
          other.date == this.date &&
          other.content == this.content &&
          other.plantStatus == this.plantStatus &&
          other.stage == this.stage &&
          other.hasIrrigation == this.hasIrrigation &&
          other.hasPest == this.hasPest &&
          other.hasTransplantOrFertilization ==
              this.hasTransplantOrFertilization);
}

class ObservationsCompanion extends UpdateCompanion<Observation> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> cropName;
  final Value<String?> cropImagePath;
  final Value<DateTime> date;
  final Value<String> content;
  final Value<String?> plantStatus;
  final Value<String?> stage;
  final Value<bool> hasIrrigation;
  final Value<bool> hasPest;
  final Value<bool> hasTransplantOrFertilization;
  const ObservationsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.cropName = const Value.absent(),
    this.cropImagePath = const Value.absent(),
    this.date = const Value.absent(),
    this.content = const Value.absent(),
    this.plantStatus = const Value.absent(),
    this.stage = const Value.absent(),
    this.hasIrrigation = const Value.absent(),
    this.hasPest = const Value.absent(),
    this.hasTransplantOrFertilization = const Value.absent(),
  });
  ObservationsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String cropName,
    this.cropImagePath = const Value.absent(),
    this.date = const Value.absent(),
    required String content,
    this.plantStatus = const Value.absent(),
    this.stage = const Value.absent(),
    this.hasIrrigation = const Value.absent(),
    this.hasPest = const Value.absent(),
    this.hasTransplantOrFertilization = const Value.absent(),
  }) : userId = Value(userId),
       cropName = Value(cropName),
       content = Value(content);
  static Insertable<Observation> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? cropName,
    Expression<String>? cropImagePath,
    Expression<DateTime>? date,
    Expression<String>? content,
    Expression<String>? plantStatus,
    Expression<String>? stage,
    Expression<bool>? hasIrrigation,
    Expression<bool>? hasPest,
    Expression<bool>? hasTransplantOrFertilization,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (cropName != null) 'crop_name': cropName,
      if (cropImagePath != null) 'crop_image_path': cropImagePath,
      if (date != null) 'date': date,
      if (content != null) 'content': content,
      if (plantStatus != null) 'plant_status': plantStatus,
      if (stage != null) 'stage': stage,
      if (hasIrrigation != null) 'has_irrigation': hasIrrigation,
      if (hasPest != null) 'has_pest': hasPest,
      if (hasTransplantOrFertilization != null)
        'has_transplant_or_fertilization': hasTransplantOrFertilization,
    });
  }

  ObservationsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? cropName,
    Value<String?>? cropImagePath,
    Value<DateTime>? date,
    Value<String>? content,
    Value<String?>? plantStatus,
    Value<String?>? stage,
    Value<bool>? hasIrrigation,
    Value<bool>? hasPest,
    Value<bool>? hasTransplantOrFertilization,
  }) {
    return ObservationsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cropName: cropName ?? this.cropName,
      cropImagePath: cropImagePath ?? this.cropImagePath,
      date: date ?? this.date,
      content: content ?? this.content,
      plantStatus: plantStatus ?? this.plantStatus,
      stage: stage ?? this.stage,
      hasIrrigation: hasIrrigation ?? this.hasIrrigation,
      hasPest: hasPest ?? this.hasPest,
      hasTransplantOrFertilization:
          hasTransplantOrFertilization ?? this.hasTransplantOrFertilization,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (cropName.present) {
      map['crop_name'] = Variable<String>(cropName.value);
    }
    if (cropImagePath.present) {
      map['crop_image_path'] = Variable<String>(cropImagePath.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (plantStatus.present) {
      map['plant_status'] = Variable<String>(plantStatus.value);
    }
    if (stage.present) {
      map['stage'] = Variable<String>(stage.value);
    }
    if (hasIrrigation.present) {
      map['has_irrigation'] = Variable<bool>(hasIrrigation.value);
    }
    if (hasPest.present) {
      map['has_pest'] = Variable<bool>(hasPest.value);
    }
    if (hasTransplantOrFertilization.present) {
      map['has_transplant_or_fertilization'] = Variable<bool>(
        hasTransplantOrFertilization.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ObservationsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('cropName: $cropName, ')
          ..write('cropImagePath: $cropImagePath, ')
          ..write('date: $date, ')
          ..write('content: $content, ')
          ..write('plantStatus: $plantStatus, ')
          ..write('stage: $stage, ')
          ..write('hasIrrigation: $hasIrrigation, ')
          ..write('hasPest: $hasPest, ')
          ..write('hasTransplantOrFertilization: $hasTransplantOrFertilization')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $UserCultivosTable userCultivos = $UserCultivosTable(this);
  late final $SharedCultivosTable sharedCultivos = $SharedCultivosTable(this);
  late final $UserFertilizantesTable userFertilizantes =
      $UserFertilizantesTable(this);
  late final $SharedFertilizantesTable sharedFertilizantes =
      $SharedFertilizantesTable(this);
  late final $UserPlagasTable userPlagas = $UserPlagasTable(this);
  late final $SharedPlagasTable sharedPlagas = $SharedPlagasTable(this);
  late final $UserPesticidasTable userPesticidas = $UserPesticidasTable(this);
  late final $SharedPesticidasTable sharedPesticidas = $SharedPesticidasTable(
    this,
  );
  late final $CropPlansTable cropPlans = $CropPlansTable(this);
  late final $CalendarTasksTable calendarTasks = $CalendarTasksTable(this);
  late final $NotificationLogsTable notificationLogs = $NotificationLogsTable(
    this,
  );
  late final $ObservationsTable observations = $ObservationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    sessions,
    userCultivos,
    sharedCultivos,
    userFertilizantes,
    sharedFertilizantes,
    userPlagas,
    sharedPlagas,
    userPesticidas,
    sharedPesticidas,
    cropPlans,
    calendarTasks,
    notificationLogs,
    observations,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String fullName,
      required String username,
      required String email,
      required String password,
      Value<String?> avatarPath,
      Value<DateTime> createdAt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> fullName,
      Value<String> username,
      Value<String> email,
      Value<String> password,
      Value<String?> avatarPath,
      Value<DateTime> createdAt,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                fullName: fullName,
                username: username,
                email: email,
                password: password,
                avatarPath: avatarPath,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String fullName,
                required String username,
                required String email,
                required String password,
                Value<String?> avatarPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                fullName: fullName,
                username: username,
                email: email,
                password: password,
                avatarPath: avatarPath,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      required int userId,
      Value<DateTime> createdAt,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<DateTime> createdAt,
    });

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
          Session,
          PrefetchHooks Function()
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                userId: userId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                Value<DateTime> createdAt = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                userId: userId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
      Session,
      PrefetchHooks Function()
    >;
typedef $$UserCultivosTableCreateCompanionBuilder =
    UserCultivosCompanion Function({
      Value<int> id,
      required int userId,
      Value<String> nombre,
      Value<String> tipo,
      Value<int> cosechaMeses,
      Value<String> estacion,
      Value<String?> imagePath,
      required String payloadJson,
    });
typedef $$UserCultivosTableUpdateCompanionBuilder =
    UserCultivosCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> nombre,
      Value<String> tipo,
      Value<int> cosechaMeses,
      Value<String> estacion,
      Value<String?> imagePath,
      Value<String> payloadJson,
    });

class $$UserCultivosTableFilterComposer
    extends Composer<_$AppDatabase, $UserCultivosTable> {
  $$UserCultivosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cosechaMeses => $composableBuilder(
    column: $table.cosechaMeses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estacion => $composableBuilder(
    column: $table.estacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserCultivosTableOrderingComposer
    extends Composer<_$AppDatabase, $UserCultivosTable> {
  $$UserCultivosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cosechaMeses => $composableBuilder(
    column: $table.cosechaMeses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estacion => $composableBuilder(
    column: $table.estacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserCultivosTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserCultivosTable> {
  $$UserCultivosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get cosechaMeses => $composableBuilder(
    column: $table.cosechaMeses,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estacion =>
      $composableBuilder(column: $table.estacion, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );
}

class $$UserCultivosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserCultivosTable,
          UserCultivo,
          $$UserCultivosTableFilterComposer,
          $$UserCultivosTableOrderingComposer,
          $$UserCultivosTableAnnotationComposer,
          $$UserCultivosTableCreateCompanionBuilder,
          $$UserCultivosTableUpdateCompanionBuilder,
          (
            UserCultivo,
            BaseReferences<_$AppDatabase, $UserCultivosTable, UserCultivo>,
          ),
          UserCultivo,
          PrefetchHooks Function()
        > {
  $$UserCultivosTableTableManager(_$AppDatabase db, $UserCultivosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserCultivosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserCultivosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserCultivosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> cosechaMeses = const Value.absent(),
                Value<String> estacion = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
              }) => UserCultivosCompanion(
                id: id,
                userId: userId,
                nombre: nombre,
                tipo: tipo,
                cosechaMeses: cosechaMeses,
                estacion: estacion,
                imagePath: imagePath,
                payloadJson: payloadJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                Value<String> nombre = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> cosechaMeses = const Value.absent(),
                Value<String> estacion = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                required String payloadJson,
              }) => UserCultivosCompanion.insert(
                id: id,
                userId: userId,
                nombre: nombre,
                tipo: tipo,
                cosechaMeses: cosechaMeses,
                estacion: estacion,
                imagePath: imagePath,
                payloadJson: payloadJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserCultivosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserCultivosTable,
      UserCultivo,
      $$UserCultivosTableFilterComposer,
      $$UserCultivosTableOrderingComposer,
      $$UserCultivosTableAnnotationComposer,
      $$UserCultivosTableCreateCompanionBuilder,
      $$UserCultivosTableUpdateCompanionBuilder,
      (
        UserCultivo,
        BaseReferences<_$AppDatabase, $UserCultivosTable, UserCultivo>,
      ),
      UserCultivo,
      PrefetchHooks Function()
    >;
typedef $$SharedCultivosTableCreateCompanionBuilder =
    SharedCultivosCompanion Function({
      Value<int> id,
      required int userId,
      Value<String> nombre,
      Value<String> tipo,
      Value<int> cosechaMeses,
      Value<String> estacion,
      Value<String?> imagePath,
      required String payloadJson,
    });
typedef $$SharedCultivosTableUpdateCompanionBuilder =
    SharedCultivosCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> nombre,
      Value<String> tipo,
      Value<int> cosechaMeses,
      Value<String> estacion,
      Value<String?> imagePath,
      Value<String> payloadJson,
    });

class $$SharedCultivosTableFilterComposer
    extends Composer<_$AppDatabase, $SharedCultivosTable> {
  $$SharedCultivosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cosechaMeses => $composableBuilder(
    column: $table.cosechaMeses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estacion => $composableBuilder(
    column: $table.estacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SharedCultivosTableOrderingComposer
    extends Composer<_$AppDatabase, $SharedCultivosTable> {
  $$SharedCultivosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cosechaMeses => $composableBuilder(
    column: $table.cosechaMeses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estacion => $composableBuilder(
    column: $table.estacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SharedCultivosTableAnnotationComposer
    extends Composer<_$AppDatabase, $SharedCultivosTable> {
  $$SharedCultivosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get cosechaMeses => $composableBuilder(
    column: $table.cosechaMeses,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estacion =>
      $composableBuilder(column: $table.estacion, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );
}

class $$SharedCultivosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SharedCultivosTable,
          SharedCultivo,
          $$SharedCultivosTableFilterComposer,
          $$SharedCultivosTableOrderingComposer,
          $$SharedCultivosTableAnnotationComposer,
          $$SharedCultivosTableCreateCompanionBuilder,
          $$SharedCultivosTableUpdateCompanionBuilder,
          (
            SharedCultivo,
            BaseReferences<_$AppDatabase, $SharedCultivosTable, SharedCultivo>,
          ),
          SharedCultivo,
          PrefetchHooks Function()
        > {
  $$SharedCultivosTableTableManager(
    _$AppDatabase db,
    $SharedCultivosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SharedCultivosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SharedCultivosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SharedCultivosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> cosechaMeses = const Value.absent(),
                Value<String> estacion = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
              }) => SharedCultivosCompanion(
                id: id,
                userId: userId,
                nombre: nombre,
                tipo: tipo,
                cosechaMeses: cosechaMeses,
                estacion: estacion,
                imagePath: imagePath,
                payloadJson: payloadJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                Value<String> nombre = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> cosechaMeses = const Value.absent(),
                Value<String> estacion = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                required String payloadJson,
              }) => SharedCultivosCompanion.insert(
                id: id,
                userId: userId,
                nombre: nombre,
                tipo: tipo,
                cosechaMeses: cosechaMeses,
                estacion: estacion,
                imagePath: imagePath,
                payloadJson: payloadJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SharedCultivosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SharedCultivosTable,
      SharedCultivo,
      $$SharedCultivosTableFilterComposer,
      $$SharedCultivosTableOrderingComposer,
      $$SharedCultivosTableAnnotationComposer,
      $$SharedCultivosTableCreateCompanionBuilder,
      $$SharedCultivosTableUpdateCompanionBuilder,
      (
        SharedCultivo,
        BaseReferences<_$AppDatabase, $SharedCultivosTable, SharedCultivo>,
      ),
      SharedCultivo,
      PrefetchHooks Function()
    >;
typedef $$UserFertilizantesTableCreateCompanionBuilder =
    UserFertilizantesCompanion Function({
      Value<int> id,
      required int userId,
      Value<String> nombre,
      Value<String> tipo,
      Value<String?> imagePath,
      required String payloadJson,
    });
typedef $$UserFertilizantesTableUpdateCompanionBuilder =
    UserFertilizantesCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> nombre,
      Value<String> tipo,
      Value<String?> imagePath,
      Value<String> payloadJson,
    });

class $$UserFertilizantesTableFilterComposer
    extends Composer<_$AppDatabase, $UserFertilizantesTable> {
  $$UserFertilizantesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserFertilizantesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserFertilizantesTable> {
  $$UserFertilizantesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserFertilizantesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserFertilizantesTable> {
  $$UserFertilizantesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );
}

class $$UserFertilizantesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserFertilizantesTable,
          UserFertilizante,
          $$UserFertilizantesTableFilterComposer,
          $$UserFertilizantesTableOrderingComposer,
          $$UserFertilizantesTableAnnotationComposer,
          $$UserFertilizantesTableCreateCompanionBuilder,
          $$UserFertilizantesTableUpdateCompanionBuilder,
          (
            UserFertilizante,
            BaseReferences<
              _$AppDatabase,
              $UserFertilizantesTable,
              UserFertilizante
            >,
          ),
          UserFertilizante,
          PrefetchHooks Function()
        > {
  $$UserFertilizantesTableTableManager(
    _$AppDatabase db,
    $UserFertilizantesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserFertilizantesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserFertilizantesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserFertilizantesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
              }) => UserFertilizantesCompanion(
                id: id,
                userId: userId,
                nombre: nombre,
                tipo: tipo,
                imagePath: imagePath,
                payloadJson: payloadJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                Value<String> nombre = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                required String payloadJson,
              }) => UserFertilizantesCompanion.insert(
                id: id,
                userId: userId,
                nombre: nombre,
                tipo: tipo,
                imagePath: imagePath,
                payloadJson: payloadJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserFertilizantesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserFertilizantesTable,
      UserFertilizante,
      $$UserFertilizantesTableFilterComposer,
      $$UserFertilizantesTableOrderingComposer,
      $$UserFertilizantesTableAnnotationComposer,
      $$UserFertilizantesTableCreateCompanionBuilder,
      $$UserFertilizantesTableUpdateCompanionBuilder,
      (
        UserFertilizante,
        BaseReferences<
          _$AppDatabase,
          $UserFertilizantesTable,
          UserFertilizante
        >,
      ),
      UserFertilizante,
      PrefetchHooks Function()
    >;
typedef $$SharedFertilizantesTableCreateCompanionBuilder =
    SharedFertilizantesCompanion Function({
      Value<int> id,
      required int userId,
      Value<String> nombre,
      Value<String> tipo,
      Value<String?> imagePath,
      required String payloadJson,
    });
typedef $$SharedFertilizantesTableUpdateCompanionBuilder =
    SharedFertilizantesCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> nombre,
      Value<String> tipo,
      Value<String?> imagePath,
      Value<String> payloadJson,
    });

class $$SharedFertilizantesTableFilterComposer
    extends Composer<_$AppDatabase, $SharedFertilizantesTable> {
  $$SharedFertilizantesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SharedFertilizantesTableOrderingComposer
    extends Composer<_$AppDatabase, $SharedFertilizantesTable> {
  $$SharedFertilizantesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SharedFertilizantesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SharedFertilizantesTable> {
  $$SharedFertilizantesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );
}

class $$SharedFertilizantesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SharedFertilizantesTable,
          SharedFertilizante,
          $$SharedFertilizantesTableFilterComposer,
          $$SharedFertilizantesTableOrderingComposer,
          $$SharedFertilizantesTableAnnotationComposer,
          $$SharedFertilizantesTableCreateCompanionBuilder,
          $$SharedFertilizantesTableUpdateCompanionBuilder,
          (
            SharedFertilizante,
            BaseReferences<
              _$AppDatabase,
              $SharedFertilizantesTable,
              SharedFertilizante
            >,
          ),
          SharedFertilizante,
          PrefetchHooks Function()
        > {
  $$SharedFertilizantesTableTableManager(
    _$AppDatabase db,
    $SharedFertilizantesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SharedFertilizantesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SharedFertilizantesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SharedFertilizantesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
              }) => SharedFertilizantesCompanion(
                id: id,
                userId: userId,
                nombre: nombre,
                tipo: tipo,
                imagePath: imagePath,
                payloadJson: payloadJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                Value<String> nombre = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                required String payloadJson,
              }) => SharedFertilizantesCompanion.insert(
                id: id,
                userId: userId,
                nombre: nombre,
                tipo: tipo,
                imagePath: imagePath,
                payloadJson: payloadJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SharedFertilizantesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SharedFertilizantesTable,
      SharedFertilizante,
      $$SharedFertilizantesTableFilterComposer,
      $$SharedFertilizantesTableOrderingComposer,
      $$SharedFertilizantesTableAnnotationComposer,
      $$SharedFertilizantesTableCreateCompanionBuilder,
      $$SharedFertilizantesTableUpdateCompanionBuilder,
      (
        SharedFertilizante,
        BaseReferences<
          _$AppDatabase,
          $SharedFertilizantesTable,
          SharedFertilizante
        >,
      ),
      SharedFertilizante,
      PrefetchHooks Function()
    >;
typedef $$UserPlagasTableCreateCompanionBuilder =
    UserPlagasCompanion Function({
      Value<int> id,
      required int userId,
      Value<String> nombre,
      Value<String> cientifico,
      Value<String?> imagePath,
      required String payloadJson,
    });
typedef $$UserPlagasTableUpdateCompanionBuilder =
    UserPlagasCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> nombre,
      Value<String> cientifico,
      Value<String?> imagePath,
      Value<String> payloadJson,
    });

class $$UserPlagasTableFilterComposer
    extends Composer<_$AppDatabase, $UserPlagasTable> {
  $$UserPlagasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cientifico => $composableBuilder(
    column: $table.cientifico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserPlagasTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPlagasTable> {
  $$UserPlagasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cientifico => $composableBuilder(
    column: $table.cientifico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserPlagasTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPlagasTable> {
  $$UserPlagasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get cientifico => $composableBuilder(
    column: $table.cientifico,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );
}

class $$UserPlagasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserPlagasTable,
          UserPlaga,
          $$UserPlagasTableFilterComposer,
          $$UserPlagasTableOrderingComposer,
          $$UserPlagasTableAnnotationComposer,
          $$UserPlagasTableCreateCompanionBuilder,
          $$UserPlagasTableUpdateCompanionBuilder,
          (
            UserPlaga,
            BaseReferences<_$AppDatabase, $UserPlagasTable, UserPlaga>,
          ),
          UserPlaga,
          PrefetchHooks Function()
        > {
  $$UserPlagasTableTableManager(_$AppDatabase db, $UserPlagasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPlagasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPlagasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPlagasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> cientifico = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
              }) => UserPlagasCompanion(
                id: id,
                userId: userId,
                nombre: nombre,
                cientifico: cientifico,
                imagePath: imagePath,
                payloadJson: payloadJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                Value<String> nombre = const Value.absent(),
                Value<String> cientifico = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                required String payloadJson,
              }) => UserPlagasCompanion.insert(
                id: id,
                userId: userId,
                nombre: nombre,
                cientifico: cientifico,
                imagePath: imagePath,
                payloadJson: payloadJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserPlagasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserPlagasTable,
      UserPlaga,
      $$UserPlagasTableFilterComposer,
      $$UserPlagasTableOrderingComposer,
      $$UserPlagasTableAnnotationComposer,
      $$UserPlagasTableCreateCompanionBuilder,
      $$UserPlagasTableUpdateCompanionBuilder,
      (UserPlaga, BaseReferences<_$AppDatabase, $UserPlagasTable, UserPlaga>),
      UserPlaga,
      PrefetchHooks Function()
    >;
typedef $$SharedPlagasTableCreateCompanionBuilder =
    SharedPlagasCompanion Function({
      Value<int> id,
      required int userId,
      Value<String> nombre,
      Value<String> cientifico,
      Value<String?> imagePath,
      required String payloadJson,
    });
typedef $$SharedPlagasTableUpdateCompanionBuilder =
    SharedPlagasCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> nombre,
      Value<String> cientifico,
      Value<String?> imagePath,
      Value<String> payloadJson,
    });

class $$SharedPlagasTableFilterComposer
    extends Composer<_$AppDatabase, $SharedPlagasTable> {
  $$SharedPlagasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cientifico => $composableBuilder(
    column: $table.cientifico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SharedPlagasTableOrderingComposer
    extends Composer<_$AppDatabase, $SharedPlagasTable> {
  $$SharedPlagasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cientifico => $composableBuilder(
    column: $table.cientifico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SharedPlagasTableAnnotationComposer
    extends Composer<_$AppDatabase, $SharedPlagasTable> {
  $$SharedPlagasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get cientifico => $composableBuilder(
    column: $table.cientifico,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );
}

class $$SharedPlagasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SharedPlagasTable,
          SharedPlaga,
          $$SharedPlagasTableFilterComposer,
          $$SharedPlagasTableOrderingComposer,
          $$SharedPlagasTableAnnotationComposer,
          $$SharedPlagasTableCreateCompanionBuilder,
          $$SharedPlagasTableUpdateCompanionBuilder,
          (
            SharedPlaga,
            BaseReferences<_$AppDatabase, $SharedPlagasTable, SharedPlaga>,
          ),
          SharedPlaga,
          PrefetchHooks Function()
        > {
  $$SharedPlagasTableTableManager(_$AppDatabase db, $SharedPlagasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SharedPlagasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SharedPlagasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SharedPlagasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> cientifico = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
              }) => SharedPlagasCompanion(
                id: id,
                userId: userId,
                nombre: nombre,
                cientifico: cientifico,
                imagePath: imagePath,
                payloadJson: payloadJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                Value<String> nombre = const Value.absent(),
                Value<String> cientifico = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                required String payloadJson,
              }) => SharedPlagasCompanion.insert(
                id: id,
                userId: userId,
                nombre: nombre,
                cientifico: cientifico,
                imagePath: imagePath,
                payloadJson: payloadJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SharedPlagasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SharedPlagasTable,
      SharedPlaga,
      $$SharedPlagasTableFilterComposer,
      $$SharedPlagasTableOrderingComposer,
      $$SharedPlagasTableAnnotationComposer,
      $$SharedPlagasTableCreateCompanionBuilder,
      $$SharedPlagasTableUpdateCompanionBuilder,
      (
        SharedPlaga,
        BaseReferences<_$AppDatabase, $SharedPlagasTable, SharedPlaga>,
      ),
      SharedPlaga,
      PrefetchHooks Function()
    >;
typedef $$UserPesticidasTableCreateCompanionBuilder =
    UserPesticidasCompanion Function({
      Value<int> id,
      required int userId,
      Value<String> nombre,
      Value<String> tipo,
      Value<String?> imagePath,
      required String payloadJson,
    });
typedef $$UserPesticidasTableUpdateCompanionBuilder =
    UserPesticidasCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> nombre,
      Value<String> tipo,
      Value<String?> imagePath,
      Value<String> payloadJson,
    });

class $$UserPesticidasTableFilterComposer
    extends Composer<_$AppDatabase, $UserPesticidasTable> {
  $$UserPesticidasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserPesticidasTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPesticidasTable> {
  $$UserPesticidasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserPesticidasTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPesticidasTable> {
  $$UserPesticidasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );
}

class $$UserPesticidasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserPesticidasTable,
          UserPesticida,
          $$UserPesticidasTableFilterComposer,
          $$UserPesticidasTableOrderingComposer,
          $$UserPesticidasTableAnnotationComposer,
          $$UserPesticidasTableCreateCompanionBuilder,
          $$UserPesticidasTableUpdateCompanionBuilder,
          (
            UserPesticida,
            BaseReferences<_$AppDatabase, $UserPesticidasTable, UserPesticida>,
          ),
          UserPesticida,
          PrefetchHooks Function()
        > {
  $$UserPesticidasTableTableManager(
    _$AppDatabase db,
    $UserPesticidasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPesticidasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPesticidasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPesticidasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
              }) => UserPesticidasCompanion(
                id: id,
                userId: userId,
                nombre: nombre,
                tipo: tipo,
                imagePath: imagePath,
                payloadJson: payloadJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                Value<String> nombre = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                required String payloadJson,
              }) => UserPesticidasCompanion.insert(
                id: id,
                userId: userId,
                nombre: nombre,
                tipo: tipo,
                imagePath: imagePath,
                payloadJson: payloadJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserPesticidasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserPesticidasTable,
      UserPesticida,
      $$UserPesticidasTableFilterComposer,
      $$UserPesticidasTableOrderingComposer,
      $$UserPesticidasTableAnnotationComposer,
      $$UserPesticidasTableCreateCompanionBuilder,
      $$UserPesticidasTableUpdateCompanionBuilder,
      (
        UserPesticida,
        BaseReferences<_$AppDatabase, $UserPesticidasTable, UserPesticida>,
      ),
      UserPesticida,
      PrefetchHooks Function()
    >;
typedef $$SharedPesticidasTableCreateCompanionBuilder =
    SharedPesticidasCompanion Function({
      Value<int> id,
      required int userId,
      Value<String> nombre,
      Value<String> tipo,
      Value<String?> imagePath,
      required String payloadJson,
    });
typedef $$SharedPesticidasTableUpdateCompanionBuilder =
    SharedPesticidasCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> nombre,
      Value<String> tipo,
      Value<String?> imagePath,
      Value<String> payloadJson,
    });

class $$SharedPesticidasTableFilterComposer
    extends Composer<_$AppDatabase, $SharedPesticidasTable> {
  $$SharedPesticidasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SharedPesticidasTableOrderingComposer
    extends Composer<_$AppDatabase, $SharedPesticidasTable> {
  $$SharedPesticidasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SharedPesticidasTableAnnotationComposer
    extends Composer<_$AppDatabase, $SharedPesticidasTable> {
  $$SharedPesticidasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );
}

class $$SharedPesticidasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SharedPesticidasTable,
          SharedPesticida,
          $$SharedPesticidasTableFilterComposer,
          $$SharedPesticidasTableOrderingComposer,
          $$SharedPesticidasTableAnnotationComposer,
          $$SharedPesticidasTableCreateCompanionBuilder,
          $$SharedPesticidasTableUpdateCompanionBuilder,
          (
            SharedPesticida,
            BaseReferences<
              _$AppDatabase,
              $SharedPesticidasTable,
              SharedPesticida
            >,
          ),
          SharedPesticida,
          PrefetchHooks Function()
        > {
  $$SharedPesticidasTableTableManager(
    _$AppDatabase db,
    $SharedPesticidasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SharedPesticidasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SharedPesticidasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SharedPesticidasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
              }) => SharedPesticidasCompanion(
                id: id,
                userId: userId,
                nombre: nombre,
                tipo: tipo,
                imagePath: imagePath,
                payloadJson: payloadJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                Value<String> nombre = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                required String payloadJson,
              }) => SharedPesticidasCompanion.insert(
                id: id,
                userId: userId,
                nombre: nombre,
                tipo: tipo,
                imagePath: imagePath,
                payloadJson: payloadJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SharedPesticidasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SharedPesticidasTable,
      SharedPesticida,
      $$SharedPesticidasTableFilterComposer,
      $$SharedPesticidasTableOrderingComposer,
      $$SharedPesticidasTableAnnotationComposer,
      $$SharedPesticidasTableCreateCompanionBuilder,
      $$SharedPesticidasTableUpdateCompanionBuilder,
      (
        SharedPesticida,
        BaseReferences<_$AppDatabase, $SharedPesticidasTable, SharedPesticida>,
      ),
      SharedPesticida,
      PrefetchHooks Function()
    >;
typedef $$CropPlansTableCreateCompanionBuilder =
    CropPlansCompanion Function({
      Value<int> id,
      required int userId,
      required String cropName,
      required DateTime startDate,
      required String preferredTime,
      required String payloadJson,
      Value<bool> active,
    });
typedef $$CropPlansTableUpdateCompanionBuilder =
    CropPlansCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> cropName,
      Value<DateTime> startDate,
      Value<String> preferredTime,
      Value<String> payloadJson,
      Value<bool> active,
    });

class $$CropPlansTableFilterComposer
    extends Composer<_$AppDatabase, $CropPlansTable> {
  $$CropPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cropName => $composableBuilder(
    column: $table.cropName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredTime => $composableBuilder(
    column: $table.preferredTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CropPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $CropPlansTable> {
  $$CropPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cropName => $composableBuilder(
    column: $table.cropName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredTime => $composableBuilder(
    column: $table.preferredTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CropPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $CropPlansTable> {
  $$CropPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get cropName =>
      $composableBuilder(column: $table.cropName, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get preferredTime => $composableBuilder(
    column: $table.preferredTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$CropPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CropPlansTable,
          CropPlan,
          $$CropPlansTableFilterComposer,
          $$CropPlansTableOrderingComposer,
          $$CropPlansTableAnnotationComposer,
          $$CropPlansTableCreateCompanionBuilder,
          $$CropPlansTableUpdateCompanionBuilder,
          (CropPlan, BaseReferences<_$AppDatabase, $CropPlansTable, CropPlan>),
          CropPlan,
          PrefetchHooks Function()
        > {
  $$CropPlansTableTableManager(_$AppDatabase db, $CropPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CropPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CropPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CropPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> cropName = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<String> preferredTime = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => CropPlansCompanion(
                id: id,
                userId: userId,
                cropName: cropName,
                startDate: startDate,
                preferredTime: preferredTime,
                payloadJson: payloadJson,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String cropName,
                required DateTime startDate,
                required String preferredTime,
                required String payloadJson,
                Value<bool> active = const Value.absent(),
              }) => CropPlansCompanion.insert(
                id: id,
                userId: userId,
                cropName: cropName,
                startDate: startDate,
                preferredTime: preferredTime,
                payloadJson: payloadJson,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CropPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CropPlansTable,
      CropPlan,
      $$CropPlansTableFilterComposer,
      $$CropPlansTableOrderingComposer,
      $$CropPlansTableAnnotationComposer,
      $$CropPlansTableCreateCompanionBuilder,
      $$CropPlansTableUpdateCompanionBuilder,
      (CropPlan, BaseReferences<_$AppDatabase, $CropPlansTable, CropPlan>),
      CropPlan,
      PrefetchHooks Function()
    >;
typedef $$CalendarTasksTableCreateCompanionBuilder =
    CalendarTasksCompanion Function({
      Value<int> id,
      Value<int?> planId,
      required int userId,
      required String title,
      Value<String?> description,
      required DateTime date,
      required String type,
      Value<bool> completed,
      Value<DateTime?> completedAt,
    });
typedef $$CalendarTasksTableUpdateCompanionBuilder =
    CalendarTasksCompanion Function({
      Value<int> id,
      Value<int?> planId,
      Value<int> userId,
      Value<String> title,
      Value<String?> description,
      Value<DateTime> date,
      Value<String> type,
      Value<bool> completed,
      Value<DateTime?> completedAt,
    });

class $$CalendarTasksTableFilterComposer
    extends Composer<_$AppDatabase, $CalendarTasksTable> {
  $$CalendarTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalendarTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendarTasksTable> {
  $$CalendarTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendarTasksTable> {
  $$CalendarTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$CalendarTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalendarTasksTable,
          CalendarTask,
          $$CalendarTasksTableFilterComposer,
          $$CalendarTasksTableOrderingComposer,
          $$CalendarTasksTableAnnotationComposer,
          $$CalendarTasksTableCreateCompanionBuilder,
          $$CalendarTasksTableUpdateCompanionBuilder,
          (
            CalendarTask,
            BaseReferences<_$AppDatabase, $CalendarTasksTable, CalendarTask>,
          ),
          CalendarTask,
          PrefetchHooks Function()
        > {
  $$CalendarTasksTableTableManager(_$AppDatabase db, $CalendarTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> planId = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => CalendarTasksCompanion(
                id: id,
                planId: planId,
                userId: userId,
                title: title,
                description: description,
                date: date,
                type: type,
                completed: completed,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> planId = const Value.absent(),
                required int userId,
                required String title,
                Value<String?> description = const Value.absent(),
                required DateTime date,
                required String type,
                Value<bool> completed = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => CalendarTasksCompanion.insert(
                id: id,
                planId: planId,
                userId: userId,
                title: title,
                description: description,
                date: date,
                type: type,
                completed: completed,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalendarTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalendarTasksTable,
      CalendarTask,
      $$CalendarTasksTableFilterComposer,
      $$CalendarTasksTableOrderingComposer,
      $$CalendarTasksTableAnnotationComposer,
      $$CalendarTasksTableCreateCompanionBuilder,
      $$CalendarTasksTableUpdateCompanionBuilder,
      (
        CalendarTask,
        BaseReferences<_$AppDatabase, $CalendarTasksTable, CalendarTask>,
      ),
      CalendarTask,
      PrefetchHooks Function()
    >;
typedef $$NotificationLogsTableCreateCompanionBuilder =
    NotificationLogsCompanion Function({
      Value<int> id,
      required int userId,
      required String title,
      required String body,
      Value<DateTime> timestamp,
      Value<bool> read,
      Value<String> status,
      Value<int?> taskId,
    });
typedef $$NotificationLogsTableUpdateCompanionBuilder =
    NotificationLogsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> title,
      Value<String> body,
      Value<DateTime> timestamp,
      Value<bool> read,
      Value<String> status,
      Value<int?> taskId,
    });

class $$NotificationLogsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationLogsTable> {
  $$NotificationLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get read => $composableBuilder(
    column: $table.read,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationLogsTable> {
  $$NotificationLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get read => $composableBuilder(
    column: $table.read,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationLogsTable> {
  $$NotificationLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<bool> get read =>
      $composableBuilder(column: $table.read, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);
}

class $$NotificationLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationLogsTable,
          NotificationLog,
          $$NotificationLogsTableFilterComposer,
          $$NotificationLogsTableOrderingComposer,
          $$NotificationLogsTableAnnotationComposer,
          $$NotificationLogsTableCreateCompanionBuilder,
          $$NotificationLogsTableUpdateCompanionBuilder,
          (
            NotificationLog,
            BaseReferences<
              _$AppDatabase,
              $NotificationLogsTable,
              NotificationLog
            >,
          ),
          NotificationLog,
          PrefetchHooks Function()
        > {
  $$NotificationLogsTableTableManager(
    _$AppDatabase db,
    $NotificationLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<bool> read = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> taskId = const Value.absent(),
              }) => NotificationLogsCompanion(
                id: id,
                userId: userId,
                title: title,
                body: body,
                timestamp: timestamp,
                read: read,
                status: status,
                taskId: taskId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String title,
                required String body,
                Value<DateTime> timestamp = const Value.absent(),
                Value<bool> read = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> taskId = const Value.absent(),
              }) => NotificationLogsCompanion.insert(
                id: id,
                userId: userId,
                title: title,
                body: body,
                timestamp: timestamp,
                read: read,
                status: status,
                taskId: taskId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationLogsTable,
      NotificationLog,
      $$NotificationLogsTableFilterComposer,
      $$NotificationLogsTableOrderingComposer,
      $$NotificationLogsTableAnnotationComposer,
      $$NotificationLogsTableCreateCompanionBuilder,
      $$NotificationLogsTableUpdateCompanionBuilder,
      (
        NotificationLog,
        BaseReferences<_$AppDatabase, $NotificationLogsTable, NotificationLog>,
      ),
      NotificationLog,
      PrefetchHooks Function()
    >;
typedef $$ObservationsTableCreateCompanionBuilder =
    ObservationsCompanion Function({
      Value<int> id,
      required int userId,
      required String cropName,
      Value<String?> cropImagePath,
      Value<DateTime> date,
      required String content,
      Value<String?> plantStatus,
      Value<String?> stage,
      Value<bool> hasIrrigation,
      Value<bool> hasPest,
      Value<bool> hasTransplantOrFertilization,
    });
typedef $$ObservationsTableUpdateCompanionBuilder =
    ObservationsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> cropName,
      Value<String?> cropImagePath,
      Value<DateTime> date,
      Value<String> content,
      Value<String?> plantStatus,
      Value<String?> stage,
      Value<bool> hasIrrigation,
      Value<bool> hasPest,
      Value<bool> hasTransplantOrFertilization,
    });

class $$ObservationsTableFilterComposer
    extends Composer<_$AppDatabase, $ObservationsTable> {
  $$ObservationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cropName => $composableBuilder(
    column: $table.cropName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cropImagePath => $composableBuilder(
    column: $table.cropImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plantStatus => $composableBuilder(
    column: $table.plantStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasIrrigation => $composableBuilder(
    column: $table.hasIrrigation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasPest => $composableBuilder(
    column: $table.hasPest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasTransplantOrFertilization => $composableBuilder(
    column: $table.hasTransplantOrFertilization,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ObservationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ObservationsTable> {
  $$ObservationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cropName => $composableBuilder(
    column: $table.cropName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cropImagePath => $composableBuilder(
    column: $table.cropImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plantStatus => $composableBuilder(
    column: $table.plantStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasIrrigation => $composableBuilder(
    column: $table.hasIrrigation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasPest => $composableBuilder(
    column: $table.hasPest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasTransplantOrFertilization => $composableBuilder(
    column: $table.hasTransplantOrFertilization,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ObservationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ObservationsTable> {
  $$ObservationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get cropName =>
      $composableBuilder(column: $table.cropName, builder: (column) => column);

  GeneratedColumn<String> get cropImagePath => $composableBuilder(
    column: $table.cropImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get plantStatus => $composableBuilder(
    column: $table.plantStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stage =>
      $composableBuilder(column: $table.stage, builder: (column) => column);

  GeneratedColumn<bool> get hasIrrigation => $composableBuilder(
    column: $table.hasIrrigation,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasPest =>
      $composableBuilder(column: $table.hasPest, builder: (column) => column);

  GeneratedColumn<bool> get hasTransplantOrFertilization => $composableBuilder(
    column: $table.hasTransplantOrFertilization,
    builder: (column) => column,
  );
}

class $$ObservationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ObservationsTable,
          Observation,
          $$ObservationsTableFilterComposer,
          $$ObservationsTableOrderingComposer,
          $$ObservationsTableAnnotationComposer,
          $$ObservationsTableCreateCompanionBuilder,
          $$ObservationsTableUpdateCompanionBuilder,
          (
            Observation,
            BaseReferences<_$AppDatabase, $ObservationsTable, Observation>,
          ),
          Observation,
          PrefetchHooks Function()
        > {
  $$ObservationsTableTableManager(_$AppDatabase db, $ObservationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ObservationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ObservationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ObservationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> cropName = const Value.absent(),
                Value<String?> cropImagePath = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> plantStatus = const Value.absent(),
                Value<String?> stage = const Value.absent(),
                Value<bool> hasIrrigation = const Value.absent(),
                Value<bool> hasPest = const Value.absent(),
                Value<bool> hasTransplantOrFertilization = const Value.absent(),
              }) => ObservationsCompanion(
                id: id,
                userId: userId,
                cropName: cropName,
                cropImagePath: cropImagePath,
                date: date,
                content: content,
                plantStatus: plantStatus,
                stage: stage,
                hasIrrigation: hasIrrigation,
                hasPest: hasPest,
                hasTransplantOrFertilization: hasTransplantOrFertilization,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String cropName,
                Value<String?> cropImagePath = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                required String content,
                Value<String?> plantStatus = const Value.absent(),
                Value<String?> stage = const Value.absent(),
                Value<bool> hasIrrigation = const Value.absent(),
                Value<bool> hasPest = const Value.absent(),
                Value<bool> hasTransplantOrFertilization = const Value.absent(),
              }) => ObservationsCompanion.insert(
                id: id,
                userId: userId,
                cropName: cropName,
                cropImagePath: cropImagePath,
                date: date,
                content: content,
                plantStatus: plantStatus,
                stage: stage,
                hasIrrigation: hasIrrigation,
                hasPest: hasPest,
                hasTransplantOrFertilization: hasTransplantOrFertilization,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ObservationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ObservationsTable,
      Observation,
      $$ObservationsTableFilterComposer,
      $$ObservationsTableOrderingComposer,
      $$ObservationsTableAnnotationComposer,
      $$ObservationsTableCreateCompanionBuilder,
      $$ObservationsTableUpdateCompanionBuilder,
      (
        Observation,
        BaseReferences<_$AppDatabase, $ObservationsTable, Observation>,
      ),
      Observation,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$UserCultivosTableTableManager get userCultivos =>
      $$UserCultivosTableTableManager(_db, _db.userCultivos);
  $$SharedCultivosTableTableManager get sharedCultivos =>
      $$SharedCultivosTableTableManager(_db, _db.sharedCultivos);
  $$UserFertilizantesTableTableManager get userFertilizantes =>
      $$UserFertilizantesTableTableManager(_db, _db.userFertilizantes);
  $$SharedFertilizantesTableTableManager get sharedFertilizantes =>
      $$SharedFertilizantesTableTableManager(_db, _db.sharedFertilizantes);
  $$UserPlagasTableTableManager get userPlagas =>
      $$UserPlagasTableTableManager(_db, _db.userPlagas);
  $$SharedPlagasTableTableManager get sharedPlagas =>
      $$SharedPlagasTableTableManager(_db, _db.sharedPlagas);
  $$UserPesticidasTableTableManager get userPesticidas =>
      $$UserPesticidasTableTableManager(_db, _db.userPesticidas);
  $$SharedPesticidasTableTableManager get sharedPesticidas =>
      $$SharedPesticidasTableTableManager(_db, _db.sharedPesticidas);
  $$CropPlansTableTableManager get cropPlans =>
      $$CropPlansTableTableManager(_db, _db.cropPlans);
  $$CalendarTasksTableTableManager get calendarTasks =>
      $$CalendarTasksTableTableManager(_db, _db.calendarTasks);
  $$NotificationLogsTableTableManager get notificationLogs =>
      $$NotificationLogsTableTableManager(_db, _db.notificationLogs);
  $$ObservationsTableTableManager get observations =>
      $$ObservationsTableTableManager(_db, _db.observations);
}
