import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:realtime_chat/models/user.dart';
import 'package:realtime_chat/pages/login_page.dart';
import 'package:realtime_chat/services/auth_service.dart';
import 'package:realtime_chat/services/chat_service.dart';
import 'package:realtime_chat/services/socket_service.dart';
import 'package:realtime_chat/services/user_service.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    final usersService = Provider.of<UserService>(context, listen: false);
    usersService.getUsers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usersService = Provider.of<UserService>(context);

    final user = authService.user;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          user.name.substring(0, 2),
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black54),
          onPressed: () async {
            socketService.disconnect();
            await authService.logout();
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        LoginPage(),
                    transitionDuration: Duration(milliseconds: 0)));
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online
                ? Icon(Icons.check_circle, color: Colors.blue[400])
                : Icon(Icons.offline_bolt, color: Colors.red[400]),
          )
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(
          complete: Icon(
            Icons.check,
            color: Colors.blue[400],
          ),
          waterDropColor: Colors.blue[400],
        ),
        controller: _refreshController,
        onRefresh: () => _onRefresh(context),
        onLoading: _onLoading,
        child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (_, index) =>
                _userListTile(context, usersService.users[index]),
            separatorBuilder: (context, index) => Divider(),
            itemCount: usersService.users.length),
      ),
    );
  }

  ListTile _userListTile(BuildContext context, User user) {
    final chatService = Provider.of<ChatService>(context, listen: false);

    return ListTile(
      onTap: () {
        chatService.userTo = user;
        Navigator.pushNamed(context, 'chat');
      },
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(user.name.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
    );
  }

  void _onRefresh(BuildContext context) async {
    // monitor network fetch
    // if failed,use refreshFailed()
    final usersService = Provider.of<UserService>(context, listen: false);
    await usersService.getUsers();

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    // if(mounted)
    // setState(() {

    // });
    _refreshController.loadComplete();
  }
}
