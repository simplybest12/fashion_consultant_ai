import 'package:ai_fashion_consultant/src/utils/helper.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class ResponseScreen extends StatelessWidget {
  final String response;
  const ResponseScreen({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        excludeHeaderSemantics: true,
        title: const Text('AI Fashion'),
        centerTitle: false,
        backgroundColor: AppColor.silverGrey.withOpacity(0.8),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12).copyWith(top: AppHelperFunctions.screenSize(context).height*0.13),
       child: ListTile(
         title: Text(response),
       ),
        ),
      ),
    );
  }
}
