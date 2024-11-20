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
