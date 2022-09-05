import 'package:care_giver/database/tables/hospital_table.dart';
import 'package:care_giver/models/hospital.dart';
import 'package:flutter/material.dart';

import '../../common/common_widget.dart';
import '../../util/navigator_util.dart';
import '../../util/reg_exp_util.dart';

class AddHospitalPage extends StatefulWidget {
  const AddHospitalPage({Key? key}) : super(key: key);

  @override
  State<AddHospitalPage> createState() => _AddHospitalPageState();
}

class _AddHospitalPageState extends State<AddHospitalPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hospitalNameTextEditController =
      TextEditingController();
  final TextEditingController _phoneTextEditingController =
      TextEditingController();
  final TextEditingController _addressTextEditingController =
      TextEditingController();
  final TextEditingController _latitudeTextEditingController =
      TextEditingController();
  final TextEditingController _longitudeTextEditingController =
      TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    super.dispose();

    _hospitalNameTextEditController.dispose();
    _phoneTextEditingController.dispose();
    _addressTextEditingController.dispose();
    _latitudeTextEditingController.dispose();
    _longitudeTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _label(),
                  const SizedBox(height: 32),
                  _textFormField(
                      _hospitalNameTextEditController, 'Hospital Name'),
                  const SizedBox(height: 16),
                  _textFormField(_phoneTextEditingController, 'Phone',
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 16),
                  _textFormField(_addressTextEditingController, 'Address'),
                  const SizedBox(height: 16),
                  _textFormField(_latitudeTextEditingController, 'Latitude',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  _textFormField(_longitudeTextEditingController, 'Longitude',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 32),
                  _saveButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label() {
    return Text(
      'Hospital',
      style: TextStyle(
        fontSize: 30,
        color: Theme.of(context).primaryColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _textFormField(
      TextEditingController textEditingController, String message,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: keyboardType,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Enter ${message.toLowerCase()}';
        }
        if (keyboardType == TextInputType.phone &&
            (!isNumeric(value) || !RegExpUtils.phoneNumber.hasMatch(value))) {
          return 'Invalid phone number!';
        }
        return null;
      },
      decoration: InputDecoration(
        label: Text(message),
        floatingLabelStyle: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _saveButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() == true) {
          _saveFirstAid();
        }
      },
      child: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        child: _loading
            ? const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(color: Colors.white),
              )
            : const Text('Save'),
      ),
    );
  }

  Future<void> _saveFirstAid() async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    // check validation
    bool isExistHospital = await HospitalTable.checkHospitalIsExist(
      _hospitalNameTextEditController.text,
      _latitudeTextEditingController.text,
      _longitudeTextEditingController.text,
    );

    if (!mounted) return;

    if (isExistHospital) {
      showSimpleSnackBar(
        context,
        'Hospital is already exist',
        Colors.red,
      );
      setState(() {
        _loading = false;
      });
      return;
    }

    // call saveInfo
    final result = await HospitalTable.insert(Hospital(
      hospitalName: _hospitalNameTextEditController.text,
      phone: _phoneTextEditingController.text,
      address: _addressTextEditingController.text,
      latitude: double.tryParse(_latitudeTextEditingController.text) ?? 0,
      longitude: double.tryParse(_longitudeTextEditingController.text) ?? 0,
    ));

    if (!mounted) return;

    showSimpleSnackBar(
      context,
      "Insert Hospital is ${result > -1 ? 'successful' : 'failed'}",
      result > -1 ? Colors.green : Colors.red,
    );
    if (result > -1) {
      NavigatorUtils.pop(context, result: true);
    } else {
      setState(() {
        _loading = false;
      });
    }
  }
}
