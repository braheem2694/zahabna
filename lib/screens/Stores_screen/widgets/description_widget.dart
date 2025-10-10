import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../../../cores/math_utils.dart';
import '../../../main.dart';
import '../controller/my_store_controller.dart';

class DescriptionEditor extends StatefulWidget {
  final String? args;
  final bool isLoading;

  const DescriptionEditor({super.key, this.args, required this.isLoading});

  @override
  State<DescriptionEditor> createState() => _DescriptionEditorState();
}

class _DescriptionEditorState extends State<DescriptionEditor> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: HtmlEditor(
        controller: globalController.descriptionController,
        callbacks: Callbacks(
          onInit: () async {
             globalController.descriptionController.setText(globalController.description.value);
          },
          onChangeContent: (String? changedContent) {
            globalController.description.value = changedContent ?? '';
          },
        ),
        htmlEditorOptions: HtmlEditorOptions(
          hint: "Description".tr,
          inputType: HtmlInputType.text,
          adjustHeightForKeyboard: false,
          autoAdjustHeight: false,
          androidUseHybridComposition: true,
        ),
        otherOptions: OtherOptions(
          height: getVerticalSize(200),
        ),
        htmlToolbarOptions: HtmlToolbarOptions(
          toolbarType: ToolbarType.nativeScrollable,
          toolbarPosition: ToolbarPosition.aboveEditor,
          defaultToolbarButtons: [
            FontButtons(clearAll: false),
            ListButtons(),
          ],
        ),
      ),
    );
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
