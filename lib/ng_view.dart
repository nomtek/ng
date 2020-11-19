import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:ng/ng_view_controller.dart';

abstract class NGView<C extends NGViewController> extends StatefulWidget {
  final C controller;

  const NGView({Key key, this.controller}) : super(key: key);

  Widget build(BuildContext context);

  @override
  _NGViewState<C> createState() => _NGViewState<C>();
}

class _NGViewState<C extends NGViewController> extends State<NGView<C>> {
  @override
  void initState() {
    SchedulerBinding.instance?.addPostFrameCallback((_) => widget.controller?.onReady());
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller?.context = context;
    return widget.build(context);
  }
}