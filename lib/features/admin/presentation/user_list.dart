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
import '../../../enums/roles.dart';
import '../../authentication/application/AuthBloc/auth_bloc.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      getIt<ManageUsersBloc>()
        ..add(LoadUsers()),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .inversePrimary,
            title: const Text("Benutzer")),
        drawer: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return TdNavigationDrawer(
                selectedIndex: 2,
                currentUser: state.user,
              );
            } else {
              return const TdNavigationDrawer(
                selectedIndex: 2,
                currentUser: null,
              );
            }
          },
        ),
        body: BlocBuilder<ManageUsersBloc, ManageUsersState>(
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
                          if(state.users[index].role == Role.admin.value)
                          const TdBadge(
                              label: "Admin", color: Colors.lightGreen),
                          if(state.users[index].role == Role.wart.value)
                            const TdBadge(
                                label: "Gerätewart", color: Colors.yellow),

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
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const CreateUser()));
          },
        ),
      ),
    );
  }
}
