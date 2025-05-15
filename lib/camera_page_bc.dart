import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:materi_camera/bloc/camera_bloc.dart';
import 'package:materi_camera/bloc/camera_event.dart';
import 'package:materi_camera/bloc/camera_state.dart';

class CameraPageBc extends StatefulWidget {
  const CameraPageBc({super.key});

  @override
  State<CameraPageBc> createState() => _CameraPageBcState();
}

class _CameraPageBcState extends State<CameraPageBc> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<CameraBloc>();
    if (bloc.state is! CameraReady) {
      bloc.add(InitializeCamera());
    }
  }

  IconData _flashIcon(FlashMode mode) {
    return switch (mode) {
      FlashMode.auto => Icons.flash_auto,
      FlashMode.always => Icons.flash_on,
      _ => Icons.flash_off,
    };
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return ClipOval(
      child: Material(
        color: Colors.white24,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<CameraBloc, CameraState>(
        builder: (context, state) {
          if (state is! CameraReady) {
            return const Center(child: CircularProgressIndicator());
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    onTapDown: (details) {
                      context.read<CameraBloc>().add(
                        TapToFocus(details.localPosition, constraints.biggest),
                      );
                    },
                    child: CameraPreview(state.controller),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}