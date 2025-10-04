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
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
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
  final urlControllerIn = TextEditingController();
  final urlControllerOut = TextEditingController();
  late Player _playerIn;
  late Player _playerOut;
  String? _currentUrlIn;
  String? _currentUrlOut;
  String testinfo = '123';
  bool showUrlInput = false;

  @override
  void initState() {
    super.initState();
    DartVLC.initialize();
    _playerIn = Player(id: 1);
    _playerOut = Player(id: 2);
  }

  @override
  void dispose() {
    _playerIn.dispose();
    _playerOut.dispose();
    urlControllerIn.dispose();
    super.dispose();
  }

  void _playVideoIn() {
    final url = urlControllerIn.text;
    if (url.isEmpty) return;

    setState(() {
      _currentUrlIn = url;
      showUrlInput = false;
      _playerIn.open(Media.network(url), autoStart: true);
    });
  }

  void _playVideoOut() {
    final url = urlControllerOut.text;
    if (url.isEmpty) return;

    setState(() {
      _currentUrlOut = url;
      showUrlInput = false;
      _playerOut.open(Media.network(url), autoStart: true);
    });
  }

  void _onVideoPanelTap() {
    setState(() {
      showUrlInput = true;
    });
  }

  void _showInputStreamDialogIn() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter RTSP Url'),
        content: SizedBox(
          width: 400,
          height: 150,
          child: UrlInputPanel(
            urlController: urlControllerIn,
            onPlay: _playVideoIn,
          ),
        ),
      ),
    );
  }

  void _showInputStreamDialogOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter RTSP Url'),
        content: SizedBox(
          width: 400,
          height: 150,
          child: UrlInputPanel(
            urlController: urlControllerOut,
            onPlay: _playVideoOut,
          ),
        ),
      ),
    );
  }

  Widget buildVideoPanelIn() {
    return GestureDetector(
      onTap: _showInputStreamDialogIn,
      child: VideoPanel(player: _playerIn, hasUrl: _currentUrlIn != null),
    );
  }

  Widget buildVideoPanelOut() {
    return GestureDetector(
      onTap: _showInputStreamDialogOut,
      child: VideoPanel(player: _playerOut, hasUrl: _currentUrlOut != null),
    );
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
                      child: buildVideoPanelIn(),
                    ),
                  ),
                  SizedBox(height: 8),
                  // Image capture of license plate
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ImagePanel(imagePath: 'images/input/input.png'),
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
                          "Biển số xe: $testinfo",
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
                      child: buildVideoPanelOut(),
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ImagePanel(imagePath: 'images/output/output.png'),
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
