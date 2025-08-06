// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Controllers
import '../../controllers/dashboard_controller.dart';
import '../../controllers/auth_controller.dart';

// Widgets
import '../../widgets/custom_button.dart';

// Models
import '../../../data/models/shopping_list_model.dart';

// Constants
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.dashboardTitle),
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 1,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                controller.logout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(Icons.logout, size: AppDimensions.iconSizeMedium),
                    SizedBox(width: AppDimensions.paddingSmall),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Obx(
                () => Text(
                  authController.currentUser.value?.displayName
                          .substring(0, 1)
                          .toUpperCase() ??
                      'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMedium),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            color: AppColors.cardBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    'Welcome back, ${authController.currentUser.value?.displayName ?? 'User'}!',
                    style: TextStyle(
                      fontSize: AppDimensions.textSizeTitle,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                Text(
                  AppStrings.welcomeMessage,
                  style: TextStyle(
                    fontSize: AppDimensions.textSizeSubtitle,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: AppStrings.createList,
                    onPressed: controller.goToCreateList,
                    backgroundColor: AppColors.primary,
                    height: AppDimensions.buttonHeight,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingSmall),
                Expanded(
                  child: CustomButton(
                    text: AppStrings.joinList,
                    onPressed: controller.goToJoinList,
                    backgroundColor: AppColors.secondary,
                    height: AppDimensions.buttonHeight,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ShoppingListModel>>(
              stream: controller.shoppingListRepository.getUserShoppingLists(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: AppColors.error),
                    ),
                  );
                }
                final shoppingLists = snapshot.data ?? [];
                if (shoppingLists.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: AppDimensions.iconSizeLarge,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: AppDimensions.paddingMedium),
                        Text(
                          AppStrings.noListsMessage,
                          style: TextStyle(
                            fontSize: AppDimensions.textSizeTitle,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingSmall),
                        Text(
                          AppStrings.createFirstList,
                          style: TextStyle(
                            fontSize: AppDimensions.textSizeSubtitle,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMedium,
                  ),
                  itemCount: shoppingLists.length,
                  itemBuilder: (context, index) {
                    final shoppingList = shoppingLists[index];
                    final isOwner =
                        shoppingList.ownerId ==
                        authController.currentUser.value?.uid;
                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: AppDimensions.paddingMedium,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.cardBorderRadius,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => controller.goToListDetail(shoppingList),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.cardBorderRadius,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            AppDimensions.paddingMedium,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          shoppingList.title,
                                          style: TextStyle(
                                            fontSize:
                                                AppDimensions.textSizeSubtitle,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        if (shoppingList.description.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: AppDimensions.paddingSmall,
                                            ),
                                            child: Text(
                                              shoppingList.description,
                                              style: TextStyle(
                                                fontSize:
                                                    AppDimensions.textSizeBody,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'leave') {
                                        controller.leaveList(shoppingList);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'leave',
                                        child: Row(
                                          children: [
                                            Icon(
                                              isOwner
                                                  ? Icons.delete
                                                  : Icons.exit_to_app,
                                              size:
                                                  AppDimensions.iconSizeMedium,
                                              color: AppColors.error,
                                            ),
                                            const SizedBox(
                                              width: AppDimensions.paddingSmall,
                                            ),
                                            Text(
                                              isOwner ? 'Delete' : 'Leave',
                                              style: TextStyle(
                                                color: AppColors.error,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: AppDimensions.paddingMedium,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.people,
                                    size: AppDimensions.iconSizeMedium,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(
                                    width: AppDimensions.paddingSmall,
                                  ),
                                  Text(
                                    '${shoppingList.memberIds.length} members',
                                    style: TextStyle(
                                      fontSize: AppDimensions.textSizeBody,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: AppDimensions.paddingMedium,
                                  ),
                                  Icon(
                                    Icons.access_time,
                                    size: AppDimensions.iconSizeMedium,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(
                                    width: AppDimensions.paddingSmall,
                                  ),
                                  Text(
                                    DateFormat(
                                      'MMM dd, yyyy',
                                    ).format(shoppingList.updatedAt),
                                    style: TextStyle(
                                      fontSize: AppDimensions.textSizeBody,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              if (isOwner)
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: AppDimensions.paddingSmall,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppDimensions.paddingSmall,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Owner',
                                    style: TextStyle(
                                      fontSize: AppDimensions.textSizeBody - 2,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
