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
}
