import 'dart:io';

import 'package:care_giver/common/common_widget.dart';
import 'package:care_giver/database/tables/first_aid_table.dart';
import 'package:care_giver/models/first_aid.dart';
import 'package:care_giver/util/file_picker_util.dart';
import 'package:care_giver/util/navigator_util.dart';
import 'package:flutter/material.dart';

class AddNewsfeedPage extends StatefulWidget {
  const AddNewsfeedPage({Key? key, required this.firstAid}) : super(key: key);
  final FirstAid? firstAid;

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
  void initState() {
    super.initState();
    if (widget.firstAid != null) {
      _nameTextEditingController.text = widget.firstAid!.name;
      _instructionTextEditingController.text = widget.firstAid!.instruction;
      _cautionTextEditingController.text = widget.firstAid!.caution;
      if (widget.firstAid!.photo != null &&
          widget.firstAid!.photo!.isNotEmpty) {
        _photoPathTextEditingController.text = widget.firstAid!.photo!;
        imageFile = File(_photoPathTextEditingController.text);
      }
    }
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
                  const SizedBox(height: 16),
                  _textFormField(
                      _instructionTextEditingController, 'Instruction'),
                  const SizedBox(height: 16),
                  _textFormField(_cautionTextEditingController, 'Caution'),
                  const SizedBox(height: 16),
                  _photoPathForm('Photo Path'),
                  const SizedBox(height: 32),
                  if (imageFile != null)
                    Image.file(
                      imageFile!,
                      height: 250,
                    ),
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
        child: TextField(
          controller: _photoPathTextEditingController,
          decoration: InputDecoration(
            label: Text(message),
            floatingLabelStyle: const TextStyle(color: Colors.black),
          ),
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
            : Text(widget.firstAid != null ? 'Update' : 'Save'),
      ),
    );
  }

  Future<void> _saveFirstAid() async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    if (widget.firstAid != null && widget.firstAid?.id != null) {
      showSimpleSnackBar(
        context,
        "Editing data is something wrong!",
        Colors.red,
      );
      setState(() {
        _loading = false;
      });
      return;
    }

    // call saveInfo
    final result = widget.firstAid != null
        ? await FirstAidTable.update(FirstAid(
            id: widget.firstAid!.id,
            name: _nameTextEditingController.text,
            instruction: _instructionTextEditingController.text,
            caution: _cautionTextEditingController.text,
            photo: _photoPathTextEditingController.text))
        : await FirstAidTable.insert(FirstAid(
            name: _nameTextEditingController.text,
            instruction: _instructionTextEditingController.text,
            caution: _cautionTextEditingController.text,
            photo: _photoPathTextEditingController.text));

    if (!mounted) return;

    showSimpleSnackBar(
      context,
      "Insert newsfeed is ${result > -1 ? 'successful' : 'failed'}",
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
