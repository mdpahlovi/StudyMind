import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/dialog/confirm.dart';
import 'package:studymind/widgets/dialog/rename.dart';

class SessionOption {
  void Function()? onTap;
  final IconData icon;
  final String title;
  final bool danger;
  final bool disabled;
  final bool isLoading;

  SessionOption({
    required this.icon,
    required this.title,
    this.danger = false,
    this.disabled = false,
    this.onTap,
    this.isLoading = false,
  });
}

class SessionOptionsSheet extends StatefulWidget {
  final List<ChatSession> selectedSessions;

  const SessionOptionsSheet({super.key, required this.selectedSessions});

  @override
  State<SessionOptionsSheet> createState() => SessionOptionsSheetState();
}

class SessionOptionsSheetState extends State<SessionOptionsSheet> {
  bool isRenaming = false;
  bool isRemoving = false;

  @override
  Widget build(BuildContext context) {
    final List<ChatSession> selectedSessions = widget.selectedSessions;

    final ChatController chatController = Get.find<ChatController>();

    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final EdgeInsets paddings = MediaQuery.of(context).padding;

    final List<SessionOption> options = [
      SessionOption(
        onTap: selectedSessions.length == 1
            ? () {
                Get.dialog(
                  RenameDialog(
                    value: selectedSessions.first.title,
                    onConfirm: (title) {
                      Get.back();
                      setState(() => isRenaming = true);
                      chatController.updateChatSession(uid: selectedSessions.first.uid, title: title);
                      setState(() => isRenaming = false);
                    },
                  ),
                );
              }
            : null,
        title: 'Rename',
        icon: HugeIcons.strokeRoundedEdit02,
        disabled: selectedSessions.length != 1,
      ),
      SessionOption(
        onTap: selectedSessions.isNotEmpty
            ? () {
                Get.dialog(
                  ConfirmDialog(
                    message: 'You want to remove? If yes,\nPlease press confirm.',
                    onConfirm: () {
                      Get.back();
                      setState(() => isRemoving = true);
                      chatController.updateBulkChatSession(
                        uid: selectedSessions.map((e) => e.uid).toList(),
                        isActive: false,
                      );
                      setState(() => isRemoving = false);
                    },
                  ),
                );
              }
            : null,
        title: 'Remove',
        icon: HugeIcons.strokeRoundedDelete02,
        danger: true,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colorPalette.background,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fixed header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedSessions.length == 1
                        ? selectedSessions.first.title
                        : '${selectedSessions.length} sessions selected',
                    style: textTheme.headlineMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: CustomIcon(icon: 'cancel', color: colorPalette.content, size: 24),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: paddings.bottom),
              child: Column(
                children: options
                    .where((option) => !option.disabled)
                    .map<List<Widget>>((option) => [buildOptionTile(context, option), const Divider()])
                    .expand((widget) => widget)
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildOptionTile(BuildContext context, SessionOption option) {
  final ColorPalette colorPalette = AppColors().palette;
  final TextTheme textTheme = Theme.of(context).textTheme;
  final Color color = option.danger ? colorPalette.error : colorPalette.content;

  return ListTile(
    onTap: option.isLoading ? null : option.onTap,
    leading: Icon(option.icon, color: color, size: 20),
    title: Text(option.title, style: textTheme.titleMedium?.copyWith(color: color)),
    trailing: option.isLoading
        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: color))
        : null,
  );
}
