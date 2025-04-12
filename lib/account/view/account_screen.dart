import 'package:flutter/material.dart';

import 'screens/update_profile_screen.dart';

class ProfileOverviewScreen extends StatefulWidget {
  const ProfileOverviewScreen({super.key});

  @override
  State<ProfileOverviewScreen> createState() => _ProfileOverviewScreenState();

  static Widget _statBox(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // Reusable: Menu tile
  static Widget _overviewTile(IconData icon, String title,
      {VoidCallback? onTap,
      bool isSwitch = false,
      bool switchValue = false,
      ValueChanged<bool>? onSwitchChanged}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title),
      trailing: isSwitch
          ? Switch(
              value: switchValue,
              onChanged: onSwitchChanged,
              activeColor: Colors.red,
            )
          : null,
      onTap: onTap,
    );
  }
}

class _ProfileOverviewScreenState extends State<ProfileOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = false;

    void _toggleTheme() {
      setState(() {
        isDarkMode = !isDarkMode;
      });

      // Optional: Apply to app theme (if using Provider or GetX, etc.)
      final themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      // You can use context.read<ThemeProvider>().setTheme(themeMode); or similar logic
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Avatar with edit icon
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage('assets/icons/profile.png'),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                        context, UpdateProfileScreenAccountsTab.id);
                  },
                  child: Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child:
                          const Icon(Icons.edit, size: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Name and location
            const Text("CHUON Raksa",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.location_pin, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text("Gulshan, Dhaka", style: TextStyle(color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 24),

            // Stats: Deliveries & Parcels
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileOverviewScreen._statBox("10 Deliveries", "Completed"),
                const SizedBox(width: 16),
                ProfileOverviewScreen._statBox("12 Parcels", "Sent"),
              ],
            ),

            const SizedBox(height: 32),

            // Overview title
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Overviews",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 16),

            // Overview list
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ProfileOverviewScreen._overviewTile(
                      Icons.person_outline, "Account"),
                  ProfileOverviewScreen._overviewTile(
                      Icons.location_on_outlined, "Address"),
                  ProfileOverviewScreen._overviewTile(
                      Icons.payment, "Payments"),
                  ProfileOverviewScreen._overviewTile(
                    Icons.brightness_6_outlined,
                    "Theme",
                    isSwitch: true,
                    switchValue: isDarkMode,
                    onSwitchChanged: (val) => _toggleTheme(),
                  ),
                  ProfileOverviewScreen._overviewTile(
                      Icons.notifications_outlined, "Notification"),
                  ProfileOverviewScreen._overviewTile(
                      Icons.info_outline, "About Us"),
                  ProfileOverviewScreen._overviewTile(
                      Icons.settings_outlined, "Setting"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logout
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: Colors.black),
              label:
                  const Text("Logout", style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade100,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
