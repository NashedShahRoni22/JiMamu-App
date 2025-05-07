import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jimamu/feature/controller/auth_controller.dart';

import '../../../controller/theme_controller.dart';
import 'screens/update_user_profile_screen.dart';
import 'screens/update_rider_profile_screen.dart';

class ProfileOverviewScreen extends StatefulWidget {
  const ProfileOverviewScreen({super.key});

  @override
  State<ProfileOverviewScreen> createState() => _ProfileOverviewScreenState();

  static Widget _statBox(context, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surface
            : Colors.grey.shade100,
        // color: Colors.grey.shade100,
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
  static Widget _overviewTile(
    IconData icon,
    String title, {
    VoidCallback? onTap,
    bool isSwitch = false,
    bool switchValue = false,
    ValueChanged<bool>? onSwitchChanged,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xff909090),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Color(0xff909090)),
      ),
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

  static Widget _overviewTileWitch(
    IconData icon,
    String title, {
    VoidCallback? onTap,
    bool isSwitch = false,
    required RxBool switchValue,
    required ValueChanged<bool> onSwitchChanged,
  }) {
    return Obx(() => ListTile(
          leading: Icon(
            icon,
            color: const Color(0xff909090),
          ),
          title: Text(
            title,
            style: const TextStyle(color: Color(0xff909090)),
          ),
          trailing: isSwitch
              ? Switch(
                  value: switchValue.value,
                  onChanged: onSwitchChanged,
                  activeColor: Colors.red,
                )
              : null,
          onTap: onTap,
        ));
  }
}

class _ProfileOverviewScreenState extends State<ProfileOverviewScreen> {
  final ThemeController themeController = Get.find();
  final AuthController _auth = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () {
      //       Get.back();
      //     },
      //   ),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Avatar with edit icon
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage:
                      NetworkImage('${_auth.userProfile.data?.profileImage}'),
                ),
                // Positioned(
                //   bottom: 4,
                //   right: 1,
                //   child: InkWell(
                //     onTap: () {
                //
                //       Get.to(UpdateRiderProfileAccount());
                //       // Get.to(UpdateProfileScreen());
                //
                //       // Navigator.pushNamed(
                //       //     context, UpdateProfileScreenAccountsTab.id);
                //     },
                //     child: Container(
                //       padding: const EdgeInsets.all(6),
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         shape: BoxShape.circle,
                //         border: Border.all(color: Colors.grey.shade300),
                //       ),
                //       child: const Icon(Icons.edit, size: 16, color: Colors.black),
                //     ),
                //   ),
                // ),
              ],
            ),

            const SizedBox(height: 12),

            // Name and location
            Text('${_auth.userProfile.data?.name}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                ProfileOverviewScreen._statBox(
                    context, "10 Deliveries", "Completed"),
                const SizedBox(width: 16),
                ProfileOverviewScreen._statBox(context, "12 Parcels", "Sent"),
              ],
            ),

            const SizedBox(height: 32),

            // Overview title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Overviews",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff909090),
                  )),
            ),
            const SizedBox(height: 16),

            // Overview list
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.surface
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(
                          0,
                          2,
                        ),
                        color: Colors.grey.shade300)
                  ]),
              child: Column(
                children: [
                  GestureDetector(
                    child: ProfileOverviewScreen._overviewTile(
                      Icons.person_outline,
                      "Customer",
                    ),
                    onTap: () {
                      Get.to(UpdateUserProfileScreen());
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(UpdateRiderProfileAccount());
                    },
                    child: ProfileOverviewScreen._overviewTile(
                      Icons.person_outline,
                      "Rider ",
                    ),
                  ),
                  ProfileOverviewScreen._overviewTile(
                      Icons.location_on_outlined, "Address"),
                  ProfileOverviewScreen._overviewTile(
                      Icons.payment, "Payments"),
                  ProfileOverviewScreen._overviewTileWitch(
                    Icons.brightness_6_outlined,
                    "Theme",
                    isSwitch: true,
                    switchValue: themeController.isDark,
                    onSwitchChanged: (val) =>
                        themeController.toggleReactiveTheme(val),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.put(AuthController()).signOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1.5,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.logout, color: Color(0xff909090)),
                    SizedBox(width: 8),
                    Text("Logout", style: TextStyle(color: Color(0xff909090))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
