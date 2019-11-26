import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:travelspots/utils/navigation.dart';

/// Creating base state to manage the states
abstract class BaseState<T extends StatefulWidget> extends State<T> {
  ///build the widgets inside localization provider
  Widget buildChild(BuildContext context);

  /// tag to debug
  String tag;

  /// Constructor BaseState
  BaseState() {
    tag = runtimeType.toString();
    Fimber.d('Create new page: $tag');
  }

  /// Go back to previous page.
  ///
  /// - from: debug variable (string) to indicate which page invokes go back method
  void goBack({String from}) {
    Navigation.goBack(context, from: from);
  }

  /// Get the corresponding Bloc instance from Provider
  /// This Bloc must be registered before in MyApp.build()
  T providerOfBloc<T extends PropertyChangeNotifier>({bool listen = false}) {
    PropertyChangeModel<T> model = PropertyChangeProvider.of<T>(
      context,
      listen: listen,
    );
    return model.value;
  }

  @override
  void initState() {
//    Fimber.d('$tag: initState()');
    super.initState();
    Fimber.d('$tag:initState - Add tokenBloc listener with base state');
  }

  @override
  Widget build(BuildContext context) {
    /*easyLocalizationProvider = EasyLocalizationProvider.of(context);
    return EasyLocalizationProvider(
      data: easyLocalizationProvider.data,
      child: buildChild(context),
    );*/
    return buildChild(context);
  }
}
