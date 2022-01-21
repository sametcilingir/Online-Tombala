import 'package:flutter/material.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';

class HomeScreen extends StatelessWidget {
  final ViewModel _viewModel = locator<ViewModel>();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Bingo',
            style: Theme.of(context).textTheme.headline1,
          ),
          Container(
            height: 200,
            width: double.infinity,
            child: PageView(
              controller: _viewModel.pageController,
              allowImplicitScrolling: false,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                LoginFormWidget(viewModel: _viewModel),
                JoinFormWidget(viewModel: _viewModel),
              ],
            ),
          ),
        ],
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Form(
            key: _viewModel.formKeyUserName,
            child: TextFormField(
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
                        width: 1, color: Theme.of(context).colorScheme.primary),
                  ),
                  onPressed: () async {
                    var val =
                        _viewModel.formKeyUserName.currentState!.validate();
                    if (val) {
                      _viewModel.formKeyUserName.currentState!.save();

                      final isRoomCreated = await _viewModel.createRoom();
                      if (isRoomCreated) {
                        Navigator.of(context).pushNamed("/waiting_room");
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
                  var val = _viewModel.formKeyUserName.currentState!.validate();
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
    );
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 300,
        child: Column(
          children: [
            Form(
              key: _viewModel.formKeyJoin,
              child: TextFormField(
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
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  _viewModel.formKeyJoin.currentState!.save();

                  bool createJointProcces = await _viewModel.joinRoom();
                  if (createJointProcces) {
                    Navigator.of(context).pushNamed('/waiting_room');
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
          ],
        ),
      ),
    );
  }
}
