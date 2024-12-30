import 'package:fernweh/utils/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncDataWidget<T> extends ConsumerWidget {
  final FutureProvider<T> dataProvider;
  final Widget Function(BuildContext context, T data) dataBuilder;
  final Widget loadingBuilder;
  final Widget Function(Object, StackTrace) errorBuilder;

  const AsyncDataWidget(
      {super.key,
      required this.dataProvider,
      required this.dataBuilder,
      this.loadingBuilder = const Center(child: LoadingWidget()),
      required this.errorBuilder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(dataProvider);

    return asyncValue.when(
      data: (data) => dataBuilder(context, data),
      loading: () => loadingBuilder,
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }
}

class AsyncDataWidgetB<T> extends ConsumerWidget {
  final ProviderBase<AsyncValue<T>> dataProvider;
  final Widget Function( T data) dataBuilder;
  final Widget loadingBuilder;
  final Widget Function(Object, StackTrace) errorBuilder;

  const AsyncDataWidgetB({
    super.key,
    required this.dataProvider,
    required this.dataBuilder,
    this.loadingBuilder = const Center(child: LoadingWidget()),
    required this.errorBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(dataProvider);

    return AnimatedSwitcher(
      key: ValueKey(asyncValue),
      duration: const Duration(milliseconds: 300),
      child: asyncValue.when(
          data: (data) => dataBuilder( data),
          loading: () => loadingBuilder,
          error: (error, stackTrace) => errorBuilder(error, stackTrace)),
    );
  }
}
class ErrorCustomWidget extends ConsumerWidget {
  final Object error;
  final VoidCallback? onRetry;
  final double height;
  const ErrorCustomWidget({
    required this.error,
    required this.onRetry,
    this.height = 200,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
            ),
            const SizedBox(height: 16),
            Text(
              error.toString(),
              maxLines: 6,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              width: 100,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: const Size(60, 40),
                ),
                onPressed: onRetry,
                child: const Text(
                  "Refresh",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}