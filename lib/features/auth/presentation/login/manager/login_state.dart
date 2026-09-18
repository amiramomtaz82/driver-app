import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/auth/domain/models/login_response_model.dart';
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool rememberMe;
  final bool isPasswordVisible;
  final Resource<LoginResponseModel> loginResource;

  const LoginState({
    this.email = '',
    this.password = '',
    this.rememberMe = false,
    this.isPasswordVisible = false,
    this.loginResource = const Resource.initial(),
  });

  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  LoginState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    bool? isPasswordVisible,
    Resource<LoginResponseModel>? loginResource,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      loginResource: loginResource ?? this.loginResource,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    rememberMe,
    isPasswordVisible,
    loginResource,
  ];
}
