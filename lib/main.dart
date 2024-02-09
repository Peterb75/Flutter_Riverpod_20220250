// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
   runApp(
     ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
       home: ProductPage(),
      ),
     ),
   );
 }

class Product{
  Product({required this.name, required this.price});

  final String name;
  final double price;
}

final _products = [
  Product(name: "Spagetti", price: 10),
  Product(name: "Indomie", price: 6),
  Product(name: "Fried Yam", price: 9),
  Product(name: "Beans", price: 10),
  Product(name: "Red Chicken feet", price: 2),
  Product(name: "PO", price: 50),
  Product(name: "Pizza", price: 80),
  Product(name: "Taco de chorizo", price: 15)
];


enum ProductSortType{
  name,
  price,
  mayor,
}


//This is the default sort type when the app is run
final productSortTypeProvider = StateProvider<ProductSortType>((ref) => 
ProductSortType.name);


final futureProductsProvider = FutureProvider<List<Product>>((ref) async {
  await Future.delayed(const Duration(seconds: 2));
  final sortType = ref.watch(productSortTypeProvider);
switch (sortType) {
    case ProductSortType.name:
       _products.sort((a, b) => a.name.compareTo(b.name));
       break;
    case ProductSortType.price:
       _products.sort((a, b) => a.price.compareTo(b.price));
       
    case ProductSortType.mayor:
       _products.sort((b, a) => a.price.compareTo(b.price));
       

}
  return _products;
});



class ProductPage extends ConsumerWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final productsProvider = ref.watch(futureProductsProvider);
 AppBar(
          title: const Text("Act 8"),
          actions: [
            DropdownButton<ProductSortType>(
              dropdownColor: Colors.brown,
              value: ref.watch(productSortTypeProvider),
                items: const [
                  DropdownMenuItem(
                    value: ProductSortType.name,
                    child: Icon(Icons.sort_by_alpha),
                ),
                  DropdownMenuItem(
                    value: ProductSortType.price,
                    child: Icon(Icons.sort),
                  ),
                  DropdownMenuItem(
                    value: ProductSortType.mayor,
                    child: Icon(Icons.elevator),
                  ),

                ],
                onChanged: (value)=> ref.watch(productSortTypeProvider.notifier).state = value!
            ),
          ],
        );

  productsProvider.when(
            data: (products)=> ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                    child: Card(
                      color: Colors.blueAccent,
                      elevation: 3,
                      child: ListTile(
                        title: Text(products[index].name,style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                        subtitle: Text("${products[index].price}",style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                      ),
                    ),
                  );
                }),
            error: (err, stack) => Text("Error: $err",style: const TextStyle(
                color: Colors.white,  fontSize: 15)),
            loading: ()=> const Center(child: CircularProgressIndicator(color: Colors.white,)),
        );

    return Scaffold(
        appBar: AppBar(
          title: const Text("Future Provider Example"),
          actions: [
            DropdownButton<ProductSortType>(
              dropdownColor: const Color.fromARGB(255, 198, 92, 54),
              value: ref.watch(productSortTypeProvider),
                items: const [
                  DropdownMenuItem(
                    value: ProductSortType.name,
                    child: Icon(Icons.sort_by_alpha),
                ),
                  DropdownMenuItem(
                    value: ProductSortType.price,
                    child: Icon(Icons.sort),
                  ),
                  DropdownMenuItem(
                    value: ProductSortType.mayor,
                    child: Icon(Icons.elevator_outlined),
                  ),

                ],
                onChanged: (value)=> ref.watch(productSortTypeProvider.notifier).state = value!
            ),
          ],
        ),
      backgroundColor: Colors.lightBlue,
      body: Container(
        child: productsProvider.when(
            data: (products)=> ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                    child: Card(
                      color: Colors.blueAccent,
                      elevation: 3,
                      child: ListTile(
                        title: Text(products[index].name,style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                        subtitle: Text("${products[index].price}",style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                      ),
                    ),
                  );
                }),
            error: (err, stack) => Text("Error: $err",style: const TextStyle(
                color: Colors.white,  fontSize: 15)),
            loading: ()=> const Center(child: CircularProgressIndicator(color: Colors.white,)),
        ),
      )
    );
  }
}