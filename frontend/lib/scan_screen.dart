import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:file_picker/file_picker.dart';

class ScanParkingPage extends StatefulWidget {
  const ScanParkingPage({super.key});

  @override
  State<ScanParkingPage> createState() => _ScanParkingPageState();
}

class UrlInputPanel extends StatelessWidget {
  final TextEditingController urlController;
  final VoidCallback onPlay;

  const UrlInputPanel({
    required this.urlController,
    required this.onPlay,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: urlController,
          decoration: InputDecoration(
            labelText: 'Enter RTSP Url',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: onPlay, child: const Text('Play Video')),
      ],
    );
  }
}

class VideoPanel extends StatelessWidget {
  final Player player;
  final bool hasUrl;

  const VideoPanel({required this.player, required this.hasUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return hasUrl
        ? Video(
            player: player,
            width: 500,
            height: 200,
            scale: 1.0,
            showControls: false,
          )
        : Container(
            color: Colors.black12,
            child: const Center(child: Text('No video')),
          );
  }
}

class ImagePanel extends StatelessWidget {
  final String imagePath;

  const ImagePanel({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: Image.file(File(imagePath), fit: BoxFit.contain),
    );
  }
}

void pickImage() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );

  if (result != null) {
    String path = result.files.single.path!;
  }
}

class InfoPanel extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const InfoPanel({required this.title, required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blueGrey, width: 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _ScanParkingPageState extends State<ScanParkingPage> {
  final urlController = TextEditingController();
  late Player _player;
  String? _currentUrl;
  String testinfo = '123';

  @override
  void initState() {
    super.initState();
    DartVLC.initialize();
    _player = Player(id: 0);
  }

  @override
  void dispose() {
    _player.dispose();
    urlController.dispose();
    super.dispose();
  }

  void _playVideo() {
    final url = urlController.text;
    if (url.isEmpty) return;

    setState(() {
      _currentUrl = url;
      _player.open(Media.network(url), autoStart: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Cột trái
            Expanded(
              // thẻ vào
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      'Camera Vào',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: VideoPanel(
                        player: _player,
                        hasUrl: _currentUrl != null,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  // Image capture of license plate
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ImagePanel(imagePath: 'images/a.png'),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InfoPanel(
                      title: 'Thông tin xe',
                      children: [
                        Text(
                          "Mã thẻ: $testinfo",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Mã Thẻ: $testinfo",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Giá tiền: $testinfo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 6),
            // Cột phải
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      'Camera Ra',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: VideoPanel(
                        player: _player,
                        hasUrl: _currentUrl != null,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ImagePanel(imagePath: 'images/a.png'),
                    ),
                  ),
                  Expanded(
                    child: InfoPanel(
                      title: 'Lịch sử giao dịch',
                      children: [
                        Text(
                          "xe N biển số 999 đã thanh toán 50000 đồng",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
