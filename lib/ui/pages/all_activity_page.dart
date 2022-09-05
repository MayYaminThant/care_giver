import 'dart:io';

import 'package:care_giver/common/cache_manager.dart';
import 'package:care_giver/database/tables/first_aid_table.dart';
import 'package:care_giver/models/first_aid.dart';
import 'package:care_giver/ui/pages/add_hospital.dart';
import 'package:care_giver/ui/pages/add_newsfeed_page.dart';
import 'package:care_giver/ui/pages/registration_page.dart';
import 'package:care_giver/ui/pages/search_hospital_page.dart';
import 'package:care_giver/util/navigator_util.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'set_alarm_page.dart';

class AllActivityPage extends StatefulWidget {
  const AllActivityPage({Key? key}) : super(key: key);

  @override
  State<AllActivityPage> createState() => _AllActivityPageState();
}

class _AllActivityPageState extends State<AllActivityPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  String? _filteredFirstAidName;
  List<FirstAid> _searchSuggestions = [];

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    _setDataForAutoCompleteSearchBox();
    super.initState();
  }

  Future<void> _setDataForAutoCompleteSearchBox() async {
    _searchSuggestions = await FirstAidTable.getAll();

    Future.delayed(
      Duration.zero,
      () {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(
            top: 25,
            bottom: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            children: [
              _searchBox(() {}),
              const SizedBox(height: 16),
              _firstAidListBuilder(),
            ],
          ),
        ),
        floatingActionButton: _floatingActionButton(),
      ),
    );
  }

  Widget _searchBox(VoidCallback voidCallback) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TypeAheadFormField<FirstAid>(
              key: _formKey,
              textFieldConfiguration: TextFieldConfiguration(
                controller: _typeAheadController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
              suggestionsCallback: (pattern) {
                return getSuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.name),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) async {
                _typeAheadController.text = suggestion.name;
                await _goToNewsfeed(suggestion);
              },
              errorBuilder: (context, error) => Text('$error',
                  style: TextStyle(color: Theme.of(context).errorColor)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                _filteredFirstAidName = value;

                Future.delayed(Duration.zero, () {
                  setState(() {});
                });

                return null;
              },
            ),
          ),
          IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {}),
        ],
      ),
    );
  }

  List<FirstAid> getSuggestions(String input) {
    List<FirstAid> matches = [];

    for (var f in _searchSuggestions) {
      if (f.name.toLowerCase().contains(input.toLowerCase())) {
        matches.add(f);
      }
    }

    return matches;
  }

  Widget _firstAidListBuilder() {
    final matches = _filteredFirstAidName != null
        ? getSuggestions(_filteredFirstAidName!)
        : _searchSuggestions;

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: matches.length,
        itemBuilder: ((context, index) {
          return _firstAidUniqueView(matches.elementAt(index));
        }),
      ),
    );
  }

  Widget _firstAidUniqueView(FirstAid firstAid) {
    return InkWell(
      onTap: () async {
        _goToNewsfeed(firstAid);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            if (firstAid.photo != null && firstAid.photo!.isNotEmpty)
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(firstAid.photo!),
                    height: 150,
                    width: MediaQuery.of(context).size.width - 50,
                    fit: BoxFit.fitWidth,
                  )),
            if (firstAid.photo != null && firstAid.photo!.isNotEmpty)
              const SizedBox(height: 15),
            _firstAidRowUI('Name', firstAid.name),
            const SizedBox(height: 15),
            _firstAidRowUI('Instruction', firstAid.instruction),
            const SizedBox(height: 15),
            _firstAidRowUI('Caution', firstAid.caution),
          ],
        ),
      ),
    );
  }

  Widget _label(String label) {
    return Text(
      label,
      textAlign: TextAlign.start,
    );
  }

  Widget _firstAidRowUI(String label, String value) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Expanded(child: _label(label)),
        _label(':'),
        const SizedBox(width: 20),
        Expanded(child: _label(value)),
      ],
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionBubble(
      items: <Bubble>[
        if (CacheManager.admin != null)
          Bubble(
            // show only admin
            title: "Registration",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.app_registration_rounded,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              NavigatorUtils.push(context, const RegistrationPage());
              _animationController.reverse();
            },
          ),
        if (CacheManager.admin != null)
          Bubble(
            // show only admin
            title: "Add New feed",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.post_add_rounded,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () async {
              await _goToNewsfeed(null);
            },
          ),
        if (CacheManager.admin != null)
          Bubble(
            // show only admin
            title: "Add Hospital",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.post_add_rounded,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () async {
              final res =
                  await NavigatorUtils.push(context, const AddHospitalPage());
              _animationController.reverse();
              if (res == true) {
                setState(() {});
              }
            },
          ),
        Bubble(
          title: "Set Alarm Time",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.timer,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            NavigatorUtils.push(context, const AlarmsPage());
            _animationController.reverse();
          },
        ),
        Bubble(
          title: "Search Hospital",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.local_hospital_rounded,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            NavigatorUtils.push(context, const SearchHospitalPage());
            _animationController.reverse();
          },
        ),
      ],
      animation: _animation,
      onPress: () => _animationController.isCompleted
          ? _animationController.reverse()
          : _animationController.forward(),
      iconColor: Colors.blue,
      iconData: Icons.add,
      backGroundColor: Colors.white,
    );
  }

  Future<void> _goToNewsfeed(FirstAid? firstAid) async {
    final res = await NavigatorUtils.push(
        context,
        AddNewsfeedPage(
          firstAid: firstAid,
        ));
    _animationController.reverse();
    if (res == true) {
      _setDataForAutoCompleteSearchBox();
    }
  }
}
