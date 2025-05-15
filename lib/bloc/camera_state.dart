part of 'camera_bloc.dart';

sealed class CameraState {}

final class CameraInitial extends CameraState {}

final class CameraReady extends CameraState {
  final CameraController controller;
  final int selectedIndex;
  final FlashMode flashMode;
  final File? imageFile;
  final String? snackBarMessage;

  CameraReady({
    required this.controller,
    required this.selectedIndex,
    required this.flashMode,
    required this.imageFile,
    required this.snackBarMessage,
  });
}