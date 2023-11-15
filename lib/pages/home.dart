import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchField(),
          SizedBox(height: 40,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Category',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                height: 150,
                color: Colors.green,
                child: ListView.builder(itemBuilder: (context, index) {

                }),
              )
            ],
          )
        ],
      ),
    );
  }

  Container _searchField() {
    return Container(
          margin: EdgeInsets.only(top: 40, left: 20, right: 20),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Color(0xff1D1617).withOpacity(0.11),
              blurRadius: 40,
              spreadRadius: 0.0,
            )
          ]),
          child: TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(15),
                hintText: 'Search Cocktail',
                hintStyle: TextStyle(
                  color: Color(0xffDDDADA)
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                /*         suffixIcon: Container(
                  width: 80,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        VerticalDivider(
                          color: Colors.black,
                          indent: 10,
                          endIndent: 10,
                          thickness: 0.1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.filter_alt_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),*/
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none)),
          ),
        );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Cocktails',
        style: TextStyle(
            color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: GestureDetector(
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 24.0,
          ),
        ),
      ),
    );
  }
}
