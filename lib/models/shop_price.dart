class ShopPrice {
  final String productId;
  final String shopName;
  final String area;
  final double price;
  final DateTime submittedAt;

  ShopPrice({
    required this.productId,
    required this.shopName,
    required this.area,
    required this.price,
    required this.submittedAt,
  });
}