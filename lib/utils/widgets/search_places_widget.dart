import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view/navigation/explore/search_filter/search_and_filter_widget.dart';
import 'async_widget.dart';

class SearchPlacesWidget extends ConsumerStatefulWidget {
  const SearchPlacesWidget(
      {super.key,
      required this.searchController,
      required this.validator,
      this.onSaved,
      this.onTap,
      this.hintText,
        this.initialValue,
      this.isEnabled = false});

  final bool? isEnabled;
  final String? Function(String?)? validator;
  final TextEditingController searchController;
  final Function(String?)? onSaved;
  final String? hintText;
  final Function(String?)? onTap;
  final String? initialValue;

  @override
  ConsumerState<SearchPlacesWidget> createState() => _SearchPlacesWidgetState();
}

class _SearchPlacesWidgetState extends ConsumerState<SearchPlacesWidget> {
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();
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
      return OverlayEntry(
          builder: (context) => Positioned(
              left: offset.dx + 20,
              top: size.height + offset.dy,
              child: CompositedTransformFollower(
                showWhenUnlinked: false,
                link: _layerLink,
                offset: Offset(0.0, size.height + 5.0),
                child: Material(
                  elevation: 5,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  child: SizedBox(
                    width: size.width,
                    child: AsyncDataWidgetB(
                        dataProvider: searchCityAndStateProvider,
                        dataBuilder: (data) {
                          return ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    widget.onTap!(data[index].placeId);
                                    widget.searchController.text =
                                        data[index].description!;
                                    _removeOverlay();
                                  },
                                  title: Text(
                                    data[index].description ?? "",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemCount: data.length);
                        },
                        errorBuilder: (e, st) {
                          return Text("Error: $e");
                        }),
                  ),
                ),
              )));
    }
    return null;
  }
  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      widget.searchController.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchData = ref.read(searchCityAndStateProvider.notifier);
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        children: [
          TextFormField(
            // initialValue: widget.initialValue,
            readOnly: widget.isEnabled ?? false,
            validator: widget.validator,
            textInputAction: TextInputAction.search,
            controller: widget.searchController,
            focusNode: _focusNode,
            onTapOutside: (val) {
              _focusNode.unfocus();
              // _removeOverlay();
            },
            onChanged: (val) {
              if (val.isNotEmpty) {
                setState(() {
                  EasyDebounce.debounce(
                    'search-theater',
                    const Duration(seconds: 1),
                    () {
                      searchData.searchCityAndState(val);
                    },
                  );
                });

                if (_overlayEntry == null) {
                  _showOverlay(
                    context,
                  );
                }
              } else {
                _removeOverlay();
              }
            },
            onSaved: (val) {
              widget.onSaved!(val);
            },
            decoration: InputDecoration(
                hintText: widget.hintText,
                prefixIcon: const Icon(
                  Icons.location_pin,
                  color: Colors.grey,
                ),
                suffixIcon: widget.searchController.text.trim().isNotEmpty &&
                        widget.isEnabled == false
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.searchController.clear();
                            _removeOverlay();
                          });
                        },
                        child: const Icon(
                          Icons.clear,
                          color: Colors.grey,
                        ))
                    : const Icon(
                        Icons.search,
                        color: Colors.grey,
                      )),
          ),
          // const SizedBox(
          //   height: 10,
          // ),
        ],
      ),
    );
  }
}
