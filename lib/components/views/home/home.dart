import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:tombala/components/widgets/snack_bar.dart';
import '../../../utils/routes/routes.dart';
import '../../view_models/view_model.dart';
import '../../../utils/locator/locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ViewModel _viewModel = locator<ViewModel>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Future.sync(() {
              _viewModel.homePageController.animateToPage(
                0,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
              );
              return false;
            }),
        child: Observer(
          builder: (_) {
            return LoadingOverlay(
              color: Colors.grey[200],
              opacity: 0.6,
              progressIndicator: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              isLoading: _viewModel.viewState == ViewState.Busy,
              child: Scaffold(
                  appBar: AppBar(
                    leading: TextButton(
                      child: Text(_viewModel.isENLocal ? "TR" : "EN"),
                      onPressed: () {
                        _viewModel.isENLocal = !_viewModel.isENLocal;
                      },
                    ),
                    elevation: 0,
                    title: Text(
                      'Online Tomabala',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    centerTitle: true,
                    actions: [
                      IconButton(
                        icon: Icon(_viewModel.isDarkModel
                            ? Icons.dark_mode
                            : Icons.light_mode),
                        onPressed: () {
                          _viewModel.isDarkModel = !_viewModel.isDarkModel;
                        },
                      ),
                    ],
                  ),
                  body: Center(
                    child: Container(
                      width: 400,
                      child: PageView(
                        allowImplicitScrolling: true,
                        controller: _viewModel.homePageController,
                        //allowImplicitScrolling: false,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          LoginFormWidget(viewModel: _viewModel),
                          JoinFormWidget(viewModel: _viewModel),
                        ],
                      ),
                    ),
                  )),
            );
          },
        ));
  }
}

class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({
    Key? key,
    required ViewModel viewModel,
  })  : _viewModel = viewModel,
        super(key: key);

  final ViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _viewModel.formKeyUserName,
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              height: 350,
              child: Column(
                children: [
                  Text("Nasıl Odaya girebilirim ?",
                      style: Theme.of(context).textTheme.headline5),
                  SizedBox(height: 20),
                  Text(
                    "Oda oluşturmak için kullanıcı adınızı girdikten sonra 'Oda Oluştur' butonuna basınız" +
                        "\n" +
                        "\nOdaya girmek için kullanıcı adınızı girdikten sonra 'Odaya Gir' butonuna basınız.\nYeni gelen ekranda size verilen oyun kodunu girip tekrardan 'Odaya Gir' butonuna basınız.",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "",
                labelText: AppLocalizations.of(context)!.textFieldUserName,
                border: OutlineInputBorder(),
              ),
              onSaved: (newValue) {
                _viewModel.playerModel.userName = newValue!;
              },
              validator: (value) {
                if (value == "") {
                  return AppLocalizations.of(context)!.textFieldError;
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                    onPressed: () async {
                      var val =
                          _viewModel.formKeyUserName.currentState!.validate();
                      if (val) {
                        _viewModel.formKeyUserName.currentState!.save();

                        bool isRoomCreated = await _viewModel.createRoom();

                        if (isRoomCreated) {
                          //_viewModel.createGameCard();
                          Navigator.of(context).pushNamed(Routes.waitingRoom);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBarWidget(
                                      color: Colors.red,
                                      message: AppLocalizations.of(context)!
                                          .cantCreateRoom)
                                  .snackBar);
                        }
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.createRoom,
                      style: Theme.of(context).textTheme.button,
                    )),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    var val =
                        _viewModel.formKeyUserName.currentState!.validate();
                    if (val) {
                      _viewModel.formKeyUserName.currentState!.save();

                      _viewModel.homePageController.animateToPage(
                        1,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.joinRoom,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

class JoinFormWidget extends StatelessWidget {
  const JoinFormWidget({
    Key? key,
    required ViewModel viewModel,
  })  : _viewModel = viewModel,
        super(key: key);

  final ViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 300,
          child: Form(
            key: _viewModel.formKeyJoin,
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  height: 450,
                  child: Column(
                    children: [
                      Text("Nasıl Oynanır ?",
                          style: Theme.of(context).textTheme.headline5),
                      SizedBox(height: 20),
                      Text(
                        "Oyun kurucu oyunu başlattıktan sonra size için kart oluşturulacaktır." +
                            "\n" +
                            "\n" +
                            "Çekilen sayı ile karınızdaki sayı eşleştiğinde, katınızdaki sayıya tıklayıp aktive edin." +
                            "\n" +
                            "\n" +
                            "Her bir sütündaki tüm sayılar aktive edilmiş ise sağ alt kösedeki 'Çinko ilan et' butonuna tıklayarak kazandığınızı herkese duyurun." +
                            "\n" +
                            "\n" +
                            "Odaya girmek için kullanıcı adınızı girdikten sonra 'Odaya Gir' butonuna basınız",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '',
                    labelText: AppLocalizations.of(context)!.gameCode,
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (newValue) {
                    _viewModel.roomModel.roomCode = newValue!;
                    //kavyeyi kapatıyor
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      _viewModel.formKeyJoin.currentState!.save();

                      final isJoined = await _viewModel.joinRoom();
                      if (isJoined) {
                        //_viewModel.createGameCard();
                        Navigator.of(context).pushNamed(Routes.waitingRoom);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBarWidget(
                          color: Colors.red,
                          message: AppLocalizations.of(context)!.cantJoinRoom,
                        ).snackBar);
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.joinRoom,
                      style: Theme.of(context).textTheme.button,
                    )),
                TextButton(
                  onPressed: () {
                    _viewModel.homePageController.animateToPage(
                      0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.back,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}