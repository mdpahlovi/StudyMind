import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:studymind/controllers/auth.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/dialog/confirm.dart';
import 'package:studymind/widgets/notification_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController = Get.find<AuthController>();

  bool isNotificationsEnabled = true;
  bool isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    List<Map<String, dynamic>> account = [
      {
        'icon': HugeIcons.strokeRoundedUser,
        'title': 'Edit Profile',
        'toggle': false,
        'onTap': () => Get.toNamed(AppRoutes.editProfile),
      },
      {
        'icon': HugeIcons.strokeRoundedNotification03,
        'title': 'Notifications',
        'toggle': true,
        'value': isNotificationsEnabled,
        'onChanged': (bool value) => setState(() => isNotificationsEnabled = value),
      },
      {
        'icon': HugeIcons.strokeRoundedMoon02,
        'title': 'Dark Mode',
        'toggle': true,
        'value': Get.isDarkMode,
        'onChanged': (bool value) =>
            setState(() => Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark)),
      },
      {
        'icon': HugeIcons.strokeRoundedDelete02,
        'title': 'Removed Items',
        'toggle': false,
        'onTap': () => Get.toNamed(AppRoutes.removedItem),
      },
      {
        'icon': HugeIcons.strokeRoundedDelete02,
        'title': 'Removed Chats',
        'toggle': false,
        'onTap': () => Get.toNamed(AppRoutes.removedChat),
      },
      {
        'icon': HugeIcons.strokeRoundedHelpCircle,
        'title': 'Help & FAQ',
        'toggle': false,
        'onTap': () => Get.toNamed(AppRoutes.faq),
      },
    ];

    return Scaffold(
      appBar: AppBar(leading: const SizedBox(), title: const Text('Profile'), actions: [NotificationButton()]),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Obx(() {
                final imageUrl = authController.user.value?.photo ?? "";
                return Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: colorPalette.content,
                    child: CircleAvatar(
                      radius: 46,
                      backgroundImage: NetworkImage(imageUrl),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Obx(
                () => Text(
                  authController.user.value?.name ?? "",
                  style: textTheme.headlineMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Obx(
                () => Text(
                  authController.user.value?.email ?? "",
                  style: textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Obx(() {
                final createdAt = authController.user.value?.createdAt;
                return Text(
                  'Joined ${createdAt != null ? DateFormat('MMM dd, yyyy').format(createdAt) : ""}',
                  style: textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              }),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: account.length,
                    itemBuilder: (context, index) {
                      final item = account[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(item['icon'], size: 20),
                          title: Text(item['title'], style: textTheme.titleMedium),
                          trailing: item['toggle']
                              ? Switch(value: item['value'], onChanged: item['onChanged'])
                              : CustomIcon(icon: 'arrowRight'),
                          onTap: item['onTap'],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: colorPalette.error.withAlpha(25),
                leading: Icon(HugeIcons.strokeRoundedLogout01, size: 20, color: colorPalette.error),
                title: Text("Logout", style: textTheme.titleMedium?.copyWith(color: colorPalette.error)),
                trailing: CustomIcon(icon: 'arrowRight', color: colorPalette.error),
                onTap: () => Get.dialog(
                  ConfirmDialog(
                    message: 'You want to logout? If yes,\nPlease press confirm.',
                    onConfirm: () => authController.logout(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(child: Text('Version 1.0.0', style: textTheme.bodySmall)),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
