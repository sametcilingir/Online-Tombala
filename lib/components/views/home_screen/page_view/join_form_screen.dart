import 'package:flutter/material.dart';
import '../../../../core/app/color/app_color.dart';
import '../../../../core/app/duration/app_duration.dart';
import '../../../../core/app/size/app_size.dart';
import '../../../../core/app/theme/app_theme.dart';
import '../../../../core/extension/context_extension.dart';
import '../../../../core/locator/locator.dart';
import '../../../../core/routes/routes.dart';
import '../../../view_models/view_model.dart';
import '../../../widgets/snack_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          AppSize.mediumHeightSizedBox,
          roomCodeTextformField(context),
          AppSize.mediumHeightSizedBox,
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
          duration: AppDuration.lowDuration,
          curve: Curves.easeIn,
        );
      },
      child: backToLoginPageViewTextButtonText(context),
    );
  }

  Text backToLoginPageViewTextButtonText(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.back,
      style: AppTheme.button,
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
      style: AppTheme.button,
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
      color: AppColor.transparentColor,
      child: Column(
        children: [
          howToPlayText(context),
          AppSize.mediumHeightSizedBox,
          howToPlayTextParag(context),
          AppSize.mediumHeightSizedBox,
        ],
      ),
    );
  }

  Text howToPlayTextParag(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.howToPlayParag,
      style: AppTheme.headline6,
    );
  }

  Text howToPlayText(BuildContext context) {
    return Text(AppLocalizations.of(context)!.howToPlay,
        style: AppTheme.headline5);
  }
}
