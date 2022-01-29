import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tombala/components/view_models/view_model.dart';
import 'package:tombala/utils/constants/size_constants.dart';
import 'package:tombala/utils/locator/locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tombala/utils/theme/app_theme.dart';

class ChatBommSheetWidget extends StatefulWidget {
  const ChatBommSheetWidget({Key? key}) : super(key: key);

  @override
  State<ChatBommSheetWidget> createState() => _ChatBommSheetWidgetState();
}

class _ChatBommSheetWidgetState extends State<ChatBommSheetWidget> {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          openedChatIconButton(_viewModel),
          messagesContainer(_viewModel),
          messageSendPadding(_viewModel),
        ],
      ),
    );
  }

  Padding messageSendPadding(ViewModel _viewModel) {
    return Padding(
      padding: EdgeInsets.all(SizeConstants().low),
      child: SizedBox(
        height: SizeConstants().high,
        width: double.infinity,
        child: messageSendForm(_viewModel),
      ),
    );
  }

  Form messageSendForm(ViewModel _viewModel) {
    return Form(
      key: _viewModel.formKeyMessageWaiting,
      child: messageSendTextFormField(_viewModel),
    );
  }

  TextFormField messageSendTextFormField(ViewModel _viewModel) {
    return TextFormField(
      controller: _viewModel.messageControllerWaiting,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: AppLocalizations.of(context)!.message,
        border: OutlineInputBorder(
          borderSide: const BorderSide(),
          borderRadius: BorderRadius.circular(8),
        ),
        suffix: messageSendTextFormFiedSuffixElevatedButton(_viewModel),
      ),
      validator: (val) {
        if (val!.isEmpty) {
        } else if (val.length.isNaN) {
        } else {}
      },
      onChanged: (value) {
        _viewModel.messageModel.messageText = value;
      },
    );
  }

  ElevatedButton messageSendTextFormFiedSuffixElevatedButton(
      ViewModel _viewModel) {
    return ElevatedButton(
      onPressed: () async {
        var val = _viewModel.formKeyMessageWaiting.currentState!.validate();
        if (val && _viewModel.messageModel.messageText!.isNotEmpty) {
          _viewModel.formKeyMessageWaiting.currentState!.save();

          bool isMassageSent = await _viewModel.sendMessage();

          if (isMassageSent) {
            _viewModel.messageModel.messageText = "";
            _viewModel.messageControllerWaiting!.clear();
          }
        }
      },
      child: messageSendTextFormFiedSuffixElevatedButtonText(_viewModel),
    );
  }

  Text messageSendTextFormFiedSuffixElevatedButtonText(ViewModel _viewModel) =>
      Text(AppLocalizations.of(context)!.send);

  Container messagesContainer(ViewModel _viewModel) {
    return Container(
      height: 310,
      child: Observer(builder: (_) {
        return ListView.builder(
          itemCount: _viewModel.messageList!.length,
          addAutomaticKeepAlives: true,
          shrinkWrap: true,
          reverse: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) =>
              messageItemPadding(_viewModel, index),
        );
      }),
    );
  }

  Padding messageItemPadding(ViewModel _viewModel, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          _viewModel.messageList![index].messageText.toString(),
          style: AppTheme().headline6,
        ),
        subtitle: Text(
          _viewModel.messageList![index].messageSenderName.toString(),
          style: AppTheme().bodyText1,
        ),
      ),
    );
  }

  IconButton openedChatIconButton(ViewModel _viewModel) {
    return IconButton(
      onPressed: () {
        _viewModel.isChatOpen = false;
        Navigator.of(context).pop();
      },
      icon: openedChatIconButtonIcon(),
    );
  }

  Icon openedChatIconButtonIcon() {
    return const Icon(
      Icons.close,
    );
  }
}
