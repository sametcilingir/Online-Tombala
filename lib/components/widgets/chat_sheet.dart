import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tombala/core/extension/context_extension.dart';
import '../../core/app/size/app_size.dart';
import '../../core/app/theme/app_theme.dart';
import '../../core/locator/locator.dart';
import '../view_models/view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatBottomSheetWidget extends StatefulWidget {
  const ChatBottomSheetWidget({Key? key}) : super(key: key);

  @override
  State<ChatBottomSheetWidget> createState() => _ChatBottomSheetWidgetState();
}

class _ChatBottomSheetWidgetState extends State<ChatBottomSheetWidget> {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(_viewModel),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            messagesContainer(_viewModel),
            messageSendPadding(_viewModel),
            AppSize.lowHeightSizedBox
          ],
        ),
      ),
    );
  }

  AppBar appBar(ViewModel _viewModel) {
    return AppBar(
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      title: Text(
        AppLocalizations.of(context)!.chat,
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: openedChatIconButtonIcon(),
        )
      ],
    );
  }

  Padding messageSendPadding(ViewModel _viewModel) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.low),
      child: SizedBox(
        height: AppSize.high * 1.2,
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
    ViewModel _viewModel,
  ) {
    return ElevatedButton(
      onPressed: () async {
        final val = _viewModel.formKeyMessageWaiting.currentState!.validate();
        if (val && _viewModel.messageModel.messageText!.isNotEmpty) {
          _viewModel.formKeyMessageWaiting.currentState!.save();

          final isMassageSent = await _viewModel.sendMessage();

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

  Widget messagesContainer(ViewModel _viewModel) {
    return Observer(
      builder: (_) {
        return Container(
          height: context.height * 0.8,
          child: ListView.builder(
            itemCount: _viewModel.messageList!.length,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (context, index) => messageItem(_viewModel, index),
          ),
        );
      },
    );
  }

  Widget messageItem(ViewModel _viewModel, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSize.medium),
      child: ListTile(
        title: Text(
          _viewModel.messageList![index].messageText.toString(),
          style: AppTheme.textStyle.headline6,
        ),
        subtitle: Text(
          _viewModel.messageList![index].messageSenderName.toString(),
          style: AppTheme.textStyle.bodyText1,
        ),
      ),
    );
  }

  Icon openedChatIconButtonIcon() {
    return const Icon(
      Icons.close,
    );
  }
}
