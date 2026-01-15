import 'package:flutter/material.dart';

class TodoInput extends StatelessWidget {
  const TodoInput({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmit;

  // värit helposti eristetty (mukavempi lukea ja muokata)
  static const _grey = Color(0xFFAEAEAE);
  static const _blue = Color(0xFF42A5F5);
  static const _bg = Color(0xFFF7F9FF);
  static const _text = Color(0xFF2E2E2E);
  static const _btnFill = Color(0xFFE9EDF6);

  static const _pad = EdgeInsets.all(16);
  static const _inputPad = EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  static const _btnPad = EdgeInsets.symmetric(horizontal: 20, vertical: 14);
  static const _pillRadius = 32.0;
  static const _btnRadius = 24.0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (_, value, __) {
        final hasText = value.text.trim().isNotEmpty;

        return Padding(
          padding: _pad,
          child: Focus(
            child: Builder(
              builder: (context) {
                final hasFocus = Focus.of(context).hasFocus;
                final borderColor = (hasFocus || hasText) ? _blue : _grey;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(_pillRadius),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          onSubmitted: onSubmit,
                          style: const TextStyle(color: _text, fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: 'Add a new todo...',
                            hintStyle: TextStyle(color: _grey, fontSize: 16),
                            border: InputBorder.none,
                            contentPadding: _inputPad,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: ElevatedButton(
                          onPressed: hasText ? () => onSubmit(value.text) : null,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                hasText ? _btnFill : Colors.transparent,
                            foregroundColor: hasText ? _blue : _grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(_btnRadius),
                            ),
                            padding: _btnPad,
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
