import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class EnterencePage extends StatelessWidget {
  const EnterencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '약국 주문 & 반품',
                style: Theme.of(context).textTheme.headline3,
              ),
              Container(
                height: size.width,
              ),
              Text(
                '스마트한 당신을 위한 앱\n 겁나 고생함',
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Text('Produced by Man About Town(MAT)..'),

              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  TextButton(
                    onPressed: () {
                      context.read<PageController>().animateToPage(1,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                    },
                    child: Text('입장하기'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
