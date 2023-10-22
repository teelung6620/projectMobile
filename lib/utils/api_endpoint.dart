class ApiEndPoints {
  static final String baseUrl = 'http://10.0.2.2:4000';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerEmail = '/register';
  final String loginEmail = '/login';
  final String postMenu = '/post_data';
  final String commentPost = '/comments';
  final String bookmarkPost = '/bookmarks';
  final String DELbookmarkPost = '/DELbookmarks';
  final String addIGD = '/ingredients_data';
  final String DELPost = '/DELpost_data';
  final String scoreAdd = '/scores';
  final String patchPOST = '/update_post_data';
  final String reportPOST = '/reports';
  final String DELreportPost = '/DELreports';
  final String UpdateImage = '/userImage';
}
