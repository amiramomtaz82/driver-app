import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../generated/locale_keys.g.dart';

class DocumentUploadTile extends StatelessWidget {
  final String label;
  final String? filePath;
  final String hint;
  final ValueChanged<ImageSource> onSourceSelected;

  const DocumentUploadTile({
    super.key,
    required this.label,
    required this.filePath,
    required this.hint,
    required this.onSourceSelected,
  });

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(LocaleKeys.common_camera.tr()),
              onTap: () {
                Navigator.pop(ctx);
                onSourceSelected(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(LocaleKeys.common_gallery.tr()),
              onTap: () {
                Navigator.pop(ctx);
                onSourceSelected(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = filePath != null && filePath!.isNotEmpty;
    final displayHint = isSelected
        ? filePath!.split(RegExp(r'[\\/]')).last
        : hint;

    return InkWell(
      onTap: () => _showImagePicker(context),
      borderRadius: BorderRadius.circular(5),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Icon(
            isSelected ? Icons.check_circle_outline : Icons.file_upload_outlined,
            color: isSelected ? Colors.green : Colors.grey,
          ),
        ),
        child: Text(
          displayHint,
          style: TextStyle(
            color: isSelected ? Colors.black87 : Colors.grey.shade600,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}