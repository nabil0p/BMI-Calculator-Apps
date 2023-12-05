import 'package:flutter/material.dart';
import 'Controller/BMIDatabase.dart';

void main() {
  runApp(BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      home: BMICalculator(),
    );
  }
}

class BMIData {
  String username;
  double height;
  double weight;
  String gender;
  double bmi;
  String status;

  BMIData({
    required this.username,
    required this.height,
    required this.weight,
    required this.gender,
    required this.bmi,
    required this.status,
  });
}

class BMICalculator extends StatefulWidget {
  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController bmiValueController = TextEditingController();
  String gender = 'Male';
  double bmi = 0.0;
  String status = "";
  List<BMIData> bmiRecords = [];

  final BMIDatabase _bmiDatabase = BMIDatabase.instance;

  @override
  void initState() {
    super.initState();
    _initDatabase(); // Call the init method during initialization
  }

  void _initDatabase() async {
    await _bmiDatabase.init();
  }

  void calculateBMI() {
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double height = double.tryParse(heightController.text) ?? 0.0;

    setState(() {
      bmi = weight / ((height / 100) * (height / 100));

      if (gender == 'Male') {
        if (bmi < 18.5) {
          status = "Underweight. Careful during strong wind!";
        } else if (18.5 <= bmi && bmi <= 24.9) {
          status = "That’s ideal! Please maintain";
        } else if (25.0 <= bmi && bmi <= 29.9) {
          status = "Overweight! Work out please";
        } else {
          status = "Whoa Obese! Dangerous mate!";
        }
      } else if (gender == 'Female') {
        if (bmi < 16) {
          status = "Underweight. Careful during strong wind!";
        } else if (16 <= bmi && bmi <= 22) {
          status = "That’s ideal! Please maintain";
        } else if (22 <= bmi && bmi <= 27) {
          status = "Overweight! Work out please";
        } else {
          status = "Whoa Obese! Dangerous mate!";
        }
      } else {
        status = "Invalid gender input";
      }

      bmiValueController.text = bmi.toString();

      BMIData record = BMIData(
        username: usernameController.text,
        height: height,
        weight: weight,
        gender: gender,
        bmi: bmi,
        status: status,
      );

      bmiRecords.add(record);

      _bmiDatabase.insertData({
        _bmiDatabase.colUsername: usernameController.text,
        _bmiDatabase.colWeight: weight,
        _bmiDatabase.colHeight: height,
        _bmiDatabase.colGender: gender,
        _bmiDatabase.colStatus: status,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Your Fullname:'),
            ),
            SizedBox(height: 5),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Height in CM:'),
            ),
            SizedBox(height: 5),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Weight in KG:'),
            ),
            SizedBox(height: 5),
            TextField(
              controller: bmiValueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'BMI Value:'),
              enabled: false,
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  value: 'Male',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value.toString();
                    });
                  },
                ),
                Text('Male'),
                Radio(
                  value: 'Female',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value.toString();
                    });
                  },
                ),
                Text('Female'),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                calculateBMI();
              },
              child: Text('Calculate BMI and Save'),
            ),
            SizedBox(height: 10),
            Text(
              '${status}',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}