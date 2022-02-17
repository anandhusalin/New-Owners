import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/view_models/vendor_details.vm.dart';
import 'package:fuodz/views/pages/vendor_details/widgets/vendor_with_menu.view.dart';
import 'package:fuodz/views/pages/vendor_details/widgets/vendor_with_subcategory.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/translations/vendor_details.i18n.dart';

class VendorDetailsPage extends StatelessWidget {
  VendorDetailsPage({this.vendor, Key key}) : super(key: key);

  final Vendor vendor;

  Widget build(BuildContext context) {
    return ViewModelBuilder<VendorDetailsViewModel>.reactive(
      viewModelBuilder: () => VendorDetailsViewModel(context, vendor),
      onModelReady: (model) => model.getVendorDetails(),
      builder: (context, model, child) {
        return BasePage(
          title: model.vendor.name,
          showAppBar: true,
          showLeadingAction: true,
          showCart: true,//!model.vendor.hasSubcategories,
          fab: model.vendor.vendorType.slug == "pharmacy"
              ? FloatingActionButton.extended(
                  onPressed: model.uploadPrescription,
                  backgroundColor: AppColor.primaryColor,
                  label: "Upload Prescription".i18n.text.white.make(),
                  icon: Icon(
                    FlutterIcons.pills_faw5s,
                    color: Colors.white,
                    size: 22,
                  ),
                )
              : null,
          body: VStack(
            [
              //
              Visibility(
                visible: !model.vendor.hasSubcategories,
                child: VendorDetailsWithMenuPage(vendor: model.vendor).expand(),
              ),

              //subcategories
              Visibility(
                visible: model.vendor.hasSubcategories,
                child: VendorDetailsWithSubcategoryPage(vendor: model.vendor)
                    .expand(),
              ),
            ],
          ),
        );
      },
    );
  }
}
