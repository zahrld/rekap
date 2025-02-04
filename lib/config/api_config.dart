class ApiConfig {
  // Untuk Android Emulator gunakan 10.0.2.2
  // Untuk iOS Simulator gunakan localhost
  static const String baseUrl = "http://192.168.5.167/api_sicap";

  // Endpoints
  static const String login = "$baseUrl/login.php";
  static const String register = "$baseUrl/register.php";
  static const String createSurvey = "$baseUrl/create_survey.php";
  static const String getSurveys = "$baseUrl/get_surveys.php";
  static const String createCatatan = "$baseUrl/create_catatan.php";
  static const String getCatatan = "$baseUrl/get_catatan.php";
  static const String recapScreen = "$baseUrl/read_catatan.php";
  static const String getUserCatatan = "$baseUrl/get_user_catatan.php";
}
