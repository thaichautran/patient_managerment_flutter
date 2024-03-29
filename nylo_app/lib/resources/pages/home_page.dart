import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/resources/pages/list_patient.dart';
import 'package:flutter_app/resources/pages/login_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:nylo_framework/theme/helper/ny_theme.dart';
import 'package:flutter/material.dart';
import '/bootstrap/extensions.dart';
import '/resources/widgets/logo_widget.dart';
import '/resources/widgets/safearea_widget.dart';
import '/bootstrap/helpers.dart';
import '/app/controllers/home_controller.dart';

class HomePage extends NyStatefulWidget<HomeController> {
  static const path = '/home';

  HomePage() : super(path, child: _HomePageState());
}

class _HomePageState extends NyState<HomePage> {
  /// The boot method is called before the [view] is rendered.
  /// You can override this method to perform any async operations.
  /// Try uncommenting the code below.
  // @override
  // boot() async {
  //   dump("boot");
  //   await Future.delayed(Duration(seconds: 2));
  // }

  /// If you would like to use the Skeletonizer loader,
  /// uncomment the code below.
  // bool get useSkeletonizer => true;

  /// The Loading widget is shown while the [boot] method is running.
  /// You can override this method to show a custom loading widget.
  // @override
  // Widget loading(BuildContext context) {
  //   return Scaffold(
  //       body: Center(child: Text("Loading..."))
  //   );
  // }

  /// The [view] method should display your page.
  ApiService _apiService = ApiService();
  @override
  init() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    String? userToken = await NyStorage.read<String>("userToken");
    if (userToken == null) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new LoginPage()));
    } else {
      final status = await _apiService.getUser();
      if (status == 200) {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new ListPatientPage()));
      } else if (status == 401) {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new LoginPage()));
      } else {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new ListPatientPage()));
      }
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello World".tr()),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: widget.controller.showAbout,
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),
      body: SafeAreaWidget(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Logo(),
              Text(
                getEnv("APP_NAME"),
              ).displayMedium(context),
              Text("Micro-framework for Flutter", textAlign: TextAlign.center)
                  .titleMedium(context)
                  .setColor(context, (color) => color.primaryAccent),
              Text(
                "Build something amazing 💡",
              ).bodyMedium(context).alignCenter(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Divider(),
                  Container(
                    height: 250,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                        color: ThemeColor.get(context).surfaceBackground,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 9,
                            offset: Offset(0, 3),
                          ),
                        ]),
                    child: Center(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children:
                            ListTile.divideTiles(context: context, tiles: [
                          MaterialButton(
                            child: Text(
                              "login".tr().capitalize(),
                            ).bodyLarge(context).setColor(
                                context, (color) => color.surfaceContent),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new LoginPage()));
                            },
                          ),
                          // MaterialButton(
                          //   child: Text(
                          //     "Danh sách bệnh nhân",
                          //   ).bodyLarge(context).setColor(
                          //       context, (color) => color.surfaceContent),
                          //   onPressed: widget.controller.onTapGithub,
                          // ),
                          // MaterialButton(
                          //   child: Text(
                          //     "changelog".tr().capitalize(),
                          //   ).bodyLarge(context).setColor(
                          //       context, (color) => color.surfaceContent),
                          //   onPressed: widget.controller.onTapChangeLog,
                          // ),
                          // MaterialButton(
                          //   child: Text(
                          //     "YouTube Channel".tr().capitalize(),
                          //   ).bodyLarge(context).setColor(
                          //       context, (color) => color.surfaceContent),
                          //   onPressed: widget.controller.onTapYouTube,
                          // ),
                        ]).toList(),
                      ),
                    ),
                  ),
                  Text(
                    "Framework Version: $nyloVersion",
                  )
                      .bodyMedium(context)
                      .setColor(context, (color) => Colors.grey),
                  if (!context.isDarkMode)
                    Switch(
                        value: isThemeDark,
                        onChanged: (_) {
                          NyTheme.set(context,
                              id: getEnv(isThemeDark != true
                                  ? 'DARK_THEME_ID'
                                  : 'LIGHT_THEME_ID'));
                        }),
                  if (!context.isDarkMode)
                    Text("${isThemeDark ? "Dark" : "Light"} Mode"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get isThemeDark =>
      ThemeProvider.controllerOf(context).currentThemeId ==
      getEnv('DARK_THEME_ID');
}
