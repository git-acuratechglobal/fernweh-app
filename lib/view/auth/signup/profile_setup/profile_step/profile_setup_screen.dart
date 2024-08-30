import 'package:fernweh/utils/common/app_button.dart';
import 'package:fernweh/utils/common/extensions.dart';
import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:fernweh/view/auth/auth_provider/auth_provider.dart';
import 'package:fernweh/view/auth/signup/profile_setup/profile_step/model/intrestedin_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../utils/common/config.dart';
import '../../../../../utils/widgets/async_widget.dart';
import '../../../auth_state/auth_state.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  int _currentPage = 0;
  List<int> categoryFirst = [];
  List<int> categorySecond = [];
  List<int> category = [];
  final PageController _pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: Config.backgroundGradient),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.paddingOf(context).top + 8),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                // if (_currentPage == 0) {
                                Navigator.of(context).pop();
                                // } else {
                                //   _pageController.previousPage(
                                //       duration:
                                //           const Duration(milliseconds: 250),
                                //       curve: Curves.easeInOut);
                                // }
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                            const SizedBox(width: 4.0),
                            const Text(
                              'Back',
                              style: TextStyle(
                                color: Color(0xFF494D60),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Expanded(
                    //   flex: 5,
                    //   child: Text.rich(
                    //     TextSpan(
                    //       children: [
                    //         const TextSpan(
                    //           text: 'Step',
                    //           style: TextStyle(
                    //             color: Color(0xFF494D60),
                    //           ),
                    //         ),
                    //         const TextSpan(
                    //           text: ' ',
                    //           style: TextStyle(
                    //             color: Color(0xFF1A1B28),
                    //           ),
                    //         ),
                    //         TextSpan(
                    //           text: '1 of 2',
                    //           style: TextStyle(
                    //             color: const Color(0xFF1A1B28),
                    //             fontVariations: FVariations.w700,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     textAlign: TextAlign.left,
                    //   ),
                    // ),
                  ],
                ),
                // StepperWidget(currentPage: _currentPage),
              ],
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                children: [
                  AsyncDataWidget(
                    dataProvider: categoriesProvider,
                    dataBuilder: (BuildContext context, data) {
                      return SelectCategory(
                        options: data,
                        onTap: (index) {
                          if (category.contains(data[index].id)) {
                            category.remove(data[index].id);
                          } else {
                            category.add(data[index].id!);
                            ref
                                .read(authNotifierProvider.notifier)
                                .updateFormData(
                                    "categories_id", category.join(','));
                          }
                          setState(() {
                            categoryFirst.toggle(index);
                          });
                        },
                        isSelected: (index) => categoryFirst.contains(index),
                      );
                    },
                    loadingBuilder: Skeletonizer(
                      child: SelectCategory(
                        onTap: (int index) {},
                        isSelected: (int index) => false,
                        options: IntrestedInCategory.dummyCategory,
                      ),
                    ),
                    errorBuilder: (error, stack) => Center(
                      child: Text(error.toString()),
                    ),
                  ),
                  // SelectCategory(
                  //   options: Config.categoriesOption,
                  //   onTap: (index) {
                  //     setState(() {
                  //       categorySecond.toggle(index);
                  //     });
                  //   },
                  //   isSelected: (index) => categorySecond.contains(index),
                  // ),
                ],
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: AppButton(
                  isLoading: authState is Loading,
                  onTap: () {
                    ref.read(authNotifierProvider.notifier).updateUser();
                  },
                  child: const Text("Continue"),
                )

                // ElevatedButton(
                //   onPressed: () {
                //     // if (_currentPage == 1) {
                //
                //     // } else {
                //     //   _pageController.nextPage(
                //     //       duration: const Duration(milliseconds: 250),
                //     //       curve: Curves.easeInOut);
                //     // }
                //   },
                //   child: ,
                // ),
                )
          ],
        ),
      ),
    );
  }
}

class SelectCategory extends StatelessWidget {
  final Function(int index) onTap;
  final bool Function(int index) isSelected;
  final List<IntrestedInCategory> options;

  const SelectCategory({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'What are you looking for?',
            style: TextStyle(
              color: const Color(0xFF1A1B28),
              fontSize: 24,
              fontVariations: FVariations.w700,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Choose category you like more',
            style: TextStyle(
              color: Color(0xFF494D60),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: options.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final category = options[index];
                return InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            border: isSelected(index)
                                ? Border.all(
                                    width: 3,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  )
                                : null,
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: ImageWidget(url: 'http://fernweh.acublock.in/public/${category.image}',)),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Image.asset(
                                  isSelected(index)
                                      ? 'assets/images/selected.png'
                                      : 'assets/images/unselected.png',
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        category.name ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF1A1B28),
                          fontSize: 16,
                          fontVariations: FVariations.w700,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
