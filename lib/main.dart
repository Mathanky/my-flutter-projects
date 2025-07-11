import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Combined App',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/todo': (context) => const TodoScreen(),
        '/bmi': (context) => const BmiScreen(),
        '/counter': (context) => const CounterScreen(),
        '/contacts': (context) => const ContactsScreen(),
        '/add': (context) => const AddContactScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Login UI'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/todo'),
              child: const Text('To-Do List'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/bmi'),
              child: const Text('BMI Calculator'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/counter'),
              child: const Text('Counter App'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/contacts'),
              child: const Text('Contacts Manager'),
            ),
          ],
        ),
      ),
    );
  }
}

// Login Screen (Assignment 1)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful!')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!_isValidEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _validateAndSubmit,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Todo Screen (Assignment 2)
class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _taskController = TextEditingController();
  final List<String> _tasks = [];

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(_taskController.text);
        _taskController.clear();
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'Enter Task',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _addTask(),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _addTask,
              child: const Text('Add Task'),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_tasks[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteTask(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Bmi Screen (Assignment 3)
class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  _BmiScreenState createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  double _bmiResult = 0;
  String _bmiCategory = '';

  void _calculateBmi() {
    final height = double.tryParse(_heightController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0;
    if (height > 0 && weight > 0) {
      setState(() {
        _bmiResult = weight / ((height / 100) * (height / 100));
        if (_bmiResult < 18.5) {
          _bmiCategory = 'Underweight';
        } else if (_bmiResult < 25) {
          _bmiCategory = 'Normal';
        } else if (_bmiResult < 30) {
          _bmiCategory = 'Overweight';
        } else {
          _bmiCategory = 'Obese';
        }
      });
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(
                labelText: 'Height (cm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _calculateBmi,
              child: const Text('Calculate BMI'),
            ),
            const SizedBox(height: 20.0),
            if (_bmiResult > 0)
              Text(
                'BMI: ${_bmiResult.toStringAsFixed(1)}\nCategory: $_bmiCategory',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

// Counter Screen (Assignment 4)
class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  void _decrement() {
    setState(() {
      if (_counter > 0) _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Count: $_counter',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _decrement,
                  child: const Text('-'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _increment,
                  child: const Text('+'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Contacts Screen (Assignment 5)
class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final List<Map<String, String>> _contacts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_contacts[index]['name'] ?? ''),
                  subtitle: Text(_contacts[index]['phone'] ?? ''),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
            child: const Text('Add Contact'),
          ),
        ],
      ),
    );
  }
}

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _addContact() {
    if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
      final contactsScreen = context.findAncestorStateOfType<_ContactsScreenState>();
      if (contactsScreen != null) {
        contactsScreen.setState(() {
          contactsScreen._contacts.add({
            'name': _nameController.text,
            'phone': _phoneController.text,
          });
        });
      }
      _nameController.clear();
      _phoneController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Contact')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            ElevatedButton(
              onPressed: _addContact,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}