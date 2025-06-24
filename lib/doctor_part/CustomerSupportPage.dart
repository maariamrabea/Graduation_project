import 'package:flutter/material.dart';

import '../Widget/arrow_back.dart';
import '../fontstyle.dart';

class CustomerSupportPage extends StatelessWidget {
  const CustomerSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomIconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        backgroundColor: ColorsApp.color1,
        title: Text(
          "CustomerSupport",
          style: AppTextStyles.f18.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSupportTile(
            icon: Icons.email_outlined,
            title: 'Email Us',
            subtitle: 'support@skinlyapp.com',
            onTap: () {},
          ),
          _buildSupportTile(
            icon: Icons.chat_outlined,
            title: 'Chat on WhatsApp',
            subtitle: '+201234567890',
            onTap: () {},
          ),
          _buildSupportTile(
            icon: Icons.phone_outlined,
            title: 'Call Us',
            subtitle: '+20 123 456 7890',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSupportTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, size: 30, color: const Color(0xFF567A88)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
