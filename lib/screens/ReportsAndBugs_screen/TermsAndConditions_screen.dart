import 'package:iq_mall/screens/ReportsAndBugs_screen/controller/TermsAndConditions_controller.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:get/get.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShImages.dart';

class ReportsAndBugsscreen extends GetView<ReportsAndBugsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Text(
          'Recommendations and bugs'.tr,
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          Image.asset(
            AssetPaths.recomandations,
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              focusNode: controller.focusNode,
              controller: controller.text,
              decoration:  InputDecoration(
                labelText: 'What\'s in your mind',
                labelStyle: TextStyle(color: MainColor),
                border: OutlineInputBorder(),
              ),
              minLines: 8,
              maxLines: null,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  controller.value.value = 1;
                },
                icon: Icon(
                  controller.value.value == 1 ? Icons.check_box : Icons.check_box_outline_blank,
                  color: controller.value.value == 1 ? Colors.green : Colors.black,
                ),
              ),
              GestureDetector(
                  onTap: () {
                    controller.value.value = 1;
                  },
                  child: Text('Recommendation'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: controller.value.value == 1 ? Colors.green : Colors.black,
                      ))),
              Container(
                width: 20,
              ),
              IconButton(
                onPressed: () {
                  controller.value.value = 2;
                },
                icon: Icon(
                  controller.value.value == 2 ? Icons.check_box : Icons.check_box_outline_blank_outlined,
                  color: controller.value.value == 2 ? Colors.green : Colors.black,
                ),
              ),
              GestureDetector(
                  onTap: () {
                    controller.value.value = 2;
                  },
                  child: Text('Report bug'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: controller.value.value == 2 ? Colors.green : Colors.black,
                      ))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 28.0, right: 28, top: 25),
                child: GestureDetector(
                  onTap: () {
                    if (controller.loading.value) {
                    } else {
                      if (controller.text.text.isEmpty) {
                        toaster(context, 'Fill the description please'.tr);
                      } else if (controller.value.value == -1) {
                        toaster(context, 'Please choose the report type'.tr);
                      } else {
                        controller.Insertdata();
                      }
                    }
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration:  BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                      ),
                      color: MainColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 5, left: 20.0, right: 20),
                      child: Center(
                        child: Obx(()=>controller.loading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                )),
                              )
                            :  Text(
                                'Submit'.tr,
                                style: const TextStyle(color: Colors.white, fontSize: 18),
                              ),
                        )
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
