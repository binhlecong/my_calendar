import 'package:flutter/material.dart';

class ColorSelector extends StatefulWidget {
  final int numOptions;
  final int checkedIndex;
  final Function myOnChange;
  ColorSelector({this.numOptions, this.checkedIndex, this.myOnChange});

  @override
  _ColorSelectorState createState() => _ColorSelectorState(
      checkedIndex: this.checkedIndex, myOnChange: this.myOnChange);
}

class _ColorSelectorState extends State<ColorSelector> {
  int checkedIndex;
  Function myOnChange;

  _ColorSelectorState({this.checkedIndex, this.myOnChange});

  @override
  Widget build(BuildContext context) {
    const List<int> boxes = [0, 1, 2, 3, 4];

    return Container(
      child: Column(
        children: [
          Row(
              children: boxes.map(
            (index) {
              return Expanded(
                flex: 1,
                child: IconButton(
                    icon: Icon(checkedIndex == index
                        ? Icons.check_box
                        : Icons.check_box_outline_blank),
                    onPressed: () {
                      setState(() {
                        checkedIndex = index;
                      });
                      myOnChange(checkedIndex);
                    }),
              );
            },
          ).toList()),
          Row(
            children: [
              Text("Not at all"),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text("Very"),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ],
      ),
    );
  }
}
