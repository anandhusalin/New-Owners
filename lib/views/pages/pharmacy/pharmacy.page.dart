import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/pharmacy.vm.dart';
import 'package:fuodz/views/pages/pharmacy/widgets/pharmacy_categories.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/banners.view.dart';
import 'package:fuodz/views/pages/vendor/widgets/header.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/cards/view_all_vendors.view.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/horizontal_vendor.list_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class PharmacyPage extends StatefulWidget {
  const PharmacyPage(this.vendorType, {Key key}) : super(key: key);

  final VendorType vendorType;
  @override
  _PharmacyPageState createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage>
    with AutomaticKeepAliveClientMixin<PharmacyPage> {
  GlobalKey pageKey = GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ViewModelBuilder<PharmacyViewModel>.reactive(
      viewModelBuilder: () => PharmacyViewModel(context, widget.vendorType),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: !AppStrings.isSingleVendorMode,
          elevation: 0,
          title: "${widget.vendorType.name}",
          appBarColor: context.theme.backgroundColor,
          appBarItemColor: AppColor.primaryColor,
          showCart: true,
          key: pageKey,
          body: VStack(
            [
              //
              VendorHeader(model: model),

              SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                controller: model.refreshController,
                onRefresh: () {
                  model.refreshController.refreshCompleted();
                  setState(() {
                    pageKey = GlobalKey<State>();
                  });
                }, // model.reloadPage,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      top: 0,
                      child: VStack(
                        [
                          Banners(widget.vendorType),

                          //categories
                          PharmacyCategories(widget.vendorType),

                          //pharmacies
                          "Nearby ${widget.vendorType.name}"
                              .text
                              .xl
                              .semiBold
                              .make()
                              .px20()
                              .py12(),
                          CustomListView(
                            noScrollPhysics: true,
                            dataSet: model.vendors,
                            isLoading: model.busy(model.vendors),
                            itemBuilder: (context, index) {
                              final vendor = model.vendors[index];
                              return HorizontalVendorListItem(
                                vendor,
                                onPressed: model.openVendorDetails,
                              );
                            },
                            separatorBuilder: (context, index) =>
                                UiSpacer.emptySpace(),
                          ).px20(),
                          //
                          UiSpacer.verticalSpace(
                              space: context.percentHeight * 20),
                        ],
                      ).scrollVertical(),
                    ),

                    //view cart and all vendors
                    ViewAllVendorsView(vendorType: widget.vendorType),
                  ],
                ),
              ).expand(),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
