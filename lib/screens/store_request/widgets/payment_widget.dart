import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart' as fn; // ✅ Import compute function
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/models/store_request.dart';
import 'package:iq_mall/screens/store_request/widgets/field_row_controller.dart';
import 'package:iq_mall/screens/store_request/widgets/payment_form_data.dart';
import 'package:iq_mall/screens/store_request/widgets/payment_form_field.dart';
import 'package:iq_mall/screens/store_request/widgets/payment_form_io.dart';
import 'package:iq_mall/screens/store_request/widgets/payment_form_refiller.dart';
import 'package:iq_mall/screens/tabs_screen/controller/tabs_controller.dart';
import 'package:iq_mall/widgets/custom_button.dart';
import 'package:iq_mall/widgets/html_widget.dart';
import 'package:iq_mall/widgets/ui.dart';

import '../../../cores/assets.dart';
import '../../../utils/ShColors.dart';
import '../../store_requests/widgets/whish_payment_view.dart';
import '../../transactions/models/payment_model.dart';
import '../store_request_view.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/src/services/text_formatter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart' as pdf;

class PaymentImagePickerScreen extends StatefulWidget {
  final StoreRequest request;
  final bool isReneu;

  const PaymentImagePickerScreen(
      {super.key, required this.request, this.isReneu = false});

  @override
  _PaymentImagePickerScreenState createState() =>
      _PaymentImagePickerScreenState();
}

class _PaymentImagePickerScreenState extends State<PaymentImagePickerScreen> {
  Rxn<String>? idImage1Path = Rxn<String>();
  RxBool isLoading = false.obs;
  RxBool saving = false.obs;
  final RxList<FieldRowController> _fields = <FieldRowController>[].obs;
  final TextEditingController _htmlCtrl = TextEditingController();
  String? _requestIdForSubtitle; // optional
  final RxBool onePerLine = true.obs;
  final ImagePicker _picker = ImagePicker();
  RxString htmlContract = "".obs;
  final RxBool isSubmittingPayment = false.obs;
  final _formKey = GlobalKey<FormState>();
  late StoreRequest request;

  Future<void> pickImage(int imageNumber) async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        if (imageNumber == 1) {
          idImage1Path?.value = picked.path;
        }
      });
    }
  }

  @override
  void initState() {
    request = widget.request;
    seedDefaultPaymentFields();

    // _acceptUserDataAndRefill(data);

    super.initState();
  }

  /// Your field list (already in your state)
  void seedDefaultPaymentFields() {
    _fields
      ..forEach((f) => f.dispose())
      ..clear();

    _fields.addAll([
      FieldRowController(
        initialTitle: 'first team'.tr,
        initialValue: "Zahabna",
        isTitleLocked: true,
        entryType: FieldEntryType.text,
        valueFocusNode: FocusNode(),
        validator: (value) =>
            (value == null || value.isEmpty) ? 'This field is required' : null,
      ),
      FieldRowController(
        initialTitle: 'second team'.tr,
        initialValue: widget.request.subscriberName,
        isTitleLocked: true,
        valueFocusNode: FocusNode(),
        entryType: FieldEntryType.text,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'This field is required' : null,
      ),
      FieldRowController(
        initialTitle: 'store address'.tr,
        initialValue: widget.request.address,
        isTitleLocked: true,
        valueFocusNode: FocusNode(),
        entryType: FieldEntryType.text,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'This field is required' : null,
      ),
      FieldRowController(
        initialTitle: 'phone number'.tr,
        initialValue: widget.request.phoneNumber,
        isTitleLocked: true,
        valueFocusNode: FocusNode(),
        entryType: FieldEntryType.number,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'This field is required' : null,
      ),
      FieldRowController(
        initialTitle: 'represented by Mr.'.tr,
        initialValue: widget.request.storeName,
        isTitleLocked: true,
        valueFocusNode: FocusNode(),
        entryType: FieldEntryType.text,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'This field is required' : null,
      ),
      FieldRowController(
        initialTitle: 'his birthday'.tr,
        initialValue: widget.request.birthDay ?? "",
        isTitleLocked: true,
        valueFocusNode: FocusNode(),
        entryType: FieldEntryType.birthday,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'This field is required' : null,
      ),
      FieldRowController(
        initialTitle: 'Mothers name'.tr,
        initialValue: widget.request.motherName,
        isTitleLocked: true,
        valueFocusNode: FocusNode(),
        entryType: FieldEntryType.text,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'This field is required' : null,
      ),
      FieldRowController(
        initialTitle: 'record number'.tr + "(رقم القيد)".tr,
        initialValue: widget.request.recordNumber != null
            ? widget.request.recordNumber.toString()
            : "",
        isTitleLocked: true,
        valueFocusNode: FocusNode(),
        entryType: FieldEntryType.number,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'This field is required' : null,
      ),
      // FieldRowController(initialTitle: 'email'.tr, isRequired: false, initialValue: widget.request.email ?? '', isTitleLocked: true, entryType: FieldEntryType.text),
    ]);
    htmlContract.value =
        globalController.homeDataList.value.paymentRequestTerms ?? '';
  }

  @override
  void dispose() {
    _htmlCtrl.dispose();
    for (final f in _fields) {
      f.dispose();
    }
    super.dispose();
  }

  void _acceptUserDataAndRefill(String jsonFromUser) {
    try {
      final data = PaymentFormIO.fromJsonString(jsonFromUser);
      PaymentFormRefiller.refillPaymentForm(
        data: data,
        fields: _fields,
        htmlCtrl: _htmlCtrl,
        onRequestId: (id) {
          // If you want to show it under the AppBar title:
          setState(() => _requestIdForSubtitle = id);
        },
      );
      Fluttertoast.showToast(msg: 'Form restored successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Invalid data format');
    }
  }

  String exportCurrentFormToJson() {
    final fields = _fields
        .map((f) => PaymentFormField(
            title: f.title.text.trim(), value: f.value.text.trim()))
        .toList();

    final data = PaymentFormData(
      requestId: _requestIdForSubtitle,
      fields: fields,
      htmlText: _htmlCtrl.text,
    );

    return PaymentFormIO.toJsonString(data);
  }

  Widget imageBox(
      {required Rxn<String>? imagePath,
      required int imageNumber,
      required String label}) {
    return GestureDetector(
      onTap: () => showPickerBottomSheet(imagePath!),
      child: Container(
        height: 150,
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: imagePath == null
            ? Center(
                child:
                    Text("Click to add $label", style: TextStyle(fontSize: 16)))
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Obx(
                  () => imagePath.value != null
                      ? Image.file(
                          File(imagePath.value ?? ""),
                          fit: BoxFit.contain,
                          width: double.infinity,
                        )
                      : SizedBox(
                          child: Center(
                              child: Text("Click to add $label".tr,
                                  style: TextStyle(fontSize: 16))),
                        ),
                )),
      ),
    );
  }

  Widget _buildDynamicForm(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header + layout toggle
          Row(
            children: [
              Expanded(
                child: Text(
                  'Payment Details Form'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ColorConstant.black900,
                  ),
                ),
              ),
              // Obx(() => ToggleButtons(
              //       isSelected: [onePerLine.value, !onePerLine.value],
              //       onPressed: (idx) => onePerLine.value = (idx == 0),
              //       constraints: const BoxConstraints(minHeight: 34, minWidth: 48),
              //       borderRadius: BorderRadius.circular(8),
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 8),
              //           child: Text('1/line', style: TextStyle(fontSize: 12, color: onePerLine.value ? Colors.white : Colors.black87)),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 8),
              //           child: Text('2/line', style: TextStyle(fontSize: 12, color: !onePerLine.value ? Colors.white : Colors.black87)),
              //         ),
              //       ],
              //       selectedColor: Colors.white,
              //       color: Colors.black87,
              //       fillColor: ColorConstant.logoFirstColor,
              //     )),
            ],
          ),
          const SizedBox(height: 12),

          // Dynamic fields
          Obx(() => Form(
                key: _formKey,
                child: Column(
                  children: List.generate(_fields.length, (i) {
                    Rx<FieldRowController> row = _fields[i].obs;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Obx(
                        () => onePerLine.value
                            ? _FieldOnePerLine(
                                row: row.value,
                                isRequired: row.value.isRequired,
                                validator: row.value.validator,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onEditTitle: () =>
                                    _editTitleDialog(context, row.value),
                              )
                            : _FieldTwoPerLine(
                                row: row,
                              ),
                      ),
                    );
                  }),
                ),
              )),

          // Add field
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: TextButton.icon(
          //     onPressed: () {
          //       _fields.add(FieldRowController());
          //       WidgetsBinding.instance.addPostFrameCallback((_) {
          //         _fields.last.title.selection = TextSelection.collapsed(offset: _fields.last.title.text.length);
          //       });
          //     },
          //     icon: const Icon(Icons.add),
          //     label: Text('Add Field'.tr),
          //   ),
          // ),

          const SizedBox(height: 12),
          // HTML field
          // Text('HTML Text'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
          // const SizedBox(height: 12),
          Obx(() => SingleChildScrollView(
                child: HtmlWidget(
                  data: htmlContract.value,
                ),
              )),
          SizedBox(
            height: getVerticalSize(50),
          )
        ],
      ),
    );
  }

  Future<SubmitPaymentResult?> submitStorePayment(
      {required String requestId,
      required num amount,
      required DateTime date,
      String? token,
      required BuildContext context}) async {
    isSubmittingPayment.value = true;
    saving.value = true;

    Future.delayed(Duration(milliseconds: 400)).then(
      (value) {
        FocusScope.of(context).unfocus();
      },
    );

    final String authToken = token ?? (prefs?.getString("token") ?? "");
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    SubmitPaymentResult? result;
    try {
      // Using your existing helper (you used getData for POST earlier)
      final Map<String, dynamic> payload = {
        'request_id': requestId,
        'amount': amount, // API sample shows numeric 60
        'date': formattedDate, // e.g., 2025-09-29
        'token': authToken,
      };

      final Map<String, dynamic> res = await api.getData(
        payload,
        "stores/submit-payment",
      );

      // Defensive parsing
      if (res['success'] == true) {
        await Get.to(
                () => WhshPaymentView(
                      url: res['collect_url'],
                      requestId: requestId,
                    ),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 200))
            ?.then(
          (value) {
            if (value["key"] == "success" && value["value"] == true) {
              res.addAll({"subscription_end_date": value["end_date"]});
              result = SubmitPaymentResult.fromMap(res);
            } else {
              Ui.flutterToast(
                  (res['message'] as String?) ??
                      'Payment submission failed. Please try again.',
                  Toast.LENGTH_SHORT,
                  Colors.red,
                  whiteA700);
            }
          },
        );
        return result;
      } else {
        Ui.flutterToast(
            (res['message'] as String?) ??
                'Payment submission failed. Please try again.',
            Toast.LENGTH_SHORT,
            Colors.red,
            whiteA700);
      }
    } catch (e) {
      saving.value = false;
    } finally {
      isSubmittingPayment.value = false;
      saving.value = false;
    }
  }

  Future<void> _generatePdfAndSave(SubmitPaymentResult result) async {
    try {
      saving.value = true;

      final originalPairs = _fields
          .map((f) => MapEntry(f.title.text.trim(), f.value.text.trim()))
          .where((e) => e.key.isNotEmpty || e.value.isNotEmpty)
          .toList();

      if (originalPairs.isEmpty && _htmlCtrl.text.trim().isEmpty) {
        Fluttertoast.showToast(
            msg: 'Please add at least one field or HTML text'.tr);
        return;
      }

      final fontRegular =
          pw.Font.ttf(await rootBundle.load('assets/fonts/Cairo-Regular.ttf'));
      final fontBold =
          pw.Font.ttf(await rootBundle.load('assets/fonts/Cairo-Bold.ttf'));

      final unescape = HtmlUnescape();
      String htmlText = unescape.convert(htmlContract.value);
      htmlText = htmlText
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      // ---------- Helpers ----------
      bool _matchesAny(String key, List<String> needles) {
        final k = key.toLowerCase();
        return needles.any((n) => k.contains(n.toLowerCase()));
      }

      // Arabic label mapping (fallback to original if not matched)
      String _arabicLabelFor(String key) {
        final k = key.toLowerCase();

        if (_matchesAny(k, ['represented', 'الممثل'])) return 'الممثل بالسيد';
        if (_matchesAny(k, ['his birthday', 'birth', 'مواليد']))
          return 'مواليد';
        if (_matchesAny(
            k, ['moms name', 'mother', 'اسم الام', 'اسم الأم', 'والدته']))
          return 'اسم الأم';
        if (_matchesAny(k, ['record', 'رقم السجل', 'سجل'])) return 'رقم السجل';
        if (_matchesAny(k, ['phone number', 'phone', 'رقم الهاتف', 'هاتف']))
          return 'رقم الهاتف';

        if (_matchesAny(k, ['first team', 'الفريق الاول']))
          return 'الفريق الأول';
        if (_matchesAny(k, ['second team', 'الفريق الثاني']))
          return 'الفريق الثاني';
        if (_matchesAny(k, [
          'store address',
          'branch address',
          'عنوان الفرع',
          'store address'
        ])) return 'عنوان الفرع';
        if (_matchesAny(k, ['store name', 'اسم المتجر'])) return 'اسم المتجر';
        if (_matchesAny(k, ['address', 'العنوان'])) return 'العنوان';

        return key; // fallback
      }

      pw.Widget _kvBlock(String label, String value) {
        return pw.Row(
          mainAxisSize: pw.MainAxisSize.max,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(_arabicLabelFor(label),
                style: pw.TextStyle(font: fontBold, fontSize: 11),
                textDirection: pw.TextDirection.rtl),
            pw.SizedBox(width: 6),
            pw.Expanded(
              child: pw.Container(
                padding: const pw.EdgeInsets.only(bottom: 2),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom:
                        pw.BorderSide(width: 0.8, color: pdf.PdfColors.grey600),
                  ),
                ),
                child: value.isEmpty
                    ? pw.SizedBox()
                    : pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 2),
                          child: pw.Text(
                            value,
                            style: pw.TextStyle(
                                font: fontRegular,
                                fontSize: 10,
                                color: pdf.PdfColors.grey700),
                            textDirection: pw.TextDirection.rtl,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        );
      }

      pw.Widget _formLine(String label, String value) => pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 6),
          child: _kvBlock(label, value));

      // 3 inline items (represented, birthday, mom) on one line, record on its own line
      pw.Widget _inlineRowWide(List<MapEntry<String, String>> items) {
        final rowItems = items.take(3).toList();
        final recordItem = items.length > 3 ? items[3] : null;

        return pw.Column(
          children: [
            pw.Row(
              children: rowItems.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                return pw.Expanded(
                  child: pw.Padding(
                    // remove right padding for the first field to align with phone line
                    padding: pw.EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      right: i == 0 ? 0 : 10, // no right pad for first item
                      left: 10,
                    ),
                    child: _kvBlock(item.key, item.value),
                  ),
                );
              }).toList(),
            ),
            if (recordItem != null)
              pw.Padding(
                padding:
                    const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                child: _kvBlock(recordItem.key, recordItem.value),
              ),
          ],
        );
      }

      // ---------- Identify special fields ----------
      const representedKeys = ['الممثل', 'الممثل بالسيد', 'represented'];
      const birthKeys = ['مواليد', 'تاريخ الميلاد', 'birth', 'his birthday'];
      const motherKeys = [
        'والدته',
        'اسم الأم',
        'moms name',
        'mother',
        'اسم الام'
      ];
      const recordKeys = ['سجل', 'رقم السجل', 'record'];
      const phoneKeys = ['هاتف', 'رقم الهاتف', 'phone', 'phone number'];

      MapEntry<String, String>? represented, birth, mother, record, phone;

      for (final p in originalPairs) {
        if (represented == null && _matchesAny(p.key, representedKeys))
          represented = p;
        if (birth == null && _matchesAny(p.key, birthKeys)) birth = p;
        if (mother == null && _matchesAny(p.key, motherKeys)) mother = p;
        if (record == null && _matchesAny(p.key, recordKeys)) record = p;
        if (phone == null && _matchesAny(p.key, phoneKeys)) phone = p;
      }

      // Order: represented → birthday → moms name → record
      final inlineItems = <MapEntry<String, String>>[];
      if (represented != null)
        inlineItems.add(MapEntry('الممثل بالسيد', represented!.value));
      if (birth != null) inlineItems.add(MapEntry('مواليد', birth!.value));
      if (mother != null) inlineItems.add(MapEntry('اسم الأم', mother!.value));
      if (record != null) inlineItems.add(MapEntry('رقم السجل', record!.value));

      // ---------- Compose ----------
      final formWidgets = <pw.Widget>[];

      pw.Widget headerLine(String text) => pw.Padding(
            padding: const pw.EdgeInsets.only(top: 8, bottom: 4),
            child: pw.Text(text,
                style: pw.TextStyle(font: fontBold, fontSize: 12),
                textDirection: pw.TextDirection.rtl),
          );

      final topWidgets = <pw.Widget>[
        pw.Center(
            child: pw.Text('عقد اشتراك',
                style: pw.TextStyle(font: fontBold, fontSize: 18))),
        pw.SizedBox(height: 10),
        headerLine('موقع فيما بين:'),
      ];

      bool inlineInserted = false;

      for (final p in originalPairs) {
        final isRep = _matchesAny(p.key, representedKeys);
        final isBirth = _matchesAny(p.key, birthKeys);
        final isMom = _matchesAny(p.key, motherKeys);
        final isRec = _matchesAny(p.key, recordKeys);
        final isPhone = _matchesAny(p.key, phoneKeys);

        if (isRep || isBirth || isMom || isRec) continue;

        if (isPhone) {
          // Force Arabic label for phone line
          formWidgets.add(_formLine('رقم الهاتف', p.value));
          if (!inlineInserted && inlineItems.isNotEmpty) {
            formWidgets.add(_inlineRowWide(inlineItems));
            inlineInserted = true;
          }
        } else {
          // Normal fields get Arabic label if known
          formWidgets.add(_formLine(_arabicLabelFor(p.key), p.value));
        }
      }

      if (!inlineInserted && inlineItems.isNotEmpty) {
        if (formWidgets.isNotEmpty) {
          formWidgets.insert(1, _inlineRowWide(inlineItems));
        } else {
          formWidgets.add(_inlineRowWide(inlineItems));
        }
      }

      final doc = pw.Document();

      doc.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            margin: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 28),
            textDirection: pw.TextDirection.rtl,
            theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
          ),
          build: (context) => [
            ...topWidgets,
            pw.Column(children: formWidgets),
            pw.SizedBox(height: 18),
            pw.Text(
              htmlText,
              style: pw.TextStyle(fontSize: 11, font: fontRegular, height: 1.5),
              textDirection: pw.TextDirection.rtl,
            ),
          ],
        ),
      );

      final bytes = await doc.save();
      final dir = await getApplicationDocumentsDirectory();
      final file = File(
          '${dir.path}/payment_form_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(bytes);

      Fluttertoast.showToast(msg: 'PDF saved:\n${file.path}');
      await uploadImageInBackground({
        "request_id": widget.request.id,
        "file": file.path,
        "token": prefs!.getString("token"),
        "table_name": result.tableName,
        "type": result.attachmentKind,
      });
      saving.value = false;
      await OpenFilex.open(file.path);
    } catch (e) {
      saving.value = false;
      Fluttertoast.showToast(msg: 'Failed to generate PDF: $e');
    }
  }

  Future<pw.Font> getArabicFont() async {
    if (arabicFont == null) {
      final data =
          await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf");
      arabicFont = pw.Font.ttf(data);
    }
    return arabicFont!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstant.white,
          elevation: 0,
          scrolledUnderElevation: 0, // keep it flat when scrolling
          centerTitle: false,
          toolbarHeight: 56,

          leadingWidth: 64, // extra room for the rounded back chip
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Ui.backArrowIcon(
              iconColor: ColorConstant.logoFirstColor,
              onTap: () => Get.back(),
            ),
          ),
          titleSpacing: 0,
          title: Text(
            "Payment Receipt".tr,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 18,
              letterSpacing: 0.2,
            ),
          ),

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: Colors.black
                  .withOpacity(0.08), // subtle divider under the app bar
            ),
          ),
        ),
        body: Padding(
          padding: getPadding(
            left: 12,
            right: 12,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: getPadding(top: 10),
                  child: PaymentSummaryCard(
                    methodName: "Whish Payment".tr,
                    logo: "https://example.com/visa.png",
                    logoIsNetwork: true,
                    beforePaymentText:
                        "Please review your details before proceeding".tr,
                    amountText:
                        "${globalController.homeDataList.value.requestPrice.toString()}\$",
                    onTap: () {
                      // open payment method selection, etc.
                    },
                  ),
                ),

                // imageBox(imagePath: idImage1Path, imageNumber: 1, label: "payment receipt".tr),
                const SizedBox(height: 12),
                // Obx(() => CheckboxListTile(
                //       value: globalController.paymentAgreedToTerms.value,
                //       onChanged: (v) {
                //         if (v == true) {
                //           // Let dialog set it to true on accept
                //           globalController.paymentAgreedToTerms.value = false;
                //           showTermsDialog(true, globalController.homeDataList.value.paymentRequestTerms ?? '');
                //         } else {
                //           globalController.paymentAgreedToTerms.value = false;
                //         }
                //       },
                //       checkColor: ColorConstant.white,
                //       activeColor: ColorConstant.logoFirstColor,
                //       title: Text('Agree to Terms'.tr),
                //       subtitle: Text('Required to proceed'.tr, style: const TextStyle(color: Colors.red)),
                //       controlAffinity: ListTileControlAffinity.leading,
                //     )),
                // const SizedBox(height: 12),

                // ---- Dynamic form (only visible when agreed) ----
                _buildDynamicForm(context),

                const SizedBox(height: 12),

                // Confirm button (kept as-is)
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Obx(() => Align(
              alignment: Alignment.bottomCenter,
              child: MyCustomButton(
                  height: getVerticalSize(50),
                  text: "Confirm payment".tr,
                  fontSize: 20,
                  variant: ButtonVariant.FillDeeporange300,
                  circularIndicatorColor: Colors.white,
                  width: 280,
                  isExpanded: saving.value,
                  onTap: () async {
                    final amount = globalController
                            .homeDataList.value.requestPrice!
                            .toDouble() +
                        globalController.homeDataList.value.requestFees!
                            .toDouble();
                    final now = DateTime.now();
                    final dateStr = DateFormat('yyyy-MM-dd').format(now);
                    Future.delayed(Duration(milliseconds: 400)).then(
                      (value) {
                        FocusScope.of(context).unfocus();
                      },
                    );
                    await Get.dialog(
                      _ConfirmSubmitPaymentDialog(
                          amount: amount,
                          dateLabel: dateStr,
                          onConfirm: () async {
                            // 0) validate required fields first
                            final isValid =
                                _formKey.currentState?.validate() ?? false;
                            if (!isValid) {
                              Navigator.of(context).pop(false);

                              Ui.flutterToast(
                                  "Please fill all required fields correctly.",
                                  Toast.LENGTH_SHORT,
                                  Colors.red,
                                  whiteA700);
                              return;
                            }
                            Navigator.of(context).pop(false);

                            final SubmitPaymentResult? result =
                                await submitStorePayment(
                                    requestId: widget.request.id,
                                    amount: amount,
                                    date: now,
                                    context: context);
                            //
                            // // If submit failed, inform user and keep screen
                            if (result == null || !result.success) {
                              Get.snackbar('Payment', 'Payment failed.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 3));
                              return; // don't proceed to PDF or pop screens
                            } else {
                              request.status = "Accepted";
                              request.endDate = result.subscriptionEndDate;
                            }

                            // 2) (optional) generate PDF if first-time (no transaction) and not a renew
                            if (result != null) {
                              await _generatePdfAndSave(result);
                            }

                            // 3) close the confirm dialog
                            // Get.back(); // closes the dialog only

                            // 4) return to previous screen with the subscriptionEndDate as result
                            FetchStores();
                            Get.back(result: request);
                          }),
                      barrierDismissible: false,
                    );
                  }),
            )),
      ),
    );
  }

  Future<void> uploadImageInBackground(Map<String, dynamic> args) async {
    isLoading.value = true;
    String filePath = args["file"];
    if (filePath.isNotEmpty) {
      File file = File(filePath);
      if (!await file.exists()) {
        print("❌ File does not exist: $filePath");
        return;
      }

      try {
        fn.Uint8List fileBytes = await file.readAsBytes();

        dio.FormData data = dio.FormData.fromMap({
          "file": dio.MultipartFile.fromBytes(
            fileBytes,
            filename: args["file"].toString().split('/').last,
          ),
          "token": args["token"],
          "table_name": args["table_name"].toString(),
          "row_id": args["request_id"].toString(),
          "type": args["type"].toString(),
        });

        dio.Dio dio2 = dio.Dio();

        var response = await dio2.post(
          "${con}side/upload-images",
          data: data,
          options: dio.Options(
            headers: {
              'Accept': "application/json",
              'Authorization': '${args["token"]}',
            },
          ),
        );
        globalController.paymentAgreedToTerms.value = false;

        if (response.statusCode == 200) {
          isLoading.value = false;
          var responseData = response.data;
          if (responseData['succeeded'] == true) {
          } else {}
        } else {}
      } catch (e) {
        isLoading.value = false;
        globalController.paymentAgreedToTerms.value = false;
        print('❌ Error while uploading: $e');
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }
}

class _FieldRow {
  final TextEditingController title = TextEditingController();
  final TextEditingController value = TextEditingController();
  void dispose() {
    title.dispose();
    value.dispose();
  }
}

class PaymentSummaryCard extends StatelessWidget {
  final String methodName;
  final String? logo; // can be asset path or network url
  final bool logoIsNetwork;
  final String beforePaymentText; // e.g. "Please review before payment"
  final String amountText; // e.g. "$250.00"
  final VoidCallback? onTap; // optional action

  const PaymentSummaryCard({
    super.key,
    required this.methodName,
    this.logo,
    this.logoIsNetwork = true,
    required this.beforePaymentText,
    required this.amountText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (isDark ? Colors.white12 : Colors.black12),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                offset: const Offset(0, 6),
                blurRadius: 16,
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top row: logo + method name
            Row(
              children: [
                _Logo(logo: logo, isNetwork: logoIsNetwork),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    methodName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                // if (onTap != null) Icon(Icons.chevron_right_rounded, color: theme.colorScheme.primary),
              ],
            ),

            const SizedBox(height: 12),

            // Middle: hint / before-payment text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      beforePaymentText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Bottom: amount
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: (isDark ? Colors.white10 : Colors.grey.shade50),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: (isDark ? Colors.white12 : Colors.black12)),
              ),
              child: Row(
                children: [
                  Text(
                    'Payment Amount'.tr,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    amountText,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 0),
                child: Text(
                  globalController.homeDataList.value.requestFees!
                          .toStringAsFixed(2) +
                      " \$ will be added as a fees".tr,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final String? logo;
  final bool isNetwork;

  const _Logo({required this.logo, required this.isNetwork});

  @override
  Widget build(BuildContext context) {
    final double size = 36;

    Widget inner;
    if (logo == null || logo!.trim().isEmpty) {
      inner = Icon(Icons.account_balance_wallet_rounded,
          size: 22, color: ColorConstant.logoSecondColor);
    } else if (isNetwork) {
      inner = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          logo!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.account_balance_wallet_rounded,
            size: 22,
            color: ColorConstant.logoSecondColor,
          ),
        ),
      );
    } else {
      inner = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          logo!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ColorConstant.logoSecondColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: inner),
    );
  }
}

// import 'package:intl/intl.dart'; // Make sure this is imported
// import 'package:flutter/services.dart'; // For FilteringTextInputFormatter

class _FieldOnePerLine extends StatelessWidget {
  const _FieldOnePerLine({
    required this.row,
    this.onEditTitle,
    this.isRequired = false,
    this.validator, // custom validator (optional)
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final FieldRowController row;
  final VoidCallback? onEditTitle;

  /// NEW
  final bool isRequired;

  /// NEW: Optional custom validator; if provided, it runs *after* the built-in checks.
  /// Return a non-null string to show an error.
  final String? Function(String? value)? validator;

  /// NEW: Control when validation errors appear (defaults to on user interaction)
  final AutovalidateMode autovalidateMode;

  Future<void> _pickBirthday(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime(now.year - 18, now.month, now.day), // default: 18 years old
      firstDate: DateTime(1900, 1, 1),
      lastDate: now,
      helpText: 'Select birthday',
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(
                primary: Theme.of(ctx).colorScheme.primary,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      row.value.text = DateFormat('yyyy-MM-dd').format(picked);
      row.value.selection =
          TextSelection.collapsed(offset: row.value.text.length);
      row.value.notifyListeners();
    }
  }

  /// Built-in validation based on entry type + isRequired.
  String? _builtInValidate(String? v) {
    final value = (v ?? '').trim();

    if (isRequired && value.isEmpty) {
      return 'This field is required';
    }

    switch (row.entryType) {
      case FieldEntryType.text:
        // no extra checks
        break;

      case FieldEntryType.number:
        if (value.isNotEmpty && num.tryParse(value) == null) {
          return 'Enter a valid number';
        }
        break;

      case FieldEntryType.birthday:
        if (value.isNotEmpty) {
          try {
            // Expecting yyyy-MM-dd
            DateFormat('yyyy-MM-dd').parseStrict(value);
          } catch (_) {
            return 'Use format YYYY-MM-DD';
          }
        }
        break;
    }
    return null;
  }

  /// Compose built-in validator with user-supplied validator (user one runs last).
  String? _effectiveValidator(String? v) {
    final builtIn = _builtInValidate(v);
    if (builtIn != null) return builtIn;
    if (validator != null) return validator!(v);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild when title or value changes
    return AnimatedBuilder(
      animation: Listenable.merge([row.title, row.value]),
      builder: (context, _) {
        final titleText = (row.title.text.isEmpty) ? 'Title' : row.title.text;

        // Configure per entry type
        TextInputType? keyboardType;
        List<TextInputFormatter>? inputFormatters;
        bool readOnly = false;
        GestureTapCallback? onTap;
        Widget? suffixIcon;

        switch (row.entryType) {
          case FieldEntryType.text:
            keyboardType = TextInputType.text;
            inputFormatters = null;
            readOnly = false;
            suffixIcon = (row.value.text.isNotEmpty)
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, size: 16),
                    onPressed: () {
                      row.value.clear();
                      row.value.notifyListeners();
                    },
                    splashRadius: 18,
                  )
                : null;
            break;

          case FieldEntryType.number:
            keyboardType = TextInputType.number;
            inputFormatters = [FilteringTextInputFormatter.digitsOnly];
            readOnly = false;
            suffixIcon = (row.value.text.isNotEmpty)
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, size: 16),
                    onPressed: () {
                      row.value.clear();
                      row.value.notifyListeners();
                    },
                    splashRadius: 18,
                  )
                : null;
            break;

          case FieldEntryType.birthday:
            keyboardType = TextInputType.datetime;
            inputFormatters = null;
            readOnly = true; // open a date picker instead
            onTap = () => _pickBirthday(context);
            suffixIcon = IconButton(
              tooltip: 'Pick date',
              icon: const Icon(Icons.calendar_today_rounded, size: 16),
              onPressed: () => _pickBirthday(context),
              splashRadius: 18,
            );
            break;
        }

        // Build a label that can show a red asterisk for required fields.
        final label = RichText(
          text: TextSpan(
            text: row.entryType == FieldEntryType.birthday
                ? 'YYYY-MM-DD'
                : titleText,
            style: Theme.of(context).inputDecorationTheme.labelStyle ??
                Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black54),
            children: isRequired
                ? const [
                    TextSpan(text: ' *', style: TextStyle(color: Colors.red))
                  ]
                : const [],
          ),
        );

        return TextFormField(
          controller: row.value,
          readOnly: readOnly,
          onTap: onTap,
          autovalidateMode: autovalidateMode,
          validator: _effectiveValidator,
          textInputAction: TextInputAction.next,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600, height: 1.2),
          decoration: InputDecoration(
            label: label, // uses the RichText above
            isDense: false,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFF1976D2), width: 1.4),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
            ),
            suffixIcon: suffixIcon,
          ),
        );
      },
    );
  }
}

/// ========== 2 per line ==========
/// Your original “Title + Value” side-by-side (polished).
class _FieldTwoPerLine extends StatelessWidget {
  const _FieldTwoPerLine({
    required this.row,
  });
  final Rx<FieldRowController> row;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Title
        Expanded(
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: row.value.title,
            builder: (context, value, _) {
              return Obx(() => TextField(
                    controller: row.value.title,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600, height: 1.2),
                    decoration: InputDecoration(
                      labelText: 'Title'.tr,
                      hintText: 'e.g. Bank Name'.tr,
                      labelStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87),
                      floatingLabelStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1976D2)),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFF1976D2), width: 1.4),
                      ),
                      prefixIcon: const Icon(Icons.badge_outlined,
                          size: 18, color: Colors.black54),
                      prefixIconConstraints: const BoxConstraints(minWidth: 40),
                      suffixIcon: value.text.isNotEmpty
                          ? IconButton(
                              tooltip: 'Clear',
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.close_rounded, size: 16),
                              onPressed: () {
                                row.value.title.clear();
                                row.value.valueFocusNode.requestFocus();
                              },
                              splashRadius: 18,
                            )
                          : null,
                    ),
                  ));
            },
          ),
        ),
        const SizedBox(width: 8),
        // Value
        Expanded(
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: row.value.value,
            builder: (context, value, _) {
              return TextField(
                controller: row.value.value,
                textInputAction: TextInputAction.next,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600, height: 1.2),
                decoration: InputDecoration(
                  labelText: 'Value'.tr,
                  hintText: 'e.g. User Name'.tr,
                  labelStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                  floatingLabelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1976D2)),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFF1976D2), width: 1.4),
                  ),
                  prefixIcon: const Icon(Icons.edit_note_outlined,
                      size: 18, color: Colors.black54),
                  prefixIconConstraints: const BoxConstraints(minWidth: 40),
                  suffixIcon: value.text.isNotEmpty
                      ? IconButton(
                          tooltip: 'Clear',
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close_rounded, size: 16),
                          onPressed: () => row.value.value.clear(),
                          splashRadius: 18,
                        )
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Inline dialog to edit the "Title" when in 1-per-line mode.
Future<void> _editTitleDialog(
    BuildContext context, FieldRowController row) async {
  final tempCtrl = TextEditingController(text: row.title.text);
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Edit Title'.tr),
      content: TextField(
        controller: tempCtrl,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Title…',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx), child: Text('Cancel'.tr)),
        ElevatedButton(
          onPressed: () {
            // Update and explicitly notify to trigger rebuilds
            row.title.text = tempCtrl.text;
            row.title.selection =
                TextSelection.collapsed(offset: row.title.text.length);
            row.title.notifyListeners(); // <-- ensures listeners rebuild
            Navigator.pop(ctx);
          },
          child: Text('Save'.tr),
        ),
      ],
    ),
  );
}

// --- Confirm dialog (submit payment) ---
class _ConfirmSubmitPaymentDialog extends StatefulWidget {
  const _ConfirmSubmitPaymentDialog({
    super.key,
    required this.amount,
    required this.dateLabel,
    required this.onConfirm, // must perform the submit + any follow-ups
  });

  final num amount;
  final String dateLabel; // e.g., "2025-09-29"
  final Future<void> Function() onConfirm;

  @override
  State<_ConfirmSubmitPaymentDialog> createState() =>
      _ConfirmSubmitPaymentDialogState();
}

class _ConfirmSubmitPaymentDialogState
    extends State<_ConfirmSubmitPaymentDialog> {
  RxBool isSubmittingPayment = false.obs;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_rounded, size: 40, color: Colors.red),
            const SizedBox(height: 12),
            Text('Confirm payment?'.tr,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              // keep it concise and clear
              'You are about to submit a payment of  ${(double.parse(globalController.homeDataList.value.requestPrice.toString()) + double.parse(globalController.homeDataList.value.requestFees.toString()))}\$\nThis action will be recorded.'
                  .trParams({
                'amount':
                    '${(double.parse(globalController.homeDataList.value.requestPrice.toString()) + double.parse(globalController.homeDataList.value.requestFees.toString()))}\$',
                'date': widget.dateLabel
              }),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Cancel'.tr),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // run the provided submit logic while keeping dialog open (shows spinner)
                      try {
                        isSubmittingPayment.value = true;
                        await widget.onConfirm();
                      } finally {
                        isSubmittingPayment.value = false;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Obx(() => isSubmittingPayment.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white)),
                          )
                        : Text('Yes, submit'.tr)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
