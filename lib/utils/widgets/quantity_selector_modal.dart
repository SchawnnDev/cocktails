import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuantitySelectorModal extends StatefulWidget {
  final int defaultQuantity;
  final Function(int) onSelected;

  const QuantitySelectorModal({super.key, required this.defaultQuantity, required this.onSelected});

  @override
  _QuantitySelectorModalState createState() => _QuantitySelectorModalState();
}

class _QuantitySelectorModalState extends State<QuantitySelectorModal> {
  int selectedQuantity = 1;
  FixedExtentScrollController fixedExtentScrollController =
      FixedExtentScrollController();


  @override
  void initState() {
    super.initState();
    selectedQuantity = widget.defaultQuantity;
    fixedExtentScrollController = FixedExtentScrollController(initialItem: widget.defaultQuantity - 1);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          MediaQuery.of(context).size.height / 4, // Adjust the height as needed
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Color(0xFF8253DB),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel_outlined, color: Colors.white),
                  iconSize: 28,
                ),
                Text(
                  'select_quantity'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    widget.onSelected(selectedQuantity);
                    Navigator.pop(context);
                  },
                  splashColor: Colors.blueGrey,
                  icon: Icon(Icons.check_circle_outline, color: Colors.white,),
                  iconSize: 28,
                ),
              ],
            )
          ),
          //SizedBox(height: 16),
          Expanded(
            child: ListWheelScrollView.useDelegate(
              controller: fixedExtentScrollController,
              itemExtent: 50,

              // Height of each item
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedQuantity = index + 1;
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: index + 1 != selectedQuantity ? Colors.white : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
                childCount:
                    20, // Set the number of quantities you want to display
              ),
            ),
          ),
        ],
      ),
    );
  }
}
