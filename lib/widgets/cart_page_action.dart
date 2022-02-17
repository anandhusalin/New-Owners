import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/views/pages/cart/cart.page.dart';
import 'package:velocity_x/velocity_x.dart';

class PageCartAction extends StatefulWidget {
  const PageCartAction({this.color = Colors.white, Key key}) : super(key: key);
  final Color color;

  @override
  _PageCartActionState createState() => _PageCartActionState();
}

class _PageCartActionState extends State<PageCartAction> {
  @override
  void initState() {
    super.initState();
    CartServices.getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CartServices.cartItemsCountStream.stream,
      initialData: 0,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Icon(
          FlutterIcons.shopping_bag_fea,
          color: widget.color,
          size: 30,
        )
            .badge(
              count: snapshot.data,
              size: 20,
              color: widget.color ?? context.cardColor,
              textStyle: context.textTheme.bodyText1.copyWith(fontSize: 13),
            )
            .centered()
            .pOnly(right: 10)
            .onInkTap(
          () async {
            //
            context.nextPage(CartPage());
          },
        );
      },
    );
  }
}
