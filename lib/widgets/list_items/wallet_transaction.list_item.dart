import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/wallet_transaction.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class WalletTransactionListItem extends StatelessWidget {
  const WalletTransactionListItem(this.walletTransaction, {Key key})
      : super(key: key);

  final WalletTransaction walletTransaction;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        HStack(
          [
            "${walletTransaction.isCredit == 1 ? 'Credit' : 'Debit'}"
                .text.semiBold.xl
                .color(
                  walletTransaction.isCredit == 1 ? Colors.green : Colors.red,
                )
                .make()
                .expand(),
            "${AppStrings.currencySymbol} ${walletTransaction.amount.numCurrency}"
                .text
                .semiBold
                .xl
                .make()
          ],
        ),
        //
        HStack(
          [
            "${walletTransaction.reason != null ?walletTransaction.reason : ''}"
                .text
                .make()
                .expand(),
            "${DateFormat.yMEd(I18n.localeStr).format(walletTransaction.createdAt)}"
                .text
                .light
                
                .make()
          ],
        ),
      ],
    ).p8().box.outerShadowSm.color(context.cardColor).roundedSM.make();
  }
}
