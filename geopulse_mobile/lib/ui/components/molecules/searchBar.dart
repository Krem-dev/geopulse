import 'package:flutter/material.dart';
import '../../../core/theme/appColors.dart';
import '../../../core/theme/appSpacing.dart';

class SearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final bool autofocus;

  const SearchBar({
    Key? key,
    this.hintText = 'Search...',
    required this.onChanged,
    this.onClear,
    this.controller,
    this.autofocus = false,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_updateText);
  }

  void _updateText() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  void _clear() {
    _controller.clear();
    widget.onClear?.call();
    setState(() {
      _hasText = false;
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Icon(Icons.search, size: 20),
        suffixIcon: _hasText
            ? IconButton(
                icon: Icon(Icons.close, size: 20),
                onPressed: _clear,
              )
            : null,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: isDark ? AppColors.gray800 : AppColors.gray100,
      ),
    );
  }
}
