import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/cart_page_action.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class BasePage extends StatefulWidget {
  final bool showAppBar;
  final bool showLeadingAction;
  final bool extendBodyBehindAppBar;
  final Function onBackPressed;
  final bool showCart;
  final String title;
  final List<Widget> actions;
  final Widget body;
  final Widget bottomSheet;
  final Widget bottomNavigationBar;
  final Widget fab;
  final bool isLoading;
  final Color appBarColor;
  final double elevation;
  final Color appBarItemColor;

  BasePage({
    this.showAppBar = false,
    this.showLeadingAction = false,
    this.onBackPressed,
    this.showCart = false,
    this.title = "",
    this.actions,
    this.body,
    this.bottomSheet,
    this.bottomNavigationBar,
    this.fab,
    this.isLoading = false,
    this.appBarColor,
    this.appBarItemColor,
    this.elevation,
    this.extendBodyBehindAppBar,
    Key key,
  }) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          I18n.language == "ar" ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar ?? false,
        appBar: widget.showAppBar
            ? AppBar(
                backgroundColor: widget.appBarColor,
                elevation: widget.elevation,
                automaticallyImplyLeading: widget.showLeadingAction,
                leading: widget.showLeadingAction
                    ? IconButton(
                        icon: Icon(
                          FlutterIcons.arrow_left_fea,
                          color: widget.appBarItemColor ?? Colors.white,
                        ),
                        onPressed: widget.onBackPressed != null
                            ? widget.onBackPressed
                            : () => Navigator.pop(context),
                      )
                    : null,
                title: widget.title.text.maxLines(1).overflow(TextOverflow.ellipsis)
                    .color(widget.appBarItemColor ?? Colors.white)
                    .make(),
                actions: widget.actions ??
                    [
                      widget.showCart
                          ? PageCartAction(color: widget.appBarItemColor)
                          : UiSpacer.emptySpace(),
                    ],
              )
            : null,
        body: VStack(
          [
            //
            widget.isLoading
                ? LinearProgressIndicator()
                : UiSpacer.emptySpace(),

            //
            widget.body.expand(),
          ],
        ),
        bottomNavigationBar: widget.bottomNavigationBar,
        bottomSheet: widget.bottomSheet,
        floatingActionButton: widget.fab,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
