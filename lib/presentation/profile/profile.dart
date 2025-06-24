import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:studymind/controllers/auth.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/colors.dart';
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

    return Scaffold(
      appBar: AppBar(leading: const SizedBox(), title: const Text('Profile'), actions: [NotificationButton()]),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 24),
              buildProfileHeader(colorPalette, textTheme),
              const SizedBox(height: 24),
              buildSettingsSection(
                title: 'Account Settings',
                items: getAccountSettings(),
                colorPalette: colorPalette,
                textTheme: textTheme,
              ),
              const SizedBox(height: 16),
              buildSettingsSection(
                title: 'App Settings',
                items: getAppSettings(),
                colorPalette: colorPalette,
                textTheme: textTheme,
              ),
              const SizedBox(height: 16),
              buildSettingsSection(
                title: 'Support',
                items: getSupportSettings(),
                colorPalette: colorPalette,
                textTheme: textTheme,
              ),
              const SizedBox(height: 24),
              buildLogoutButton(colorPalette, textTheme),
              const SizedBox(height: 16),
              buildAppVersion(textTheme),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileHeader(ColorPalette colorPalette, TextTheme textTheme) {
    return Column(
      children: [
        Obx(() {
          final imageUrl = authController.user.value?.photo ?? "";
          return Stack(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: colorPalette.content,
                  child: CircleAvatar(radius: 48, backgroundImage: NetworkImage(imageUrl)),
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 16),
        Obx(
          () => Text(
            authController.user.value?.name ?? "User Name",
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        Obx(
          () => Text(
            authController.user.value?.email ?? "user@email.com",
            style: textTheme.bodyMedium?.copyWith(color: colorPalette.contentDim),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final createdAt = authController.user.value?.createdAt;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorPalette.primary.withAlpha(50),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Member since ${createdAt != null ? DateFormat('MMM yyyy').format(createdAt) : "Apr 2024"}',
              style: textTheme.bodySmall?.copyWith(color: colorPalette.primary, fontWeight: FontWeight.w500),
            ),
          );
        }),
      ],
    );
  }

  Widget buildSettingsSection({
    required String title,
    required List<Map<String, dynamic>> items,
    required ColorPalette colorPalette,
    required TextTheme textTheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: textTheme.headlineMedium),
        ),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: item['color']?.withAlpha(50) ?? colorPalette.primary.withAlpha(50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item['icon'], color: item['color'] ?? colorPalette.primary, size: 20),
                ),
                title: Text(item['title'], style: textTheme.titleMedium),
                trailing: item['toggle']
                    ? Switch(value: item['value'], onChanged: item['onChanged'])
                    : Icon(HugeIcons.strokeRoundedArrowRight01, size: 20, color: colorPalette.content),
                onTap: item['onTap'],
              );
            },
            separatorBuilder: (_, _) => Divider(),
          ),
        ),
      ],
    );
  }

  Widget buildLogoutButton(ColorPalette colorPalette, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorPalette.error.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorPalette.error.withAlpha(50), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: colorPalette.error.withAlpha(50), borderRadius: BorderRadius.circular(8)),
          child: Icon(HugeIcons.strokeRoundedLogout01, color: colorPalette.error, size: 20),
        ),
        title: Text("Logout", style: textTheme.titleMedium?.copyWith(color: colorPalette.error)),
        trailing: Icon(HugeIcons.strokeRoundedArrowRight01, color: colorPalette.error, size: 20),
        onTap: () => Get.dialog(
          ConfirmDialog(message: 'Are you sure you want to logout?', onConfirm: () => authController.logout()),
        ),
      ),
    );
  }

  Widget buildAppVersion(TextTheme textTheme) {
    return Column(
      children: [
        Text('StudyMind', style: textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text('Version 1.0.0', style: textTheme.bodySmall),
      ],
    );
  }

  List<Map<String, dynamic>> getAccountSettings() {
    return [
      {
        'icon': HugeIcons.strokeRoundedUser,
        'title': 'Edit Profile',
        'toggle': false,
        'color': Colors.blue,
        'onTap': () => Notification.info('Edit profile screen coming soon'),
      },
      {
        'icon': HugeIcons.strokeRoundedNotification03,
        'title': 'Notifications',
        'toggle': true,
        'color': Colors.orange,
        'value': isNotificationsEnabled,
        'onChanged': (bool value) => setState(() => isNotificationsEnabled = value),
      },
    ];
  }

  List<Map<String, dynamic>> getAppSettings() {
    return [
      {
        'icon': HugeIcons.strokeRoundedMoon02,
        'title': 'Dark Mode',
        'toggle': true,
        'color': Colors.indigo,
        'value': Get.isDarkMode,
        'onChanged': (bool value) =>
            setState(() => Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark)),
      },
      {
        'icon': HugeIcons.strokeRoundedDelete02,
        'title': 'Removed Items',
        'toggle': false,
        'color': Colors.red,
        'onTap': () => Get.toNamed(AppRoutes.removedItem),
      },
      {
        'icon': HugeIcons.strokeRoundedMessage02,
        'title': 'Removed Chats',
        'toggle': false,
        'color': Colors.purple,
        'onTap': () => Get.toNamed(AppRoutes.removedChat),
      },
    ];
  }

  List<Map<String, dynamic>> getSupportSettings() {
    return [
      {
        'icon': HugeIcons.strokeRoundedHelpCircle,
        'title': 'Help & FAQ',
        'toggle': false,
        'color': Colors.green,
        'onTap': () => Notification.info('Help & FAQ screen coming soon'),
      },
    ];
  }
}
