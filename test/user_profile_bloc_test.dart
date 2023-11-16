import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/services/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'mock/injector_mock.dart';
import 'unit_logger.dart';
import 'utils/fake_path_provider_platform.dart';
import 'utils/hydrated_bloc_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final platform = FakePathProviderPlatform();
  final hydratedBlocStorage = HydratedBlocStorage();
  late InjectorMock injector;
  setUpLogger();

  group('breez_user_model_tests', () {
    late UserProfileBloc userProfileBloc;

    setUp(() async {
      injector = InjectorMock();
      ServiceInjector.configure(injector);
      await platform.setUp();
      PathProviderPlatform.instance = platform;
      await hydratedBlocStorage.setUpHydratedBloc();
      userProfileBloc = UserProfileBloc(
        injector.breezSDK,
        injector.breezServer,
        injector.notifications,
      );
    });

    tearDown(() async {
      await platform.tearDown();
      await hydratedBlocStorage.tearDownHydratedBloc();
    });

    test("should return empty user when not registered", () async {
      final user = userProfileBloc.state;
      expect(user.profileSettings.userID, null);
    });

    test("should return registered user", () async {
      userProfileBloc.updateProfile(
        name: "A name",
      );
      // wait for the hydration to complete
      await Future.delayed(const Duration(milliseconds: 100));

      userProfileBloc = UserProfileBloc(
        injector.breezSDK,
        injector.breezServer,
        injector.notifications,
      );

      final user = userProfileBloc.state;
      expect(user.profileSettings.name, "A name");
    });
  });
}
