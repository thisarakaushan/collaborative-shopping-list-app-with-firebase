// Packages
import 'package:get/get.dart';

// Pages
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/auth/forgot_password_page.dart';
import '../../presentation/pages/auth/verify_email_page.dart';
import '../../presentation/pages/dashboard/dashboard_page.dart';
// import '../../presentation/pages/shopping_list/create_list_page.dart';
// import '../../presentation/pages/shopping_list/join_list_page.dart';
// import '../../presentation/pages/shopping_list/list_detail_page.dart';

// import '../../presentation/controllers/dashboard_controller.dart';
// import '../../presentation/controllers/shopping_list_controller.dart';

// Controllers
import '../../presentation/controllers/auth_controller.dart';

// Routes
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.SPLASH, page: () => const SplashPage()),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const RegisterPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.VERIFY_EMAIL,
      page: () => const VerifyEmailPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardPage(),
      // binding: BindingsBuilder(() {
      //   Get.lazyPut(() => DashboardController());
      // }),
    ),
    // GetPage(
    //   name: AppRoutes.CREATE_LIST,
    //   page: () => const CreateListPage(),
    //   binding: BindingsBuilder(() {
    //     Get.lazyPut(() => ShoppingListController());
    //   }),
    // ),
    // GetPage(
    //   name: AppRoutes.JOIN_LIST,
    //   page: () => const JoinListPage(),
    //   binding: BindingsBuilder(() {
    //     Get.lazyPut(() => ShoppingListController());
    //   }),
    // ),
    // GetPage(
    //   name: AppRoutes.LIST_DETAIL,
    //   page: () => const ListDetailPage(),
    //   binding: BindingsBuilder(() {
    //     Get.lazyPut(() => ShoppingListController());
    //   }),
    // ),
  ];
}
