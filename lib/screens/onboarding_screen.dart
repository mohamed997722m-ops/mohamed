import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../models/user_profile.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();
  final _collegeController = TextEditingController();
  final _deptController = TextEditingController();
  final _semesterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('أهلاً بك في مسار', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'سجل بياناتك للبدء',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  SizedBox(height: 30),
                  _buildTextField(_nameController, 'الاسم بالكامل'),
                  _buildTextField(_yearController, 'السنة الدراسية'),
                  _buildTextField(_collegeController, 'الكلية'),
                  _buildTextField(_deptController, 'القسم'),
                  _buildTextField(_semesterController, 'الترم'),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('ابدأ الآن', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.green),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? 'يرجى إدخال $label' : null,
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final profile = UserProfile(
        name: _nameController.text,
        academicYear: _yearController.text,
        college: _collegeController.text,
        department: _deptController.text,
        semester: _semesterController.text,
      );
      await Provider.of<ProfileProvider>(context, listen: false).saveProfile(profile);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  }
}
