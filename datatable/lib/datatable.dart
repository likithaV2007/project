import 'package:flutter/material.dart';

late List<Map<String, dynamic>> filteredUsers;

List<Map<String, dynamic>> users = [
  {"Id": "1", "Name": "John", "Email": "john@example.com"},
  {"Id": "2", "Name": "Jane", "Email": "jane@example.com"},
  {"Id": "3", "Name": "Alex", "Email": "alex@example.com"},
];

class Datatable extends StatefulWidget {
  const Datatable({super.key});

  @override
  State<Datatable> createState() => _DatatableState();
}

class _DatatableState extends State<Datatable> {
  final TextEditingController searchController = TextEditingController();
  late bool noValue;
  bool isIdChange = true;
  bool isNameChange = true;
  bool isEmailChange = true;

  // Column order control
  List<String> columnOrder = ["Id", "Name", "Email"];

  @override
  void initState() {
    super.initState();
    filteredUsers = List.from(users);
    noValue = false;
  }

  void searchUsers(String value) {
    setState(() {
      if (value.isEmpty) {
        filteredUsers = List.from(users);
        noValue = true;
      } else {
        filteredUsers = users
            .where(
              (user) =>
                  user['Name'].toLowerCase().contains(value.toLowerCase()) ||
                  user['Id'].toLowerCase().contains(value.toLowerCase()) ||
                  user['Email'].toLowerCase().contains(value.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void sort(String field, bool ascending) {
    setState(() {
      filteredUsers.sort((a, b) {
        var valA = a[field];
        var valB = b[field];

        if (valA is int && valB is int) {
          return ascending ? valA.compareTo(valB) : valB.compareTo(valA);
        } else {
          return ascending
              ? valA.toString().compareTo(valB.toString())
              : valB.toString().compareTo(valA.toString());
        }
      });
    });
  }
Widget buildDraggableHeader(String columnName, int index) {
  return DragTarget<int>(
    onAccept: (fromIndex) {
      setState(() {
        final moved = columnOrder.removeAt(fromIndex);
        columnOrder.insert(index, moved);
      });
    },
    builder: (context, candidateData, rejectedData) {
      return Draggable<int>(
        data: index,
        feedback: Material(
          color: Colors.transparent,
          child: Container(
            width: 100,
            padding: const EdgeInsets.all(8),
            color: Colors.blueGrey,
            child: Text(
              columnName,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: headerContent(columnName),
        ),
        child: headerContent(columnName),
      );
    },
  );
}

Widget headerContent(String columnName) {
  IconData sortIcon = Icons.arrow_drop_down;

  if (columnName == "Id") {
    sortIcon = isIdChange ? Icons.arrow_drop_up : Icons.arrow_drop_down;
  } else if (columnName == "Name") {
    sortIcon = isNameChange ? Icons.arrow_drop_up : Icons.arrow_drop_down;
  } else if (columnName == "Email") {
    sortIcon = isEmailChange ? Icons.arrow_drop_up : Icons.arrow_drop_down;
  }

  return Container(
    width: 100,
    alignment: Alignment.center,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(columnName),
        IconButton(
          onPressed: () {
            setState(() {
              if (columnName == "Id") {
                isIdChange = !isIdChange;
                sort("Id", isIdChange);
              } else if (columnName == "Name") {
                isNameChange = !isNameChange;
                sort("Name", isNameChange);
              } else if (columnName == "Email") {
                isEmailChange = !isEmailChange;
                sort("Email", isEmailChange);
              }
            });
          },
          icon: Icon(sortIcon),
        )
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 450,
            height: 50,
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Enter value to Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: searchUsers,
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(80),
                    offset: const Offset(0, 2),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor:
                      WidgetStateProperty.all(Colors.grey.shade200),
                  columns: columnOrder
                      .asMap()
                      .entries
                      .map(
                        (entry) => DataColumn(
                          label: buildDraggableHeader(
                              entry.value, entry.key),
                        ),
                      )
                      .toList(),
                  rows: filteredUsers.map(
                    (user) {
                      return DataRow(
                        cells: columnOrder
                            .map((col) => DataCell(Text(user[col])))
                            .toList(),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ),
          if (filteredUsers.isEmpty) const Text("No data found"),
        ],
      ),
    );
  }
}
