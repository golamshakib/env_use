import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/common/widgets/custom_textformfield.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../../authentication/controllers/login_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final String? firebaseAPIKey = dotenv.env['Firebase_web_secret_api_Key'];
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(getWidth(16)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(text: 'Below is the Dotenv secret value', fontWeight: FontWeight.bold,),
              SizedBox(height: getHeight(36)),
              CustomText(text: '$firebaseAPIKey', fontWeight: FontWeight.bold,),
            ],
          ),
        ),
      ),
    );
  }
}
