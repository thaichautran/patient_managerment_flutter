import 'package:flutter_app/resources/pages/detail_page.dart';
import 'package:flutter_app/resources/pages/list_patient.dart';

import '/resources/pages/home_page.dart';
import '/resources/pages/login_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* App Router
|--------------------------------------------------------------------------
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "dart run nylo_framework:main make:page profile_page"
| Learn more https://nylo.dev/docs/5.20.0/router
|-------------------------------------------------------------------------- */

appRouter() => nyRoutes((router) {
      router.route(HomePage.path, (context) => HomePage(), initialRoute: true);
      // Add your routes here

      router.route("/login", (context) => LoginPage(),
          transition: PageTransitionType.fade);
    });
