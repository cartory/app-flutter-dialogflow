import 'package:flutter/material.dart';

import 'package:app_dialog/views/product/produc_list.dart';
import 'package:app_dialog/providers/speech_provider.dart';
import 'package:app_dialog/providers/dialog_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final snackBar = SnackBar(
    backgroundColor: Colors.white70,
    duration: Duration(seconds: 50),
    content: StreamBuilder(
        stream: SpeechRecognizer.instance.dataStream,
        builder: (_, AsyncSnapshot<SpeechData> snapshot) {
          return Text(
            snapshot.data?.text ?? 'Esperando voz...',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.right,
          );
        }),
  );

  @override
  void initState() {
    super.initState();
    VoiceReader.instance.speak('Bienvenido');
    this.addListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Speech to Text App'),
        centerTitle: true,
      ),
      body: _currentWidget(_selectedIndex),
      bottomNavigationBar: _bottomAppBar(),
    );
  }

  Widget _bottomAppBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          title: Text('Productos'),
        ),
        BottomNavigationBarItem(
          icon: FloatingActionButton(
            backgroundColor: Colors.deepPurpleAccent,
            child: Icon(Icons.mic),
            onPressed: () {
              SpeechRecognizer.instance.speechToText();
              scaffoldKey.currentState.showSnackBar(snackBar);
            },
          ),
          title: Container(),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text('Promociones'),
        ),
      ],
    );
  }

  Widget _currentWidget(int index) {
    if (index == 0) {
      return ProductList.instance;
    }
    if (index == 2) {
      return ProductListQuery.instance;
    }
    return Container();
  }

  _onItemTapped(int index) {
    if (index == 1) return;
    setState(() => _selectedIndex = index);
  }

  void addListeners() {
    DialogProvider.instance.dialogStream.listen((res) {
      setState(() {
        if (res.action == 'promo') {
          _selectedIndex = 2;
        }
        if (res.action == 'list') {
          _selectedIndex = 0;
        }
      });
    });
    SpeechRecognizer.instance.dataStream.listen((data) {
      if (!data.status) {
        DialogProvider.instance.makeQuery(data.text);
        data.status = true;
        SpeechRecognizer.instance.dataSink(data);
        scaffoldKey.currentState.removeCurrentSnackBar();
      }
    });
  }

  @override
  void dispose() {
    VoiceReader.instance.dispose();
    DialogProvider.instance.dispose();
    SpeechRecognizer.instance.dispose();
    super.dispose();
  }
}
