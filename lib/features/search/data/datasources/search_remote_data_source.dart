import 'package:clapmi/Models/search/user_search.dart';
import 'package:clapmi/core/api/clapmi_network_client.dart';
import 'package:clapmi/core/constants/endpoint_constant.dart';
import 'package:clapmi/core/error/exception.dart';
import 'package:dio/dio.dart';

abstract class SearchRemoteDataSource {
  Future<List<UserSearch>> searchUsers(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ClapMiNetworkClient networkClient;

  SearchRemoteDataSourceImpl({required this.networkClient});

  @override
  Future<List<UserSearch>> searchUsers(String query) async {
    try {
      final response = await networkClient.get(
        endpoint: EndpointConstant.generalUsersSearch,
        isAuthHeaderRequired: true,
        params: {'query': query},
      );

      if (response.success == "true") {
        final List<dynamic> data = response.data;
        return data.map((json) => UserSearch.fromMap(json)).toList();
      } else {
        throw Exception(response.message);
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
