sealed class LocationDetailIntent {
  const LocationDetailIntent();
}

class LoadLocationDetail extends LocationDetailIntent {
  const LoadLocationDetail();
}

class CallTapped extends LocationDetailIntent {
  final String phone;

  const CallTapped({required this.phone});
}

class MessageTapped extends LocationDetailIntent {
  final String phone;

  const MessageTapped({required this.phone});
}
