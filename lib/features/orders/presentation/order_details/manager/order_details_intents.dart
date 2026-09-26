sealed class OrderDetailsIntent {
  const OrderDetailsIntent();
}

class OrderDetailsStarted extends OrderDetailsIntent {
  const OrderDetailsStarted();
}

class OrderDetailsRetried extends OrderDetailsIntent {
  const OrderDetailsRetried();
}

class OrderStatusAdvanced extends OrderDetailsIntent {
  const OrderStatusAdvanced();
}
