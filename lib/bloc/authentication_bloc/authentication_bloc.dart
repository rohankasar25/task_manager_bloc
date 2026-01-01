import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/auth_repository.dart';
import 'authentication_events.dart';
import 'authentication_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLogin);
    on<LogoutRequested>(_onLogout);
  }

  void _onAppStarted(AppStarted event, Emitter emit) {
    if (repository.isLoggedIn()) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(LoginRequested event, Emitter emit) async {
    final success = await repository.login(
      event.email,
      event.password,
    );

    if (success) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthError('Invalid email or password'));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogout(LogoutRequested event, Emitter emit) async {
    await repository.logout();
    emit(AuthUnauthenticated());
  }
}
