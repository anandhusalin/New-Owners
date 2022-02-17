import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/requests/vendor_type.request.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/views/pages/grocery/grocery.page.dart';
import 'package:fuodz/views/pages/parcel/parcel.page.dart';
import 'package:fuodz/views/pages/pharmacy/pharmacy.page.dart';
import 'package:fuodz/views/pages/service/service.page.dart';
import 'package:fuodz/views/pages/vendor/vendor.page.dart';
import 'package:velocity_x/velocity_x.dart';

class WelcomeViewModel extends MyBaseViewModel {
  //
  WelcomeViewModel(BuildContext context) {
    this.viewContext = context;
  }

  Widget selectedPage;
  List<VendorType> vendorTypes = [];
  VendorTypeRequest vendorTypeRequest = VendorTypeRequest();
  bool showGrid = true;

  //
  //
  initialise() async {
    await getVendorTypes();
  }

  getVendorTypes() async {
    setBusy(true);
    try {
      vendorTypes = await vendorTypeRequest.index();
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  pageSelected(VendorType vendorType) {
    Widget nextpage = VendorPage(vendorType);

    switch (vendorType.slug) {
      case "parcel":
        nextpage = ParcelPage(vendorType);
        break;
      case "grocery":
        nextpage = GroceryPage(vendorType);
        break;
      case "food":
        nextpage = VendorPage(vendorType);
        break;
      case "pharmacy":
        nextpage = PharmacyPage(vendorType);
        break;
      case "service":
        nextpage = ServicePage(vendorType);
        break;
      default:
        nextpage = VendorPage(vendorType);
        break;
    }

    viewContext.nextPage(nextpage);
  }
}
