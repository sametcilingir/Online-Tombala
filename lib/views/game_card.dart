import 'package:flutter/material.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';

class GameCardScreen extends StatelessWidget {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  Widget build(BuildContext context) {
    _viewModel.createGameCard();
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      focusColor: Colors.amberAccent,
                      splashColor: Colors.amberAccent,
                      hoverColor: Colors.amberAccent,
                      highlightColor: Colors.amberAccent,
                      onTap: () {
                        print("sdfsdfds");
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(),
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))),
                        child: Center(
                          child: Text(
                            '${_viewModel.randomNumbersForCards[0]}',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    color: Colors.red,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
