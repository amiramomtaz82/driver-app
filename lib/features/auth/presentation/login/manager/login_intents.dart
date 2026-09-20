sealed class LoginIntent {
  const LoginIntent();
}

class EmailChanged extends LoginIntent {
  final String value;
  const EmailChanged(this.value);
}

class PasswordChanged extends LoginIntent {
  final String value;
  const PasswordChanged(this.value);
}

class RememberMeToggled extends LoginIntent {
  const RememberMeToggled();
}

class TogglePasswordVisibility extends LoginIntent {
  const TogglePasswordVisibility();
}

class LoginSubmitted extends LoginIntent {
  const LoginSubmitted();
}

class ForgotPasswordTapped extends LoginIntent {
  const ForgotPasswordTapped();
}
