sealed class ChangePasswordIntent {
  const ChangePasswordIntent();
}

class CurrentPasswordChanged extends ChangePasswordIntent {
  final String value;
  const CurrentPasswordChanged(this.value);
}

class NewPasswordChanged extends ChangePasswordIntent {
  final String value;
  const NewPasswordChanged(this.value);
}

class ConfirmPasswordChanged extends ChangePasswordIntent {
  final String value;
  const ConfirmPasswordChanged(this.value);
}

class ChangePasswordSubmitted extends ChangePasswordIntent {
  const ChangePasswordSubmitted();
}
