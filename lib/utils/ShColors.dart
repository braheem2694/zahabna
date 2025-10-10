import 'package:flutter/material.dart';
import 'package:iq_mall/widgets/ui.dart';

import '../main.dart';
import '../models/Stores.dart';

const Color sh_editText_background_active = Color(0xFFFDE9DA);
Color? verificationColor = Color(0xFFfbfbfb);

List<Color> main_gradient = [
  Colors.grey.withOpacity(0.05),
  Colors.grey.withOpacity(0.5),
];

 Color MainColor = Color(0x2b2b2b);
const Color MainColorConst = Color(0x2b2b2b);
Color Button_color = Color(0xFF281a55);
Color button_text_color = Color(0xFF281a55);
Color discount_price_color = Color(0xFF281a55);
Color price_color = Color(0xFF281a55);
Color secondaryColor = Color(0xFF64748B);
const Color sh_transparent = Colors.transparent;
const Color bbbb = Color(0xFFfbfbfb);
const Color sh_view_color = Color(0xFFCBC5C6FF);
const Color sh_textColorPrimary = Color(0xFF212121);
const Color sh_textColorSecondary = Color(0xFF757575);
const Color sh_white = Color(0xFFffffff);
const Color sh_semi_white = Color(0xFFF8F7F7);
const Color sh_black = Color(0xFF000000);
const Color sh_view_Color = Color(0xFFCBC5C6FF);
const Color redDark =  Color(0xffd00000);

const Color qIBus_gray = Color(0xFFCBC5C6);
const Color qIBus_textChild = Color(0xFF747474);
const Color qIBus_dark_gray = Color(0xFF929292);
const Color sh_editText_background = Color(0xFFF1F1F1);
const Color sh_light_gray = Color(0xFFECECEC);
const Color sh_item_background = Color(0xFFEFF3F6);
const Color sh_light_grey = Color(0xFFFAFAFA);
const Color sh_itemText_background = Color(0xFFF8F8F8);
const Color sh_shadow_Color = Color(0X95E9EBF0);

Color gray400 = fromHex('#c4c4c4');

Color black900 = fromHex('#000000');

Color bluegray400 = fromHex('#888888');

Color gray900 = fromHex('#191919');

Color gray20001 = fromHex('#ebebeb');

Color gray200 = fromHex('#eaeaea');

Color whiteA700 = fromHex('#ffffff');

Color gray100 = fromHex('#f5f5f5');

class ColorConstant {
  static Color black9007f = fromHex('#7f000000');

  static Color whiteA700B2 = fromHex('#b2ffffff');

  static Color red800 = fromHex('#c72828');

  static Color red200 = fromHex('#e8a78a');
  static Color blueA700 = fromHex('#246bfd');

  static Color red400 = fromHex('#d55a5a');

  static Color gray80001 = fromHex('#505050');

  static Color green500 = fromHex('#54b435');
  static Color blueA7003f = fromHex('#3f246bfd');

  static Color black90001 = fromHex('#000000');

  static Color lightBlueA700 = fromHex('#0395e7');

  static Color blueGray700 = fromHex('#494c57');

  static Color orange8007e = fromHex('#7eeb6309');

  static Color blueGray900 = fromHex('#2c3134');

  static Color redA700 = fromHex('#fa0b0b');

  static Color black90002 = fromHex('#000000');

  static Color black9004c = fromHex('#4c000000');

  static Color gray400 = fromHex('#c4c4c4');

  static Color blueGray100 = fromHex('#d9d9d9');

  static Color gray800 = fromHex('#393f42');

  static Color orangeA70033 = fromHex('#33fe6b04');

  static Color blue500 = fromHex('#3397e8');

  static Color orange800 = fromHex('#eb6309');

  static Color black9000c = fromHex('#0c000000');

  static Color black90099 = fromHex('#99000000');

  static Color gray10001 = fromHex('#f3f5f4');

  static Color redA70002 = fromHex('#dc0000');

  static Color black90019 = fromHex('#19000000');

  static Color redA70001 = fromHex('#c60000');

  static Color whiteA700 = fromHex('#ffffff');
  static Color logoFirstColorConstant = fromHex('#0f0649');
  static Color logoFirstColor = fromHex('#0f0649');
  static Color logoSecondColor = fromHex('#c8a443');
  static Color logoSecondColorConstant  = fromHex('#c8a443');

  static Color orangeA70026 = fromHex('#26fe6b04');

  static Color blueGray50 = fromHex('#f1f1f1');

  static Color blueGray10001 = fromHex('#d5d6d0');

  static Color red300 = fromHex('#c46e5b');

  static Color gray50 = fromHex('#f9f9fb');

  static Color black900 = fromHex('#030304');

  static Color blueGray100B2 = fromHex('#b2cdd1d8');

  static Color gray50001 = fromHex('#9e9e9e');

  static Color gray50002 = fromHex('#909090');

  static Color black90026 = fromHex('#26000000');

  static Color orange80026 = fromHex('#26eb6309');

  static Color blueGray200 = fromHex('#aeb3be');

  static Color gray500 = fromHex('#999999');

  static Color blueGray400 = fromHex('#888888');

  static Color orange700 = fromHex('#ff7a00');

  static Color orange80063 = fromHex('#63eb6309');

  static Color gray300 = fromHex('#e4e4e4');

  static Color gray30002 = fromHex('#e5e5e5');

  static Color gray30001 = fromHex('#dfdfdf');

  static Color gray100 = fromHex('#f5f5f5');

  static Color gray300B2 = fromHex('#b2e5e5e5');
  static const Color white = Color(0xFFFFFFFF);

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

void changeColorsAndDisplay(String button_color, String mainColorCode, String discountColorCode) {
  //priceColor = hexToColor(priceColorCode);
  MainColor = hexToColor(mainColorCode);
  ColorConstant.logoFirstColor=MainColor;
  Button_color = hexToColor(prefs!.getString('button_background_color')!);
  ColorConstant.logoSecondColor=Button_color;

  button_text_color = hexToColor(prefs!.getString('button_color')!);
  discount_price_color = hexToColor(prefs!.getString('discount_price_color')!);
  price_color = hexToColor(prefs!.getString('price_color')!);
  //discountColor = hexToColor(discountColorCode);
}
