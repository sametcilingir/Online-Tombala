import 'package:flutter/material.dart';
import 'package:tombala/locator.dart';
import 'package:tombala/view_model/view_model.dart';
import 'package:tombala/views/room_join.dart';
import 'package:tombala/views/waiting.dart';

class RoomChooseScreen extends StatelessWidget {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.withOpacity(0.5),
      child: Center(
        child: Container(
          color: Colors.red,
          height: 300,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () async {
                    bool createRoomProcces = await _viewModel.createRoom();
                    if (createRoomProcces) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WaitingScreen()));
                    }
                  },
                  child: Text('Oda Oluştur')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (context, animation, secondaryAnimation) => RoomJoinScreen(),));
                  },
                  child: Text('Odaya gir')),
            ],
          ),
        ),
      ),
    );
  }
}
