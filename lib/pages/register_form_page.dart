import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_example/pages/user_info.dart';

import '../models/user.dart';

class RegisterFormPage extends StatefulWidget {
  const RegisterFormPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterFormPageState createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage> {
  User user = User();

  bool _obscure = true;
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _storyTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  final List<String> _countries = [
    'Belarus',
    'Ukraine',
    'Poland',
    'Montenegro'
  ];
  String? _selectedCountry;

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _nameTextController.dispose();
    _phoneTextController.dispose();
    _emailTextController.dispose();
    _storyTextController.dispose();
    _confirmPasswordTextController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _passFocus.dispose();
  }

  void _setFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register Form'),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              TextFormField(
                focusNode: _nameFocus,
                autofocus: true,
                onFieldSubmitted: (_) {
                  _setFocus(context, _nameFocus, _phoneFocus);
                },
                validator: (val) => _validateName(val!),
                controller: _nameTextController,
                onSaved: (val) => user.name = val!,
                decoration: InputDecoration(
                  labelText: 'Full name*',
                  hintText: 'What people call you?',
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _nameTextController.clear();
                    },
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.grey,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Colors.black26, width: 1),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                focusNode: _phoneFocus,
                onFieldSubmitted: (_) {
                  _setFocus(context, _phoneFocus, _passFocus);
                },
                controller: _phoneTextController,
                validator: (val) => _validatePhone(val!),
                onSaved: (val) => user.phone = val!,
                decoration: InputDecoration(
                  labelText: 'Phone Number*',
                  helperText: "Phone format: (XXX)XXX-XXXX",
                  hintText: 'Where can we reach you?',
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: Colors.blue,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _phoneTextController.clear();
                    },
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Colors.black26, width: 1),
                  ),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  // FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter(RegExp(r'^[()\d -]{1,15}$'),
                      allow: true)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _emailTextController,
                validator: (val) => _validateEmail(val!),
                onSaved: (val) => user.email = val!,
                decoration: const InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Enter a Email address',
                    icon: Icon(
                      Icons.mail,
                      color: Colors.blue,
                    )),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _storyTextController,
                onSaved: (val) => user.story = val!,
                decoration: const InputDecoration(
                  labelText: 'Life story',
                  hintText: 'Tell us about yourself',
                  helperText: 'Keep it short',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                maxLines: 3,
                inputFormatters: [LengthLimitingTextInputFormatter(100)],
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                items: _countries.map((country) {
                  return DropdownMenuItem(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (country) {
                  setState(() {
                    _selectedCountry = country;
                  });
                },
                onSaved: (country) => user.country = country!,
                value: _selectedCountry,
                decoration: const InputDecoration(
                    icon: Icon(Icons.map),
                    labelText: 'Country',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    )),
                validator: (val) =>
                    (val == null) ? 'Please, select the country' : null,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                focusNode: _passFocus,
                controller: _confirmPasswordTextController,
                decoration: InputDecoration(
                  labelText: 'Password*',
                  hintText: 'Enter the password',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                      icon: _obscure
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off)),
                  icon: Icon(
                    Icons.security,
                    color: Colors.blue[200],
                  ),
                ),
                obscureText: _obscure,
                maxLength: 8,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (val) => (val == _confirmPasswordTextController.text)
                    ? null
                    : 'Check the password',
                obscureText: _obscure,
                maxLength: 8,
                decoration: InputDecoration(
                  labelText: 'Confirm password*',
                  hintText: 'Repeat the password',
                  icon: Icon(
                    Icons.border_color,
                    color: Colors.blue[200],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _showDialog('Successful');
                    } else {
                      _showMessage('Form is not valid');
                    }
                  },
                  child: const Text('Submit Form')),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateName(String value) {
    final regExp = RegExp(r'^[a-zA-Z ]+$');
    if (value.isEmpty) {
      return 'Name is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Enter correct name';
    }
    return null;
  }

  String? _validatePhone(String value) {
    final regExp = RegExp(r'^\(\d\d\d\)\d\d\d-\d\d\d\d$');
    if (!regExp.hasMatch(value)) {
      return 'Enter correct number';
    }
    return null;
  }

  String? _validateEmail(String value) {
    final regExp = RegExp(r'^\w+@\w+\.\w+$');
    if (!regExp.hasMatch(value)) {
      return 'Enter correct Email';
    }
    return null;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
      ),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 5),
    ));
  }

  void _showDialog(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(
                message,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserInfoPage(user)));
                    },
                    child: const Text('OK')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('CANCEL')),
              ],
            ));
  }
}
