import 'package:AmbiNav/grid.dart';
import 'package:flutter/material.dart';

class BookingWidget extends StatefulWidget {
  Grid? grid;
  bool isVisible;
  BookingWidget({super.key, this.grid, required this.isVisible});

  //function to toggle visibility of search overlay (essentially a card element to enter destination)
  void toggleVisibility() {
    isVisible = !isVisible;
  }

  @override
  State<BookingWidget> createState() => _BookingWidgetState();
}

class _BookingWidgetState extends State<BookingWidget> {
  TextStyle style = TextStyle(fontSize: 16, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Container(
          margin: EdgeInsets.all(30),
          height: 70,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)],
              color: Colors.blue.shade400,
              borderRadius: BorderRadius.all(Radius.circular(13))),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Text("Proceed to Book?", style: style),
                Container(
                  width: 70,
                ),
                VerticalDivider(
                  width: 30,
                  thickness: 1.2,
                ),
                GestureDetector(
                  child: Text('Yes', style: style),
                  onTap: () {
                    if (widget.grid != null) {
                      widget.grid!.sobj.bookAmbulance();
                      setState((() => widget.toggleVisibility()));
                      widget.grid!.isBooking = false;
                      widget.grid!.removeGrid();
                    }
                  },
                ),
                VerticalDivider(
                  width: 30,
                  thickness: 1.2,
                ),
                GestureDetector(
                  child: Text('No', style: style),
                  onTap: () {
                    setState((() => widget.toggleVisibility()));
                    widget.grid!.removeGrid();
                    widget.grid = null;
                  },
                ), // Text here
              ],
            ),
          )),
      visible: widget.isVisible,
    );
  }
}