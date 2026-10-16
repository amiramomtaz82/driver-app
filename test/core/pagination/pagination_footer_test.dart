import 'package:driver_app/core/pagination/presentation/pagination_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('PaginationFooter', () {
    testWidgets('shows a spinner while loading more', (tester) async {
      await tester.pumpWidget(
        _wrap(const PaginationFooter(isLoadingMore: true, hasNextPage: true)),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows a retry button on load-more error', (tester) async {
      var retried = false;
      await tester.pumpWidget(
        _wrap(
          PaginationFooter(
            isLoadingMore: false,
            hasNextPage: true,
            loadMoreError: 'errors.something_went_wrong',
            onRetry: () => retried = true,
          ),
        ),
      );

      final retry = find.text('common.retry');
      expect(retry, findsOneWidget);

      await tester.tap(retry);
      expect(retried, isTrue);
    });

    testWidgets('shows end-of-list note when there is no next page', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const PaginationFooter(isLoadingMore: false, hasNextPage: false)),
      );

      expect(find.text('common.no_more_items'), findsOneWidget);
    });

    testWidgets('renders nothing while idle with more pages', (tester) async {
      await tester.pumpWidget(
        _wrap(const PaginationFooter(isLoadingMore: false, hasNextPage: true)),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('common.no_more_items'), findsNothing);
    });
  });
}
