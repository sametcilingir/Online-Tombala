import 'package:flutter/material.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';

class RoomJoinScreen extends StatelessWidget {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.withOpacity(0.5),
      child: Center(
        child: Container(
          color: Colors.yellow,
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
                    decoration: InputDecoration(
                      hintText: 'nuymarasi',
                      labelText: 'oda',
                      prefixIcon: Icon(Icons.supervised_user_circle_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onSaved: (newValue) {
                      _viewModel.userName = newValue!;
                    },
                  ),
                ),
              ),
              TextButton(onPressed: () {}, child: Text('Odaya gir')),
            ],
          ),
        ),
      ),
    );
  }
}
