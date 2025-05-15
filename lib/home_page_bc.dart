import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:materi_camera/bloc/camera_bloc.dart';
import 'package:materi_camera/bloc/camera_event.dart';
import 'package:materi_camera/bloc/camera_state.dart';

class HomePageBc extends StatelessWidget {
  const HomePageBc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: SafeArea(
        child: BlocConsumer<CameraBloc, CameraState>(
          listener: (context, state) {
            if (state is CameraReady && state.snackBarMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.snackBarMessage!)));
              context.read<CameraBloc>().add(ClearSnackbar());
            }
          },
           builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.camera),
                        label: const Text('Ambil Foto'),
                        onPressed: () {
                          final bloc = context.read<CameraBloc>();
                          if (bloc.state is! CameraReady) {
                            bloc.add(InitializeCamera());
                          }
                          bloc.add(OpenCameraAndCapture(context));
                        },
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: Icon (Icons.folder),
                      label: const Text('Pilih dari Galeri'),
                      onPressed: () => context
                          .read<CameraBloc>()
                          .add(PickImageFromGallery()),
                    ), 
                  ],
                ),
                const SizedBox(height: 20),
                BlocBuilder<CameraBloc, CameraState>(
                  builder: (context, state) {
                    final ImageFile = 
                        state is CameraReady ? state.imageFile : null;

                    return ImageFile != null
                        ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                ImageFile,
                                width: double.infinity,
                              ),
                            ),
                            Text('Gambar disimpan di: ${ImageFile.path}'),
                            ElevatedButton.icon(
                              icon: Icon(Icons.delete),
                              label: const Text('Hapus Gambar'),
                              onPressed: () => context
                                    .read<CameraBloc>()
                                    .add(DeleteImage()),
                            )
                          ],
                        )
                      : const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Belum ada gambar yang diambil/dipilih'),
                      );
                  })
              ],
            );
          },
        ),
      ),
    );
  }
}