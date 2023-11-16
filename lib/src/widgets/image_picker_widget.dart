import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File? image)? onChanged;
  final Widget? placeholder;

  const ImagePickerWidget({
    super.key,
    this.onChanged,
    this.placeholder
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  late ImagePicker _imagePicker;
  File? _image;
  
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return GestureDetector(
      onLongPress: () {
        setState(() {
          _image = null;
        });

        widget.onChanged?.call(_image);
      },
      onTap: () async {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery
        );

        if(image != null) {
          setState(() {
            _image = File(image.path);
          });

          widget.onChanged?.call(_image);
        }
      },
      child: Stack(
        children: [
          SizedBox(
            height: 140.0,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.5),
                color: themeData.colorScheme.surface,
              ),
              child: _image != null ? Image.file(_image!) : widget.placeholder,
            )
          ),
          const Positioned(
            bottom: 14.0,
            right: 14.0,
            child: Icon(Icons.camera_alt_outlined)
          )
        ]
      )
    );
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _imagePicker = ImagePicker();
  }
}
