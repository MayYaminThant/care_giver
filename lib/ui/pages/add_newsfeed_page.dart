import 'dart:io';

import 'package:care_giver/util/file_picker_util.dart';
import 'package:flutter/material.dart';

class AddNewsfeedPage extends StatefulWidget {
  const AddNewsfeedPage({Key? key}) : super(key: key);

  @override
  State<AddNewsfeedPage> createState() => _AddNewsfeedPageState();
}

class _AddNewsfeedPageState extends State<AddNewsfeedPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameTextEditingController = TextEditingController();
  final _instructionTextEditingController = TextEditingController();
  final _cautionTextEditingController = TextEditingController();
  final _photoPathTextEditingController = TextEditingController();

  bool _loading = false;
  File? imageFile;

  @override
  void dispose() {
    super.dispose();

    _nameTextEditingController.dispose();
    _instructionTextEditingController.dispose();
    _cautionTextEditingController.dispose();
    _photoPathTextEditingController.dispose();
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
                  _textFormField(_nameTextEditingController, 'Name'),
                  const SizedBox(height: 32),
                  _textFormField(
                      _instructionTextEditingController, 'Instruction'),
                  const SizedBox(height: 16),
                  _textFormField(_cautionTextEditingController, 'Caution'),
                  const SizedBox(height: 32),
                  _photoPathForm('Photo Path'),
                  const SizedBox(height: 32),
                  _saveButton(),
                  const SizedBox(height: 32),
                  if (imageFile != null) Image.file(imageFile!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFormField(
    TextEditingController textEditingController,
    String message,
  ) {
    return TextFormField(
      controller: textEditingController,
      validator: (String? value) {
        return (value == null || value.isEmpty)
            ? 'Enter ${message.toLowerCase()}'
            : null;
      },
      decoration: InputDecoration(
        label: Text(message),
        floatingLabelStyle: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _photoPathForm(
    String message,
  ) {
    return InkWell(
      child: AbsorbPointer(
        child: _textFormField(
          _photoPathTextEditingController,
          message,
        ),
      ),
      onTap: () async {
        final pathUrl = await FilePickerUtils.pickFile();
        if (pathUrl != null && pathUrl.isNotEmpty) {
          _photoPathTextEditingController.text = pathUrl;
          imageFile = File(pathUrl);
          setState(() {});
        }
      },
    );
  }

  Widget _saveButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() == true) {
          _saveInfo();
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

  Future<void> _saveInfo() async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    // call saveInfo

    setState(() {
      _loading = false;
    });

    if (!mounted) return;
  }
}
