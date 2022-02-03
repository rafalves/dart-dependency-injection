import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

void main() async {
  final dio = Dio();
  final dioService = DioService(dio);

  final client = http.Client();
  final httpService = HttpService(client);

  // you can use any one of the services created, dioService or httpService
  //final product = Product(dioService);
  final product = Product(httpService);

  final list = await product.fetchProduct();
  print(list);
}

abstract class IHttpService {
  Future<dynamic> get(String url);
}

class DioService implements IHttpService {
  final Dio dio;

  DioService(this.dio);

  @override
  Future get(String url) async => (await dio.get(url)).data;
}

class HttpService implements IHttpService {
  final http.Client client;

  HttpService(this.client);

  @override
  Future get(String url) async =>
      jsonDecode((await client.get(Uri.parse(url))).body);
}

class Product {
  final IHttpService service;

  Product(this.service);

  Future<List> fetchProduct() async {
    final response =
        await service.get('https://jsonplaceholder.typicode.com/todos');
    return response;
  }
}
