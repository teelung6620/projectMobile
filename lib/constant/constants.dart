class Product {
  final String name;
  final String type;
  bool isSelected;

  Product({
    required this.name,
    required this.type,
    required this.isSelected,
  });
}

final List<Product> FoodList = [
  Product(name: 'ข้าวขาหมู', type: 'food', isSelected: false),
  Product(name: 'ข้าวมันไก่', type: 'food', isSelected: false),
  Product(name: 'ข้าวไข่เจียว', type: 'food', isSelected: false),
  Product(name: 'ice-cream', type: 'sweet', isSelected: false),
  Product(name: 'cake', type: 'sweet', isSelected: false),
  Product(name: 'waffle', type: 'sweet', isSelected: false),
  Product(name: 'coke', type: 'drink', isSelected: false),
  Product(name: 'pepsi', type: 'drink', isSelected: false),
  Product(name: 'fanta', type: 'drink', isSelected: false),
];

// const FOOD_DATA = [
//   {
//     "foodName": "ข้าวขาหมู",
//     "userOwner": "jimmy",
//     "image": "KaMoo.png"
//   },
//   {
//     "type": "sweet",
//     "foodName": "ไอศครีม",
//     "userOwner": "Michale",
//     "price": 1.55,
//     "image": "ice_cream.png"
//   },
//   {
//     "foodName": "ข้าวขาหมู",
//     "userOwner": "jimmy",
//     "price": 2.99,
//     "image": "KaMoo.png",
//     "tag": "food"
//   },
//   {
//     "foodName": "ข้าวขาหมู",
//     "userOwner": "jimmy",
//     "price": 2.99,
//     "image": "KaMoo.png"
//   },
//   {
//     "type": "sweet",
//     "foodName": "ไอศครีม",
//     "userOwner": "Michale",
//     "price": 1.55,
//     "image": "ice_cream.png",
//     "tag": "sweet"
//   },
//   {
//     "foodName": "ข้าวขาหมู",
//     "userOwner": "jimmy",
//     "price": 2.99,
//     "image": "KaMoo.png"
//   },
//   {
//     "type": "sweet",
//     "foodName": "ไอศครีม",
//     "userOwner": "Michale",
//     "price": 1.55,
//     "image": "ice_cream.png"
//   },
//   {
//     "foodName": "ข้าวขาหมู",
//     "userOwner": "jimmy",
//     "price": 2.99,
//     "image": "KaMoo.png"
//   },
//   {
//     "type": "sweet",
//     "foodName": "ไอศครีม",
//     "userOwner": "Michale",
//     "price": 1.55,
//     "image": "ice_cream.png"
//   },
//   {
//     "foodName": "ข้าวขาหมู",
//     "userOwner": "jimmy",
//     "price": 2.99,
//     "image": "KaMoo.png"
//   },
//   {
//     "foodName": "ข้าวขาหมู",
//     "userOwner": "jimmy",
//     "price": 2.99,
//     "image": "KaMoo.png"
//   },
// ];
