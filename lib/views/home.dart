import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';
import 'package:tombala/views/room_choose.dart';

class HomeScreen extends StatelessWidget {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Bingo',
                  style: Theme.of(context).textTheme.headline1,
                ),
                Container(
                  width: 300,
                  child: Column(
                    children: [
                      Form(
                        key: _viewModel.formKeyUserName,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Çilgin Çocuk 37',
                            labelText: 'Kullanici Adi ',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (newValue) {
                            _viewModel.userName = newValue!;
                          },
                          validator: (value) {
                            if (value == "") {
                              return 'Kullanici Adi bos olamaz';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          var val = _viewModel.formKeyUserName.currentState!
                              .validate();
                          if (val) {
                            _viewModel.formKeyUserName.currentState!.save();
                            Navigator.of(context).pushNamed('/room_choose');
                          } else {
                            showToastWidget(                              
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                 margin: EdgeInsets.all(20),
                                  child: Text(
                                    'Kullanici Adi bos olamaz',
                                    style:  Theme.of(context).textTheme.bodyText1,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              position: StyledToastPosition.top,
                              duration: Duration(seconds: 2),
                              context: context,
                              animation: StyledToastAnimation.slideFromTop,
                              reverseAnimation: StyledToastAnimation.slideToTop,
                              
                            );
                            
                          }
                        },
                        child: Text(
                          'Giris',
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
