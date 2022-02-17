import 'package:flutter/cupertino.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/models/category.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/requests/search.request.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchViewModel extends MyBaseViewModel {
  //
  SearchRequest _searchRequest = SearchRequest();
  TextEditingController keywordTEC = TextEditingController();
  ScrollController scrollController = ScrollController();
  RefreshController refreshController = RefreshController();
  String type = "";
  Category category;
  //
  int queryPage = 1;
  List<Product> products = [];
  List<Vendor> vendors = [];
  List<dynamic> searchResults = [];
  bool filterByProducts = true;

  SearchViewModel(BuildContext context, Search search) {
    this.viewContext = context;
    this.category = search?.category;
    this.type = search?.type;
    this.vendorType = search?.vendorType;

    //
    if (this.vendorType != null) {
      filterByProducts = false;
      type = "vendor";
      notifyListeners();
    }
    //
    startSearch();
  }

  //
  startSearch({bool initialLoaoding = true}) async {
    //
    if (initialLoaoding) {
      setBusy(true);
      queryPage = 1;
      refreshController.refreshCompleted();
    } else {
      queryPage = queryPage + 1;
    }

    //
    try {
      final searchResult = await _searchRequest.searchRequest(
        keyword: keywordTEC.text ?? "",
        categoryId: category != null ? category.id.toString() : null,
        vendorTypeId: vendorType != null ? vendorType.id.toString() : null,
        type: type,
        page: queryPage,
      );
      clearErrors();

      //
      if (initialLoaoding) {
        products = searchResult[0];
        vendors = searchResult[1];
      } else {
        final mProducts = searchResult[0];
        final mVendors = searchResult[1];
        //
        products.addAll(mProducts as List<Product>);
        vendors.addAll(mVendors as List<Vendor>);
      }

      if (filterByProducts) {
        searchResults = products;
      } else {
        searchResults = vendors;
      }
    } catch (error) {
      print("Error ==> $error");
      setError(error);
    }

    if (!initialLoaoding) {
      refreshController.loadComplete();
    }
    //done loading data
    setBusy(false);
  }

  //
  void showFilter() {}

  //
  productSelected(Product product) async {
    viewContext.navigator.pushNamed(
      AppRoutes.product,
      arguments: product,
    );
  }

  //
  vendorSelected(Vendor vendor) async {
    viewContext.navigator.pushNamed(
      AppRoutes.vendorDetails,
      arguments: vendor,
    );
  }

  void enableProductFilter() {
    filterByProducts = true;
    searchResults = products;
    type = "product";
    // scrollController.animToTop();
    notifyListeners();
    startSearch();
  }

  void enableVendorFilter() {
    filterByProducts = false;
    searchResults = vendors;
    type = "vendor";
    // scrollController.animToTop();
    notifyListeners();
    startSearch();
  }
}
