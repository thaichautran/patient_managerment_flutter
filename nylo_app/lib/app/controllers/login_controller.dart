import 'package:flutter/material.dart';
import '/resources/widgets/logo_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'controller.dart';

class HomeController extends Controller {
  @override
  construct(BuildContext context) {
    super.construct(context);
  }

  onTapLogin() async {
    await launchUrl(Uri.parse("https://nylo.dev/docs"));
  }

  showAbout() {
    showAboutDialog(
      context: context!,
      applicationName: getEnv('APP_NAME'),
      applicationIcon: Logo(),
      applicationVersion: nyloVersion,
    );
  }
}
