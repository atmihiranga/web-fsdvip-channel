import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close)),
                      ),
                      const Text(
                        'Important',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      ListTile(
                        leading: Icon(Icons.circle),
                        title: Text(
                            'Signals are published automatically through a system; always double check the signal details such as entry & exit prices before placing an order.'),
                      ),
                      ListTile(
                        leading: Icon(Icons.circle),
                        title: Text(
                            'We try our best to publish 1 signal per day. But on bad market conditions, we will not publish signals.This is for your own safety, we prefer quality over quantity.'),
                      ),
                      ListTile(
                        leading: Icon(Icons.circle),
                        title: Text(
                            'Take Profit hits and Stop Loss hits are updated manually for now. Due to this, there can be delays in updating them, and you may see a signal as active even after it has already hit a TP or SL.'),
                      ),
                      ListTile(
                        leading: Icon(Icons.circle),
                        title: Text(
                            'Analysis Charts are published manually after the signal, so there may be a delay between the signal publication and chart availability.'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.info_outline,
        ),
      ),
    );
  }
}
