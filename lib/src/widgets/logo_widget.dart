import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../color_extension.dart';

class LogoWidget extends StatelessWidget {
  final double? height;
  final double? width;

  const LogoWidget({
    super.key,
    this.height,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    
    return SvgPicture.string(
      '''
        <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect width="32" height="32" rx="8" fill="${themeData.colorScheme.primaryContainer.toHexString()}"/>
        <path d="M2 10H11.2077L15.0342 15.1345L13.8305 16.9514L10.1846 12.0592H6.09229L13.2047 21.6028L14.7163 19.3209L14.7189 19.3227L17.7881 14.6895L17.7855 14.6877L20.8909 10H30L24.5436 18.2368H20.3524L21.7165 16.1776H23.4485L26.1767 12.0592H21.9859L13.303 25.1667L2 10Z" fill="${themeData.colorScheme.onPrimaryContainer.toHexString()}"/>
        </svg>
      ''',
      height: height,
      width: width
    );
  }
}
