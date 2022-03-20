import 'package:flutter/material.dart';

class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Widget child;

  /// Accepts [onInit] callback to prefetch data in [initState].
  const StatefulWrapper({required this.onInit, required this.child, Key? key})
      : super(key: key);

  @override
  State<StatefulWrapper> createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    super.initState();

    widget.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
