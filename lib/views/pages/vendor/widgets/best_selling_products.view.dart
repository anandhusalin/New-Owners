import 'package:flutter/material.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/view_models/vendor/best_selling_products.vm.dart';
import 'package:fuodz/widgets/custom_grid_view.dart';
import 'package:fuodz/widgets/list_items/grid_view_product.list_item.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/translations/vendor/best_selling_products.i18n.dart';

class BestSellingProducts extends StatelessWidget {
  const BestSellingProducts(this.vendorType, {Key key}) : super(key: key);

  final VendorType vendorType;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BestSellingProductsViewModel>.reactive(
      viewModelBuilder: () => BestSellingProductsViewModel(
        context,
        vendorType,
      ),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return VStack(
          [
            //
            "Best Selling".i18n.text.xl.semiBold.make().p12(),
            CustomGridView(
              // scrollDirection: Axis.horizontal,
              noScrollPhysics: true,
              padding: EdgeInsets.symmetric(horizontal: 10),
              dataSet: model.products,
              isLoading: model.isBusy,
              crossAxisSpacing: 10,
              childAspectRatio: 1.1,
              itemBuilder: (context, index) {
                //
                return GridViewProductListItem(
                  product: model.products[index],
                  onPressed: model.productSelected,
                  qtyUpdated: model.addToCartDirectly,
                );
              },
            ),
          ],
        ).py12();
      },
    );
  }
}
