import 'package:catapp_test/cat.dart';
import 'package:catapp_test/imagemodel.dart';
import 'package:catapp_test/service.dart';
import 'package:flutter/material.dart';

void main() {
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
      //home: MyHomePage(title: 'Flutter Cat Test Project'),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Flutter Cat Test Project'),
        '/detail': (context) => DetailCat(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<List<Cat>> cat = CatService.getListCat();

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    CatService.getListCat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.greenAccent,
              ),
              onPressed: () {
                setState(() {

                });
              })
        ],
      ),
      body: FutureBuilder(
          future: cat,
          builder: (context, AsyncSnapshot<List<Cat>> snapshot) {
            List<String> list_cat_name = [];
            List<String> list_cat_weight = [];
            List<String> list_cat_img_url = [];
            List<String> list_cat_description = [];
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                snapshot.data.forEach((Cat cat_data) {
                  list_cat_name.add(cat_data.name);
                  list_cat_weight.add(cat_data.weight.imperial);
                  list_cat_description.add(cat_data.description);
                  if (cat_data.image != null) {
                    list_cat_img_url.add(cat_data.image.url);
                  } else {
                    list_cat_img_url.add(
                        "https://png.pngtree.com/element_our/20200610/ourmid/pngtree-not-found-image_2238448.jpg");
                  }
                });
              }
              print(list_cat_name.length);

              return ListView.builder(
                itemCount: list_cat_name.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            //_showMyDialog();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailCat(),
                                  settings: RouteSettings(
                                    arguments: [
                                      list_cat_description[index],
                                      list_cat_img_url[index],
                                      list_cat_name[index]
                                    ],
                                  ),
                                ));
                          },
                          child: Column(
                            children: [
                              Image.network(
                                list_cat_img_url[index],
                                width: 300,
                                height: 200,
                              ),
                              Text("Name Cat : " + list_cat_name[index]),
                              Text("Weight : " +
                                  list_cat_weight[index] +
                                  " lb."),
                              Text(
                                list_cat_description[index],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Container(
                  child: Text(
                    "Service Error " + '${snapshot.error}',
                    style: TextStyle(fontSize: 40.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          }),
    );
  }
}

//class _Mylistwidget extends StatelessWidget{
//  final Future<List<Cat>> cat = CatService.getListCat();
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: new ListView.builder(
//          itemCount: 0,
//          itemBuilder: (BuildContext context,int index){
//            return Container(
//              child: ,
//            );
//          },
//      ),
//    );
//  }
//}

class DetailCat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> detail = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat Detail'),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.network(
                  detail[1],
                  width: 350,
                  height: 300,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Cat Name : " + detail[2]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(detail[0]),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  color: Colors.blue,
                  child: Text(
                    'Back',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
