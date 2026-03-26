import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DraggableCommentsSheet extends StatefulWidget {
  final List<String> comments;
  final bool isMinimized;

  DraggableCommentsSheet({Key? key, required this.comments, this.isMinimized = false}) : super(key: key);

  @override
  _DraggableCommentsSheetState createState() => _DraggableCommentsSheetState();
}

class _DraggableCommentsSheetState extends State<DraggableCommentsSheet> {
  bool isMinimized;

  @override
  void initState() {
    super.initState();
    isMinimized = widget.isMinimized;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: isMinimized ? 0.1 : 0.75,
      minChildSize: 0.1,
      maxChildSize: 0.75,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey, width: 1)),
          ),
          child: Column(
            children: [
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  // Logic for dragging the sheet up and down
                },
                child: Container(
                  height: 30,
                  color: Colors.grey[300],
                  child: Center(child: Text('Drag Here')), // Drag Handle
                ),
              ),
              IconButton(
                icon: Icon(isMinimized ? Icons.expand_more : Icons.expand_less),
                onPressed: () {
                  setState(() {
                    isMinimized = !isMinimized;
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: widget.comments.length,
                  itemBuilder: (context, index) {
                    return AnimatedSlide(
                      duration: Duration(milliseconds: 300),
                      offset: isMinimized ? Offset(0, 1) : Offset(0, 0),
                      child: ListTile(
                        title: Text(widget.comments[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}