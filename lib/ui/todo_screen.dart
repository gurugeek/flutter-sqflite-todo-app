import 'package:flutter/material.dart';
import 'package:todo_sqflite_flutter/model/todo_item.dart';
import 'package:todo_sqflite_flutter/util/database_client.dart';
import 'package:todo_sqflite_flutter/util/date_formatter.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => new _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  var db = DatabaseHelper();
  final List<TodoItem> _itemList = <TodoItem>[];

  @override
  void initState() {
    super.initState();

    _readToDoList();
  }

  void _handleSubmitted(String text) async {
    _textEditingController.clear();

    TodoItem noDoItem = TodoItem(text, dateFormatted());
    int savedItemId = await db.saveItem(noDoItem);

    TodoItem addedItem = await db.getItem(savedItemId);

    setState(() {
      _itemList.insert(0, addedItem);
    });

    print("Item saved id: $savedItemId");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
                padding: EdgeInsets.all(2.0),
                reverse: false,
                itemCount: _itemList.length,
                itemBuilder: (_, int index) {
                  return Card(
                    color: Colors.white70,
                    child: ListTile(
                      title: _itemList[index],
                      onLongPress: () => _updateItem(_itemList[index], index),
                      onTap: () => _showDetail(_itemList[index], index),
                      trailing: Listener(
                        key: Key(_itemList[index].itemName),
                        child: Icon(
                          Icons.delete_forever,
                          color: Colors.redAccent,
                        ),
                        onPointerDown: (pointerEvent) =>
                            _deleteNoDo(_itemList[index].id, index),
                      ),
                    ),
                  );
                }),
          ),
          // Divider(
          //   height: 10.0,
          // )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        elevation: 10.0,
        highlightElevation: 10.0,
        child: new ListTile(
          title: new Icon(Icons.add),
        ),
        onPressed: _showFormDialog,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 6.0,
        color: Colors.lightBlue,
        //update 2019
        notchMargin: 2.0,
        shape: CircularNotchedRectangle(),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // new Container(
            //   height: 30.0,
            // )
            IconButton(
              icon: Icon(Icons.lightbulb_outline),
              onPressed: () {
                _showTip();
              },
              color: Colors.white,
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: InputDecoration(
                labelText: "Todo", icon: Icon(Icons.event_note)),
          ))
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              _handleSubmitted(_textEditingController.text);
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: Text("Save")),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _readToDoList() async {
    List items = await db.getItems();
    items.forEach((item) {
      TodoItem todoItem = TodoItem.fromMap(item);
      setState(() {
        _itemList.add(TodoItem.map(item));
      });
      print("Db items: ${todoItem.itemName}");
    });
  }

  _deleteNoDo(int id, int index) async {
    debugPrint("Deleted Todo!");

    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _updateItem(TodoItem item, int index) {
    var alert = AlertDialog(
      title: Text("Update Todo"),
      content: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: InputDecoration(
                labelText: "Update Todo", icon: Icon(Icons.update)),
          ))
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () async {
              TodoItem newItemUpdated = TodoItem.fromMap({
                "itemName": _textEditingController.text,
                "dateCreated": dateFormatted(),
                "id": item.id
              });

              _handleSubmittedUpdate(index, item); //redrawing the screen
              await db.updateItem(newItemUpdated); //updating the item
              setState(() {
                _readToDoList(); // redrawing the screen with all items saved in the db
              });

              Navigator.pop(context);
            },
            child: Text("Update")),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _showDetail(TodoItem itemList, int index) {
    var alert = new AlertDialog(
      title: Text("Detail"),
      content: Row(
        children: <Widget>[
          Expanded(
            child: Text(itemList.itemName),
          )
        ],
      ),
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmittedUpdate(int index, TodoItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].itemName == item.itemName;
      });
    });
  }

  void _showTip() {
    var alert = new AlertDialog(
      title: Text("Tip"),
      content: Row(
        children: <Widget>[
          Expanded(
            child:
                Text("Press to see Todo detail\n\nLong press to update Todo"),
          )
        ],
      ),
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }
}
