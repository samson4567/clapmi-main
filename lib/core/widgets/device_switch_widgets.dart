import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_state.dart';
import 'package:flutter/foundation.dart';

/// Widget to display device switch and companion mode options
/// This can be added to the livestream screen's settings menu or overlay
class DeviceSwitchMenu extends StatelessWidget {
  final String comboId;
  final String userId;
  final VoidCallback? onSwitchDevice;
  final VoidCallback? onJoinAsCompanion;
  final bool isStreaming;

  const DeviceSwitchMenu({
    super.key,
    required this.comboId,
    required this.userId,
    this.onSwitchDevice,
    this.onJoinAsCompanion,
    this.isStreaming = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      onSelected: (value) {
        switch (value) {
          case 'switch':
            _showSwitchDeviceDialog(context);
            break;
          case 'companion':
            _showJoinCompanionDialog(context);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'switch',
          child: Row(
            children: [
              const Icon(Icons.swap_horiz, size: 20),
              const SizedBox(width: 12),
              Text(
                isStreaming ? 'Switch to Another Device' : 'Start Streaming on This Device',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'companion',
          child: Row(
            children: [
              const Icon(Icons.phone_android, size: 20),
              const SizedBox(width: 12),
              const Text(
                'Join as Companion',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSwitchDeviceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Switch Device'),
        content: Text(
          isStreaming
              ? 'This will transfer your streaming to this device. Your current device will stop streaming. Continue?'
              : 'This device will become your primary streaming device. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onSwitchDevice?.call();
            },
            child: const Text('Switch'),
          ),
        ],
      ),
    );
  }

  void _showJoinCompanionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join as Companion'),
        content: const Text(
          'As a companion, you can watch and interact but cannot stream. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onJoinAsCompanion?.call();
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}

/// Widget to display when device switch is requested
/// Shows notification and options to the user
class DeviceSwitchNotification extends StatelessWidget {
  final String newDevice;
  final String message;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const DeviceSwitchNotification({
    super.key,
    required this.newDevice,
    required this.message,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.swap_horiz,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: onReject,
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: onAccept,
                child: const Text('Accept'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget to show companion mode indicator
class CompanionModeIndicator extends StatelessWidget {
  const CompanionModeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.phone_android,
            color: Colors.white,
            size: 16,
          ),
          SizedBox(width: 6),
          Text(
            'Companion Mode',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget to show primary device indicator
class PrimaryDeviceIndicator extends StatelessWidget {
  final String deviceType;

  const PrimaryDeviceIndicator({
    super.key,
    this.deviceType = 'mobile',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            deviceType == 'mobile' ? Icons.phone_android : Icons.laptop_mac,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 6),
          const Text(
            'Streaming',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bloc listener for device switch states
class DeviceSwitchBlocListener extends StatelessWidget {
  final Widget child;
  final Function(ComboState)? onSwitchDeviceSuccess;
  final Function(ComboState)? onSwitchDeviceError;
  final Function(ComboState)? onCompanionSuccess;
  final Function(ComboState)? onCompanionError;

  const DeviceSwitchBlocListener({
    super.key,
    required this.child,
    this.onSwitchDeviceSuccess,
    this.onSwitchDeviceError,
    this.onCompanionSuccess,
    this.onCompanionError,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ComboBloc, ComboState>(
      listener: (context, state) {
        if (state is SwitchDeviceSuccessState) {
          debugPrint('Device switch successful: ${state.result.message}');
          onSwitchDeviceSuccess?.call(state);
        } else if (state is SwitchDeviceErrorState) {
          debugPrint('Device switch error: ${state.errorMessage}');
          onSwitchDeviceError?.call(state);
        } else if (state is JoinCompanionSuccessState) {
          debugPrint('Join companion successful: ${state.result.message}');
          onCompanionSuccess?.call(state);
        } else if (state is JoinCompanionErrorState) {
          debugPrint('Join companion error: ${state.errorMessage}');
          onCompanionError?.call(state);
        }
      },
      child: child,
    );
  }
}

/// Helper function to show device switch error
void showDeviceSwitchError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}

/// Helper function to show device switch success
void showDeviceSwitchSuccess(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ),
  );
}