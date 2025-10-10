import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iq_mall/models/category.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/widgets/custom_image_view.dart';
import 'package:iq_mall/widgets/ui.dart';
import '../../../cores/math_utils.dart';
import '../../../main.dart';
import 'package:flutter/material.dart';

import '../../../models/Stores.dart';
import '../../../utils/ShColors.dart';
import '../../Stores_details/controller/store_detail_controller.dart';

// ignore: must_be_immutable
class storeWorkTime extends StatefulWidget {
  final int index;


  storeWorkTime({super.key, required this.index});

  @override
  State<storeWorkTime> createState() => _storeWorkTimeState();
}

class _storeWorkTimeState extends State<storeWorkTime> {
  var controller = Get.find<StoreDetailController>();
  bool isSwitched = false;


  @override
  initState(){
    super.initState();
    isSwitched = controller.store.value.storeWorkingDays![widget.index].isOff == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250), // Animation duration
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child); // Scale animation
          },
          child: !controller.isEdit.value
              ? Container(
            key: const ValueKey('viewMode'), // Unique key for this mode
            width: getHorizontalSize(90.00),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: controller.store.value.storeWorkingDays![widget.index].isOff != 1
                    ? [
                  ColorConstant.logoFirstColor,
                  ColorConstant.logoFirstColor.withOpacity(0.9),
                  ColorConstant.logoFirstColor.withOpacity(0.8),
                  ColorConstant.logoFirstColor.withOpacity(0.7),
                ]
                    : [
                  Colors.grey,
                  Colors.grey.withOpacity(0.9),
                  Colors.grey.withOpacity(0.8),
                  Colors.grey.withOpacity(0.7),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: getPadding(left: 4, right: 4,bottom: 20,top: 6),
                    child: Text(
                      controller.store.value.storeWorkingDays![widget.index].day ?? "",
                      maxLines: 3,
                      textDirection: TextDirection.rtl,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: getFontSize(14), color: Colors.white),
                    ),
                  ),
                ),
                if (controller.store.value.storeWorkingDays![widget.index].isOff == 1)

                const Spacer(),
                if (controller.store.value.storeWorkingDays![widget.index].isOff == 1)
                  Text(
                    "Closed",
                    textDirection: TextDirection.rtl,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: getFontSize(14), color: Colors.white),
                  ),
                if (controller.store.value.storeWorkingDays![widget.index].isOff == 1)

                const Spacer(),

                if (controller.store.value.storeWorkingDays![widget.index].isOff == 0)
                  ...[
                    Padding(
                      padding: getPadding(left: 4, right: 4,),
                      child: Text(
                        controller.store.value.storeWorkingDays![widget.index].openTime ?? "Set Time",
                        maxLines: 3,
                        textDirection: TextDirection.ltr,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: getFontSize(14), color: Colors.white),
                      ),
                    ),

                    Padding(
                      padding: getPadding(left: 4, right: 4,top: 15),
                      child: Text(
                        controller.store.value.storeWorkingDays![widget.index].closeTime ?? "Set Time",
                        maxLines: 3,
                        textDirection: TextDirection.ltr,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: getFontSize(14), color: Colors.white),
                      ),
                    ),
                  ],
                const Spacer(),
              ],
            ),
          )
              : Container(
            key: const ValueKey('editMode'), // Unique key for this mode

            width: getHorizontalSize(90.00),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorConstant.logoSecondColor,
                  ColorConstant.logoSecondColor.withOpacity(0.9),
                  ColorConstant.logoSecondColor.withOpacity(0.8),
                  ColorConstant.logoSecondColor.withOpacity(0.7),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: getPadding(left: 4, right: 4,bottom: 10,top: 6),
                  child: Text(
                    controller.store.value.storeWorkingDays![widget.index].day ?? "",
                    maxLines: 3,
                    textDirection: TextDirection.rtl,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: getFontSize(14),
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(20),
                  child: Center(
                    child: Padding(
                      padding: getPadding(left: 4, right: 4, bottom: 0),
                      child: Obx(() {
                        return GestureDetector(
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: controller.store.value.storeWorkingDays![widget.index].openTime != null
                                  ? TimeOfDay(
                                hour: int.parse(controller.store.value.storeWorkingDays![widget.index].openTime!.split(":")[0]),
                                minute: int.parse(controller.store.value.storeWorkingDays![widget.index].openTime!.split(":")[1]
                                    .split("")
                                    .first),
                              )
                                  : TimeOfDay.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    timePickerTheme: TimePickerThemeData(
                                      backgroundColor: Colors.white,
                                      // Dialog background color
                                      hourMinuteTextColor: Colors.white,
                                      // Hour/Minute text color
                                      hourMinuteColor: ColorConstant.logoFirstColor,
                                      // Hour/Minute field background
                                      dialBackgroundColor: ColorConstant.logoSecondColor,
                                      // Clock background
                                      dialHandColor: Colors.white,
                                      // Clock hand color
                                      dialTextColor: ColorConstant.logoFirstColor,
                                      dayPeriodTextColor: ColorConstant.logoFirstColor,
                                      dayPeriodColor: ColorConstant.logoSecondColor,
                                      // AM/PM text color// Clock numbers color
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (pickedTime != null) {
                              // Update controller with the selected time
                              setState(() {
                                controller.store.value.storeWorkingDays![widget.index].openTime = pickedTime.format(context);
                              });
                            }
                          },
                          child: Container(
                            padding: getPadding(bottom: 4),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.white70,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Text(
                              controller.store.value.storeWorkingDays![widget.index].openTime ?? "Open",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: getFontSize(14), // Smaller font size for display
                                color:
                                controller.store.value.storeWorkingDays![widget.index].openTime == null ? ColorConstant.logoFirstColor : Colors.white, // Text color
                              ),
                            ),
                          ),
                        );
                      })
                      ,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: getPadding(bottom: 4.0),

                  child: SizedBox(
                    height: getVerticalSize(20),

                    child: Center(
                      child: Padding(
                        padding: getPadding(left: 4, right: 4),
                        child: Obx(() {
                          return GestureDetector(
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,

                                initialTime: controller.store.value.storeWorkingDays![widget.index].closeTime != null
                                    ? TimeOfDay(
                                  hour: int.parse(controller.store.value.storeWorkingDays![widget.index].closeTime!.split(":")[0]),
                                  minute: int.parse(controller.store.value.storeWorkingDays![widget.index].closeTime!.split(":")[1]
                                      .split("")
                                      .first),
                                )
                                    : TimeOfDay.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      timePickerTheme: TimePickerThemeData(
                                        backgroundColor: Colors.white,
                                        // Dialog background color
                                        hourMinuteTextColor: Colors.white,
                                        // Hour/Minute text color
                                        hourMinuteColor: ColorConstant.logoFirstColor,
                                        // Hour/Minute field background
                                        dialBackgroundColor: ColorConstant.logoSecondColor,
                                        // Clock background
                                        dialHandColor: Colors.white,
                                        // Clock hand color
                                        dialTextColor: ColorConstant.logoFirstColor,
                                        dayPeriodTextColor: ColorConstant.logoFirstColor,
                                        dayPeriodColor: ColorConstant.logoSecondColor,
                                        // AM/PM text color// Clock numbers color
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (pickedTime != null) {
                                // Update controller with the selected time
                                setState(() {
                                  controller.store.value.storeWorkingDays![widget.index].closeTime =
                                      pickedTime.format(context);
                                }); // Update the controller's text
                              }
                            },
                            child: Container(
                              padding: getPadding(bottom: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white70,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                controller.store.value.storeWorkingDays![widget.index].closeTime ?? "Close",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: getFontSize(14), // Smaller font size for display
                                  color: controller.store.value.storeWorkingDays![widget.index].closeTime == null ? ColorConstant.logoFirstColor : Colors.white, // Dimmed hint-style text color
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: getSize(50), // Custom width for the switch
                  height: getSize(40), // Custom height for the switch
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                          controller.store.value.storeWorkingDays![widget.index].isOff = isSwitched?0:1;
                        });
                        Ui.flutterToast('${controller.store.value.storeWorkingDays![widget.index].day} is ${isSwitched ? "OPEN" : "CLOSED"}'.tr, Toast.LENGTH_LONG, ColorConstant.logoFirstColor, whiteA700);
                      },
                      activeTrackColor: Colors.green,
                      activeColor: Colors.white,
                      inactiveThumbColor: ColorConstant.logoFirstColor,
                      inactiveTrackColor: Colors.white,
                    ),
                  ),
                ),


              ],
            ),
          )
        ),
    );

  }

  /// Helper function to convert 12-hour format string to TimeOfDay
  /// Helper function to convert 12-hour format string to TimeOfDay
  TimeOfDay _convertToTimeOfDay(String timeString) {
    try {
      final timeParts = timeString.split(' '); // Split into time and period (AM/PM)
      if (timeParts.length != 2) {
        throw FormatException('Invalid time format');
      }

      final period = timeParts[1].toUpperCase(); // AM or PM
      final time = timeParts[0].split(':');
      if (time.length != 2) {
        throw FormatException('Invalid time format');
      }

      int hour = int.parse(time[0]);
      final minute = int.parse(time[1]);

      // Adjust hour for AM/PM
      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      throw FormatException('Invalid time format: $timeString');
    }
  }
}
