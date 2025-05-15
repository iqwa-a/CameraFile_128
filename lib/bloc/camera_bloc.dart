import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:materi_camera/bloc/camera_event.dart';
import 'package:materi_camera/bloc/camera_state.dart';


class CameraBloc extends Bloc<CameraEvent, CameraState> {
  late final List<CameraDescription> _cameras;

  CameraBloc() : super(CameraInitial()) {
    on<InitializeCamera>(_onInit);
    on<SwitchCamera>(_onSwitch);
    on<ToogleFlash>(_onToggleFlash);
    on<TakePicture>(_onTakePicture);
    on<TapToFocus>(_onTapFocus);
    on<PickImageFromGallery>(_onPickGallery);
    on<OpenCameraAndCapture>(_onOpenCamera);
    on<DeleteImage>(_onDeleteImage);
    on<ClearSnackbar>(_onClearSnackbar);
    on<RequestPermission>(_onRequestPermissions);
  }
  Future<void> _onInit(
      InitializeCamera event, Emitter<CameraState> emit) async {
    _cameras = await availableCameras();

    await _setupController(0, emit);
  }

   Future<void> _onSwitch(SwitchCamera event, Emitter<CameraState> emit) async {
    if (state is! CameraReady) return;
    final s = state as CameraReady;
    final next = (s.selectedIndex + 1) % _cameras.length;
    await _setupController(next, emit, previous: s);
  }

  Future<void> _onToggleFlash(
    ToogleFlash event, Emitter<CameraState> emit) async {
      if (state is! CameraReady) return;
      final s = state as CameraReady;
      final next = s.flashMode == FlashMode.off
          ? FlashMode.auto
          : s.flashMode == FlashMode.auto
              ? FlashMode.always
              : FlashMode.off;
      await s.controller.setFlashMode(next);
      emit(s.copyWith(flashMode: next));
    }
    Future<void> _onTakePicture(
    TakePicture event, Emitter<CameraState> emit) async {
      if (state is! CameraReady) return;
      final s = state as CameraReady;
      final file = await s.controller.takePicture();
      event.onPictureTaken(File(file.path)
    );
  }

  Future<void> _onTapFocus(TapToFocus event, Emitter<CameraState> emit) async {
    if (state is! CameraReady) return;
    final s = state as CameraReady;
    final relative = Offset(
      event.position.dx / event.previewSize.width, 
      event.position.dy / event.previewSize.height
    );
    await s.controller.setFocusPoint(relative);
    await s.controller.setExposurePoint(relative);
  }
  Future<void> _onPickGallery(
        PickImageFromGallery event, Emitter<CameraState> emit) async {
      if (state is! CameraReady) return;
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      final file = File(picked!.path);
      emit ((state as CameraReady).copyWith(
        imageFile: file,
        snackBarMessage: 'Berhasil memilih dari galeri',
      )
    );
  }
}