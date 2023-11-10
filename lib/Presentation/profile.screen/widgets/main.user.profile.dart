import 'package:flutter/material.dart';
import 'package:pharmacy/Presentation/profile.screen/widgets/approval.widget.dart';

class MainUserProfile extends StatefulWidget {
  const MainUserProfile({super.key});

  @override
  State<MainUserProfile> createState() => _MainUserProfileState();
}

class _MainUserProfileState extends State<MainUserProfile> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Orders | Approvals',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ApprovalWidget()
          ],
        ),
      ),
    );
  }
}
