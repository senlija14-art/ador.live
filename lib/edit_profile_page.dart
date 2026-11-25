

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic>? profile;

  const EditProfilePage({
    super.key,
    this.profile,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ImagePicker picker = ImagePicker();

  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController bioController;
  late TextEditingController birthdayController;
  late TextEditingController countryController;
  late TextEditingController cityController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  String gender = 'Male';
  String? imagePath;

  int sendingLevel = 1;
  int receivingLevel = 1;

  @override
  void initState() {
    super.initState();

    final data = widget.profile ?? {};

    nameController =
        TextEditingController(text: data['name']?.toString() ?? '');
    usernameController =
        TextEditingController(text: data['username']?.toString() ?? '');
    bioController =
        TextEditingController(text: data['bio']?.toString() ?? '');
    birthdayController =
        TextEditingController(text: data['birthday']?.toString() ?? '');
    countryController =
        TextEditingController(text: data['country']?.toString() ?? '');
    cityController =
        TextEditingController(text: data['city']?.toString() ?? '');
    phoneController =
        TextEditingController(text: data['phone']?.toString() ?? '');
    emailController =
        TextEditingController(text: data['email']?.toString() ?? '');

    final savedGender = data['gender']?.toString() ?? 'Male';
    gender = ['Male', 'Female', 'Other'].contains(savedGender)
        ? savedGender
        : 'Male';

    imagePath = data['profileImage']?.toString();

    sendingLevel =
        int.tryParse(data['sendingLevel']?.toString() ?? '') ?? 1;
    receivingLevel =
        int.tryParse(data['receivingLevel']?.toString() ?? '') ?? 1;
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    bioController.dispose();
    birthdayController.dispose();
    countryController.dispose();
    cityController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> changePhoto() async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1000,
      );

      if (image != null && mounted) {
        setState(() {
          imagePath = image.path;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ছবি নির্বাচন করা যায়নি। আবার চেষ্টা করো।'),
        ),
      );
    }
  }

  Future<void> chooseBirthday() async {
    DateTime initialDate = DateTime(2000);

    final parsedDate = DateTime.tryParse(birthdayController.text);
    if (parsedDate != null) {
      initialDate = parsedDate;
    }

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        birthdayController.text =
            '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Widget textField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget levelBox(String title, int level, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.deepPurple.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.deepPurple, size: 26),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Level $level',
              style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider? get profileImage {
    if (imagePath == null || imagePath!.isEmpty) return null;

    final file = File(imagePath!);
    if (file.existsSync()) return FileImage(file);

    return null;
  }

  void saveProfile() {
    final updatedProfile = <String, dynamic>{
      'name': nameController.text.trim(),
      'username': usernameController.text.trim(),
      'bio': bioController.text.trim(),
      'gender': gender,
      'birthday': birthdayController.text.trim(),
      'country': countryController.text.trim(),
      'city': cityController.text.trim(),
      'phone': phoneController.text.trim(),
      'email': emailController.text.trim(),
      'profileImage': imagePath,
      'sendingLevel': sendingLevel,
      'receivingLevel': receivingLevel,
    };

    Navigator.pop(context, updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            GestureDetector(
              onTap: changePhoto,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.deepPurple.shade100,
                    backgroundImage: profileImage,
                    child: profileImage == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.deepPurple,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.deepPurple,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Change Profile Photo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                levelBox('Sending Level', sendingLevel, Icons.send),
                const SizedBox(width: 12),
                levelBox(
                  'Receiving Level',
                  receivingLevel,
                  Icons.card_giftcard,
                ),
              ],
            ),

            const SizedBox(height: 25),

            textField('Name', nameController),
            textField('Username', usernameController),
            textField('Bio', bioController, maxLines: 3),

            DropdownButtonFormField<String>(
              value: gender,
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    gender = value;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: birthdayController,
              readOnly: true,
              onTap: chooseBirthday,
              decoration: InputDecoration(
                labelText: 'Birthday',
                suffixIcon: const Icon(Icons.calendar_month),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            textField('Country', countryController),
            textField('City', cityController),
            textField(
              'Phone Number',
              phoneController,
              keyboardType: TextInputType.phone,
            ),
            textField(
              'Email',
              emailController,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
