import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tombala/components/view_models/view_model.dart';
import 'package:tombala/components/widgets/snack_bar.dart';
import 'package:tombala/utils/constants/color_constants.dart';
import 'package:tombala/utils/constants/duration_constants.dart';
import 'package:tombala/utils/constants/size_constants.dart';
import 'package:tombala/utils/extension/color_extension.dart';
import 'package:tombala/utils/extension/context_extension.dart';
import 'package:tombala/utils/extension/duration_extension.dart';
import 'package:tombala/utils/extension/size_extension.dart';
import 'package:tombala/utils/locator/locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tombala/utils/routes/routes.dart';
import 'package:tombala/utils/theme/app_theme.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({Key? key}) : super(key: key);

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final ViewModel _viewModel = locator<ViewModel>();



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: context.paddingNormal,
      child: loginForm(),
    ));
  }

  Form loginForm() {
    return Form(
      key: _viewModel.formKeyUserName,
      child: Column(
        children: [
          howToTextContainer(),
          SizeConstants().mediumHeight,
          userNameTextFormField(),
          SizeConstants().mediumHeight,
          buttonsRow(),
        ],
      ),
    );
  }

  Row buttonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        createRoomOutlinedButton(),
        SizeConstants().mediumHeight,
        joinPageTransferElevatedButton(),
      ],
    );
  }

  ElevatedButton joinPageTransferElevatedButton() {
    return ElevatedButton(
      onPressed: () {
        var val = _viewModel.formKeyUserName.currentState!.validate();
        if (val) {
          _viewModel.formKeyUserName.currentState!.save();

          _viewModel.homePageController.animateToPage(
            1,
            duration: DurationConstants().durationLow,
            curve: Curves.easeIn,
          );
        }
      },
      child: joinPageTransferElevatedButtonText(),
    );
  }

  Text joinPageTransferElevatedButtonText() {
    return Text(
     AppLocalizations.of(context)!.joinRoom,
      style: AppTheme().button,
    );
  }

  OutlinedButton createRoomOutlinedButton() {
    return OutlinedButton(
      onPressed: () async {
        var val = _viewModel.formKeyUserName.currentState!.validate();

        if (val) {
          _viewModel.formKeyUserName.currentState!.save();
          bool isRoomCreated = await _viewModel.createRoom();
          if (isRoomCreated) {
            Navigator.of(context).pushNamed(Routes.waitingRoom);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              snackBar(
                Colors.red,
               AppLocalizations.of(context)!.cantCreateRoom,
              ),
            );
          }
        }
      },
      child: createRoomOutlinedButtonText(),
    );
  }

  Text createRoomOutlinedButtonText() {
    return Text(
     AppLocalizations.of(context)!.createRoom,
      style: AppTheme().button,
    );
  }

  TextFormField userNameTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText:AppLocalizations.of(context)!.textFieldUserName,
        border: const OutlineInputBorder(),
      ),
      onSaved: (newValue) {
        _viewModel.playerModel.userName = newValue!;
      },
      validator: (value) {
        if (value == "") {
          return AppLocalizations.of(context)?.textFieldError;
        }
      },
    );
  }

  Container howToTextContainer() {
    return Container(
      color: ColorConstants().transparentColor,
      child: Column(
        children: [
          howToJoinRoomText(),
          SizeConstants().mediumHeight,
          howToJoinRoomPragText(),
        ],
      ),
    );
  }

  Text howToJoinRoomPragText() {
    return Text(
     AppLocalizations.of(context)!.howtoJoinRoomParag,
      style: AppTheme().headline6,
    );
  }

  Text howToJoinRoomText() {
    return Text(AppLocalizations.of(context)!.howtoJoinRoom,
        style: AppTheme().headline5);
  }
}
