import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // HomeWidget.setAppGroupId('');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeWidgetTestViiew(),
    );
  }
}

class HomeWidgetTestViiew extends StatefulWidget {
  const HomeWidgetTestViiew({super.key});

  @override
  State<HomeWidgetTestViiew> createState() => _HomeWidgetTestViiewState();
}

class _HomeWidgetTestViiewState extends State<HomeWidgetTestViiew>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    HomeWidget.registerInteractivityCallback(interactiveCallbackCounter);
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _incrementCounter() async {
    await _increment();
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomeWidget Example')),
      body: Center(
        child: Column(
          children: [
            const Text('You have pushed the button this many times:'),
            FutureBuilder<int>(
              future: _value,
              builder: (_, snapshot) => Text(
                (snapshot.data ?? 0).toString(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            TextButton(
              onPressed: () async {
                await _clear();
                setState(() {});
              },
              child: const Text('Clear'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

@pragma('vm:entry-point')
Future<void> interactiveCallbackCounter(Uri? uri) async {
  // Set AppGroup Id. This is needed for iOS Apps to talk to their WidgetExtensions
  // await HomeWidget.setAppGroupId('my.group.name');

  // We check the host of the uri to determine which action should be triggered.

  print(uri?.host);
  if (uri?.host == 'increment') {
    print("invoke increment");
    await _increment();
  } else if (uri?.host == 'clear') {
    await _clear();
  }
}

const _countKey = 'counter';

/// Gets the currently stored Value
Future<int> get _value async {
  final value = await HomeWidget.getWidgetData<int>(_countKey, defaultValue: 0);
  return value!;
}

/// Retrieves the current stored value
/// Increments it by one
/// Saves that new value
/// @returns the new saved value
Future<int> _increment() async {
  final oldValue = await _value;
  final newValue = oldValue + 1;
  await _sendAndUpdate(newValue);
  return newValue;
}

/// Clears the saved Counter Value
Future<void> _clear() async {
  await _sendAndUpdate(null);
}

/// Stores [value] in the Widget Configuration
Future<void> _sendAndUpdate([int? value]) async {
  await HomeWidget.saveWidgetData(_countKey, value);
  await HomeWidget.updateWidget(
    iOSName: 'CounterWidget',
    androidName: 'MyCounterWidgetProvider', // tis should same as kotlin name
  );
}
