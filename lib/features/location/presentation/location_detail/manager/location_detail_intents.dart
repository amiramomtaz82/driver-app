sealed class LocationDetailIntent {
  const LocationDetailIntent();
}

class LoadLocationDetail extends LocationDetailIntent {
  const LoadLocationDetail();
}

class CallTapped extends LocationDetailIntent {
  const CallTapped();
}

class MessageTapped extends LocationDetailIntent {
  const MessageTapped();
}
