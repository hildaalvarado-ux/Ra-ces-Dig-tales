import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/db_instance.dart';
import '../data/app_database.dart';
import '../main.dart';
import 'calendario.dart';

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
    final now = DateTime.now();
    // Filter to only show notifications from today or the past, preventing "future" tasks from appearing.
    final filtered = list.where((log) => log.timestamp.isBefore(now) ||
      (log.timestamp.year == now.year && log.timestamp.month == now.month && log.timestamp.day == now.day)).toList();

    setState(() {
      _logs = filtered;
      _loading = false;
    });
  }

  Future<void> _handleNotificationTap(NotificationLog log) async {
    // If unread, mark as read
    if (log.status == 'unread') {
      await appDb.updateNotificationStatus(log.id, 'read');
    }

    // Navigate to calendar
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CalendarioPage(userId: widget.userId)),
      ).then((_) => _loadLogs());
    }
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
          actions: [
            IconButton(
              tooltip: 'Limpiar vistas',
              onPressed: () async {
                await appDb.clearReadNotifications(widget.userId);
                _loadLogs();
              },
              icon: const Icon(Icons.delete_sweep_rounded),
            ),
          ],
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
                        final isRead = log.status == 'read';
                        final isCompleted = log.status == 'completed';
                        final isUnread = log.status == 'unread';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: isUnread ? Colors.white : Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isUnread ? AppColors.greenDark.withOpacity(0.3) : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: ListTile(
                            onTap: () => _handleNotificationTap(log),
                            leading: CircleAvatar(
                              backgroundColor: isCompleted ? Colors.green.shade100 : (isUnread ? AppColors.greenSoft.withOpacity(0.2) : Colors.grey.shade200),
                              child: Icon(
                                isCompleted ? Icons.check_circle_rounded : (isUnread ? Icons.notifications_active_rounded : Icons.notifications_none_rounded),
                                color: isCompleted ? Colors.green : (isUnread ? AppColors.greenDark : Colors.grey),
                              ),
                            ),
                            title: Text(
                              log.title,
                              style: TextStyle(
                                fontWeight: isUnread ? FontWeight.w900 : FontWeight.w600,
                                color: isUnread ? AppColors.greenDarker : Colors.black54,
                                decoration: isCompleted ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(log.body),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat('dd/MM/yyyy hh:mm a').format(log.timestamp),
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                    if (isCompleted)
                                      const Text('COMPLETADA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.green)),
                                    if (isRead && !isCompleted)
                                      const Text('VISTA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.blueGrey)),
                                  ],
                                ),
                              ],
                            ),
                            trailing: isUnread ? Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle)) : null,
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}