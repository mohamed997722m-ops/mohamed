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
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _ageController = TextEditingController();

  final List<String> _colleges = [
    'هندسة', 'طب', 'تجارة', 'حقوق', 'آداب', 'علوم', 'حاسبات ومعلومات', 'صيدلة', 'تربية', 'زراعة'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('أهلاً بك في مسار', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen())),
            child: Text('تخطي', style: TextStyle(color: Colors.white)),
          )
        ],
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
                  _buildTextField(_ageController, 'السن', keyboardType: TextInputType.number),
                  _buildAutocompleteField(_collegeController, 'الكلية', _colleges),
                  _buildTextField(_deptController, 'القسم'),
                  _buildTextField(_yearController, 'السنة الدراسية'),
                  _buildTextField(_semesterController, 'الترم'),
                  _buildTextField(_phoneController, 'رقم الهاتف (اختياري)', isRequired: false, keyboardType: TextInputType.phone),
                  _buildTextField(_addressController, 'العنوان (اختياري)', isRequired: false),
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
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isRequired = true, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.green),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          border: OutlineInputBorder(),
        ),
        validator: (value) => isRequired && (value == null || value.isEmpty) ? 'يرجى إدخال $label' : null,
      ),
    );
  }

  Widget _buildAutocompleteField(TextEditingController controller, String label, List<String> options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: RawAutocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return options.where((String option) {
            return option.contains(textEditingValue.text);
          });
        },
        onSelected: (String selection) {
          controller.text = selection;
        },
        fieldViewBuilder: (context, fieldController, focusNode, onFieldSubmitted) {
          // Sync fieldController with our controller if needed
          return TextFormField(
            controller: fieldController,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.green),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => controller.text = val,
            validator: (value) => value == null || value.isEmpty ? 'يرجى إدخال $label' : null,
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topRight,
            child: Material(
              elevation: 4.0,
              child: Container(
                width: MediaQuery.of(context).size.width - 32,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return ListTile(
                      title: Text(option),
                      onTap: () => onSelected(option),
                    );
                  },
                ),
              ),
            ),
          );
        },
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
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        address: _addressController.text.isEmpty ? null : _addressController.text,
        age: int.tryParse(_ageController.text) ?? 0,
      );
      await Provider.of<ProfileProvider>(context, listen: false).saveProfile(profile);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  }
}
