import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:flutter_app/resources/pages/list_patient.dart';
import 'package:nylo_framework/nylo_framework.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends NyState<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Đăng nhập vào ứng dụng quản lý bệnh nhân',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String username = usernameController.text;
                String password = passwordController.text;

                String? token = await api<ApiService>(
                    (service) =>
                        service.login(username: username, password: password),
                    context: context);

                if (token != null) {
                  await NyStorage.store('userToken', token);
                  Backpack.instance.set('userToken', token);
                  showToastSuccess(description: 'Đăng nhập thành công!');
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new ListPatientPage()));
                } else {
                  showToastOops(description: 'Đăng nhập thất bại!');
                }
              },
              child: Text('Đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }
}
