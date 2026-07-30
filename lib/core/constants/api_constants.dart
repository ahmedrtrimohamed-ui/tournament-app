class ApiConstants {
  // Use 10.0.2.2 for Android Emulator to access localhost
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Auth Endpoints
  static const String login = '/accounts/login/';
  static const String register = '/accounts/register/';
  static const String verifyOtp = '/accounts/verify-otp/';
  static const String refresh = '/accounts/token/refresh/';
  static const String userProfile = '/accounts/profile/';
  static const String forgotPassword = '/accounts/forgot-password/';
  static const String resetPassword = '/accounts/reset-password/';

  // Tournament Endpoints
  static const String tournaments = '/tournaments/';
  static const String tournamentDetails = '/tournaments/{id}/';
  static const String joinTournament = '/tournaments/{id}/join/';
  static const String leaderboard = '/tournaments/{id}/leaderboard/';

  // Wallet Endpoints
  static const String walletBalance = '/wallet/balance/';
  static const String transactions = '/wallet/transactions/';
  static const String withdraw = '/wallet/withdraw/';

  // Storage Keys
  static const String tokenKey = 'access_token';
  static const String refreshKey = 'refresh_token';
}
