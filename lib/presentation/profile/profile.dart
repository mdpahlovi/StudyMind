import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:studymind/controllers/auth.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/custom_image.dart';
import 'package:studymind/widgets/dialog/confirm.dart';
import 'package:studymind/widgets/notification_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    List<Map<String, dynamic>> account = [
      {'icon': HugeIcons.strokeRoundedUser, 'title': 'Edit Profile', 'toggle': false, 'onTap': () {}},
      {'icon': HugeIcons.strokeRoundedNotification03, 'title': 'Notifications', 'toggle': true, 'onTap': () {}},
      {'icon': HugeIcons.strokeRoundedMoon02, 'title': 'Dark Mode', 'toggle': true, 'onTap': () {}},
    ];
    List<Map<String, dynamic>> study = [
      {'icon': HugeIcons.strokeRoundedCalendar03, 'title': 'Study Schedule', 'onTap': () {}},
      {'icon': HugeIcons.strokeRoundedTarget03, 'title': 'Learning Goals', 'onTap': () {}},
      {'icon': HugeIcons.strokeRoundedDownload01, 'title': 'Offline Content', 'onTap': () {}},
    ];
    List<Map<String, dynamic>> support = [
      {'icon': HugeIcons.strokeRoundedCustomerSupport, 'title': 'Help Center', 'onTap': () {}},
      {'icon': HugeIcons.strokeRoundedSecurityCheck, 'title': 'Privacy Policy', 'onTap': () {}},
      {'icon': HugeIcons.strokeRoundedSettings02, 'title': 'App Settings', 'onTap': () {}},
    ];

    return Scaffold(
      appBar: AppBar(leading: SizedBox(), title: Text('Profile'), actions: [NotificationButton()]),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Profile Section
              Obx(() {
                final imageUrl = authController.user.value?.photo ?? "";
                return Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: colorPalette.content),
                    ),
                    child: ClipOval(child: CustomImage(imageUrl: imageUrl, fit: BoxFit.cover)),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Obx(
                () => Text(
                  authController.user.value?.name ?? "",
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Obx(
                () => Text(
                  authController.user.value?.email ?? "",
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Obx(() {
                final DateTime? createdAt = authController.user.value?.createdAt;
                return Text(
                  'Joined ${createdAt != null ? DateFormat('MMM dd, YYYY').format(createdAt) : ""}',
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              }),
              const SizedBox(height: 16),
              // Account Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account', style: textTheme.headlineMedium),
                  const SizedBox(height: 12),
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
                          trailing: CustomIcon(icon: 'arrowRight'),
                          onTap: item['onTap'],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Study Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Study', style: textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: study.length,
                    itemBuilder: (context, index) {
                      final item = study[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(item['icon'], size: 20),
                          title: Text(item['title'], style: textTheme.titleMedium),
                          trailing: CustomIcon(icon: 'arrowRight'),
                          onTap: item['onTap'],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Support Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Support', style: textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: support.length,
                    itemBuilder: (context, index) {
                      final item = support[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(item['icon'], size: 20),
                          title: Text(item['title'], style: textTheme.titleMedium),
                          trailing: CustomIcon(icon: 'arrowRight'),
                          onTap: item['onTap'],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Sign Out Button
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: colorPalette.error.withAlpha(25),
                leading: Icon(HugeIcons.strokeRoundedLogout01, size: 20, color: colorPalette.error),
                title: Text("Logout", style: textTheme.titleMedium?.copyWith(color: colorPalette.error)),
                trailing: CustomIcon(icon: 'arrowRight', color: colorPalette.error),
                onTap: () => Get.dialog(ConfirmDialog(onConfirmed: () => authController.logout())),
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

  Widget buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF8B5CF6), size: 20),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
