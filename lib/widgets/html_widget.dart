import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_html/flutter_html.dart' as html;

class HtmlWidget extends StatelessWidget {
  final String? data;
  final int? maxLines;
  final double? fontSize;

  const HtmlWidget({Key? key, required this.data, this.maxLines, this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(data);
    var unescape = HtmlUnescape();
    String text = unescape.convert(data ?? '');
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(15)),
      constraints: BoxConstraints(
        minHeight: getVerticalSize(80),
      ),
      padding: getPadding(left: 25, right: 25),
      child: html.Html(
        data: text,
        onLinkTap: (url, attributes, element) async {
          final Uri uri = Uri.parse(url ?? '');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            throw 'Could not launch $url';
          }
        },
        // style: {
        //   "p": html.Style(
        //       // This sets the general text color
        //       margin: Margins.zero,
        //       fontSize: fontSize != null ? html.FontSize(fontSize!) : null,
        //       maxLines: maxLines,

        //       padding: HtmlPaddings.only(top: 5, bottom: 5),
        //       textAlign: TextAlign.start,
        //       alignment: Alignment.topRight,
        //       color: Colors.black,
        //       textDecorationColor: Colors.black,
        //       whiteSpace: WhiteSpace.normal,
        //       textOverflow: TextOverflow.visible,
        //       fontWeight: FontWeight.w400),
        //   "body": html.Style(
        //       // This sets the general text color
        //       margin: Margins.zero,
        //       textDecorationColor: Colors.black,
        //       maxLines: maxLines,
        //       fontSize: fontSize != null ? html.FontSize(fontSize!) : null,
        //       padding: HtmlPaddings.only(top: 5, bottom: 5),
        //       textAlign: TextAlign.start,
        //       alignment: Alignment.topRight,
        //       whiteSpace: WhiteSpace.normal,
        //       color: Colors.black,
        //       textOverflow: TextOverflow.visible,
        //       fontWeight: FontWeight.w200),

        //   // You can add more tags and styles as needed
        // },
      ),
    );
  }
}
