import 'package:flutter/material.dart';
import '../../../../../constant/color_path.dart';
import '../../../../../constant/global_typography.dart';

class UpdateProfileScreenAccountsTab extends StatefulWidget {

  const UpdateProfileScreenAccountsTab({super.key});

  @override
  State<UpdateProfileScreenAccountsTab> createState() =>
      _UpdateProfileScreenAccountsTabState();
}

class _UpdateProfileScreenAccountsTabState
    extends State<UpdateProfileScreenAccountsTab> {
  String? selectedDocType;
  bool isDefaultPayment = false;

  final _docNumberController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _docNumberController.dispose();
    _cardNumberController.dispose();
    _expDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.surface: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorPath.flushMahogany,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text('Update Profile',
                style:
                    GlobalTypography.sub1Medium.copyWith(color: Colors.white)),
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile avatar
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage('assets/icons/profile.png'),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ColorPath.flushMahogany,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Dropdown
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Select Document Type",
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedDocType,
              items: ['Passport', 'ID Card', 'Driver License']
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (val) => setState(() => selectedDocType = val),
              decoration: InputDecoration(
                hintText: "Types",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Document number
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Enter Document Number",
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _docNumberController,
              decoration: InputDecoration(
                hintText: "45454 545454 54545",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Upload box
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Document Image",
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 12),
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined,
                      color: ColorPath.flushMahogany, size: 32),
                  const SizedBox(height: 8),
                   Text("Drag your file here",
                      style: TextStyle(color:Theme.of(context).brightness == Brightness.dark
                          ?  Colors.white: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bank info section
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Bank Information",
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.surface: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Card Number",
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _expDateController,
                          decoration: const InputDecoration(
                            labelText: "Exp Date",
                            hintText: "DD/MM",
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _cvvController,
                          decoration: const InputDecoration(
                            labelText: "CVV Code",
                            hintText: "000",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    value: isDefaultPayment,
                    onChanged: (val) =>
                        setState(() => isDefaultPayment = val ?? false),
                    title: const Text("Set as your default payment method"),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: ColorPath.flushMahogany,
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPath.flushMahogany,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child:
                    const Text("Submit", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
