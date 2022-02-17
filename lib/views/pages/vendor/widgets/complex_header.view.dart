import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/translations/home.i18n.dart';

class ComplexVendorHeader extends StatelessWidget {
  const ComplexVendorHeader({
    Key key,
    this.model,
  }) : super(key: key);

  final MyBaseViewModel model;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        CustomTextFormField(
          prefixIcon: Icon(
            FlutterIcons.search1_ant,
            color: AppColor.primaryColor,
          ),
          isReadOnly: true,
          hintText: "Search for".i18n + " ${model.vendorType.name}",
          filled: true,
          fillColor: context.backgroundColor,
          onTap: () {
            
            model.openSearch();
          },
        ).box.p4.roundedSM.color(context.backgroundColor).make(),

        //
        HStack(
          [
            //location icon
            Icon(
              FlutterIcons.location_pin_sli,
              // size: 16,
            ).onInkTap(
              model.useUserLocation,
            ),

            //
            VStack(
              [
                //
                "Delivery Location".i18n.text.lg.semiBold.make(),
                model.deliveryaddress.address.text.sm.make(),
              ],
            )
                .onInkTap(
                  model.pickDeliveryAddress,
                )
                .px12()
                .expand(),

            //
            //
            Icon(
              FlutterIcons.my_location_mdi,
            ).px4(),
          ],
        ).p8(),
      ],
    ).px16().py12();
  }
}
