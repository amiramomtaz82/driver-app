sealed class UserLocationIntent {
  const UserLocationIntent();
}
class LoadUserLocation extends UserLocationIntent {
  const LoadUserLocation();
}
class CallUserTapped extends UserLocationIntent {
  const CallUserTapped();
}
class MessageUserTapped extends UserLocationIntent {
  const MessageUserTapped();
}
