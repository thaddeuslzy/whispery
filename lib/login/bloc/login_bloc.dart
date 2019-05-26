import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whispery/login/login.dart';
import 'package:whispery/user_repository.dart';
import 'package:whispery/validators.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    // if (event is EmailChanged) {
    //   yield* _mapEmailChangedToState(event.email);
    // } else if (event is PasswordChanged) {
    //   yield* _mapPasswordChangedToState(event.password);
    // } else if (event is LoginWithGooglePressed) {
    //   yield* _mapLoginWithGooglePressedToState();
    // } else
    if (event is LoginWithCredentialsPressed) {
      // yield* _mapEmailChangedToState(event.email);
      // yield* _mapPasswordChangedToState(event.password);
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  // Stream<LoginState> _mapEmailChangedToState(String email) async* {
  //   yield currentState.update(
  //     isEmailValid: Validators.isValidEmail(email),
  //   );
  // }

  // Stream<LoginState> _mapPasswordChangedToState(String password) async* {
  //   yield currentState.update(
  //     isPasswordValid: Validators.isValidPassword(password),
  //   );
  // }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithCredentials(email, password);
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
