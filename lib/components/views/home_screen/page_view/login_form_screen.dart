import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../core/app/color/app_color.dart';
import '../../../../core/app/duration/app_duration.dart';
import '../../../../core/app/size/app_size.dart';
import '../../../../core/app/theme/app_theme.dart';
import '../../../../core/extension/context_extension.dart';
import '../../../../core/locator/locator.dart';
import '../../../../core/routes/routes.dart';
import '../../../view_models/view_model.dart';
import '../../../widgets/snack_bar.dart';

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
        padding: context.paddingMedium,
        child: loginForm(),
      ),
    );
  }

  Widget loginForm() {
    return Observer(builder: (_) {
      return Form(
        key: _viewModel.formKeyUserName,
        child: Column(
          children: [
            howToTextContainer(),
            AppSize.highHeightSizedBox,
            userNameTextFormField(),
            AppSize.highHeightSizedBox,
            buttonsRow(),
          ],
        ),
      );
    });
  }

  Row buttonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        createRoomOutlinedButton(),
        AppSize.mediumHeightSizedBox,
        joinPageTransferElevatedButton(),
      ],
    );
  }

  ElevatedButton joinPageTransferElevatedButton() {
    return ElevatedButton(
      onPressed: () {
        final val = _viewModel.formKeyUserName.currentState!.validate();
        if (val) {
          _viewModel.formKeyUserName.currentState!.save();

          _viewModel.homePageController.animateToPage(
            1,
            duration: AppDuration.lowDuration,
            curve: Curves.easeIn,
          );
        }
      },
      child: joinPageTransferElevatedButtonText(),
    );
  }

  Widget joinPageTransferElevatedButtonText() {
    return Text(
      AppLocalizations.of(context)!.joinRoom,
    );
  }

  Widget createRoomOutlinedButton() {
    return OutlinedButton(
      onPressed: () async {
        final val = _viewModel.formKeyUserName.currentState!.validate();

        if (val) {
          _viewModel.formKeyUserName.currentState!.save();
          final isRoomCreated = await _viewModel.createRoom();
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

  Widget createRoomOutlinedButtonText() {
    return Text(
      AppLocalizations.of(context)!.createRoom,
    );
  }

  TextFormField userNameTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.textFieldUserName,
        border: const OutlineInputBorder(),
      ),
      onSaved: (newValue) {
        _viewModel.playerModel.userName = newValue;
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
      color: AppColor.transparentColor,
      child: Column(
        children: [
          howToJoinRoomText(),
          AppSize.mediumHeightSizedBox,
          howToJoinRoomPragText(),
        ],
      ),
    );
  }

  Widget howToJoinRoomPragText() {
    return Text(
      AppLocalizations.of(context)!.howtoJoinRoomParag,
      style: AppTheme.textStyle.headline6,
    );
  }

  Widget howToJoinRoomText() {
    return Text(
      AppLocalizations.of(context)!.howtoJoinRoom,
      style: AppTheme.textStyle.headline5,
    );
  }
}
