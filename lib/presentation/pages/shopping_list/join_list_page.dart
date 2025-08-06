// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers
import '../../controllers/shopping_list_controller.dart';

// Widegts
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class JoinListPage extends GetView<ShoppingListController> {
  const JoinListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ShoppingListController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Join Shopping List'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: controller.joinListFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.group_add, size: 80, color: Colors.green),
                  const SizedBox(height: 24),
                  const Text(
                    'Join Existing List',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter the invite code shared with you',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 48),

                  // Invite Code Field
                  CustomTextField(
                    controller: controller.inviteCodeController,
                    hintText: 'Invite Code (6 characters)',
                    prefixIcon: Icons.vpn_key,
                    validator: (value) => controller.validateInviteCode(value),
                    onChanged: (value) {
                      controller.inviteCodeController.text = value
                          .toUpperCase();
                      controller
                          .inviteCodeController
                          .selection = TextSelection.fromPosition(
                        TextPosition(
                          offset: controller.inviteCodeController.text.length,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Join Button
                  Obx(
                    () => CustomButton(
                      text: 'Join List',
                      isLoading: controller.isLoading.value,
                      onPressed: controller.joinShoppingList,
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
