import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:restaraunt_app/restaurant_list.dart';

// Creates the search page where the user can search a restaurant
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.position}) : super(key: key);
  final Position position;
  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> with AutomaticKeepAliveClientMixin {
  bool complete = false;
  Widget list = Column();

  // Required for the AutomaticKeepAliveClientMixin which allows the user to 
  // navigate between the other pages and retain the page at the same state/
  // location
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: const Color(0xFFFFF3E0),

        appBar: PreferredSize(
            child: AppBar(
              title: const Align(
                alignment: Alignment.center,
                child:Text(
                  "Search",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Sora')
                  )),
                  elevation: 0.0,
              backgroundColor: Colors.transparent,
            ),
            preferredSize: const Size.fromHeight(50.0)),

        // Container for the 
        body: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextField(
                    controller: TextEditingController(),
                    textAlignVertical: TextAlignVertical.center,

                    // On completion of input the, search results are retrieved
                    onSubmitted: ((value) => {
                      complete = !complete,

                      if (complete == true) {
                        setState(() {
                          list = RestaurantListWidget(
                              position: widget.position,
                              listType: 2,
                              search: value
                            );
                        }),
                      } else {
                        setState(() {
                          list = Column(); 
                        }),
                      },
                    }),

                    style: const TextStyle(fontSize: 14),

                    // Input field for search
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
            // Search results 
            Expanded(child: list)
          ],
        ));
  }
}
