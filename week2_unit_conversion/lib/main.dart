import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ConverterWidget(title: 'Measures Converter'),
    );
  }
}

class ConverterWidget extends StatefulWidget {
  const ConverterWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ConverterWidget> createState() => _ConverterState();
}

class Unit {
  String name;
  double mulitplier;

  Unit(this.name, this.mulitplier);
}

class _ConverterState extends State<ConverterWidget> {
  final Map<String, List<Unit>> units = {
    "Length": [
      Unit("meters", 1),
      Unit("kilometers", 1000),
      Unit("feet", 0.3048),
      Unit("miles", 1609.344),
    ],
    "Weight": [
      Unit("grams", 1),
      Unit("kilograms", 1000),
      Unit("ounces", 28.34952),
      Unit("pounds", 453.5924),
    ]
  };

  final TextStyle inputStyle = const TextStyle(
    fontSize: 20,
    color: Colors.blue,
  );

  final TextStyle labelStyle = TextStyle(
    fontSize: 24,
    color: Colors.grey[900],
  );

  //STATES
  double _numberFrom = 0;
  double _numberTo = 0;
  String? _selectedCategory;
  Unit? _selectedFromUnit;
  Unit? _selectedToUnit;

  List<DropdownMenuItem<Unit>> selectableUnits() {
    if (_selectedCategory == null) return List.empty();
    return units[_selectedCategory]!
        .map((unit) => DropdownMenuItem(
              child: Text(unit.name),
              value: unit,
            ))
        .toList();
  }

  List<DropdownMenuItem<String>> categoryItems() {
    return units.keys
        .map((category) =>
            DropdownMenuItem(child: Text(category), value: category))
        .toList();
  }

  @override
  void initState() {
    _numberFrom = 0;
    super.initState();
  }

  void readInput(String text) {
    double? number = double.tryParse(text);
    if (number != null) {
      setState(() {
        _numberFrom = number;
      });
    }
  }

  void selectFromUnit(Unit unit) {
    setState(() {
      _selectedFromUnit = unit;
    });
  }

  void selectToUnit(Unit unit) {
    setState(() {
      _selectedToUnit = unit;
    });
  }

  void selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void convertInput() {
    if (_selectedFromUnit == null || _selectedToUnit == null) return;
    setState(() {
      _numberTo = _numberFrom *
          _selectedFromUnit!.mulitplier /
          _selectedToUnit!.mulitplier;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Category
            const Spacer(),
            Text('Category', style: labelStyle),
            DropdownButton(
                items: categoryItems(),
                onChanged: (value) {
                  selectCategory(value as String);
                },
                hint: const Text("Select a category"),
                value: _selectedCategory),

            //Value text field
            const Spacer(),
            Row(
              children: <Widget>[
                Padding(
                  child: Text('Value', style: labelStyle),
                  padding: const EdgeInsets.only(right: 30),
                ),
                Expanded(
                    child: TextField(
                  onChanged: readInput,
                  style: inputStyle,
                  decoration: const InputDecoration(hintText: 'Input value'),
                )),
              ],
            ),

            //From unit dropdown
            const Spacer(),
            Row(
              children: <Widget>[
                Padding(
                  child: Text('From', style: labelStyle),
                  padding: const EdgeInsets.only(right: 30),
                ),
                DropdownButton(
                  items: selectableUnits(),
                  onChanged: (value) {
                    selectFromUnit(value as Unit);
                  },
                  hint: const Text("Select an unit"),
                  value: _selectedFromUnit,
                ),
              ],
            ),

            //To unit dropdown
            const Spacer(),
            Row(
              children: <Widget>[
                Padding(
                  child: Text('To', style: labelStyle),
                  padding: const EdgeInsets.only(right: 30),
                ),
                DropdownButton(
                  items: selectableUnits(),
                  onChanged: (value) {
                    selectToUnit(value as Unit);
                  },
                  hint: const Text("Select an unit"),
                  value: _selectedToUnit,
                ),
              ],
            ),

            //Result
            const Spacer(),
            Padding(
              child: Text('$_numberTo',
                  style: Theme.of(context).textTheme.headline4, maxLines: 1),
              padding: const EdgeInsets.only(bottom: 40),
            ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: convertInput,
        child: const Icon(Icons.autorenew),
      ),
    );
  }
}
