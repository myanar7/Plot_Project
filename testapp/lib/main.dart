import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'mobile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Report Information'),
        // When navigating to the "/" route, build the FirstScreen widget.
        '/first': (context) => FirstScreen(title: 'Report Information'),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/second': (context) => const SecondScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String valueOfDrop = "";
  List valuesOfDropDown = ["Ayhan", "Ertugrul", "Elif", "Civan", "Musmafa"];
  @override
  void initState() {
    super.initState();
    valueOfDrop = valuesOfDropDown[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton(
                hint: Text("Hello"),
                value: valueOfDrop,
                onChanged: (newValue) {
                  setState(() {
                    valueOfDrop = newValue.toString();
                  });
                },
                items: valuesOfDropDown.map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/first');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    PdfGrid grid = PdfGrid();

    grid.columns.add(count: 3);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = valueOfDrop;

    PdfGridRow row = grid.rows.add();
    row.cells[0].value = valueOfDrop;
    grid.style = PdfGridStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 30),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));
    grid.draw(
        // Türkçe Karakter sorunu çıkıyor
        page: document.pages.add(),
        bounds: const Rect.fromLTWH(0, 0, 0, 0));

    List<int> bytes = document.save();
    document.dispose();

    saveAndLaunchFile(bytes, "Output.pdf");
  }

  _addData() {
    Map<String, dynamic> demoData = {
      "name": "$valueOfDrop",
      "city": "Istanbul"
    };
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("data");
    collectionReference.add(demoData);
    _fetchData();
  }

  _fetchData() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("data");
    collectionReference.snapshots().listen((snapshot) {
      // Snapshot olunca listener olayı mevcut değiştikçe burası aktif oluyor
      print(snapshot.docs[0].data());
    });
  }

  _deleteData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("data");
    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs[0].reference
        .delete(); // burada reference ile silme işlemi yapılabilir
  }

  _updateData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("data");
    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs[0].reference.update({
      "name": "$valueOfDrop",
      "city": "Istanbul"
    }); // burada reference ile silme işlemi yapılabilir
  }
}

class FirstScreen extends StatefulWidget {
  FirstScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  String valueOfDrop = "";
  List valuesOfDropDown = ["Ayhan", "Ertugrul", "Elif", "Civan", "Musmafa"];
  @override
  void initState() {
    super.initState();
    valueOfDrop = valuesOfDropDown[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton(
                hint: Text("Hello"),
                value: valueOfDrop,
                onChanged: (newValue) {
                  setState(() {
                    valueOfDrop = newValue.toString();
                  });
                },
                items: valuesOfDropDown.map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPDF,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    PdfGrid grid = PdfGrid();

    grid.columns.add(count: 3);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = valueOfDrop;

    PdfGridRow row = grid.rows.add();
    row.cells[0].value = valueOfDrop;
    grid.style = PdfGridStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 30),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));
    grid.draw(
        // Türkçe Karakter sorunu çıkıyor
        page: document.pages.add(),
        bounds: const Rect.fromLTWH(0, 0, 0, 0));

    List<int> bytes = document.save();
    document.dispose();

    saveAndLaunchFile(bytes, "Output.pdf");
  }

  addData() {
    Map<String, dynamic> demoData = {
      "name": "$valueOfDrop",
      "city": "Istanbul"
    };
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("data");
    collectionReference.add(demoData);
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first screen when tapped.
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
