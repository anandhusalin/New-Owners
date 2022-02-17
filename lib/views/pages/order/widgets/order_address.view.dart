import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/order_details.vm.dart';
import 'package:fuodz/widgets/list_items/parcel_order_stop.list_view.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/translations/order_details.i18n.dart';

class OrderAddressesView extends StatelessWidget {
  const OrderAddressesView(this.vm, {Key key}) : super(key: key);

  final OrderDetailsViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        vm.order.isPackageDelivery
            ? VStack(
                [
                  //
                  ParcelOrderStopListView(
                    "Pickup Location",
                    vm.order.orderStops.first,
                    canCall: vm.order.canChatVendor,
                  ),

                  //stops
                  ...stopsList(),
                  //
                  ParcelOrderStopListView(
                    "Dropoff Location",
                    vm.order.orderStops.last,
                    canCall: vm.order.canChatVendor,
                  ),
                ],
              )
            : UiSpacer.emptySpace(),

        //regular delivery address
        Visibility(
          visible: !vm.order.isPackageDelivery,
          child: VStack(
            [
              "Deliver To".i18n.text.gray500.medium.sm.make(),
              vm.order.deliveryAddress != null
                  ? vm.order.deliveryAddress.name.text.xl.medium.make()
                  : UiSpacer.emptySpace(),
              vm.order.deliveryAddress != null
                  ? vm.order.deliveryAddress.address.text
                      .make()
                      .pOnly(bottom: Vx.dp20)
                  : UiSpacer.emptySpace(),
            ],
          ),
        ),
      ],
    );
  }

  //
  List<Widget> stopsList() {
    
    List<Widget> stopViews = [];
    if (vm.order.orderStops.length > 2) {
      stopViews = vm.order.orderStops
          .sublist(1, vm.order.orderStops.length - 1)
          .mapIndexed((stop, index) {
        return VStack(
          [
            ParcelOrderStopListView(
              "Stop".i18n + " ${index + 1}",
              stop,
              canCall: vm.order.canChatVendor,
            ),
          ],
        );
      }).toList();
    } else {
      stopViews.add(UiSpacer.emptySpace());
    }

    return stopViews;
  }
}
