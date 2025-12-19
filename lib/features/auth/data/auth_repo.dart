import 'package:dio/dio.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/core/network/api_service.dart';
import 'package:hungry/core/utils/pref_helpers.dart';
import 'package:hungry/features/auth/data/user_model.dart';

class AuthRepo {
  ApiService apiService = ApiService();
  bool isGuest = false;
  UserModel? _currentuser;

  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await apiService.post('/login', {
        'email': email,
        'password': password,
      });
      if (response is ApiError) {
        // print(response);

        throw response;
      }
      // print(response);
      if (response is Map<String, dynamic>) {
        // final msg = response['message'];
        // final code = response['code'];
        // final data = response['data'];
        // if (code != 200 || data == null) {
        //   print(msg);
        //   throw ApiError(message: msg);
        // }

        final user = UserModel.fromJson(response['data']);
        if (user.token != null) {
          await PrefHelpers.saveToken(user.token!);
        }
        isGuest = false;
        _currentuser = user;
        return user;
      } else {
        throw 'Some thing wrong';
      }
    } on DioException catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<UserModel?> singUp(String email, String password, String name) async {
    try {
      final response = await apiService.post('/register', {
        'name': name,
        'email': email,
        'password': password,
      });
      if (response is ApiError) {
        // print(response);

        throw response;
      }
      if (response is Map<String, dynamic>) {
        final user = UserModel.fromJson(response['data']);
        if (user.token != null) {
          await PrefHelpers.saveToken(user.token!);
        }
        isGuest = false;
        _currentuser = user;
        return user;
      } else {
        throw 'Some thing wrong';
      }
    } on DioException catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<UserModel?> getProfileData() async {
    try {
      final token = await PrefHelpers.getToken();
      if (token == null || token == 'guest') {
        return null;
      }
      final response = await apiService.get('/profile');

      final user = UserModel.fromJson(response['data']);
      _currentuser = user;

      return user;

      // if (response is ApiError) {
      //   // print(response);

      //   throw response;
      // }
      // if (response is Map<String, dynamic>) {

      //   final user = UserModel.fromJson(response['data']);
      //   if (user.token != null) {
      //     await PrefHelpers.saveToken(user.token!);
      //   }
      //   return user;
      // } else {
      //   throw 'Some thing wrong';
      // }
    } on DioException catch (e) {
      throw ApiError(message: e.toString());
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<UserModel?> updateProfileData({
    required String name,
    required String email,
    required String address,
    String? visa,
    String? imagepath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'address': address,
        if (visa != null && visa.isNotEmpty) 'Visa': visa,
        if (imagepath != null && imagepath.isNotEmpty)
          'image': await MultipartFile.fromFile(
            imagepath,
            filename: 'profile.jpg',
          ),
      });

      final response = await apiService.post('/update-profile', formData);
      if (response != null) {
        _currentuser = UserModel.fromJson(response);

        return UserModel.fromJson(response);
      } else {
        // throw ApiError(message: 'Failed to update profile');
      }
    } on DioException catch (e) {
      throw ApiError(message: e.response?.data['message'] ?? e.message);
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await apiService.post('/logout', {});
      await PrefHelpers.clearToken();
      _currentuser = null;
      isGuest = true;
    } catch (e) {
      throw ApiError(message: 'Logout failed');
    }
  }

  Future<void> continueAsGeust() async {
    isGuest = true;
    _currentuser = null;
    await PrefHelpers.saveToken('guest');
  }

  Future<UserModel?> autoLogin() async {
    final token = await PrefHelpers.getToken();

    if (token == null || token == 'guest') {
      isGuest = true;
      _currentuser = null;
      return null;
    }

    try {
      final user = await getProfileData();
      isGuest = false;
      _currentuser = user;
      return user;
    } catch (e) {
      await PrefHelpers.clearToken();
      isGuest = true;
      _currentuser = null;
      return null;
    }
  }

  UserModel? get currentuser => _currentuser;
  bool get isLogedin => !isGuest && _currentuser != null;
}
