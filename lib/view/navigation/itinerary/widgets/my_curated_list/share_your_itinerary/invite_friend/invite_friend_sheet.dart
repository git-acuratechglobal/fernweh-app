import 'package:fernweh/utils/common/app_button.dart';
import 'package:fernweh/utils/common/app_validation.dart';
import 'package:fernweh/utils/common/common.dart';
import 'package:fernweh/utils/common/config.dart';
import 'package:fernweh/view/navigation/itinerary/widgets/my_curated_list/share_your_itinerary/invite_friend/notifier/invite_friend_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../utils/common/app_mixin.dart';
import '../../../../../../../utils/common/extensions.dart';

class InviteFriendSheet extends ConsumerStatefulWidget {
  const InviteFriendSheet({super.key});

  @override
  ConsumerState<InviteFriendSheet> createState() => _InviteFriendSheetState();
}

class _InviteFriendSheetState extends ConsumerState<InviteFriendSheet>with FormUtilsMixin {
  final emailController = TextEditingController();
   @override
  void initState() {
   ref.listenManual(inviteFriendNotifierProvider, (_,next){
     switch(next){
       case AsyncData<String?> data when data.value !=null:
         Navigator.pop(context,true);
         Common.showSnackBar(context, data.value.toString());
       case AsyncError error:
         Common.showSnackBar(context, error.error.toString());
     }
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inviteFriendNotifierProvider);
    final validator = ref.watch(validatorsProvider);
    return Form(
      key: fkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
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
                  'Invite Friend',
                  style: TextStyle(
                    color: const Color(0xFF1A1B28),
                    fontSize: 20,
                    fontVariations: FVariations.w700,
                  ),
                ),
                const SizedBox.square(dimension: 40)
              ],
            ),
          ),
          Container(
            height: 200,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(gradient: Config.backgroundGradient),
            child: SizedBox(
              width: 220,
              height: 200,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/images/share_illustration.png'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 24.0, right: 24.0, top: 24, bottom: 16),
            child: TextFormField(
              validator: (val)=>validator.validateEmail(val),
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email or Phone Number',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: TextButton(
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/link.png',
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    "Copy Link",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                      fontVariations: FVariations.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(24.0),
              child: AppButton(
                isLoading: state is AsyncLoading,
                onTap: () {
                  if(validateAndSave()){
                    ref
                        .read(inviteFriendNotifierProvider.notifier)
                        .inviteFriend(emailController.text.toString());
                  }

                },
                child: const Text("Send Invite"),
              )),
        ],
      ),
    );
  }
}
