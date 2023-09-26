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
  IngredientsUnitsName ingredientsUnitsName;
  int ingredientsCal;

  IngredientList({
    required this.ingredientsId,
    required this.ingredientsName,
    required this.ingredientsUnits,
    required this.ingredientsUnitsName,
    required this.ingredientsCal,
  });

  factory IngredientList.fromJson(Map<String, dynamic> json) => IngredientList(
        ingredientsId: json["ingredients_id"],
        ingredientsName: json["ingredients_name"],
        ingredientsUnits: json["ingredients_units"],
        ingredientsUnitsName:
            ingredientsUnitsNameValues.map[json["ingredients_unitsName"]]!,
        ingredientsCal: json["ingredients_cal"],
      );

  Map<String, dynamic> toJson() => {
        "ingredients_id": ingredientsId,
        "ingredients_name": ingredientsName,
        "ingredients_units": ingredientsUnits,
        "ingredients_unitsName":
            ingredientsUnitsNameValues.reverse[ingredientsUnitsName],
        "ingredients_cal": ingredientsCal,
      };
}

enum IngredientsUnitsName { EMPTY, INGREDIENTS_UNITS_NAME }

final ingredientsUnitsNameValues = EnumValues({
  "กรัม": IngredientsUnitsName.EMPTY,
  "ฟอง": IngredientsUnitsName.INGREDIENTS_UNITS_NAME
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
