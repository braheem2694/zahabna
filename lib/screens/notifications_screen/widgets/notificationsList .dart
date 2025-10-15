import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/models/Notifications.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../widgets/custom_image_view.dart';

class NotificationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: notificationslist.length,
      padding: getPadding(bottom: 0,top: 0),
      itemBuilder: (context, index) {
        return ListTile(
          minVerticalPadding: 5,
          contentPadding: getPadding(bottom: 0,left: 12,right: 12,top: 0),
          title: GestureDetector(
            onTap: () async {

            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: notificationslist[index].notification_status.toString() == '0' ? Colors.transparent : Colors.grey[200],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: getPadding(left: 12.0,top: 8),
                    child: Text(
                      notificationslist[index].subject,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      textAlign: TextAlign.left,
                      maxLines: 3,
                      style: Theme.of(context).textTheme.bodyMedium!.merge( TextStyle(fontWeight: FontWeight.w600,fontSize: getFontSize(16))),
                    ),
                  ),
                  Padding(
                    padding:getPadding(top: 5,right: 8,left: 8,bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Get.theme.focusColor.withOpacity(1),
                                    Get.theme.focusColor.withOpacity(0.2),
                                  ],
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CustomImageView(svgUrl: prefs!.getString('main_image')!,width: getSize(50),height: getSize(50),),
                                  // CircleAvatar(
                                  //   backgroundColor: Colors.black38,
                                  //   radius: 25,
                                  //   backgroundImage: NetworkImage(prefs!.getString('main_image')!),
                                  // ),
                                  const CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.notifications_none,
                                      size: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: -15,
                              bottom: -30,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(150),
                                ),
                              ),
                            ),
                            Positioned(
                              left: -20,
                              top: -55,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(150),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  notificationslist[index].is_seen.toString() == '1'
                                      ? const SizedBox()
                                      : Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: MainColor,
                                          ),
                                          child:  Text(
                                            "  ${'New'.tr}  ",
                                            style: TextStyle(color: Colors.white, fontSize: 13),
                                          ),
                                        ),
                                ],
                              ),
                              Text(
                                notificationslist[index].body,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.bodyMedium!.merge( TextStyle(fontWeight: FontWeight.w300,fontSize: getFontSize(14),color: Colors.grey[800])),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    timeAgoFromUTC(notificationslist[index].created_at),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorConstant.gray500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


String timeAgoFromUTC(String utcDateString) {
  // Parse the date string and ensure it's in UTC.
  DateTime utcDateTime = DateTime.parse(utcDateString).toUtc();

  DateTime localDateTime = utcDateTime.toLocal();
  // Return the "time ago" format using the timeago package.
  return timeago.format(localDateTime,);
}
