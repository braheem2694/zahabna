import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';

class RowItem extends StatelessWidget {
  final Icon icon;
  final String? title;
  final VoidCallback? callback;

  const RowItem({required this.icon, required this.title, this.callback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(

        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1),borderRadius: BorderRadius.circular(15.0)),
        padding: const EdgeInsets.fromLTRB(spacing_standard, 0, spacing_control_half, 0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: icon,
            ),
            Expanded(
              child: Text(
                title!,
                style: const TextStyle(color: sh_textColorPrimary, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0,bottom: 8),
              child: InkWell(
                onTap: callback,
                child: const Icon(
                  Icons.keyboard_arrow_right,
                  color: sh_textColorPrimary,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
