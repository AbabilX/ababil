import 'package:flutter/material.dart';
import 'package:ababil_flutter/ui/theme/app_theme.dart';

class ResponseStatusBar extends StatelessWidget {
  final int statusCode;
  final int durationMs;
  final int? responseSize;

  const ResponseStatusBar({
    super.key,
    required this.statusCode,
    required this.durationMs,
    this.responseSize,
  });

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = AppTheme.getStatusColor(statusCode);
    final statusText = _getStatusText(statusCode);
    final size = responseSize ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF3D3D3D)
                : Colors.grey.shade300,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$statusCode $statusText',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              Icon(
                Icons.timer_outlined,
                size: 14,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 4),
              Text(
                '${durationMs} ms',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
          if (size > 0) ...[
            const SizedBox(width: 12),
            Row(
              children: [
                Icon(
                  Icons.data_usage,
                  size: 14,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatSize(size),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getStatusText(int code) {
    if (code >= 200 && code < 300) {
      if (code == 201) return 'Created';
      return 'OK';
    }
    if (code >= 300 && code < 400) return 'Redirect';
    if (code >= 400 && code < 500) return 'Client Error';
    if (code >= 500) return 'Server Error';
    return 'Unknown';
  }
}
