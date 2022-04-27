import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/services/injector.dart';
import 'package:test/test.dart';
import 'mocks.dart';

void main() {
  group('breez_user_model_tests', () {
    InjectorMock _injector = InjectorMock();
    UserProfileBloc _userProfileBloc;

    setUp(() async {
      ServiceInjector.configure(_injector);
      _userProfileBloc =
          UserProfileBloc(_injector.breezServer, _injector.notifications);
    });

    test("should return empty user when not registered", () async {});

    test("shoud return registered user", () async {});
  });
}
