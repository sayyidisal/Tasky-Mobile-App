import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:tasky_app/managers/organization_manager.dart';
import 'package:tasky_app/managers/user_manager.dart';
import 'package:tasky_app/models/organization.dart';
import 'package:tasky_app/utils/local_storage.dart';
import 'package:tasky_app/utils/ui_utils/custom_colors.dart';
import 'package:tasky_app/utils/ui_utils/ui_utils.dart';
import 'package:tasky_app/views/inbox/inbox_view.dart';
import 'package:tasky_app/views/overview/over_view.dart';
import 'package:tasky_app/views/account/account_view.dart';
import 'package:tasky_app/views/task/task_view.dart';

final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();
final OrganizationManager _organizationManager =
    GetIt.I.get<OrganizationManager>();
final UserManager _userManager = GetIt.I.get<UserManager>();

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final UiUtilities uiUtilities = UiUtilities();
  String department;
  int _currentIndex = 0;
  final List<Widget> _pages = [
    OverView(),
    TaskView(),
    InboxView(),
    AccountView()
  ];

  _onChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    checkAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onChanged,
        selectedIconTheme:
            Theme.of(context).iconTheme.copyWith(color: customRedColor),
        selectedLabelStyle: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(color: customRedColor),
        unselectedIconTheme:
            Theme.of(context).iconTheme.copyWith(color: customGreyColor),
        unselectedLabelStyle: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(color: customGreyColor),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: customRedColor,
        unselectedItemColor: customGreyColor,
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/chart_pie.svg'),
              label: 'Overview',
              activeIcon: SvgPicture.asset(
                'assets/chart_pie.svg',
                color: customRedColor,
              )),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/lightning_bolt.svg'),
              label: 'Task',
              activeIcon: SvgPicture.asset(
                'assets/lightning_bolt.svg',
                color: customRedColor,
              )),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/inbox.svg'),
              label: 'Inbox',
              activeIcon: SvgPicture.asset(
                'assets/inbox.svg',
                color: customRedColor,
              )),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/user_circle.svg'),
              label: 'Account',
              activeIcon: SvgPicture.asset(
                'assets/user_circle.svg',
                color: customRedColor,
              ))
        ],
      ),
    );
  }

  void getUserDepartment() async {
    Organization organization = await _organizationManager.getOrganization();
    _localStorage.getUserInfo().then((data) {
      if (data.department == null)
        showDialog(
            context: context,
            child: AlertDialog(
              title: Text(
                'Update your department',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: SizedBox(
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: DropdownButton<String>(
                          style: Theme.of(context).textTheme.bodyText1,
                          hint: Text(
                            'Select your department',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          value: department,
                          onChanged: (value) {
                            setState(() {
                              department = value;
                            });
                          },
                          items: organization.data.department.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                '$value',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: customRedColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: () async {
                          Navigator.pop(context);
                          if (department == null) {
                            uiUtilities.actionAlertWidget(
                                context: context, alertType: 'error');
                            uiUtilities.alertNotification(
                                context: context,
                                message: 'Select a department');
                          } else {
                            BotToast.showLoading(
                                allowClick: false,
                                clickClose: false,
                                backButtonBehavior: BackButtonBehavior.ignore);
                            bool isUpdated = await _userManager
                                .updateUserDepartment(department: department);
                            BotToast.closeAllLoading();
                            if (isUpdated) {
                              uiUtilities.actionAlertWidget(
                                  context: context, alertType: 'success');
                              uiUtilities.alertNotification(
                                  context: context,
                                  message: _userManager.message);
                            } else {
                              uiUtilities.actionAlertWidget(
                                  context: context, alertType: 'error');
                              uiUtilities.alertNotification(
                                  context: context,
                                  message: _userManager.message);
                            }
                          }
                        },
                        child: Text(
                          'Update department',
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Colors.white),
                        ))
                  ],
                ),
              ),
            ));
    });
  }

  void checkAuth() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.userChanges().listen((user) {
      if (user != null) {
        getUserDepartment();
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/loginView', (route) => false);
      }
    });
  }
}
