import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//void main() => runApp(new MyApp());
void main() => runApp(new SampleApp());
/*void main() =>
    runApp(new MaterialApp(
      home: new MyApp(),
      *//*Flutter不具有Intents的概念，如果需要的话，Flutter可以通过Native整合来触发Intents
  * 要在Flutter中切换屏幕，您可以访问路由以绘制新的Widget，管理多个屏幕有两个核心概念和类：
  * Route和Navigator，Route是应用程序的“屏幕”或者“页面”的抽象（可以认为是activity），
  * Navigator是管理Route的Widget。Navigator可以通过push和pop route以实现页面切换
  *
  * 通过Navigator来切换到命名路由的页面
  * Navigator.of(context).pushNamed('/b');
  * Intents另一个用途是调用外部组件，如Camera或File picker，为此，您需要和native集成（或使用现有的库），
  * *//*
      routes: <String, WidgetBuilder>{
        '/a': (BuildContext context) => new RandomWordsPage(title: "随机英文列表"),
        '/b': (BuildContext context) => new ChangeTextPage(title: "改变文字"),
        '/c': (BuildContext context) =>
        new SwithDemoPage(title: "两个widget之间切换"),
      },
    ));*/
/*绘制到画布*/
//void main() => runApp(new MaterialApp(home: new DemoApp(),));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(primaryColor: Colors.deepPurpleAccent),
      /*随机英文列表*/
//      home: new RandomWordsPage(title: "随机英文列表"),
      /*改变文字*/
//      home: new ChangeTextPage(title:"改变文字"),
      /*两个widget 切换*/
//      home: new SwithDemoPage(title: "两个widget之间切换"),
      /*淡入淡出logo*/
      home: new FadeLogoPage(title: '淡入淡出的logo'),
      /*绘制到画布*/
//      home: new DemoApp(),
    );
  }

/*  @override
  Widget build(BuildContext context) {
//    final wordPair = new WordPair.random();
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome to Flutter'),
        ),
        body: new Center(
//          child: new Text('Hello World'),
//          child: new Text(wordPair.asPascalCase),
          child: new RandomWordsPage(),
        ),
      ),
    );
  }*/
}

/*随机英文生成器*/
class RandomWordsPage extends StatefulWidget {
  final String title;

  RandomWordsPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new RandomWordsPageState();
}

class RandomWordsPageState extends State<RandomWordsPage> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final tiles = _saved.map((pair) {
        return new ListTile(
          title: new Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final divided =
      ListTile.divideTiles(tiles: tiles, context: context).toList();
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Saved Suggestions'),
        ),
        body: new ListView(children: divided),
      );
    }));
  }
}

/*按下，淡入淡出的logo*/
class FadeLogoPage extends StatefulWidget {
  final String title;

  FadeLogoPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _FadeLogoPage();
}

class _FadeLogoPage extends State<FadeLogoPage> with TickerProviderStateMixin {
  AnimationController controller;
  CurvedAnimation curve;

  @override
  void initState() {
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    curve = new CurvedAnimation(parent: controller, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Center(
            child: new Container(
                child: new FadeTransition(
                    opacity: curve,
                    child: new FlutterLogo(
                      size: 100.0,
                    )))),
        floatingActionButton: new FloatingActionButton(
          tooltip: 'Fade',
          child: new Icon(Icons.brush),
          onPressed: () {
            controller.forward();
          },
        ));
  }
}

/*改变文字*/
class ChangeTextPage extends StatefulWidget {
  String title;

  ChangeTextPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ChangeTextPageState();
}

class _ChangeTextPageState extends State<ChangeTextPage> {
  String textShow = "I Like Flutter";

  void _updateText() {
    setState(() {
      textShow = "Flutter is Awesome!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Text(textShow),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _updateText,
        tooltip: 'Update Text',
        child: new Icon(Icons.update),
      ),
    );
  }
}

/*两个widget之间切换*/
class SwithDemoPage extends StatefulWidget {
  String title;

  SwithDemoPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _SwithDemoPageState();
}

class _SwithDemoPageState extends State<SwithDemoPage> {
  bool toggle = true;

  void _toggle() {
    setState(() {
      toggle = !toggle;
    });
  }

  _getToggleChild() {
    if (toggle) {
      return new Text('Toggle One');
    } else {
      return new MaterialButton(
        onPressed: () {},
        child: new Text('Toggle Two'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: _getToggleChild(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _toggle,
        tooltip: 'Update Text',
        child: new Icon(Icons.update),
      ),
    );
  }
}

/*绘制自定义形状 绘制到画布*/
class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points);

  final List<Offset> points;

  void paint(Canvas canvas, Size size) {
    var paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null)
        canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  bool shouldRepaint(SignaturePainter other) => other.points != points;
}

class Signature extends StatefulWidget {
  SignatureState createState() => new SignatureState();
}

class SignatureState extends State<Signature> {
  List<Offset> _points = <Offset>[];

  Widget build(BuildContext context) {
    return new GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          RenderBox referenceBox = context.findRenderObject();
          Offset localPosition =
          referenceBox.globalToLocal(details.globalPosition);
          _points = new List.from(_points)
            ..add(localPosition);
        });
      },
      onPanEnd: (DragEndDetails details) => _points.add(null),
      child: new CustomPaint(painter: new SignaturePainter(_points)),
    );
  }
}

class DemoApp extends StatelessWidget {
  Widget build(BuildContext context) => new Scaffold(body: new Signature());
}

/*自定义widget*/
//在Flutter中，一个自定义的widget通常是组合其他的widget来实现的，而不是继承，
class CustomButton extends StatelessWidget {
  final String label;

  CustomButton(this.label);

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      onPressed: () {},
      child: new Text(label),
    );
  }
}
/*如何在Flutter中处理来自外部应用程序传入的Intents*/
class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample Shared App Handler',
      theme: new ThemeData(
          primarySwatch: Colors.blue
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) :super(key: key);

  @override
  State<StatefulWidget> createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  static const platform = const MethodChannel('app.channel.shared.data');
  String dataShared = 'No data';

  @override
  void initState() {
    super.initState();
    getShareText();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: new Center(child: new Text(dataShared),),);
  }

  void getShareText() async {
    var sharedData = await platform.invokeMethod("getSharedText");
    if (sharedData != null) {
      setState(() {
        dataShared = sharedData;
      });
    }
  }
}