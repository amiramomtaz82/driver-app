sealed class UiEvent {
  const UiEvent();
}



class ShowSnackBarEvent extends UiEvent {
  final String message;
  final bool isError;

  const ShowSnackBarEvent({
    required this.message,
    this.isError = false,
  });
}

class NavigateEvent extends UiEvent {
  final String route;
  final Object? arguments;

  const NavigateEvent(
      this.route, {
        this.arguments,
      });
}

class NavigateReplacementEvent extends UiEvent {
  final String route;
  final Object? arguments;

  const NavigateReplacementEvent(
      this.route, {
        this.arguments,
      });
}

class PopEvent extends UiEvent {
  final Object? result;

  const PopEvent([this.result]);
}

class ShowDialogEvent extends UiEvent {
  final String title;
  final String message;

  const ShowDialogEvent({
    required this.title,
    required this.message,
  });
}