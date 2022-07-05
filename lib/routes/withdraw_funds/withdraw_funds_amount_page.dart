import 'package:flutter/material.dart';

class WithdrawFundsAmountPage extends StatelessWidget {
  final String address;

  const WithdrawFundsAmountPage(
    this.address, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO implements amount page"),
      ),
      body: Center(
        child: Text(
          "TODO implements amount page, received address: $address",
        ),
      ),
    );
  }
}
