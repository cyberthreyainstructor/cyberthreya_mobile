import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api.dart';
import '../models/machine.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, Map<String, String>> _statuses = {};
  List<Map<String, String>> _notifications = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _updateStatuses();
    _updateNotifications();
    Future.delayed(Duration(minutes: 10), () {
      if (mounted) {
        _updateStatuses();
        _updateNotifications();
      }
    });
  }

  Future<void> _updateStatuses() async {
    try {
      final statuses = await ApiService.getStatuses();
      setState(() => _statuses = statuses);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> _updateNotifications() async {
    try {
      final notifications = await ApiService.getNotifications();
      setState(() => _notifications = notifications);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> _startMachines() async {
    setState(() => _isLoading = true);
    try {
      await ApiService.startMachines();
      await _updateNotifications();
      Fluttertoast.showToast(msg: 'Restart sequence started');
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cyberthreya Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _startMachines,
                    child: Text('Restart Machines'),
                  ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (_notifications.isNotEmpty)
                  Card(
                    child: ListTile(
                      title: Text('Notifications'),
                      subtitle: Column(
                        children: _notifications
                            .map((n) => Text('${n['created_at']}: ${n['message']}'))
                            .toList(),
                      ),
                    ),
                  ),
                for (var group in _statuses.keys)
                  ExpansionTile(
                    title: Text(group),
                    children: _statuses[group]!.keys.map((machine) {
                      return ListTile(
                        title: Text(machine),
                        trailing: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _statuses[group]![machine] == 'running'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
