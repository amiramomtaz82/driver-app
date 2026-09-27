sealed class PickupLocationIntent {
  const PickupLocationIntent();
}
class LoadPickupLocation extends PickupLocationIntent {
  const LoadPickupLocation();
}
class CallPickupTapped extends PickupLocationIntent {
  const CallPickupTapped();
}
class MessagePickupTapped extends PickupLocationIntent {
  const MessagePickupTapped();
}
