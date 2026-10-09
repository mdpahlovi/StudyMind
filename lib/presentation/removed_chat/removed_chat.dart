import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/controllers/removed_chat.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_back_button.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/dialog/confirm.dart';
import 'package:timeago/timeago.dart' as timeago;

class RemovedChatScreen extends StatelessWidget {
  const RemovedChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RemovedChatController controller = Get.find<RemovedChatController>();

    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        controller.selectedSessions.isEmpty ? Get.back() : controller.selectedSessions.clear();
      },
      child: RefreshIndicator(
        onRefresh: () async => controller.fetchRemovedSessions(),
        child: Scaffold(
          appBar: AppBar(
            leading: Obx(() {
              if (controller.selectedSessions.isEmpty) return const CustomBackButton();

              return IconButton(
                icon: const CustomIcon(icon: 'cancel', size: 28),
                onPressed: () => controller.selectedSessions.clear(),
              );
            }),
            title: Obx(() {
              final selectedSessions = controller.selectedSessions;
              return Text(selectedSessions.isEmpty ? 'Removed Chats' : '${selectedSessions.length}  chats');
            }),
            actions: [
              Obx(() {
                final selectedSessions = controller.selectedSessions;

                if (selectedSessions.isEmpty) return const SizedBox.shrink();

                final allSelected = controller.removedSessions.isNotEmpty && selectedSessions.length == controller.removedSessions.length;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: allSelected ? 'Deselect all' : 'Select all',
                      icon: Icon(allSelected ? HugeIcons.strokeRoundedCheckmarkCircle01 : HugeIcons.strokeRoundedCircle, size: 22),
                      onPressed: controller.selectAll,
                    ),
                    IconButton(
                      tooltip: 'Restore',
                      icon: const Icon(HugeIcons.strokeRoundedRestoreBin, size: 22),
                      onPressed: controller.restoreSelected,
                    ),
                    IconButton(
                      tooltip: 'Delete permanently',
                      icon: Icon(HugeIcons.strokeRoundedDelete02, size: 22, color: colorPalette.error),
                      onPressed: () => Get.dialog(
                        ConfirmDialog(
                          message: 'Selected chats will be deleted permanently.\nThis cannot be undone.',
                          onConfirm: controller.deleteSelected,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final List<ChatSession> removedSessions = controller.removedSessions;

            if (removedSessions.isEmpty) return buildEmptyState(colorPalette, textTheme);

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: removedSessions.length,
              itemBuilder: (context, index) =>
                  RemovedChatTile(session: removedSessions[index], onTap: () => controller.toggleSelection(removedSessions[index])),
              separatorBuilder: (_, _) => const SizedBox(height: 12),
            );
          }),
        ),
      ),
    );
  }

  Widget buildEmptyState(ColorPalette colorPalette, TextTheme textTheme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 64),
        Icon(HugeIcons.strokeRoundedChatBot, size: 64, color: colorPalette.contentDim),
        const SizedBox(height: 16),
        Text('No removed chats', textAlign: TextAlign.center, style: textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          'Chats you remove will appear here.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: colorPalette.contentDim),
        ),
      ],
    );
  }
}

class RemovedChatTile extends StatelessWidget {
  final ChatSession session;
  final VoidCallback onTap;

  const RemovedChatTile({super.key, required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final RemovedChatController controller = Get.find<RemovedChatController>();
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color color = colorPalette.primary;
    final DateTime removedAt = session.lastMessageAt ?? session.updatedAt;

    return Obx(() {
      final bool selected = controller.selectedSessions.contains(session);

      return Card(
        color: selected ? color.withAlpha(25) : colorPalette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: selected ? BorderSide(color: color.withAlpha(50), width: 1) : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withAlpha(50),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withAlpha(100), width: 1),
                  ),
                  child: Icon(HugeIcons.strokeRoundedChatBot, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(session.title, style: textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(
                        session.lastMessage?.isNotEmpty == true ? session.lastMessage! : 'removed ${timeago.format(removedAt)}',
                        style: textTheme.bodySmall?.copyWith(color: colorPalette.contentDim),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  selected ? HugeIcons.strokeRoundedCheckmarkCircle01 : HugeIcons.strokeRoundedCircle,
                  size: 22,
                  color: selected ? colorPalette.primary : colorPalette.contentDim,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
