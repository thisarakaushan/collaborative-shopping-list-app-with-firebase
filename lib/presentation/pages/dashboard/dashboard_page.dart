// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Controllers
import '../../controllers/dashboard_controller.dart';
import '../../controllers/auth_controller.dart';

// Widgets
import '../../widgets/custom_button.dart';
import '../../widgets/loading_widget.dart';

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
        title: Text(
          AppStrings.dashboardTitle,
          style: TextStyle(
            fontSize: AppDimensions.textSizeTitle,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 2,
        shadowColor: AppColors.textSecondary.withOpacity(0.2),
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
                  children: [
                    Icon(
                      Icons.logout,
                      size: AppDimensions.iconSizeMedium,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: AppDimensions.paddingSmall),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeBody,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.only(
                right: AppDimensions.paddingMedium,
              ),
              child: AnimatedScale(
                scale: 1.0,
                duration: const Duration(milliseconds: 300),
                child: CircleAvatar(
                  backgroundColor: AppColors.accent,
                  radius: 20,
                  child: Obx(
                    () => Text(
                      authController.currentUser.value?.displayName
                              .substring(0, 1)
                              .toUpperCase() ??
                          'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimensions.textSizeSubtitle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(AppDimensions.paddingMedium),
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.accent.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(
                AppDimensions.cardBorderRadius,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textSecondary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Obx(
                    () => Text(
                      'Welcome back, ${authController.currentUser.value?.displayName ?? 'User'}!',
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeTitle,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                Text(
                  AppStrings.welcomeMessage,
                  style: TextStyle(
                    fontSize: AppDimensions.textSizeSubtitle,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
            ),
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(
                AppDimensions.cardBorderRadius,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textSecondary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 400),
                    child: CustomButton(
                      text: AppStrings.createList,
                      onPressed: controller.goToCreateList,
                      backgroundColor: AppColors.primary,
                      textColor: Colors.white,
                      height: AppDimensions.buttonHeight,
                      borderRadius: AppDimensions.cardBorderRadius,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingSmall),
                Expanded(
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 400),
                    child: CustomButton(
                      text: AppStrings.joinList,
                      onPressed: controller.goToJoinList,
                      backgroundColor: AppColors.secondary,
                      textColor: Colors.white,
                      height: AppDimensions.buttonHeight,
                      borderRadius: AppDimensions.cardBorderRadius,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                controller.refreshLists();
              },
              color: AppColors.primary,
              child: StreamBuilder<List<ShoppingListModel>>(
                stream: controller.shoppingListRepository
                    .getUserShoppingLists(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingWidget(
                      message: 'Loading lists...',
                      size: AppDimensions.iconSizeLarge,
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: AppDimensions.iconSizeLarge,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: AppDimensions.paddingMedium),
                          Text(
                            'Error loading lists: ${snapshot.error}',
                            style: TextStyle(
                              fontSize: AppDimensions.textSizeSubtitle,
                              color: AppColors.error,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppDimensions.paddingMedium),
                          CustomButton(
                            text: 'Retry',
                            onPressed: () => controller.refreshLists(),
                            backgroundColor: AppColors.primary,
                            textColor: Colors.white,
                            height: AppDimensions.buttonHeight,
                            borderRadius: AppDimensions.cardBorderRadius,
                          ),
                        ],
                      ),
                    );
                  }
                  final shoppingLists = snapshot.data ?? [];
                  if (shoppingLists.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: 1.0,
                            duration: const Duration(milliseconds: 500),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              size: AppDimensions.iconSizeLarge,
                              color: AppColors.textSecondary,
                            ),
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
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.paddingMedium),
                          CustomButton(
                            text: 'Create a List',
                            icon: Icons.add,
                            onPressed: controller.goToCreateList,
                            backgroundColor: AppColors.primary,
                            textColor: Colors.white,
                            height: AppDimensions.buttonHeight,
                            borderRadius: AppDimensions.cardBorderRadius,
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingMedium,
                      vertical: AppDimensions.paddingMedium,
                    ),
                    itemCount: shoppingLists.length,
                    itemBuilder: (context, index) {
                      final shoppingList = shoppingLists[index];
                      final isOwner =
                          shoppingList.ownerId ==
                          authController.currentUser.value?.uid;
                      return AnimatedOpacity(
                        opacity: 1.0,
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        child: Card(
                          margin: const EdgeInsets.only(
                            bottom: AppDimensions.paddingMedium,
                          ),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.cardBorderRadius,
                            ),
                          ),
                          child: InkWell(
                            onTap: () =>
                                controller.goToListDetail(shoppingList),
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
                                                fontSize: AppDimensions
                                                    .textSizeSubtitle,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            if (shoppingList
                                                .description
                                                .isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: AppDimensions
                                                      .paddingSmall,
                                                ),
                                                child: Text(
                                                  shoppingList.description,
                                                  style: TextStyle(
                                                    fontSize: AppDimensions
                                                        .textSizeBody,
                                                    color:
                                                        AppColors.textSecondary,
                                                    height: 1.3,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                  size: AppDimensions
                                                      .iconSizeMedium,
                                                  color: AppColors.error,
                                                ),
                                                const SizedBox(
                                                  width: AppDimensions
                                                      .paddingSmall,
                                                ),
                                                Text(
                                                  isOwner ? 'Delete' : 'Leave',
                                                  style: TextStyle(
                                                    fontSize: AppDimensions
                                                        .textSizeBody,
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.cardBorderRadius / 2,
                                          ),
                                        ),
                                        color: AppColors.cardBackground,
                                        elevation: 4,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: AppDimensions.paddingMedium,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              AppDimensions.paddingSmall,
                                          vertical:
                                              AppDimensions.paddingSmall / 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(
                                            0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.cardBorderRadius / 2,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.people,
                                              size:
                                                  AppDimensions.iconSizeMedium,
                                              color: AppColors.primary,
                                            ),
                                            const SizedBox(
                                              width:
                                                  AppDimensions.paddingSmall /
                                                  2,
                                            ),
                                            Text(
                                              '${shoppingList.memberIds.length} members',
                                              style: TextStyle(
                                                fontSize:
                                                    AppDimensions.textSizeBody,
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: AppDimensions.paddingMedium,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              AppDimensions.paddingSmall,
                                          vertical:
                                              AppDimensions.paddingSmall / 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondary
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.cardBorderRadius / 2,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size:
                                                  AppDimensions.iconSizeMedium,
                                              color: AppColors.secondary,
                                            ),
                                            const SizedBox(
                                              width:
                                                  AppDimensions.paddingSmall /
                                                  2,
                                            ),
                                            Text(
                                              DateFormat(
                                                'MMM dd, yyyy',
                                              ).format(shoppingList.updatedAt),
                                              style: TextStyle(
                                                fontSize:
                                                    AppDimensions.textSizeBody,
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
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
                                        vertical:
                                            AppDimensions.paddingSmall / 2,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primary.withOpacity(0.2),
                                            AppColors.accent.withOpacity(0.2),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.cardBorderRadius / 2,
                                        ),
                                      ),
                                      child: Text(
                                        'Owner',
                                        style: TextStyle(
                                          fontSize:
                                              AppDimensions.textSizeBody - 2,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
