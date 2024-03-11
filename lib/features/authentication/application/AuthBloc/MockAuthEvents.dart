import 'package:pocketbase/pocketbase.dart';
import 'package:technischer_dienst/features/authentication/application/AuthBloc/auth_bloc.dart';
import 'package:technischer_dienst/features/authentication/domain/user.dart';

class MockAuthentication extends AuthEvent {
  final User user = User(
      username: "Nicolas",
      profileImage: "",
      email: "nicolas.will01@gmail.com",
      authStore: AuthStore());

  @override
  List<Object> get props => [];
}
