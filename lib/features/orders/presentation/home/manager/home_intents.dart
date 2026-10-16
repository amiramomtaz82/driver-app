sealed class HomeIntent {
  const HomeIntent();
}

class HomeStarted extends HomeIntent {
  const HomeStarted();
}

class HomeRefreshed extends HomeIntent {
  const HomeRefreshed();
}

class HomeLoadMore extends HomeIntent {
  const HomeLoadMore();
}

class HomeRetried extends HomeIntent {
  const HomeRetried();
}

class OrderAccepted extends HomeIntent {
  const OrderAccepted(this.orderId);

  final String orderId;
}
