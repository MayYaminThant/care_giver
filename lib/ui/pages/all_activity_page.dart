import 'package:care_giver/ui/pages/add_newsfeed_page.dart';
import 'package:care_giver/ui/pages/registration_page.dart';
import 'package:care_giver/util/navigator_util.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';

class AllActivityPage extends StatefulWidget {
  const AllActivityPage({Key? key}) : super(key: key);

  @override
  State<AllActivityPage> createState() => _AllActivityPageState();
}

class _AllActivityPageState extends State<AllActivityPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchTextEditingController =
      TextEditingController();
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(
            top: 25,
            bottom: 50,
            left: 16,
            right: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _searchBox(() {}),
                const SizedBox(height: 16),
                _newsFeedUniqueView(),
              ],
            ),
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
            child: TextField(
              onChanged: (value) {
                // catController.searchTerm = value;
              },
              cursorColor: Colors.black38,
              controller: _searchTextEditingController,
              decoration: const InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.black26),
                fillColor: Colors.white,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              ),
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

  Widget _newsFeedUniqueView() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          _label('Name'),
          const SizedBox(height: 32),
          _label('Instruction'),
          const SizedBox(height: 32),
          _label('Caution'),
        ],
      ),
    );
  }

  Widget _label(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionBubble(
      items: <Bubble>[
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
        Bubble(
          // show only admin
          title: "Add New feed",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.post_add_rounded,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            NavigatorUtils.push(context, const AddNewsfeedPage());
            _animationController.reverse();
          },
        ),
        Bubble(
          title: "Set Alarm Time",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.timer,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
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
}
