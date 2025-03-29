import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PotraitCoverPicker extends StatefulWidget {
  const PotraitCoverPicker({super.key});

  @override
  State<PotraitCoverPicker> createState() => _PotraitCoverPickerState();
}

class _PotraitCoverPickerState extends State<PotraitCoverPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            CoverPicker(),
            Positioned(
              top: 40,
              child: PotraitPicker(),
            ),
          ],
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}

class PotraitPicker extends StatefulWidget {
  const PotraitPicker({super.key});

  @override
  State<PotraitPicker> createState() => _PotraitPickerState();
}

class _PotraitPickerState extends State<PotraitPicker> {
  File? _imageFile;
  Uint8List? _webImageBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      if (kIsWeb) {
        // On web, read image as bytes and update the state.
        final Uint8List bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
        });
      } else {
        // On mobile/desktop, use the File API.
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    }
  }

  Widget _buildImage() {
    if (kIsWeb) {
      return _webImageBytes == null
          ? Icon(
              Icons.face,
              color: Colors.white38,
            )
          : Image.memory(
              _webImageBytes!,
              fit: BoxFit.cover,
            );
    } else {
      return _imageFile == null
          ? Icon(
              Icons.face,
              color: Colors.white38,
            )
          : Image.file(
              _imageFile!,
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          // Main circular image container
          InkWell(
            borderRadius: BorderRadius.circular(75),
            enableFeedback: true,
            onTap: () => _pickImage(ImageSource.gallery),
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 6.0,
                ),
              ),
              child: ClipOval(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: _buildImage(),
                ),
              ),
            ),
          ),
          // Positioned small circle button at bottom left
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 40, // Adjust size as needed
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightGreen,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CoverPicker extends StatefulWidget {
  const CoverPicker({super.key});

  @override
  State<CoverPicker> createState() => _CoverPickerState();
}

class _CoverPickerState extends State<CoverPicker> {
  File? _imageFile;
  Uint8List? _webImageBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      if (kIsWeb) {
        // On web, read image as bytes and update the state.
        final Uint8List bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
        });
      } else {
        // On mobile/desktop, use the File API.
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    }
  }

  Widget _buildImage() {
    if (kIsWeb) {
      return _webImageBytes == null
          ? Icon(
              Icons.photo,
              color: Colors.white38,
            )
          : Image.memory(
              _webImageBytes!,
              fit: BoxFit.cover,
            );
    } else {
      return _imageFile == null
          ? Icon(
              Icons.photo,
              color: Colors.white38,
            )
          : Image.file(
              _imageFile!,
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          // Main circular image container
          InkWell(
            borderRadius: BorderRadius.circular(75),
            enableFeedback: true,
            onTap: () => _pickImage(ImageSource.gallery),
            child: Container(
              width: min((MediaQuery.of(context).size.height * 0.9), 600),
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[400],
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: Colors.white,
                  width: 6.0,
                ),
              ),
              child: ClipRect(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: _buildImage(),
                ),
              ),
            ),
          ),
          // Positioned small circle button at bottom left
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              width: 40, // Adjust size as needed
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlueAccent,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
