import 'package:flutter/material.dart';

List<Map<String, dynamic>> products = [
  {"id": 1, "title": "iPhone 14", "price": 999},
  {"id": 2, "title": "Samsung Galaxy S23", "price": 899},
  {"id": 3, "title": "Pixel 7", "price": 799},
  {"id": 4, "title": "OnePlus 11", "price": 749},
  {"id": 5, "title": "Realme GT", "price": 499},
  {"id": 6, "title": "Xiaomi 13", "price": 650},
  {"id": 7, "title": "Oppo Reno 10", "price": 550},
  {"id": 8, "title": "Vivo V27", "price": 450},
  {"id": 9, "title": "Moto Edge 40", "price": 600},
  {"id": 10, "title": "Nothing Phone 2", "price": 700},
  {"id": 11, "title": "iPad Air", "price": 599},
  {"id": 12, "title": "MacBook Air", "price": 1199},
  {"id": 13, "title": "Dell XPS 13", "price": 999},
  {"id": 14, "title": "HP Spectre x360", "price": 1099},
  {"id": 15, "title": "Lenovo ThinkPad", "price": 950},
  {"id": 16, "title": "Asus ROG Laptop", "price": 1400},
  {"id": 17, "title": "Acer Predator", "price": 1300},
  {"id": 18, "title": "Sony Headphones", "price": 199},
  {"id": 19, "title": "Bose Speaker", "price": 299},
  {"id": 20, "title": "JBL Flip", "price": 120},
  {"id": 21, "title": "Apple Watch Series 8", "price": 399},
  {"id": 22, "title": "Samsung Watch 5", "price": 349},
  {"id": 23, "title": "Fitbit Charge 5", "price": 179},
  {"id": 24, "title": "Garmin Forerunner", "price": 299},
  {"id": 25, "title": "Canon EOS R5", "price": 2500},
  {"id": 26, "title": "Nikon Z6", "price": 1800},
  {"id": 27, "title": "Sony Alpha A7", "price": 2200},
  {"id": 28, "title": "GoPro Hero 11", "price": 499},
  {"id": 29, "title": "PlayStation 5", "price": 499},
  {"id": 30, "title": "Xbox Series X", "price": 499},
  {"id": 31, "title": "Nintendo Switch", "price": 299},
  {"id": 32, "title": "Logitech Mouse", "price": 49},
  {"id": 33, "title": "Mechanical Keyboard", "price": 120},
  {"id": 34, "title": "Dell Monitor 27\"", "price": 300},
  {"id": 35, "title": "LG Ultrawide Monitor", "price": 450},
  {"id": 36, "title": "Apple AirPods Pro", "price": 249},
  {"id": 37, "title": "Samsung Buds Pro", "price": 199},
  {"id": 38, "title": "Anker Power Bank", "price": 59},
  {"id": 39, "title": "Mi Smart Band 7", "price": 59},
  {"id": 40, "title": "Kindle Paperwhite", "price": 139},
  {"id": 41, "title": "Smart TV 55\"", "price": 700},
  {"id": 42, "title": "Fire TV Stick", "price": 49},
  {"id": 43, "title": "Google Chromecast", "price": 69},
  {"id": 44, "title": "Bluetooth Speaker Mini", "price": 80},
  {"id": 45, "title": "External Hard Drive 1TB", "price": 75},
  {"id": 46, "title": "SSD 512GB", "price": 90},
  {"id": 47, "title": "Router WiFi 6", "price": 150},
  {"id": 48, "title": "Webcam HD", "price": 85},
  {"id": 49, "title": "Office Chair", "price": 200},
  {"id": 50, "title": "Standing Desk", "price": 450},
];

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
