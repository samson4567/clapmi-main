import 'dart:convert';

import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationNavigationService {
  static Future<void> openFromPayload({
    BuildContext? context,
    String? payload,
    Map<String, dynamic>? data,
  }) async {
    final targetContext =
        context ?? rootNavigatorKey.currentContext ?? rootNavigatorKey.currentState?.context;
    if (targetContext == null) {
      return;
    }

    final normalizedData = _normalizePayload(payload: payload, data: data);
    final encodedPayload = payload ??
        (normalizedData == null || normalizedData.isEmpty
            ? null
            : jsonEncode(normalizedData));

    if (_routeToTarget(targetContext, normalizedData)) {
      return;
    }

    targetContext.pushNamed(
      MyAppRouteConstant.notificationPage,
      extra: {
        'payload': encodedPayload,
      },
    );
  }

  static bool _routeToTarget(
    BuildContext context,
    Map<String, dynamic>? data,
  ) {
    if (data == null || data.isEmpty) {
      return false;
    }

    final deepLink = _extractString(
      data,
      const ['deep_link', 'deeplink', 'url', 'link', 'action_url'],
      nestedKeys: const ['url', 'link', 'value'],
    );
    final deepLinkLocation = _mapLinkToLocation(deepLink);
    if (deepLinkLocation != null) {
      context.go(deepLinkLocation);
      return true;
    }

    final type = (_extractString(
              data,
              const ['type', 'notification_type'],
            ) ??
            '')
        .toLowerCase();
    final postId = _extractString(
      data,
      const ['post', 'post_id', 'postId'],
      nestedKeys: const ['uuid', 'id', 'post', 'post_id', 'postId'],
    );
    final comboGroundId = _extractString(
      data,
      const ['combo-ground', 'combo_ground', 'comboGround'],
      nestedKeys: const ['uuid', 'id', 'combo', 'combo_id', 'comboId'],
    );
    final comboId = _extractString(
      data,
      const [
        'combo',
        'combo_id',
        'comboId',
        'livestream',
        'livestream_id',
        'livestreamId',
      ],
      nestedKeys: const ['uuid', 'id', 'combo', 'combo_id', 'comboId'],
    );
    final userId = _extractString(
      data,
      const [
        'user',
        'user_id',
        'userId',
        'profile',
        'profile_id',
        'profileId',
        'sender',
        'sender_profile',
        'senderProfile',
        'receiver',
        'receiver_profile',
        'receiverProfile',
        'pid',
        'host',
        'challenger',
      ],
      nestedKeys: const ['pid', 'id', 'profile', 'user', 'uuid'],
    );
    if ((postId ?? '').isNotEmpty ||
        type == 'post' ||
        type == 'postreaction' ||
        type == 'post-like') {
      if ((postId ?? '').isNotEmpty) {
        context.go('${MyAppRouteConstant.sharedPostBase}/$postId');
        return true;
      }
    }

    if ((comboGroundId ?? '').isNotEmpty) {
      context.go('${MyAppRouteConstant.sharedComboGroundBase}/$comboGroundId');
      return true;
    }

    if ((comboId ?? '').isNotEmpty &&
        (type.contains('live') ||
            type.contains('challenge') ||
            type.contains('schedule'))) {
      context.go('${MyAppRouteConstant.sharedLivestreamBase}/$comboId');
      return true;
    }

    if (type.contains('message')) {
      context.goNamed(MyAppRouteConstant.chatListPage);
      return true;
    }

    if ((userId ?? '').isNotEmpty &&
        (type.contains('clap') ||
            type.contains('account') ||
            type.contains('email') ||
            type.contains('password') ||
            type.contains('login') ||
            type.contains('profile') ||
            type.contains('user'))) {
      context.goNamed(
        MyAppRouteConstant.othersAccountPage,
        extra: {'userId': userId},
      );
      return true;
    }

    if ((comboId ?? '').isNotEmpty) {
      context.go('${MyAppRouteConstant.sharedLivestreamBase}/$comboId');
      return true;
    }

    if ((postId ?? '').isNotEmpty) {
      context.go('${MyAppRouteConstant.sharedPostBase}/$postId');
      return true;
    }

    if ((userId ?? '').isNotEmpty) {
      context.goNamed(
        MyAppRouteConstant.othersAccountPage,
        extra: {'userId': userId},
      );
      return true;
    }

    return false;
  }

  static Map<String, dynamic>? _normalizePayload({
    String? payload,
    Map<String, dynamic>? data,
  }) {
    if (data != null) {
      return Map<String, dynamic>.from(data);
    }

    if (payload == null || payload.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return decoded.map(
          (key, value) => MapEntry(key.toString(), value),
        );
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  static String? _mapLinkToLocation(String? rawLink) {
    if (rawLink == null || rawLink.trim().isEmpty) {
      return null;
    }

    final link = Uri.tryParse(rawLink);
    if (link == null) {
      return null;
    }

    final segments = link.scheme.toLowerCase() == 'clapmi'
        ? <String>[
            if (link.host.isNotEmpty) link.host,
            ...link.pathSegments.where((segment) => segment.trim().isNotEmpty),
          ]
        : link.pathSegments
            .where((segment) => segment.trim().isNotEmpty)
            .toList();

    if (segments.length < 2) {
      return null;
    }

    final resource = segments.first.toLowerCase();
    final id = segments[1];
    if (id.isEmpty) {
      return null;
    }

    if (resource == 'posts') {
      return '${MyAppRouteConstant.sharedPostBase}/$id';
    }

    if (resource == 'livestream') {
      return '${MyAppRouteConstant.sharedLivestreamBase}/$id';
    }

    if (resource == 'combo-ground') {
      return '${MyAppRouteConstant.sharedComboGroundBase}/$id';
    }

    return null;
  }

  static String? _extractString(
    Map<String, dynamic> data,
    List<String> keys, {
    List<String> nestedKeys = const ['id', 'uuid', 'pid', 'value'],
  }) {
    for (final key in keys) {
      final value = _findValueByKey(data, key);
      final normalized = _normalizeValue(value, nestedKeys);
      if (normalized != null && normalized.isNotEmpty) {
        return normalized;
      }
    }
    return null;
  }

  static dynamic _findValueByKey(dynamic node, String key) {
    final normalizedNeedle = _normalizeKey(key);

    if (node is Map) {
      for (final entry in node.entries) {
        final entryKey = entry.key.toString();
        if (_normalizeKey(entryKey) == normalizedNeedle) {
          return entry.value;
        }
      }

      for (final value in node.values) {
        final nested = _findValueByKey(value, key);
        if (nested != null) {
          return nested;
        }
      }
    }

    if (node is List) {
      for (final value in node) {
        final nested = _findValueByKey(value, key);
        if (nested != null) {
          return nested;
        }
      }
    }

    return null;
  }

  static String? _normalizeValue(dynamic value, List<String> nestedKeys) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    if (value is num || value is bool) {
      return value.toString();
    }

    if (value is Map) {
      final mapValue = value.map(
        (key, nestedValue) => MapEntry(key.toString(), nestedValue),
      );
      for (final nestedKey in nestedKeys) {
        final nested = _extractString(
          mapValue,
          [nestedKey],
          nestedKeys: const ['id', 'uuid', 'pid', 'value'],
        );
        if (nested != null && nested.isNotEmpty) {
          return nested;
        }
      }
    }

    return null;
  }

  static String _normalizeKey(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }
}
