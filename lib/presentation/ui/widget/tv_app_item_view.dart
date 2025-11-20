import 'package:android_tv_my/data/model/tv_app_model.dart';
import 'package:android_tv_my/presentation/ui/common/image_from_base64.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TvAppItemView extends StatefulWidget {
  final TvAppModel item;
  final VoidCallback onTap;

  const TvAppItemView({super.key, required this.item, required this.onTap});

  @override
  State<TvAppItemView> createState() => _TvAppItemViewState();
}

class _TvAppItemViewState extends State<TvAppItemView> {
  bool isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.select || event.logicalKey == LogicalKeyboardKey.enter)) {
          widget.onTap();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          width: 120,
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isFocused ? Colors.white.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isFocused ? Colors.blue : Colors.transparent,
              width: 3,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isFocused
                      ? [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          )
                        ]
                      : [],
                ),
                child: widget.item.icon != null
                    ? ImageFromBase64(base64String: widget.item.icon!, size: 80)
                    : const Icon(Icons.android, size: 80, color: Colors.red),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.item.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: isFocused ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
