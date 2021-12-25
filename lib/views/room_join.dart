import 'package:flutter/material.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';
import 'package:tombala/views/waiting.dart';

class RoomJoinScreen extends StatelessWidget {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green.withOpacity(0.5),
        child: Center(
          child: Container(
            color: Colors.red,
            height: 300,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Oda Numarasini Giriniz"),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 400,
                  child: Form(
                    key: _viewModel.formKeyRoomId,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '54253453',
                        labelText: 'Oda Numarasi',
                        prefixIcon: Icon(Icons.supervised_user_circle_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onSaved: (newValue) {
                        _viewModel.roomId = newValue!;
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      _viewModel.formKeyRoomId.currentState!.save();

                      _viewModel.context = context;

                      bool createJointProcces = await _viewModel.joinRoom(context: context);
                      if (createJointProcces) {
                     /*   Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WaitingScreen()));*/
                                Navigator.of(context).popAndPushNamed( '/waiting_room');
                      }
                    },
                    child: Text('Odaya gir')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
