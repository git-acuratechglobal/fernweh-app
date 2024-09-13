import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view/navigation/friends_list/controller/friends_notifier.dart';
import '../widgets/loading_widget.dart';

class PaginationWidget<T> extends StatefulWidget {
  final AsyncValue<PaginationResponse<T>> value;
  final Widget? Function(int, T) itemBuilder;
  final Widget separator;
  final ScrollController? scrollController;
  final VoidCallback onLoadMore;
  final VoidCallback? retry;
  final bool Function() canLoadMore;
  final Axis scrollDirection;
  final EdgeInsets? padding;
  final Widget emptyWidget;
  final Widget loading;

  const PaginationWidget({
    super.key,
    required this.value,
    required this.itemBuilder,
    required this.onLoadMore,
    required this.separator,
    required this.emptyWidget,
    required this.canLoadMore,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.scrollController,
    this.retry,
    required this.loading,
  });

  @override
  State<PaginationWidget<T>> createState() => _PaginationWidgetState<T>();
}

class _PaginationWidgetState<T> extends State<PaginationWidget<T>> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = widget.scrollController ?? ScrollController();
    scrollController.addListener(() {
      if (widget.canLoadMore() &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent) {
        widget.onLoadMore.call();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncWidget(
      skipError: true,
      onRetry: widget.retry,
      value: widget.value,
      data: (list) {
        if (list.data.isEmpty) {
          return widget.emptyWidget;
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: ListView.separated(
            padding: widget.padding,
            scrollDirection: widget.scrollDirection,
            controller: scrollController,
            itemCount: list.data.length +
                (widget.value.isRefreshing || widget.value.hasError ? 1 : 0),
            itemBuilder: (context, index) {
              if (index != list.data.length) {
                return widget.itemBuilder(index, list.data[index]);
              } else {
                if (widget.value.isRefreshing) {
                  return const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Please wait"),
                      SizedBox(
                        width: 8,
                      ),
                      LoadingWidget()
                    ],
                  );
                } else if (widget.value.hasError) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.value.error.toString(),
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        OutlinedButton(
                          onPressed: widget.onLoadMore,
                          child: const Text(
                            "Retry",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }
            },
            separatorBuilder: (BuildContext context, int index) {
              return widget.separator;
            },
          ),
        );
      },
      loading: widget.loading,
    );
  }
}

class AsyncWidget<T> extends StatelessWidget {
  final double height;
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final void Function()? onRetry;
  final bool skipLoadingOnReload;
  final bool skipLoadingOnRefresh;
  final bool skipError;
  final Widget loading;

  const AsyncWidget({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.skipLoadingOnReload = false,
    this.skipLoadingOnRefresh = true,
    this.skipError = false,
    this.height = 200,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: value.when(
        data: data,
        loading: () => loading,
        error: (e, st) => ErrorCustomWidget(
          key: UniqueKey(),
          error: e,
          height: height,
          onRetry: onRetry,
        ),
        skipLoadingOnReload: skipLoadingOnReload,
        skipLoadingOnRefresh: skipLoadingOnRefresh,
        skipError: skipError,
      ),
    );
  }
}

class ErrorCustomWidget extends ConsumerWidget {
  final Object error;
  final VoidCallback? onRetry;
  final double height;

  const ErrorCustomWidget( {
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
        width: MediaQuery.sizeOf(context).width,
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
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(60, 40),
              ),
              onPressed: onRetry,
              child: const Text(
                "Refresh",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
