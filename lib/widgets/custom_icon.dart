import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/theme/colors.dart';

class CustomIcon extends StatelessWidget {
  final String icon;
  final double size;
  final Color? color;

  const CustomIcon({super.key, required this.icon, this.size = 20, this.color});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;

    final Map<String, IconData> iconMap = {
      'home': HugeIcons.strokeRoundedHome12,
      'library': HugeIcons.strokeRoundedLibrary,
      'chatbot': HugeIcons.strokeRoundedChatBot,
      'profile': HugeIcons.strokeRoundedUser03,
      'add': HugeIcons.strokeRoundedAdd01,
      'arrowRight': HugeIcons.strokeRoundedArrowRight01,
      'noteEdit': HugeIcons.strokeRoundedTaskEdit01,
      'documentScanner': HugeIcons.strokeRoundedAiScan,
      'flashcard': HugeIcons.strokeRoundedNote,
      'note': HugeIcons.strokeRoundedTask01,
      'document': HugeIcons.strokeRoundedNotebook,
      'notification': HugeIcons.strokeRoundedNotification02,
      'arrowLeft': HugeIcons.strokeRoundedArrowLeft01,
      'menuDot': HugeIcons.strokeRoundedMoreVertical,
      'folder': HugeIcons.strokeRoundedFolder01,
      'upload': HugeIcons.strokeRoundedUpload03,
      'media': HugeIcons.strokeRoundedAiVideo,
      'mail': HugeIcons.strokeRoundedMail01,
      'lock': HugeIcons.strokeRoundedSquareLock01,
      'view': HugeIcons.strokeRoundedView,
      'viewOff': HugeIcons.strokeRoundedViewOff,
      'google': HugeIcons.strokeRoundedGoogle,
      'facebook': HugeIcons.strokeRoundedFacebook01,
      'audio': HugeIcons.strokeRoundedVoice,
      'video': HugeIcons.strokeRoundedPlaySquare,
      'image': HugeIcons.strokeRoundedImage02,
      'tick': HugeIcons.strokeRoundedTick01,
      'cancel': Icons.close,
      'arrowDown': HugeIcons.strokeRoundedArrowDown01,
      'tickCircle': HugeIcons.strokeRoundedCheckmarkCircle03,
      'book': HugeIcons.strokeRoundedBook02,
      'physics': HugeIcons.strokeRoundedPhysics,
      'chemistry': HugeIcons.strokeRoundedAtom02,
      'math': HugeIcons.strokeRoundedMath,
      'history': HugeIcons.strokeRoundedGlobal,
      'artificialIntelligence': HugeIcons.strokeRoundedArtificialIntelligence01,
      'statistics': HugeIcons.strokeRoundedPieChart02,
      'botany': HugeIcons.strokeRoundedBioEnergy,
      'factory': HugeIcons.strokeRoundedFactory,
      'tap': HugeIcons.strokeRoundedTap05,
      'sent': HugeIcons.strokeRoundedSent02,
      'message': HugeIcons.strokeRoundedMessageMultiple01,
      'fileEdit': HugeIcons.strokeRoundedFileEdit,
    };

    if (iconMap.containsKey(icon)) {
      return Icon(iconMap[icon]!, size: size, color: color ?? colorPalette.content);
    } else {
      return Icon(HugeIcons.strokeRoundedHelpCircle, size: size, color: color ?? colorPalette.content);
    }
  }
}
