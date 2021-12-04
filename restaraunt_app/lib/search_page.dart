import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:restaraunt_app/listview.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.position}) : super(key: key);
  final Position position;
  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> with AutomaticKeepAliveClientMixin {
  bool complete = false;
  Widget list = Column();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
            ),
            preferredSize: const Size.fromHeight(25.0)),
        body: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextField(
                    controller: TextEditingController(),
                    textAlignVertical: TextAlignVertical.center,
                    onSubmitted: ((value) => {
                      complete = !complete,
                      print(complete),
                      if (complete == true) {
                        setState(() {
                          list = ListViewWidget(
                              position: widget.position, listType: 2, search: value);
                        }),
                      } else {
                        setState(() {
                          list = Column(); 
                        }),
                      },
                    }),
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: "Enter restaurant name",
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      )),
                    ))),
            Expanded(child: list)
          ],
        ));
  }

  void getList(String search) {
    print(search + " $complete");

    if (complete == true) {
      setState(() {
        list = ListViewWidget(
            position: widget.position, listType: 2, search: search);
      });
    } else {
      setState(() {
        list = Column();
      });
    }
    complete = !complete;
  }

  @override
  bool get wantKeepAlive => true;
}
