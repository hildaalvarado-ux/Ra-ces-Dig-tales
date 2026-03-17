import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/db_instance.dart';
import '../data/app_database.dart';
import '../main.dart';

class NotificacionesPage extends StatefulWidget {
  final int userId;
  const NotificacionesPage({super.key, required this.userId});

  @override
  State<NotificacionesPage> createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  bool _loading = true;
  List<NotificationLog> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _loading = true);
    final list = await appDb.getNotificationLogs(widget.userId);
    setState(() {
      _logs = list;
      _loading = false;
    });
  }

  Future<void> _markAsRead(NotificationLog log) async {
    if (log.read) return;
    await appDb.markNotificationAsRead(log.id);
    _loadLogs();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.greenDark,
          foregroundColor: Colors.white,
          title: const Text('Notificaciones', style: TextStyle(fontWeight: FontWeight.w900)),
        ),
        body: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _logs.isEmpty
                  ? const Center(
                      child: Text(
                        'No tienes notificaciones aún',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(14),
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        final log = _logs[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: log.read ? Colors.white.withOpacity(0.7) : Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: log.read ? Colors.transparent : AppColors.greenDark.withOpacity(0.15),
                            ),
                          ),
                          child: ListTile(
                            onTap: () => _markAsRead(log),
                            leading: Icon(
                              log.read ? Icons.notifications_none_rounded : Icons.notifications_active_rounded,
                              color: log.read ? Colors.grey : AppColors.greenDark,
                            ),
                            title: Text(
                              log.title,
                              style: TextStyle(
                                fontWeight: log.read ? FontWeight.w600 : FontWeight.w900,
                                color: log.read ? Colors.black54 : AppColors.greenDarker,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(log.body),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('dd/MM/yyyy hh:mm a').format(log.timestamp),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}