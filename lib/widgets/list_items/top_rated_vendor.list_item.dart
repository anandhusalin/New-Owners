import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class TopRatedVendorListItem extends StatelessWidget {
  const TopRatedVendorListItem({
    this.vendor,
    this.onPressed,
    Key key,
  }) : super(key: key);

  final Vendor vendor;
  final Function(Vendor) onPressed;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        Hero(
          tag: vendor.heroTag,
          child: CustomImage(
            imageUrl: vendor.logo,
            height: Vx.dp64 * 1.4,
            width: Vx.dp64 * 1.4,
          ).box.clip(Clip.antiAlias).roundedFull.make(),
        ).centered(),

        //
        VStack(
          [
            //name
            vendor.name.text.xl.medium
                .maxLines(1)
                .overflow(TextOverflow.ellipsis)
                .makeCentered(),
            //rating
            VxRating(
              maxRating: 5.0,
              value: double.parse(vendor.rating.toString()),
              isSelectable: false,
              onRatingUpdate: null,
              selectionColor: AppColor.ratingColor,
            ).centered(),
          ],
        ).p8().centered(),
      ],
    )
        .centered()
        .onInkTap(
          () => this.onPressed(this.vendor),
        )
        .wOneThird(context)
        .card
        .make()
        .box
        .outerShadow
        .roundedSM
        .make();
  }
}
