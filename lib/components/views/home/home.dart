import 'package:flutter/material.dart';
import 'package:tombala/utils/constants/string_constants.dart';
import 'package:tombala/utils/routes/routes.dart';
import '../../view_models/view_model.dart';
import '../../../utils/locator/locator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ViewModel _viewModel = locator<ViewModel>();

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Online Tomabala',
            style: Theme.of(context).textTheme.headline5,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            width: 400,
            child: PageView(
              allowImplicitScrolling: true,
              controller: _viewModel.pageController,
              //allowImplicitScrolling: false,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                LoginFormWidget(viewModel: _viewModel),
                JoinFormWidget(viewModel: _viewModel),
              ],
            ),
          ),
        ));
  }
}

class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({
    Key? key,
    required ViewModel viewModel,
  })  : _viewModel = viewModel,
        super(key: key);

  final ViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _viewModel.formKeyUserName,
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              height: 300,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "",
                labelText: StringConstants.textFieldUserName,
                border: OutlineInputBorder(),
              ),
              onSaved: (newValue) {
                _viewModel.userName = newValue!;
              },
              validator: (value) {
                if (value == "") {
                  return StringConstants.textFieldError;
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                            
                    onPressed: () async {
                      var val =
                          _viewModel.formKeyUserName.currentState!.validate();
                      if (val) {
                        _viewModel.formKeyUserName.currentState!.save();

                        bool isRoomCreated = await _viewModel.createRoom();

                        if (isRoomCreated) {
                          //_viewModel.createGameCard();
                          Navigator.of(context).pushNamed(Routes.waitingRoom);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(StringConstants.cantCreateRoom),
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      'Oda Oluştur',
                      style: Theme.of(context).textTheme.button,
                    )),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    var val =
                        _viewModel.formKeyUserName.currentState!.validate();
                    if (val) {
                      _viewModel.formKeyUserName.currentState!.save();

                      _viewModel.pageController.animateToPage(
                        1,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: Text(
                    StringConstants.joinRoom,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

class JoinFormWidget extends StatelessWidget {
  const JoinFormWidget({
    Key? key,
    required ViewModel viewModel,
  })  : _viewModel = viewModel,
        super(key: key);

  final ViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.sync(() {
        _viewModel.pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
        return false;
      }),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 300,
            child: Form(
              key: _viewModel.formKeyJoin,
              child: Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    height: 300,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '',
                      labelText: StringConstants.gameCode,
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (newValue) {
                      _viewModel.roomModel.roomCode = newValue!;
                      //kavyeyi kapatıyor
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        _viewModel.formKeyJoin.currentState!.save();

                        final isJoined = await _viewModel.joinRoom();
                        if (isJoined) {
                          //_viewModel.createGameCard();
                          Navigator.of(context).pushNamed(Routes.waitingRoom);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(StringConstants.cantJoinRoom),
                            ),
                          );
                        }
                      },
                      child: Text(
                        StringConstants.joinRoom,
                        style: Theme.of(context).textTheme.button,
                      )),
                  TextButton(
                    onPressed: () {
                      _viewModel.pageController.animateToPage(
                        0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                    child: Text(
                      StringConstants.back,
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
