import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppImageView extends StatelessWidget {
  ///[url] is required parameter for fetching network image
  final String? url;

  ///[imagePath] is required parameter for showing png,jpg,etc image
  final String? imagePath;

  ///[svgPath] is required parameter for showing svg image
  final String? svgPath;

  ///[file] is required parameter for fetching image file
  final File? file;

  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;

  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? radius;
  final BoxBorder? border;
  final BoxDecoration? foregroundDecoration;
  final BoxShape? shape;

  ///a [AppImageView] it can be used for showing any type of images
  /// it will shows the placeholder image if image is not found on network image
  const AppImageView({
    super.key,
    this.url,
    this.padding,
    this.imagePath,
    this.svgPath,
    this.file,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.shape,
    this.foregroundDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildWidget(),
          )
        : _buildWidget();
  }

  Widget _buildWidget() {
    if (border != null || radius != null || shape != null) {
      return Container(
        margin: margin,
        padding: padding,
        width: width,
        height: height,
        clipBehavior: shape != null || radius != null
            ? Clip.antiAliasWithSaveLayer
            : Clip.none,
        decoration: BoxDecoration(
          border: border,
          shape: shape ?? BoxShape.rectangle,
          borderRadius: radius,
        ),
        foregroundDecoration: foregroundDecoration,
        child: InkWell(onTap: onTap, child: _buildImageView()),
      );
    } else {
      return InkWell(onTap: onTap, child: _buildImageView());
    }
  }

  Widget _buildImageView() {
    if (svgPath != null && svgPath!.isNotEmpty) {
      return SvgPicture.asset(
        svgPath!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
        colorFilter:
            color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      );
    } else if (file != null && file!.path.isNotEmpty) {
      return Image.file(
        file!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
      );
    } else if (url != null && url!.isNotEmpty) {
      return CachedNetworkImage(
        height: height,
        width: width,
        fit: fit,
        imageUrl: url!,
        fadeInDuration: const Duration(microseconds: 0),
        fadeOutDuration: const Duration(microseconds: 0),
        color: color,
        placeholder: (context, url) => const SizedBox(),
        errorWidget: (context, url, error) => const Icon(Icons.error_outline),
      );
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      return Image.asset(
        imagePath!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
        errorBuilder: (context, _, __) => const Icon(Icons.error_outline),
      );
    }
    return const SizedBox();
  }
}
