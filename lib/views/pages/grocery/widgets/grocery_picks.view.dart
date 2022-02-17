import 'package:flutter/material.dart';
import 'package:fuodz/view_models/grocery.vm.dart';
import 'package:fuodz/widgets/custom_grid_view.dart';
import 'package:fuodz/widgets/list_items/grid_view_product.list_item.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/translations/vendor/vendor_type_view.i18n.dart';

class GroceryPicksView extends StatelessWidget {
  
  const GroceryPicksView(this.vm,{Key key}) : super(key: key);

  final GroceryViewModel vm;

  @override
  Widget build(BuildContext context) {
    return VStack(
          [
            //
            "Pick's Today".i18n.text.xl.semiBold.make().p12(),

            CustomGridView(
              noScrollPhysics: true,
              padding: EdgeInsets.symmetric(horizontal: 10),
              dataSet: vm.productPicks,
              isLoading: vm.busy(vm.productPicks),
              crossAxisSpacing: 15,
              childAspectRatio: 0.85,
              itemBuilder: (context, index) {
                //
                return GridViewProductListItem(
                  product: vm.productPicks[index],
                  onPressed: vm.productSelected,
                  qtyUpdated: vm.addToCartDirectly,
                  showStepper: true,
                );
              },
            ),
          ],
        ).py12();
  }
}
