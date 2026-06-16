import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class CheckSession extends AuthEvent {
  const CheckSession();
}

class SignIn extends AuthEvent {
  final String email;
  final String password;
  const SignIn(this.email, this.password);
  @override
  List<Object?> get props => [email];
}

class SignUp extends AuthEvent {
  final String email;
  final String password;
  const SignUp(this.email, this.password);
  @override
  List<Object?> get props => [email];
}

class GoogleSignIn extends AuthEvent {
  const GoogleSignIn();
}

class SignOut extends AuthEvent {
  const SignOut();
}
