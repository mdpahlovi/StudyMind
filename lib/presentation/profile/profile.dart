import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/controllers/auth.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/custom_image.dart';
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

    List<Map<String, dynamic>> profileSections = [
      {'title': 'My Progress', 'icon': HugeIcons.strokeRoundedTradeUp, 'onTap': () {}},
      {'title': 'Study History', 'icon': HugeIcons.strokeRoundedClock04, 'onTap': () {}},
      {'title': 'Achievements', 'icon': HugeIcons.strokeRoundedSaveEnergy01, 'onTap': () {}},
      {'title': 'Saved Items', 'icon': HugeIcons.strokeRoundedBookmark01, 'onTap': () {}},
      {'title': 'Logout', 'icon': HugeIcons.strokeRoundedLogout01, 'onTap': () {}},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), actions: [NotificationButton()]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Obx(() {
            final imageUrl = authController.user.value!.photo;
            return Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(child: CustomImage(imageUrl: imageUrl!, fit: BoxFit.cover)),
              ),
            );
          }),
          const SizedBox(height: 20),
          Obx(
            () => Text(authController.user.value!.name, textAlign: TextAlign.center, style: textTheme.headlineMedium),
          ),
          const SizedBox(height: 4),
          Obx(() => Text(authController.user.value!.email, textAlign: TextAlign.center, style: textTheme.bodyMedium)),
          const SizedBox(height: 12),
          ...profileSections.map((section) {
            return Card(
              margin: const EdgeInsets.only(top: 12),
              child:
                  section['title'] == 'Logout'
                      ? ListTile(
                        leading: Icon(section['icon'], size: 20, color: colorPalette.error),
                        title: Text(
                          section['title'],
                          style: textTheme.titleMedium?.copyWith(color: colorPalette.error),
                        ),
                        trailing: CustomIcon(icon: 'arrowRight', color: colorPalette.error),
                        onTap: section['onTap'],
                        tileColor: colorPalette.error.withAlpha(25),
                      )
                      : ListTile(
                        leading: Icon(section['icon'], size: 20),
                        title: Text(section['title'], style: textTheme.titleMedium),
                        trailing: CustomIcon(icon: 'arrowRight'),
                        onTap: section['onTap'],
                      ),
            );
          }),
        ],
      ),
    );
  }
}
