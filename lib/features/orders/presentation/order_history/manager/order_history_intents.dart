sealed class OrderHistoryIntent {
  const OrderHistoryIntent();
}

class OrderHistoryStarted extends OrderHistoryIntent {
  const OrderHistoryStarted();
}

class OrderHistoryRefreshed extends OrderHistoryIntent {
  const OrderHistoryRefreshed();
}

class OrderHistoryLoadMore extends OrderHistoryIntent {
  const OrderHistoryLoadMore();
}

class OrderHistoryRetried extends OrderHistoryIntent {
  const OrderHistoryRetried();
}
