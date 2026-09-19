sealed class ForgetPasswordIntent {
  const ForgetPasswordIntent();
}

class EmailChanged extends ForgetPasswordIntent {
  final String value;
  const EmailChanged(this.value);
}

class SendCodeSubmitted extends ForgetPasswordIntent {
  const SendCodeSubmitted();
}

class ResendCodeTapped extends ForgetPasswordIntent {
  const ResendCodeTapped();
}

class OtpChanged extends ForgetPasswordIntent {
  const OtpChanged();
}

class OtpCompleted extends ForgetPasswordIntent {
  final String code;
  const OtpCompleted(this.code);
}

class NewPasswordChanged extends ForgetPasswordIntent {
  final String value;
  const NewPasswordChanged(this.value);
}

class ConfirmPasswordChanged extends ForgetPasswordIntent {
  final String value;
  const ConfirmPasswordChanged(this.value);
}

class ResetPasswordSubmitted extends ForgetPasswordIntent {
  const ResetPasswordSubmitted();
}

class BackPressed extends ForgetPasswordIntent {
  const BackPressed();
}
