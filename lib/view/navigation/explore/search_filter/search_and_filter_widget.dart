import 'package:animated_hint_textfield/animated_hint_textfield.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:fernweh/view/navigation/map/notifier/category_notifier.dart';
import 'package:fernweh/view/navigation/map/state/map_view_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../services/api_service/api_service.dart';
import '../../../../utils/widgets/async_widget.dart';
import '../filter_sheet/filter_sheet.dart';
import 'model/search_result.dart';

part 'search_and_filter_widget.g.dart';

class SearchAndFilterWidget extends ConsumerStatefulWidget {
  const SearchAndFilterWidget({super.key, required this.refresh});

  final Function(String val) refresh;

  @override
  ConsumerState<SearchAndFilterWidget> createState() =>
      _SearchAndFilterWidgetState();
}

class _SearchAndFilterWidgetState extends ConsumerState<SearchAndFilterWidget> {
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();
  Map<String, dynamic> filter = {};
  final LayerLink _layerLink = LayerLink();

  void _showOverlay(
    BuildContext context,
  ) {
    _overlayEntry = _createOverlayEntry(
      context,
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry? _createOverlayEntry(
    BuildContext context,
  ) {
    if (context.findRenderObject() != null) {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      var size = renderBox.size;
      var offset = renderBox.localToGlobal(Offset.zero);
      final filters = ref.watch(filtersProvider);
      final searchController = ref.watch(searchControllerProvider);
      final mapState = ref.read(mapViewStateProvider.notifier);
      return OverlayEntry(
          builder: (context) => Positioned(
              left: offset.dx + 20,
              top: size.height + offset.dy,
              width: size.width - 40,
              child: CompositedTransformFollower(
                showWhenUnlinked: false,
                link: _layerLink,
                offset: Offset(0.0, size.height + 5.0),
                child: Material(
                  elevation: 5,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  child: AsyncDataWidgetB(
                      dataProvider: searchPlaceNotifierProvider,
                      dataBuilder: ( data) {
                        return ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return ListTile(
                                  onTap: () {
                                    // ref
                                    //     .read(searchControllerProvider.notifier)
                                    //     .state
                                    //     .text = data[index].description??"";
                                    // if (index == 0) {
                                    filter = {
                                      'type': filters['type'],
                                      'search_term':
                                          searchController.text.toString(),
                                      'selected_category':
                                          filters['selected_category'],
                                    };
                                    // }
                                    // else {
                                    //   filter.remove('search_term');
                                    //   filter = {
                                    //     'type': filters['type'],
                                    //     'selected_category':
                                    //     filters['selected_category'],
                                    //     'input': searchController.text.toString(),
                                    //   };
                                    //
                                    // }

                                    ref
                                        .read(filtersProvider.notifier)
                                        .updateFilter(filter);
                                    ref
                                        .read(
                                            itineraryNotifierProvider.notifier)
                                        .filteredItinerary();
                                    mapState.update(
                                        selectedItinerary: -1,
                                        categoryView: true,
                                        itineraryView: false);
                                    _removeOverlay();
                                  },
                                  title: Text(
                                    searchController.text.toString(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                );
                              }
                              return ListTile(
                                onTap: () {
                                  ref
                                      .read(searchControllerProvider.notifier)
                                      .state
                                      .text = data[index - 1].description ?? "";
                                  if (data[index - 1].placeId == null) {
                                    filter = {
                                      'type': filters['type'],
                                      'search_term':
                                          searchController.text.toString(),
                                      'selected_category':
                                          filters['selected_category'],
                                    };
                                  } else {
                                    filter.remove('search_term');
                                    filter = {
                                      'type': filters['type'],
                                      'selected_category':
                                          filters['selected_category'],
                                      'input': data[index - 1].placeId,
                                    };
                                  }

                                  ref
                                      .read(filtersProvider.notifier)
                                      .updateFilter(filter);
                                  ref
                                      .read(itineraryNotifierProvider.notifier)
                                      .filteredItinerary();
                                  mapState.update(
                                      selectedItinerary: -1,
                                      categoryView: true,
                                      itineraryView: false);
                                  _removeOverlay();
                                },
                                title: Text(
                                  data[index - 1].description ?? "",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: data.length + 1);
                      },
                      errorBuilder: (e, st) {
                        return Text("Error: $e");
                      }),
                ),
              )));
    }
    return null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchController = ref.watch(searchControllerProvider);
    final filters = ref.watch(filtersProvider);
    final mapState = ref.read(mapViewStateProvider.notifier);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: CompositedTransformTarget(
          link: _layerLink,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: const Color(0xFFE2E2E2)),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 20,
                              offset: const Offset(0, 2),
                            ),
                          ]),
                      child: AnimatedTextField(
                        textInputAction: TextInputAction.search,
                        animationDuration: const Duration(seconds: 2),
                        animationType: Animationtype.slide,
                        hintTextStyle: TextStyle(
                            letterSpacing: -1,
                            color: Colors.grey.shade700,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        controller: searchController,
                        focusNode: _focusNode,
                        onTapOutside: (val) {
                          _focusNode.unfocus();
                        },
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            EasyDebounce.debounce(
                              'search-theater',
                              const Duration(seconds: 1),
                              () {
                                ref
                                    .read(searchPlaceNotifierProvider.notifier)
                                    .setSearch(val);
                              },
                            );
                            // ref
                            //     .read(searchPlaceNotifierProvider.notifier)
                            //     .setSearch(val);
                            // ref
                            //     .read(searchControllerProvider.notifier)
                            //     .state
                            //     .text = val;
                            if (_overlayEntry == null) {
                              _showOverlay(
                                context,
                              );
                            }
                          } else {
                            _removeOverlay();
                          }
                        },
                        onSubmitted: (val) {
                          filter = {
                            'type': filters['type'],
                            'search_term': searchController.text.toString(),
                            'selected_category': filters['selected_category'],
                          };
                          _removeOverlay();
                          mapState.update(
                              selectedItinerary: -1,
                              categoryView: true,
                              itineraryView: false);
                          ref
                              .read(filtersProvider.notifier)
                              .updateFilter(filter);
                          ref
                              .read(itineraryNotifierProvider.notifier)
                              .filteredItinerary();
                        },
                        decoration: InputDecoration(
                            prefixIcon: Image.asset('assets/images/search.png'),
                            suffixIcon: searchController.text.isEmpty
                                ? const SizedBox.shrink()
                                : GestureDetector(
                                    onTap: () {
                                      searchController.clear();
                                      ref
                                          .read(searchPlaceNotifierProvider
                                              .notifier)
                                          .build();
                                      Map<String, dynamic> resetFilter = {
                                        'type': filters['type'],
                                        'selected_category':
                                            filters['selected_category'],
                                      };
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilter(resetFilter);
                                      // ref
                                      //     .read(itineraryNotifierProvider
                                      //         .notifier)
                                      //     .filteredItinerary();
                                      // mapState.update(
                                      //     selectedItinerary: -1,
                                      //     categoryView: true,
                                      //     itineraryView: false);
                                      ref.invalidate(mapViewStateProvider);
                                      ref.invalidate(itineraryNotifierProvider);
                                      // ref.invalidate(latlngProvider);
                                      _removeOverlay();
                                    },
                                    child: const Icon(Icons.clear))),
                        hintTexts: const [
                          'Search  for  "Restaurant"',
                          'Search  for  "Cafe"',
                          'Search  for  "Bars"',
                          'Search  for  "Theaters"',
                          'Search  for  "Attractions"',
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 20,
                          offset: const Offset(0, 2),
                        ),
                      ]),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(8),
                        ),
                        child: Image.asset('assets/images/filter.png'),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            isScrollControlled: true,
                            constraints: BoxConstraints.tightFor(
                              height: MediaQuery.sizeOf(context).height * 0.88,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return FilterSheet(
                                refresh: (String val) {
                                  widget.refresh("");
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}

@riverpod
class SearchPlaceNotifier extends _$SearchPlaceNotifier {
  @override
  FutureOr<List<SearchResult>> build() async {
    return [];
  }

  Future<void> setSearch(String search) async {
    try {
      state = const AsyncLoading();
      final data = await ref.watch(apiServiceProvider).getPlaceSearch(search);
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

@riverpod
class SearchCityAndState extends _$SearchCityAndState {
  @override
  FutureOr<List<SearchResult>> build() async {
    return [];
  }

  Future<void> searchCityAndState(String search) async {
    try {
      state = const AsyncLoading();
      final data = await ref.watch(apiServiceProvider).getCityAndStateSearch(search);
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
