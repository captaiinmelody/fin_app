import 'dart:convert';

import 'package:fin_app/features/auth/data/models/request/product_model.dart';
import 'package:fin_app/features/auth/data/models/response/product_response_model.dart';
import 'package:http/http.dart' as http;

class ProductDataSources {
  Future<ProductResponseModel> createProduct(ProductModel model) async {
    final response = await http.post(
        Uri.parse('https://api.escuelajs.co/api/v1/products/'),
        body: model.toMap());
    return ProductResponseModel.fromJson(response.body);
  }

  Future<ProductResponseModel> updateProduct(
      ProductResponseModel model, int id) async {
    final response = await http.put(
        Uri.parse('https://api.escuelajs.co/api/v1/products/$id'),
        body: model.toMap());
    return ProductResponseModel.fromJson(response.body);
  }

  Future<ProductResponseModel> getProductById(int id) async {
    final response = await http.get(
      Uri.parse('https://api.escuelajs.co/api/v1/products/$id'),
    );
    return ProductResponseModel.fromJson(response.body);
  }

  Future<List<ProductResponseModel>> getAllProduct() async {
    final response = await http.get(
      Uri.parse('https://api.escuelajs.co/api/v1/products?offset=0&limit=100'),
    );

    final result = List<ProductResponseModel>.from(
        jsonDecode(response.body).map((x) => ProductResponseModel.fromMap(x)));

    return result;
  }
}
