import 'package:flutter/material.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';
import 'package:tombala/views/waiting.dart';

class RoomJoinScreen extends StatelessWidget {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
           /* Text(
              'Oda numarası giriniz',
              style: Theme.of(context).textTheme.headline2,
            ),*/
            Container(
              width: 300,
              child: Column(
                children: [
                  Form(
                    key: _viewModel.formKeyRoomId,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '54253453',
                        labelText: 'Oda Numarasi',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (newValue) {
                        _viewModel.roomId = newValue!;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        _viewModel.formKeyRoomId.currentState!.save();

                        _viewModel.context = context;

                        bool createJointProcces =
                            await _viewModel.joinRoom(context: context);
                        if (createJointProcces) {
                          Navigator.of(context).popAndPushNamed('/waiting_room');
                        }
                      },
                      child: Text('Odaya gir',style: Theme.of(context).textTheme.button,)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
