/// Expandable Text Widget
/// Shows text truncated to [trimLines] lines with a "Read More" toggle.
/// Tap "Read More" to see full text, "Read Less" to collapse back.
library;

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int trimLines;
  final TextAlign textAlign;

  const ExpandableText(
      this.text, {
        super.key,
        this.style,
        this.trimLines = 2,
        this.textAlign = TextAlign.start,
      });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.text.isEmpty) return const SizedBox.shrink();

    final style = widget.style ??
        TextStyle(fontSize: 13, color: AppColors.text2Of(context));

    return LayoutBuilder(
      builder: (context, constraints) {
        // Check whether the text actually overflows at trimLines.
        final span = TextSpan(text: widget.text, style: style);
        final tp = TextPainter(
          text: span,
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final doesOverflow = tp.didExceedMaxLines;

        if (!doesOverflow) {
          // Fits within trimLines already — no toggle needed.
          return Text(widget.text, style: style, textAlign: widget.textAlign);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: style,
              textAlign: widget.textAlign,
              maxLines: _expanded ? null : widget.trimLines,
              overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _expanded ? 'Read Less' : 'Read More',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.cyan,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}