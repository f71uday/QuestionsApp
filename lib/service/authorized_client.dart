import 'package:http/http.dart';

import 'auth_service.dart';

class HttpService {
  Future<Response> authorizedGet(Uri url) async {
    String sessionToken = await AuthService.getAccessToken();
    return await get(
      url,
      headers: {
        'Authorization': 'Bearer $sessionToken',
      },
    );
  }
}
