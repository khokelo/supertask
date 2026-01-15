class ApiConfig {
  // Menggunakan String.fromEnvironment untuk membaca variabel lingkungan saat build.
  // Jika 'API_BASE_URL' tidak disetel, akan kembali ke 'http://localhost:3000'.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  // Authentifizierung
  static const String login = '/login';
  static const String register = '/register';

  // Aufgaben
  static const String tasks = '/tasks';

  // Dashboard
  static const String dashboard = '/dashboard';
}
