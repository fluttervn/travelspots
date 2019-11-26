import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

//enum ScreenName { SignIn, Home  }

/// Utility class help handle navigation of pages
class Navigation {
  ///Present new page like iOS
  static Future presentScreen(BuildContext context, Widget page,
      {bool hasAnimation = true}) {
    return Navigator.of(context).push(
        CupertinoPageRoute(fullscreenDialog: true, builder: (context) => page));
  }

  /// Push new page
  /// Set [replaceScreen] is true if you want to replace new page with current page
  static Future openScreen(
      {@required BuildContext context,
      @required Widget page,
      bool replaceScreen = false,
      String routeName = ''}) {
    // FIXME(triet): recursive bug makes us don't use `replaceScreen` yet
    /*if (replaceScreen) {
      return Navigator.of(context).pushReplacement(
        SlideRightToLeftRoute(
          previousPage: oldPage,
          builder: (context) => page,
        ),
      );
    } else {
      return Navigator.of(context).push(
        SlideRightToLeftRoute(
          previousPage: oldPage,
          builder: (context) => page,
        ),
      );
    }*/
    if (replaceScreen) {
      return Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          settings: RouteSettings(name: routeName),
          builder: (context) => page,
        ),
      );
    } else {
      return Navigator.of(context).push(
        CupertinoPageRoute(
          settings: RouteSettings(name: routeName),
          builder: (context) => page,
        ),
      );
    }
  }

  /// Push new page with Bloc
  /// Set [replaceScreen] is true if you want to replace new page with current page
  static Future openScreenWithBloc<T extends PropertyChangeNotifier>({
    @required BuildContext context,
    @required Widget page,
    @required T bloc,
    bool replaceScreen = false,
    String routeName = '',
  }) {
    // FIXME(triet): recursive bug makes us don't use `replaceScreen` yet
    /*if (replaceScreen) {
      return Navigator.of(context).pushReplacement(
        SlideRightToLeftRoute(
          previousPage: oldPage,
          builder: (context) => page,
        ),
      );
    } else {
      return Navigator.of(context).push(
        SlideRightToLeftRoute(
          previousPage: oldPage,
          builder: (context) => page,
        ),
      );
    }*/

    var provider = PropertyChangeProvider(
      value: bloc,
      child: page,
    );

    if (replaceScreen) {
      return Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          settings: RouteSettings(name: routeName),
          builder: (context) => provider,
        ),
      );
    } else {
      return Navigator.of(context).push(
        CupertinoPageRoute(
          settings: RouteSettings(name: routeName),
          builder: (context) => provider,
        ),
      );
    }
  }

  /// openning the screen on the top root and clear all the previous screen
  static Future openScreenAndReplace({
    @required BuildContext context,
    @required Widget page,
    String routeName = '',
    bool navigationBack = false,
  }) {
    /*if (navigationBack) {
      return Navigator.of(context).pushAndRemoveUntil(
        SlideLeftToRightRoute(
            previousPage: oldPage, builder: (context) => page),
        (Route<dynamic> route) => false,
      );
    } else {
      return Navigator.of(context).pushAndRemoveUntil(
        SlideRightToLeftRoute(
          previousPage: oldPage,
          builder: (context) => page,
        ),
        (Route<dynamic> route) => false,
      );
    }*/
    return Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (context) => page,
      ),
      (Route<dynamic> route) {
        Fimber.d('route: $route');
        return route.settings.name == '/';
      },
    );
  }

  /// Push new page by drawer navigation
  /// Set [replaceScreen] is true if you want to replace new page with current page
  static Future openScreenByDrawer(
    NavigatorState navigatorState,
    BuildContext context,
    Widget page, {
    bool replaceScreen = false,
    String routeName = '',
  }) {
    if (replaceScreen) {
      return navigatorState.pushReplacement(
        CupertinoPageRoute(
          settings: RouteSettings(name: routeName),
          builder: (context) => page,
        ),
      );
    } else {
      return navigatorState.push(
        CupertinoPageRoute(
          builder: (context) => page,
        ),
      );
    }
  }

  /// Opening the transparent screen and push overlay the previous screen
  static Future openOverlayScreen(BuildContext context, Widget page) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => page,
      ),
    );
  }

  /// Back to previous page include result data
  static bool goBackWithData<T extends Object>(BuildContext context, T result) {
    return Navigator.of(context).pop(result);
  }

  ///Back to previous page
  static bool goBack(BuildContext context, {String from}) {
    Fimber.d('Navigation: back: ($from) -------------------------- ');
    return Navigator.of(context).pop();
  }

  ///Back to root page
  static void goBackToRoot(BuildContext context, {String from}) {
    Fimber.d('Navigation:back to root: ($from) -------------------------- ');

    Navigator.popUntil(context, (Route<dynamic> route) {
      Fimber.d('rounte name: ${route.settings.name}');
      return route.settings.name == '/';
    });
  }
}

///Route for transition page from left to right, it's same transition of pop
class SlideLeftToRightRoute extends MaterialPageRoute {
  ///page before slide transition happen
  final Widget previousPage;

  ///Constructor of SlideLeftToRightRoute
  SlideLeftToRightRoute(
      {this.previousPage, WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget currentPage) {
    var _slideAnimationPage1 =
        Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.0, 0.0))
            .animate(animation);
    var _slideAnimationPage2 =
        Tween<Offset>(begin: Offset(-0.3, 0.0), end: Offset(0.0, 0.0))
            .animate(animation);
    return Stack(
      children: <Widget>[
        SlideTransition(position: _slideAnimationPage2, child: currentPage),
        SlideTransition(position: _slideAnimationPage1, child: previousPage),
      ],
    );
  }
}

///Route for transition page from right to left, it's same default transition
class SlideRightToLeftRoute extends MaterialPageRoute {
  ///page before slide transition happen
  final Widget previousPage;

  ///Constructor of SlideRightToLeftRoute
  SlideRightToLeftRoute(
      {this.previousPage, WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget currentPage) {
    var _slideAnimationPage1 =
        Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(-0.3, 0.0))
            .animate(animation);
    var _slideAnimationPage2 =
        Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
            .animate(animation);
    return Stack(
      children: <Widget>[
        SlideTransition(position: _slideAnimationPage1, child: previousPage),
        SlideTransition(position: _slideAnimationPage2, child: currentPage),
      ],
    );
  }
}
