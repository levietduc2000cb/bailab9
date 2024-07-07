import 'package:flutter/material.dart';

import '../models/user.dart';
import '../widgets/gender_icon.dart';
import '../widgets/image_section.dart';
import '../widgets/row_option.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return Scaffold(
        backgroundColor: const Color.fromRGBO(57, 39, 97, 1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageSection(user: user),
              const Divider(),
              RowOption(
                icon: Icons.email,
                text: user.email,
              ),
              const Divider(),
              RowOption(
                icon: Icons.phone,
                text: user.phone,
              ),
              const Divider(),
              RowOption(
                icon: GenderIcon(gender: user.gender).getIconData(),
                text: user.gender,
              ),
              const Divider(),
            ],
          ),
        ));
  }
}
