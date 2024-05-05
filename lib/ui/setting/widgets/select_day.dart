import 'package:beyond_vision/core/constants.dart';
import 'package:flutter/material.dart';

class SelectImage extends StatelessWidget {
  final int index;
  final String name;
  final bool isSelected;
  final void Function(int index) onTap;
  const SelectImage(
      {super.key,
      required this.index,
      required this.name,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onTap(index),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: isSelected
                        ? const Color(fontYellowColor)
                        : Colors.transparent,
                    width: isSelected ? 3.0 : 0.0),
                shape: BoxShape.circle),
            child: Center(
              child: Text(name,
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? const Color(fontYellowColor)
                          : Colors.white)),
            ),
          ),
        ));
  }
}
