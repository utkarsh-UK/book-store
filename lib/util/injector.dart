import 'package:bookstore/services/api_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

void init() {
  locator.registerLazySingleton(() => ApiController(locator(), locator()));

  locator.registerLazySingleton(() => http.Client());
  locator
      .registerLazySingletonAsync(() async => SharedPreferences.getInstance());
}
