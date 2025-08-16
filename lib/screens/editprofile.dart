import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import '../utils/screensize.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? firstName;
  String? lastName;
  String? location;
  String? mobile;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    firstName = userProvider.firstName;
    lastName = userProvider.lastName;
    location = userProvider.location;
    mobile = userProvider.mobile;
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.updateProfile(
      firstName: firstName,
      lastName: lastName,
      location: location,
      mobile: mobile,
    );
    
    // Navigate back to profile screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: userProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockH! * 6,
                      vertical: SizeConfig.blockV! * 2),
                  child: Column(
                    children: [
                      // Top bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.blockH! * 5,
                            ),
                          ),
                          TextButton(
                            onPressed: saveProfile,
                            child: Text(
                              "Done",
                              style: TextStyle(
                                color: DesignColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.blockH! * 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.blockV! * 2),
                      // Avatar and name
                      CircleAvatar(
                        radius: SizeConfig.blockH! * 8,
                        backgroundColor: Colors.pink[100],
                        child: Icon(Icons.person,
                            size: SizeConfig.blockH! * 10,
                            color: Colors.blueGrey),
                      ),
                      SizedBox(height: SizeConfig.blockV! * 1.5),
                      Text(
                        "${firstName ?? ''} ${lastName ?? ''}".trim(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockH! * 4.5,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Change Profile Picture",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                      SizedBox(height: SizeConfig.blockV! * 2),
                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _EditField(
                              label: "First Name",
                              initialValue: firstName ?? '',
                              onSaved: (val) => firstName = val,
                            ),
                            SizedBox(height: SizeConfig.blockV! * 2),
                            _EditField(
                              label: "Last Name",
                              initialValue: lastName ?? '',
                              onSaved: (val) => lastName = val,
                            ),
                            SizedBox(height: SizeConfig.blockV! * 2),
                            _EditField(
                              label: "Location",
                              initialValue: location ?? '',
                              onSaved: (val) => location = val,
                            ),
                            SizedBox(height: SizeConfig.blockV! * 2),
                            _EditField(
                              label: "Mobile Number",
                              initialValue: mobile ?? '',
                              keyboardType: TextInputType.phone,
                              onSaved: (val) => mobile = val,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final String initialValue;
  final void Function(String?) onSaved;
  final TextInputType? keyboardType;

  const _EditField({
    required this.label,
    required this.initialValue,
    required this.onSaved,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          onSaved: onSaved,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: const Icon(Icons.check, color: Colors.orange),
          ),
        ),
      ],
    );
  }
}