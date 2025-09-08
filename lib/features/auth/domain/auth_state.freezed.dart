// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() signingIn,
    required TResult Function() signingUp,
    required TResult Function(String email, String? message) emailPending,
    required TResult Function(User user) authenticated,
    required TResult Function(String message, String? code) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? signingIn,
    TResult? Function()? signingUp,
    TResult? Function(String email, String? message)? emailPending,
    TResult? Function(User user)? authenticated,
    TResult? Function(String message, String? code)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? signingIn,
    TResult Function()? signingUp,
    TResult Function(String email, String? message)? emailPending,
    TResult Function(User user)? authenticated,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_SigningIn value) signingIn,
    required TResult Function(_SigningUp value) signingUp,
    required TResult Function(_EmailPending value) emailPending,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Error value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_SigningIn value)? signingIn,
    TResult? Function(_SigningUp value)? signingUp,
    TResult? Function(_EmailPending value)? emailPending,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Error value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_SigningIn value)? signingIn,
    TResult Function(_SigningUp value)? signingUp,
    TResult Function(_EmailPending value)? emailPending,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UnauthenticatedImplCopyWith<$Res> {
  factory _$$UnauthenticatedImplCopyWith(
    _$UnauthenticatedImpl value,
    $Res Function(_$UnauthenticatedImpl) then,
  ) = __$$UnauthenticatedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnauthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$UnauthenticatedImpl>
    implements _$$UnauthenticatedImplCopyWith<$Res> {
  __$$UnauthenticatedImplCopyWithImpl(
    _$UnauthenticatedImpl _value,
    $Res Function(_$UnauthenticatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UnauthenticatedImpl implements _Unauthenticated {
  const _$UnauthenticatedImpl();

  @override
  String toString() {
    return 'AuthState.unauthenticated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UnauthenticatedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() signingIn,
    required TResult Function() signingUp,
    required TResult Function(String email, String? message) emailPending,
    required TResult Function(User user) authenticated,
    required TResult Function(String message, String? code) error,
  }) {
    return unauthenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? signingIn,
    TResult? Function()? signingUp,
    TResult? Function(String email, String? message)? emailPending,
    TResult? Function(User user)? authenticated,
    TResult? Function(String message, String? code)? error,
  }) {
    return unauthenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? signingIn,
    TResult Function()? signingUp,
    TResult Function(String email, String? message)? emailPending,
    TResult Function(User user)? authenticated,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_SigningIn value) signingIn,
    required TResult Function(_SigningUp value) signingUp,
    required TResult Function(_EmailPending value) emailPending,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Error value) error,
  }) {
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_SigningIn value)? signingIn,
    TResult? Function(_SigningUp value)? signingUp,
    TResult? Function(_EmailPending value)? emailPending,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Error value)? error,
  }) {
    return unauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_SigningIn value)? signingIn,
    TResult Function(_SigningUp value)? signingUp,
    TResult Function(_EmailPending value)? emailPending,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }
}

abstract class _Unauthenticated implements AuthState {
  const factory _Unauthenticated() = _$UnauthenticatedImpl;
}

/// @nodoc
abstract class _$$SigningInImplCopyWith<$Res> {
  factory _$$SigningInImplCopyWith(
    _$SigningInImpl value,
    $Res Function(_$SigningInImpl) then,
  ) = __$$SigningInImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SigningInImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$SigningInImpl>
    implements _$$SigningInImplCopyWith<$Res> {
  __$$SigningInImplCopyWithImpl(
    _$SigningInImpl _value,
    $Res Function(_$SigningInImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SigningInImpl implements _SigningIn {
  const _$SigningInImpl();

  @override
  String toString() {
    return 'AuthState.signingIn()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SigningInImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() signingIn,
    required TResult Function() signingUp,
    required TResult Function(String email, String? message) emailPending,
    required TResult Function(User user) authenticated,
    required TResult Function(String message, String? code) error,
  }) {
    return signingIn();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? signingIn,
    TResult? Function()? signingUp,
    TResult? Function(String email, String? message)? emailPending,
    TResult? Function(User user)? authenticated,
    TResult? Function(String message, String? code)? error,
  }) {
    return signingIn?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? signingIn,
    TResult Function()? signingUp,
    TResult Function(String email, String? message)? emailPending,
    TResult Function(User user)? authenticated,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (signingIn != null) {
      return signingIn();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_SigningIn value) signingIn,
    required TResult Function(_SigningUp value) signingUp,
    required TResult Function(_EmailPending value) emailPending,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Error value) error,
  }) {
    return signingIn(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_SigningIn value)? signingIn,
    TResult? Function(_SigningUp value)? signingUp,
    TResult? Function(_EmailPending value)? emailPending,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Error value)? error,
  }) {
    return signingIn?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_SigningIn value)? signingIn,
    TResult Function(_SigningUp value)? signingUp,
    TResult Function(_EmailPending value)? emailPending,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (signingIn != null) {
      return signingIn(this);
    }
    return orElse();
  }
}

abstract class _SigningIn implements AuthState {
  const factory _SigningIn() = _$SigningInImpl;
}

/// @nodoc
abstract class _$$SigningUpImplCopyWith<$Res> {
  factory _$$SigningUpImplCopyWith(
    _$SigningUpImpl value,
    $Res Function(_$SigningUpImpl) then,
  ) = __$$SigningUpImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SigningUpImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$SigningUpImpl>
    implements _$$SigningUpImplCopyWith<$Res> {
  __$$SigningUpImplCopyWithImpl(
    _$SigningUpImpl _value,
    $Res Function(_$SigningUpImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SigningUpImpl implements _SigningUp {
  const _$SigningUpImpl();

  @override
  String toString() {
    return 'AuthState.signingUp()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SigningUpImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() signingIn,
    required TResult Function() signingUp,
    required TResult Function(String email, String? message) emailPending,
    required TResult Function(User user) authenticated,
    required TResult Function(String message, String? code) error,
  }) {
    return signingUp();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? signingIn,
    TResult? Function()? signingUp,
    TResult? Function(String email, String? message)? emailPending,
    TResult? Function(User user)? authenticated,
    TResult? Function(String message, String? code)? error,
  }) {
    return signingUp?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? signingIn,
    TResult Function()? signingUp,
    TResult Function(String email, String? message)? emailPending,
    TResult Function(User user)? authenticated,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (signingUp != null) {
      return signingUp();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_SigningIn value) signingIn,
    required TResult Function(_SigningUp value) signingUp,
    required TResult Function(_EmailPending value) emailPending,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Error value) error,
  }) {
    return signingUp(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_SigningIn value)? signingIn,
    TResult? Function(_SigningUp value)? signingUp,
    TResult? Function(_EmailPending value)? emailPending,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Error value)? error,
  }) {
    return signingUp?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_SigningIn value)? signingIn,
    TResult Function(_SigningUp value)? signingUp,
    TResult Function(_EmailPending value)? emailPending,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (signingUp != null) {
      return signingUp(this);
    }
    return orElse();
  }
}

abstract class _SigningUp implements AuthState {
  const factory _SigningUp() = _$SigningUpImpl;
}

/// @nodoc
abstract class _$$EmailPendingImplCopyWith<$Res> {
  factory _$$EmailPendingImplCopyWith(
    _$EmailPendingImpl value,
    $Res Function(_$EmailPendingImpl) then,
  ) = __$$EmailPendingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String? message});
}

/// @nodoc
class __$$EmailPendingImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$EmailPendingImpl>
    implements _$$EmailPendingImplCopyWith<$Res> {
  __$$EmailPendingImplCopyWithImpl(
    _$EmailPendingImpl _value,
    $Res Function(_$EmailPendingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? message = freezed}) {
    return _then(
      _$EmailPendingImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$EmailPendingImpl implements _EmailPending {
  const _$EmailPendingImpl({required this.email, this.message});

  @override
  final String email;
  @override
  final String? message;

  @override
  String toString() {
    return 'AuthState.emailPending(email: $email, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailPendingImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, message);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailPendingImplCopyWith<_$EmailPendingImpl> get copyWith =>
      __$$EmailPendingImplCopyWithImpl<_$EmailPendingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() signingIn,
    required TResult Function() signingUp,
    required TResult Function(String email, String? message) emailPending,
    required TResult Function(User user) authenticated,
    required TResult Function(String message, String? code) error,
  }) {
    return emailPending(email, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? signingIn,
    TResult? Function()? signingUp,
    TResult? Function(String email, String? message)? emailPending,
    TResult? Function(User user)? authenticated,
    TResult? Function(String message, String? code)? error,
  }) {
    return emailPending?.call(email, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? signingIn,
    TResult Function()? signingUp,
    TResult Function(String email, String? message)? emailPending,
    TResult Function(User user)? authenticated,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (emailPending != null) {
      return emailPending(email, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_SigningIn value) signingIn,
    required TResult Function(_SigningUp value) signingUp,
    required TResult Function(_EmailPending value) emailPending,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Error value) error,
  }) {
    return emailPending(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_SigningIn value)? signingIn,
    TResult? Function(_SigningUp value)? signingUp,
    TResult? Function(_EmailPending value)? emailPending,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Error value)? error,
  }) {
    return emailPending?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_SigningIn value)? signingIn,
    TResult Function(_SigningUp value)? signingUp,
    TResult Function(_EmailPending value)? emailPending,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (emailPending != null) {
      return emailPending(this);
    }
    return orElse();
  }
}

abstract class _EmailPending implements AuthState {
  const factory _EmailPending({
    required final String email,
    final String? message,
  }) = _$EmailPendingImpl;

  String get email;
  String? get message;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmailPendingImplCopyWith<_$EmailPendingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthenticatedImplCopyWith<$Res> {
  factory _$$AuthenticatedImplCopyWith(
    _$AuthenticatedImpl value,
    $Res Function(_$AuthenticatedImpl) then,
  ) = __$$AuthenticatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({User user});
}

/// @nodoc
class __$$AuthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthenticatedImpl>
    implements _$$AuthenticatedImplCopyWith<$Res> {
  __$$AuthenticatedImplCopyWithImpl(
    _$AuthenticatedImpl _value,
    $Res Function(_$AuthenticatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null}) {
    return _then(
      _$AuthenticatedImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
      ),
    );
  }
}

/// @nodoc

class _$AuthenticatedImpl implements _Authenticated {
  const _$AuthenticatedImpl({required this.user});

  @override
  final User user;

  @override
  String toString() {
    return 'AuthState.authenticated(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticatedImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticatedImplCopyWith<_$AuthenticatedImpl> get copyWith =>
      __$$AuthenticatedImplCopyWithImpl<_$AuthenticatedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() signingIn,
    required TResult Function() signingUp,
    required TResult Function(String email, String? message) emailPending,
    required TResult Function(User user) authenticated,
    required TResult Function(String message, String? code) error,
  }) {
    return authenticated(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? signingIn,
    TResult? Function()? signingUp,
    TResult? Function(String email, String? message)? emailPending,
    TResult? Function(User user)? authenticated,
    TResult? Function(String message, String? code)? error,
  }) {
    return authenticated?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? signingIn,
    TResult Function()? signingUp,
    TResult Function(String email, String? message)? emailPending,
    TResult Function(User user)? authenticated,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_SigningIn value) signingIn,
    required TResult Function(_SigningUp value) signingUp,
    required TResult Function(_EmailPending value) emailPending,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Error value) error,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_SigningIn value)? signingIn,
    TResult? Function(_SigningUp value)? signingUp,
    TResult? Function(_EmailPending value)? emailPending,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Error value)? error,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_SigningIn value)? signingIn,
    TResult Function(_SigningUp value)? signingUp,
    TResult Function(_EmailPending value)? emailPending,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class _Authenticated implements AuthState {
  const factory _Authenticated({required final User user}) =
      _$AuthenticatedImpl;

  User get user;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthenticatedImplCopyWith<_$AuthenticatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
    _$ErrorImpl value,
    $Res Function(_$ErrorImpl) then,
  ) = __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, String? code});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? code = freezed}) {
    return _then(
      _$ErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl({required this.message, this.code});

  @override
  final String message;
  @override
  final String? code;

  @override
  String toString() {
    return 'AuthState.error(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthenticated,
    required TResult Function() signingIn,
    required TResult Function() signingUp,
    required TResult Function(String email, String? message) emailPending,
    required TResult Function(User user) authenticated,
    required TResult Function(String message, String? code) error,
  }) {
    return error(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthenticated,
    TResult? Function()? signingIn,
    TResult? Function()? signingUp,
    TResult? Function(String email, String? message)? emailPending,
    TResult? Function(User user)? authenticated,
    TResult? Function(String message, String? code)? error,
  }) {
    return error?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthenticated,
    TResult Function()? signingIn,
    TResult Function()? signingUp,
    TResult Function(String email, String? message)? emailPending,
    TResult Function(User user)? authenticated,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_SigningIn value) signingIn,
    required TResult Function(_SigningUp value) signingUp,
    required TResult Function(_EmailPending value) emailPending,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_SigningIn value)? signingIn,
    TResult? Function(_SigningUp value)? signingUp,
    TResult? Function(_EmailPending value)? emailPending,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_SigningIn value)? signingIn,
    TResult Function(_SigningUp value)? signingUp,
    TResult Function(_EmailPending value)? emailPending,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements AuthState {
  const factory _Error({required final String message, final String? code}) =
      _$ErrorImpl;

  String get message;
  String? get code;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
