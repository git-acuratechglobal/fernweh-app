import 'package:fernweh/utils/common/config.dart';
import 'package:fernweh/view/navigation/map/notifier/category_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/common/extensions.dart';

class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({
    super.key,
    required this.refresh,
  });

  final Function(String val) refresh;

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        filtersData = ref.watch(filtersProvider);
        _sliderValue = filtersData['selected_radius'] ?? 0.0;
      });
    });
  }

  String? _rating;
  String? _sortBy;
  double _sliderValue = 0.0;
  Map<String, dynamic> filtersData = {
    'type': "restaurant|bakery|meal_delivery|meal_takeaway",
    'rating': null,
    'radius': null,
    'sort_by': null,
    'selected_category': "Restaurant",
  };

  double milesToMeters(double miles) {
    const double milesToMetersConversionFactor = 1609.344;
    return miles * milesToMetersConversionFactor;
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(filtersProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.clear),
              ),
              Text(
                'Filters',
                style: TextStyle(
                  color: const Color(0xFF1A1B28),
                  fontSize: 20,
                  fontVariations: FVariations.w700,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref.invalidate(filtersProvider);
                  widget.refresh("sunil");
                  Navigator.pop(
                    context,
                  );
                },
                child: Text(
                  'Clear',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 18,
                    fontVariations: FVariations.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 0),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 5.0, // Space between chips
                  runSpacing: 3.0, // Space between rows
                  children: Config.dashboardCategories.map((data) {
                    final isSelected =
                        filtersData['selected_category'] == data.title;

                    return RawChip(
                      showCheckmark: false,
                      side: BorderSide(
                          color: isSelected
                              ? Theme.of(context).colorScheme.secondary
                              : const Color(0xffE2E2E2)),
                      label: Text(data.title),
                      selected: isSelected,
                      selectedColor: const Color(0xffFFE9E9),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.black,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          filtersData['type'] = data.type;
                          filtersData['selected_category'] = data.title;
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),
                const Divider(height: 0),
                const SizedBox(height: 24),
                OptionListWidget(
                  label: 'Rating',
                  spacing: 8,
                  options: List.generate(
                      6, (index) => index == 0 ? "All" : "$index"),
                  isSelected: (value) => value == filtersData['rating'],
                  onTap: (value) {
                    setState(() {
                      filtersData['rating'] = value == "All" ? null : value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                const Divider(height: 0),
                const SizedBox(height: 24),
                const Text(
                  'Distance',
                  style: TextStyle(
                    color: Color(0xFF494D60),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 12),
                Slider(
                  value: _sliderValue,
                  min: 0.0,
                  max: 10.0,
                  activeColor: Theme.of(context).colorScheme.tertiary,
                  inactiveColor: const Color(0xffE2E2E2),
                  thumbColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                      filtersData['selected_radius'] = value;
                      filtersData['radius'] = milesToMeters(value);
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '0 mi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF494D60),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "${_sliderValue.floor()} mi",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF494D60),
                          fontSize: 12,
                        ),
                      ),
                      const Text(
                        '10 mi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF494D60),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 34),
                const Divider(height: 0),
                const SizedBox(height: 24),
                OptionListWidget(
                  label: "Sort by",
                  isSelected: (value) => value == _sortBy,
                  options: Config.sortBy,
                  onTap: (value) {
                    setState(() {
                      _sortBy = value;
                      filtersData['sort_by'] = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(filtersProvider.notifier)
                        .updateFilter(filtersData);
                     ref.read(itineraryNotifierProvider.notifier).filteredItinerary();
                    widget.refresh("sunil");
                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text("Continue"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OptionListWidget extends StatelessWidget {
  final String label;
  final List<String> options;
  final Function(String v) onTap;
  final bool Function(String v) isSelected;
  final double spacing;

  const OptionListWidget({
    super.key,
    required this.label,
    required this.onTap,
    required this.isSelected,
    required this.options,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF494D60),
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: spacing,
          children: options.map((e) {
            return RawChip(
              onPressed: () => onTap(e),
              backgroundColor:
                  isSelected(e) ? const Color(0xffFFE9E9) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                    color: isSelected(e)
                        ? Theme.of(context).colorScheme.secondary
                        : const Color(0xffE2E2E2)),
              ),
              label: Text(
                e,
                style: TextStyle(
                  fontVariations: FVariations.w500,
                  color: isSelected(e)
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.black,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
