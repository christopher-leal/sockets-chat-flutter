import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:realtime_chat/models/user.dart';

class UsersPage extends StatelessWidget {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    final usuarios = [
      User(uid: '1', name: 'Test', email: 'test@test.com', online: true),
      User(uid: '2', name: 'Test 2', email: 'test2@test.com', online: true),
      User(uid: '3', name: 'Test 3', email: 'test3@test.com', online: false),
      User(uid: '4', name: 'Test 4', email: 'test4@test.com', online: true),
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Usuario',
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black54),
          onPressed: () {},
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.blue[400]),
          )
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(
          complete: Icon(
            Icons.check,
            color: Colors.blue[400],
          ),
          waterDropColor: Colors.blue[400],
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (_, index) => _userListTile(context, usuarios[index]),
            separatorBuilder: (context, index) => Divider(),
            itemCount: usuarios.length),
      ),
    );
  }

  ListTile _userListTile(BuildContext context, User user) {
    return ListTile(
      onTap: () => Navigator.pushNamed(context, 'chat'),
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

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
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
