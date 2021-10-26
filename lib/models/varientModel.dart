class Varient {
  String size;
  String color;
  int qty;
  double price;
  double salePrice;
  String image;

  Varient(
    this.color,
    this.size,
    this.qty,
    this.price,
    this.salePrice,
    this.image,
  );

  Map<String, dynamic> toJson() => {
        '"color"': '"$color"',
        '"size"': '"$size"',
        '"qty"': '"$qty"',
        '"price"': '"$price"',
        '"salePrice"': '"$salePrice"',
        '"image"': '"$image"'
      };
}
