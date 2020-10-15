import 'package:flumould/app/app_repository.dart';
import 'package:flumould/app/app_route.dart';
import 'package:flumould/app/state/app_bloc.dart';
import 'package:flumould/common/common_service.dart';
import 'package:flumould/common/dialog.dart';
import 'package:flumould/models/app_user.dart';
import 'package:flumould/page/percent_show/percent_show.dart';
import 'package:flumould/theme/model/theme_model.dart';
import 'package:flumould/theme/state/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
import 'package:flutter_i18n/loaders/local_translation_loader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppRepository().getAppConfig().then((value) => runApp(MyApp(value)));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Config _config;

  MyApp(this._config);

  AppBloc appBloc;
  ThemeBloc themeBloc;
  AppRepository appRepository = AppRepository();
  @override
  Widget build(BuildContext context) {
    appBloc = new AppBloc(appRepository);
    themeBloc = new ThemeBloc(ThemeModel.mapStringToThmemeModel(_config.theme));
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => appBloc),
        BlocProvider(create: (context) => themeBloc),
      ],
      child: RefreshConfiguration(
          //配置下拉刷新 上拉加载框架的统一风格
          // headerBuilder: () =>
          // MyWaterDropHeader(), // 配置默认头部指示器,假如你每个页面的头部指示器都一样的话,你需要设置这个
//            footerBuilder:  () => ClassicFooter(
//
//              idleText: "上拉加载",
//              loadingText: "正在加载",
//              noDataText: "没有更多了",
//              outerBuilder: (child) {
//
//                return Container(
//                  width: 80.0,
//                  child: Center(
//                    child: child,
//                  ),
//                );
//              },
//            ),        // 配置默认底部指示器
          springDescription: SpringDescription(
              stiffness: 170,
              damping: 16,
              mass: 1.9), // 自定义回弹动画,三个属性值意义请查询flutter api
          maxOverScrollExtent: 100, //头部最大可以拖动的范围,如果发生冲出视图范围区域,请设置这个属性
          maxUnderScrollExtent: 0, // 底部最大可以拖动的范围
          enableScrollWhenRefreshCompleted:
              true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
          enableLoadingWhenFailed: true, //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
          hideFooterWhenNotFull: false, // Viewport不满一屏时,禁用上拉加载更多功能
          enableBallisticLoad: true, // 可以通过惯性滑动触发加载更多
          child: MaterialApp(
            title: 'Flutter Demo',
            onGenerateRoute: AppRoute(appBloc).onGenerateRoute,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: MyHomePage(),
            localizationsDelegates: [
              FlutterI18nDelegate(
                translationLoader: FileTranslationLoader(
                    useCountryCode: false,
                    decodeStrategies: [JsonDecodeStrategy()],
                    fallbackFile: 'en',
                    basePath: 'i18n',
                    forcedLocale: Locale('ch')),
              ),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
          )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<AppBloc>(context).add(InitEvent());
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return Scaffold(
              appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text(
                  FlutterI18n.translate(context, "title"),
                  style: TextStyle(
                      color: BlocProvider.of<ThemeBloc>(context)
                          .state
                          .themeModel
                          .appBarTitleTxtColor),
                ),
                backgroundColor: BlocProvider.of<ThemeBloc>(context)
                    .state
                    .themeModel
                    .appBarBgColor,
              ),
              body: getContentByAppState(state),
              backgroundColor: BlocProvider.of<ThemeBloc>(context)
                  .state
                  .themeModel
                  .appBarBgColor,
            );
          },
        );
      },
    );
  }

  Widget getContentByAppState(AppState state) {
    if (state is AppInitial) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      );
    } else if (state is AppInitSuc) {
      return Center(
        child: getSuccessContent(),
      );
    } else if (state is AppInitial) {
      return Center(
        child: GestureDetector(
          child: Text("启动失败，点击重试"),
          onTap: () {
            BlocProvider.of<AppBloc>(context).add(InitEvent());
          },
        ),
      );
    }
  }

  Widget getSuccessContent() {
    return Column(
      children: [
        RaisedButton(
          child: Text(
            "listview",
            style: TextStyle(
                color: BlocProvider.of<ThemeBloc>(context)
                    .state
                    .themeModel
                    .normalTxtColor),
          ), //下拉刷新 上滑自动加载
          onPressed: () {
            Navigator.of(context).pushNamed('listview');
          },
        ),
        FlatButton(
          child: Text(FlutterI18n.translate(context, "changeTheme"),
              style: TextStyle(
                  color: BlocProvider.of<ThemeBloc>(context)
                      .state
                      .themeModel
                      .normalTxtColor)),
          onPressed: () async {
            int result = await changeTheme();
            if (result != null) {
              BlocProvider.of<ThemeBloc>(context).add(ChangeThemeEvent(result));
              Config config = await AppRepository().getAppConfig();
              config.theme = result;
              AppRepository().saveConfigs(config);
              DialogUtil.showSuccessToast(context, text: "修改主题成功");
            }
          },
        ),
        OutlineButton(
          child: Text(FlutterI18n.translate(context, "changeLanguage")),
          onPressed: () async {
            int result = await changeLanguage();
            if (result != null) {
              await FlutterI18n.refresh(
                  context, Locale(result == 1 ? "ch" : "en"));
              DialogUtil.showSuccessToast(context, text: "修改语言成功");
              setState(() {});
            }
          },
        ),
        RaisedButton(
          onPressed: () {
            DialogUtil.showShortToastAlignCenter("我是吐司");
          },
          child: Text("吐司"),
        ),
        RaisedButton(
          onPressed: () {
            DialogUtil.showProgressDialog(context, "加载中");
          },
          child: Text("加载框"),
        ),
        RaisedButton(
          onPressed: () {
            DialogUtil.showSuccessToast(context);
          },
          child: Text("操作成功提示"),
        ),
        RaisedButton(
          onPressed: () {
            DialogUtil.shoFailToast(context);
          },
          child: Text("操作失败提示"),
        ),
        PercentShow(),
      ],
    );
  }

  Future<int> changeTheme() async {
    return await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('请选择主题'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  // 返回1
                  Navigator.pop(context, 1);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text('亮色'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  // 返回2
                  Navigator.pop(context, 2);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text('暗色'),
                ),
              ),
            ],
          );
        });
  }

  Future<int> changeLanguage() async {
    return await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('请选择语言'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  // 返回1
                  Navigator.pop(context, 1);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text('中文'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  // 返回2
                  Navigator.pop(context, 2);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text('英文'),
                ),
              ),
            ],
          );
        });
  }
}
