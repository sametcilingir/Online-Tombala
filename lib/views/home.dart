import 'package:flutter/material.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';
import 'package:tombala/views/room_choose.dart';

class HomeScreen extends StatelessWidget {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Tombala',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 400,
              child: Form(
                key: _viewModel.formKeyUserName,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Çilgin Çocuk 37',
                    labelText: 'Kullanici Adi Giriniz',
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
            SizedBox(
              height: 20,
            ),
            OutlinedButton(
              onPressed: () {
                _viewModel.formKeyUserName.currentState!.save();
                
                Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      RoomChooseScreen(),
                ));
              },
              child: Text('Giris'),
            ),
          ],
        ),
      ),
    );
  }
}
