class ApiEndPoints {
  static final String baseUrl = 'http://10.0.2.2:4000';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerEmail = '/register';
  final String loginEmail = '/login';
}