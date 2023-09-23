// To parse this JSON data, do
//
//     final ingredientList = ingredientListFromJson(jsonString);

import 'dart:convert';

List<IngredientList> ingredientListFromJson(String str) =>
    List<IngredientList>.from(
        json.decode(str).map((x) => IngredientList.fromJson(x)));

String ingredientListToJson(List<IngredientList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IngredientList {
  int ingredientsId;
  String ingredientsName;
  int ingredientsUnits;
  int ingredientsCal;
  bool isSelected;

  IngredientList({
    required this.ingredientsId,
    required this.ingredientsName,
    required this.ingredientsUnits,
    required this.ingredientsCal,
    this.isSelected = false,
  });

  factory IngredientList.fromJson(Map<String, dynamic> json) => IngredientList(
        ingredientsId: json["ingredients_id"],
        ingredientsName: json["ingredients_name"],
        ingredientsUnits: json["ingredients_units"],
        ingredientsCal: json["ingredients_cal"],
      );

  Map<String, dynamic> toJson() => {
        "ingredients_id": ingredientsId,
        "ingredients_name": ingredientsName,
        "ingredients_units": ingredientsUnits,
        "ingredients_cal": ingredientsCal,
      };
}
