import 'package:flutter/material.dart';

class NoInternet extends StatefulWidget {

  final Function retry;

  const NoInternet({super.key, required this.retry});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFBAA9DB),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 128,
            width: 128,
            child: Image.asset('assets/img/no-wifi.png'),
          ),
          const SizedBox(height: 20),
          Text(
            'No internet connection',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: 'Karla',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Directionality(
            textDirection: TextDirection.ltr,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.retry();
                });
              },
              child: Text(
                '💣 Try again',
                style: TextStyle(fontSize: 20, fontFamily: 'Karla'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
