import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/patient.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '/config/storage_keys.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter_app/app/models/rawdata.dart';

/* ApiService
| -------------------------------------------------------------------------
| Define your API endpoints

| Learn more https://nylo.dev/docs/5.20.0/networking
|-------------------------------------------------------------------------- */

class ApiService extends NyApiService {
  ApiService({BuildContext? buildContext})
      : super(
          buildContext,
          decoders: modelDecoders,
          // baseOptions: (BaseOptions baseOptions) {
          //   return baseOptions
          //             ..connectTimeout = Duration(seconds: 5)
          //             ..sendTimeout = Duration(seconds: 5)
          //             ..receiveTimeout = Duration(seconds: 5);
          // },
        );

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  @override
  final interceptors = {
    if (getEnv('APP_DEBUG') == true) PrettyDioLogger: PrettyDioLogger()
  };

  Future<String?> login(
      {required String username,
      required String password,
      bool rememberLogin = true}) async {
    return await network(
      request: (request) => request.post("/Auth/login", data: {
        "username": username,
        "password": password,
        "rememberLogin": rememberLogin
      }),
      handleSuccess: (Response response) {
        return response.data['data']['rawData'];
      },
    );
  }

  Future logout() async {
    return await network(
      request: (request) {
        String userToken = Backpack.instance.read('userToken');
        request.options.headers = {'Authorization': "Bearer " + userToken};
        return request.get("/Auth/logout");
      },
      handleSuccess: (Response response) {
        return response.statusCode;
      },
    );
  }

  Future<List<Patient>?> fetchPatient(
      String date, int page, int pageSize) async {
    return await network<List<Patient>>(request: (request) {
      String userToken = Backpack.instance.read('userToken');

      // Set auth header
      request.options.headers = {'Authorization': "Bearer " + userToken};
      return request.get("/Patient", queryParameters: {
        "date": date,
        "page": page,
        "pageSize": pageSize,
      });
    }, handleSuccess: (Response response) {
      return response.data['data']
          .map<Patient>((json) => Patient.fromJson(json))
          .toList();
    });
  }

  Future addPatient({
    required String hovaten,
    required int socon,
    required int namsinh,
    required String sohoso,
    required String diachi,
    required String gioitinh,
    required String nghenghiep,
    required String ngaytao,
    required String ngayketthuc,
    MedicalRecords? medicalRecords,
    List<String> hinhanh = const [],
  }) async {
    return await network(request: (request) {
      String userToken = Backpack.instance.read('userToken');
      request.options.headers = {'Authorization': "Bearer " + userToken};

      return request.post("/Patient", data: {
        "hovaten": hovaten,
        "socon": socon,
        "namsinh": namsinh,
        "sohoso": sohoso,
        "diachi": diachi,
        "gioitinh": gioitinh,
        "nghenghiep": nghenghiep,
        "ngaytao": ngaytao,
        "ngayketthuc": ngayketthuc,
        "medicalRecord": medicalRecords,
        "hinhanh": hinhanh
      });
    }, handleSuccess: (Response response) {
      return response.statusCode;
    });
  }
  /* Helpers
  |-------------------------------------------------------------------------- */

  /* Authentication Headers
  |--------------------------------------------------------------------------
  | Set your auth headers
  | Authenticate your API requests using a bearer token or any other method
  |-------------------------------------------------------------------------- */

  // @override
  // Future<RequestHeaders> setAuthHeaders(RequestHeaders headers) async {
  //   String? myAuthToken = await StorageKey.userToken.read();
  //   if (myAuthToken != null) {
  //     headers.addBearerToken( myAuthToken );
  //   }
  //   return headers;
  // }

  /* Should Refresh Token
  |--------------------------------------------------------------------------
  | Check if your Token should be refreshed
  | Set `false` if your API does not require a token refresh
  |-------------------------------------------------------------------------- */

  // @override
  // Future<bool> shouldRefreshToken() async {
  //   return false;
  // }

  /* Refresh Token
  |--------------------------------------------------------------------------
  | If `shouldRefreshToken` returns true then this method
  | will be called to refresh your token. Save your new token to
  | local storage and then use the value in `setAuthHeaders`.
  |-------------------------------------------------------------------------- */

  // @override
  // refreshToken(Dio dio) async {
  //  dynamic response = (await dio.get("https://example.com/refresh-token")).data;
  //  // Save the new token
  //   await StorageKey.userToken.store(response['token']);
  // }

  /* Display a error
  |--------------------------------------------------------------------------
  | This method is only called if you provide the API service
  | with a [BuildContext]. Example below:
  | api<ApiService>(
  |        request: (request) => request.myApiCall(),
  |         context: context);
  |-------------------------------------------------------------------------- */
}
