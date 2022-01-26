import 'package:flutter/material.dart';
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
            'Tombala',
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
              color: Colors.amber,
              height: 300,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "",
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
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () async {
                      var val =
                          _viewModel.formKeyUserName.currentState!.validate();
                      if (val) {
                        _viewModel.formKeyUserName.currentState!.save();

                        final isRoomCreated = await _viewModel.createRoom();
                        if (isRoomCreated) {
                          Navigator.of(context).pushNamed("/home/waiting_room");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Oda olusturulamadi'),
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
                    'Odaya gir',
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
                    color: Colors.amber,
                    height: 300,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '',
                      labelText: 'Oda Numarasi',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (newValue) {
                      _viewModel.roomCode = newValue!;
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

                        bool createJointProcces = await _viewModel.joinRoom();
                        if (createJointProcces) {
                          _viewModel.createGameCard();
                          Navigator.of(context).pushNamed('/home/waiting_room');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Oda girme islemi basarisiz'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Odaya gir',
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
                      'Geri',
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
