import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

  Widget subcatshimmer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 400,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          AnimationConfiguration.staggeredList(
              position: 3,
              duration: const Duration(milliseconds: 350),
              child: SlideAnimation(
                  verticalOffset: 500,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: 1,
                              itemBuilder: (BuildContext context, int index2) {
                                return Column(
                                  children: [
                                    const Divider(
                                      color: Colors.grey,
                                      height: 20,
                                      thickness: 0.6,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 15, right: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            color: Colors.grey,
                                            width: 100,
                                            height: 8,
                                          ),
                                          Container(
                                            color: Colors.grey,
                                            width: 70,
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 20.0),
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                        thickness: 0.6,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.width * 0.7,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 3,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.only(right: 16),
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 15),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                                          color: Colors.grey,
                                                        ),
                                                        width: MediaQuery.of(context).size.width * 0.3,
                                                        height: MediaQuery.of(context).size.height * 0.17,
                                                      ),
                                                    ],
                                                  ),
                                                  Container(height: 6),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        color: Colors.grey,
                                                        width: 40,
                                                        height: 8,
                                                        child: Text(''),
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                                                      ),
                                                      Icon(
                                                        Icons.favorite,
                                                        color: Colors.grey,
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        color: Colors.grey,
                                                        width: 40,
                                                        height: 8,
                                                        child: Text(''),
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 21.0),
                                                      ),
                                                      Container(
                                                        decoration: new BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                        ),
                                                        width: 40,
                                                        height: 13,
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4.0),
                                                    child: Container(
                                                      color: Colors.grey,
                                                      width: MediaQuery.of(context).size.width * 0.3,
                                                      height: 8,
                                                      child: Text(''),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4.0),
                                                    child: Container(
                                                      decoration: new BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                      ),
                                                      width: MediaQuery.of(context).size.width * 0.3,
                                                      height: 30,
                                                      child: Text(''),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    )
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),
                  ))),
        ],
      ),
    );
  }
