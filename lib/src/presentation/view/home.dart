import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ai_fashion_consultant/src/presentation/view/controller.dart';
import 'package:ai_fashion_consultant/src/presentation/view/response_screen.dart';
import 'package:ai_fashion_consultant/src/utils/constants.dart';
import 'package:ai_fashion_consultant/src/utils/file_picker.dart';
import 'package:ai_fashion_consultant/src/utils/helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(ImageController());

  String occasion = "";
  bool error = false;
  bool isLoading = false;

  bool isPersonPortrait = false;

  final gemini = Gemini.instance;

  Future<String> imageAnalyzer(String text, File image) async {
    String result = '';
    try {
      setState(() {
        isLoading = true;
      });

      // Convert image to bytes
      final imageBytes = await image.readAsBytes();

      // Debugging output
      print("Starting image analysis...");
      print("Text for analysis: $text");
      print("Image file path: ${image.path}");

      // Make the API call

      final response = await gemini.textAndImage(
        text: text,
        images: [imageBytes], // Ensure this format is correct
      );

      // Debugging output for response handling
      print("Received response from Gemini API: $response");

      // Check if response and its content are valid
      if (response != null &&
          response.content != null &&
          response.content!.parts != null &&
          response.content!.parts!.isNotEmpty) {
        setState(() {
          result = response.content!.parts![0].text ?? "No text found";
          isLoading = false;
        });
        print("Analysis successful, result: $result");
      } else {
        throw Exception("Unexpected response structure or empty response");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      // Improved error handling
      if (e is GeminiException) {
        print("GeminiException occurred: $e");
        if (e.statusCode == 404) {
          print("404 Error: The requested resource was not found. Please check the URL or resource identifier.");
        } else {
          print("API Error: ${e.message}");
        }
      } else {
        print("An unexpected error occurred: $e");
      }
    }

    return result;
  }



  void startAnalyzing() async {

    final File? imageFile = controller.imageFile.value ;
    print("Start");
    print(imageFile);


    if (controller.occasion.isEmpty || imageFile == null || isLoading) {
      setState(() {
        error = true;
      });
      return;
    }

    try {
      bool containPerson = await containsSingleOrPortraitPerson(imageFile);
      print("Hello");
      print(containPerson);

      if (!containPerson) {
        setState(() {
          error = true;
          controller.imageFile.value = null; // Resetting imageFile to null
        });
        return;
      } else {
        setState(() => error = false);

        String res = await imageAnalyzer(
            "Analyze my outfit in this picture and tell some clothing styles and necessary adjustments that should be made to enhance my current style for a ${controller.occasion} look",
            imageFile); // Use the local variable imageFile here

        setState(() => controller.imageFile.value = null); // Clear the image after analysis
        print("Ghanta");
        print(res);

        if (mounted) {
          Get.to(() => ResponseScreen(response: res));
        }
      }
    } catch (e) {
      setState(() {
        error = true;
      });
      print("Error during analysis: $e");
    }
  }

  Future<bool> containsSingleOrPortraitPerson(File imageFile) async {
    final result = await imageAnalyzer(
        "Analyze the image and determine if there is exactly one visible human figure present. Return TRUE if only one person is detected, and FALSE otherwise",
        imageFile);
    if (result.contains("TRUE")) {
      setState(() => isPersonPortrait = true);
    } else {
      setState(() => isPersonPortrait = false);
    }
    return isPersonPortrait;
  }





  Widget buildOccasion(String label) {
    return Obx(() {
      return ChoiceChip(
        label: Text(label),
        selected: controller.occasion.value == label,
        onSelected: (selected) {
          controller.setOccasion(label, selected);
        },
      );
    });
  }

//   void selectImage() async{
// final FilePickerResult? res = await pickImage();
// if(res != null){
//   setState(() {
//     imageFile = File(res.files.single.path!);
//     error= false;
//   });

// }
// } 
 @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        excludeHeaderSemantics: true,
        title: const Text('AI Fashion'),
        centerTitle: false,
        backgroundColor: AppColor.silverGrey.withOpacity(0.8),
      ),
      body: Stack(
        children: [
          Obx(() {
            return SizedBox(
              width: double.maxFinite,
              height: AppHelperFunctions.screenSize(context).height,
              child:
                   ImageUplaodWidget(
                      onPressed: controller.selectImage,
                      imageFile: controller.imageFile.value,
                    )

            );
          }),
          Positioned(
            bottom: -20,
            right: 124,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: AppColor.platinumWhite.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  bottomLeft: Radius.circular(32)
                )
              ),

            ),
          ),
          Positioned(
            bottom: -12,
            right: 64,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: AppColor.platinumWhite.withOpacity(0.4),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  bottomLeft: Radius.circular(32)
                )
              ),

            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                color: AppColor.platinumWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  bottomLeft: Radius.circular(32)
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("What occasion is this outfit for?",style: Theme.of(context).textTheme.titleMedium,),
                  SizedBox(height: 8,),
                  Wrap(
                    spacing: 8,
                    children: [
                      buildOccasion('Casual'),
                      buildOccasion('Formal'),
                      buildOccasion('Work')
                    ],
                  ),
                  if(error) const SizedBox(height: 16,),
                  if(!error)
                    Container(
                      color:AppColor.white,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Please select an occasion and upload an image',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColor.errorColor),
                      ),

                    ),
                  if (isLoading) const SizedBox(height: 16),
                  if (isLoading)
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    ),


                  OutlinedButton(
                      
                      onPressed: isLoading?null:startAnalyzing,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        )
                      ),
                      child: Text("Start Analyzer"))
                  
                ],
              ),

            ),
          )
        ],
      ),
    );
  }
}

class ImageUplaodWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final File? imageFile;
  const ImageUplaodWidget({super.key, required this.onPressed, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return imageFile != null
        ? Image.file(
            imageFile!,
            fit: BoxFit.cover,
          )
        : Padding(
            padding: const EdgeInsets.all(20).copyWith(
                bottom: AppHelperFunctions.screenSize(context).height * 0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: onPressed, icon: const Icon(CupertinoIcons.camera)),
                Text(
                  "Upload a picture(Full body for best result)",
                  style: Theme.of(context).textTheme!.bodySmall,
                )
              ],
            ),
          );
  }
}


