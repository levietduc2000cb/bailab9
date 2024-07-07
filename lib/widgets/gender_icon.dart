import 'package:flutter/material.dart';

class GenderIcon {
  final String gender;

  const GenderIcon({required this.gender});

  IconData getIconData() {
    IconData iconData;
    switch (gender) {
      case 'male':
        iconData = Icons.male;
        break;
      case 'female':
        iconData = Icons.female;
        break;
      default:
        iconData = Icons.person; // default icon if gender is not specified
    }

    return iconData;
  }
}
