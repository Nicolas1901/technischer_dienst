import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technischer_dienst/features/admin/application/manage_users_bloc.dart';
import 'package:technischer_dienst/features/admin/presentation/create_user.dart';
import 'package:technischer_dienst/features/admin/presentation/user_details.dart';
import 'package:technischer_dienst/features/authentication/data/user_repository.dart';
import 'package:technischer_dienst/main.dart';
import 'package:technischer_dienst/shared/presentation/components/td_badge.dart';
import 'package:technischer_dienst/shared/presentation/components/td_circle_avatar.dart';
import 'package:technischer_dienst/shared/presentation/components/td_navigation_drawer.dart';
import '../../authentication/application/AuthBloc/auth_bloc.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Benutzer")),
      drawer: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return TdNavigationDrawer(
                accountName: state.user.username,
                email: state.user.email,
                avatar: state.user.profileImage,
                selectedIndex: 2);
          } else {
            return const TdNavigationDrawer(
                accountName: "", email: "", avatar: "", selectedIndex: 2);
          }
        },
      ),
      body: BlocProvider(
        create: (context) =>
            ManageUsersBloc(userRepository: getIt<UserRepository>())
              ..add(LoadUsers()),
        child: BlocBuilder<ManageUsersBloc, ManageUsersState>(
          builder: (BuildContext context, state) {
            if (state is ManageUsersInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is UsersLoaded) {
              return ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading:
                          TdCircleAvatar(url: state.users[index].profileImage),
                      title: Row(
                        children: [
                          Text(state.users[index].username),
                          const TdBadge(
                              label: "Admin", color: Colors.lightGreen)
                        ],
                      ),
                      subtitle: Text(state.users[index].email),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                UserDetails(user: state.users[index])));
                      },
                    );
                  });
            }
            return const Center(
              child: Text("Etwas ist schiefgelaufen"),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => CreateUser()));
        },
      ),
    );
  }
}
