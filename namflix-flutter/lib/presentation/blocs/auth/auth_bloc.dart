import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _supabase = Supabase.instance.client;

  AuthBloc() : super(AuthInitial()) {
    on<CheckSession>(_onCheckSession);
    on<SignIn>(_onSignIn);
    on<SignUp>(_onSignUp);
    on<GoogleSignIn>(_onGoogleSignIn);
    on<SignOut>(_onSignOut);
  }

  void _onCheckSession(CheckSession event, Emitter<AuthState> emit) {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignIn(SignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: event.email,
        password: event.password,
      );
      if (response.user != null) {
        emit(Authenticated(response.user!));
      } else {
        emit(const AuthError('Sign in failed. Please check your credentials.'));
      }
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (_) {
      emit(const AuthError('An error occurred. Please try again.'));
    }
  }

  Future<void> _onSignUp(SignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _supabase.auth.signUp(
        email: event.email,
        password: event.password,
      );
      if (response.user != null) {
        // Email confirmation may be required
        emit(AuthSignUpSuccess());
      } else {
        emit(const AuthError('Sign up failed. Please try again.'));
      }
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (_) {
      emit(const AuthError('An error occurred. Please try again.'));
    }
  }

  Future<void> _onGoogleSignIn(GoogleSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'namflix://login-callback',
      );
      // Auth state change will be handled by supabase listener
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (_) {
      emit(const AuthError('Google sign in failed.'));
    }
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _supabase.auth.signOut();
      emit(Unauthenticated());
    } catch (_) {
      emit(Unauthenticated());
    }
  }
}
