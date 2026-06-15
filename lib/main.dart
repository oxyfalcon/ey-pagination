import 'package:flutter/material.dart';
import 'package:test_app/constants.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ValueNotifier<List<Map<String, dynamic>>>? _apiValues;
  ValueNotifier<List<Map<String, dynamic>>> get apiValues =>
      _apiValues ??= ValueNotifier<List<Map<String, dynamic>>>(
        products.take(pageSize).toList(),
      );
  final ValueNotifier<int> currentPage = ValueNotifier<int>(1);
  final int pageSize = 20;

  void pageListener() => apiValues.value = currentPage.value == 1
      ? products.take(pageSize).toList()
      : products
            .skip(pageSize * (currentPage.value - 1))
            .take(pageSize)
            .toList();

  @override
  void initState() {
    super.initState();
    currentPage.addListener(pageListener);
  }

  @override
  void dispose() {
    currentPage.removeListener(pageListener);
    apiValues.dispose();
    currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Expanded(
              child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: apiValues,
                builder: (BuildContext context, value, Widget? child) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> product = value[index];
                      return Center(
                        child: ListTile(
                          title: Text("${product["title"]}"),
                          leading: Text("${product["id"]}"),
                          trailing: Text("${product["price"]}"),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: currentPage,
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: .center,
                  spacing: 10,
                  children: [
                    TextButton(
                      onPressed: value == 1
                          ? null
                          : () => currentPage.value -= 1,
                      child: Text("prev"),
                    ),
                    Text("$value"),
                    TextButton(
                      onPressed: value * pageSize >= products.length
                          ? null
                          : () => currentPage.value += 1,
                      child: Text("next"),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
