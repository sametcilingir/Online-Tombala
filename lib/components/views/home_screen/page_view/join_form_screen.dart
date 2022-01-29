import 'package:flutter/material.dart';
import 'package:tombala/components/view_models/view_model.dart';
import 'package:tombala/components/widgets/snack_bar.dart';
import 'package:tombala/utils/constants/color_constants.dart';
import 'package:tombala/utils/constants/duration_constants.dart';
import 'package:tombala/utils/constants/size_constants.dart';
import 'package:tombala/utils/extension/color_extension.dart';
import 'package:tombala/utils/extension/context_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tombala/utils/extension/duration_extension.dart';
import 'package:tombala/utils/extension/size_extension.dart';
import 'package:tombala/utils/locator/locator.dart';
import 'package:tombala/utils/routes/routes.dart';
import 'package:tombala/utils/theme/app_theme.dart';

class JoinFormScreen extends StatelessWidget {
  const JoinFormScreen({Key? key}) : super(key: key);

  ViewModel get _viewModel => locator<ViewModel>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: context.paddingLow,
        child: joinForm( context),
      ),
    );
  }

  Form joinForm(BuildContext context) {
    return Form(
      key: _viewModel.formKeyJoin,
      child: Column(
        children: [
          howToTextContainer(context),
          SizeConstants().mediumHeight,
          roomCodeTextformField(context),
          SizeConstants().mediumHeight,
          joinRoomElevatedButton(context),
          backToLoginPageViewTextButton(context),
        ],
      ),
    );
  }

  TextButton backToLoginPageViewTextButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        _viewModel.homePageController.animateToPage(
          0,
          duration: DurationConstants().durationLow,
          curve: Curves.easeIn,
        );
      },
      child: backToLoginPageViewTextButtonText(context),
    );
  }

  Text backToLoginPageViewTextButtonText(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.back,
      style: AppTheme().button,
    );
  }

  ElevatedButton joinRoomElevatedButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          _viewModel.formKeyJoin.currentState!.save();

          final isJoined = await _viewModel.joinRoom();
          if (isJoined) {
            //_viewModel.createGameCard();
            Navigator.of(context).pushNamed(Routes.waitingRoom);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              snackBar(
                Colors.red,
                AppLocalizations.of(context)!.cantJoinRoom,
              ),
            );
          }
        },
        child: joinRoomElevatedButtonText(context));
  }

  Text joinRoomElevatedButtonText(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.joinRoom,
      style: AppTheme().button,
    );
  }

  TextFormField roomCodeTextformField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.gameCode,
        border: const OutlineInputBorder(),
      ),
      onSaved: (newValue) {
        _viewModel.roomModel.roomCode = newValue!;
      },
    );
  }

  Container howToTextContainer(BuildContext context) {
    return Container(
      color: ColorConstants().transparentColor,
      child: Column(
        children: [
          howToPlayText(context),
          SizeConstants().mediumHeight,
          howToPlayTextParag(context),
          SizeConstants().mediumHeight,
        ],
      ),
    );
  }

  Text howToPlayTextParag(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.howToPlayParag,
      style: AppTheme().headline6,
    );
  }

  Text howToPlayText(BuildContext context) {
    return Text(AppLocalizations.of(context)!.howToPlay,
        style: AppTheme().headline5);
  }
}
