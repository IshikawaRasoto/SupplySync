import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class LogoAndHelpWidget extends StatelessWidget {
  final Function()? onHelp;
  final Function()? onLogout;
  final Function()? onReturn;
  const LogoAndHelpWidget({
    super.key,
    this.onHelp,
    this.onLogout,
    this.onReturn,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(AssetsConstants.logo),
          Positioned(
            right: 1,
            top: 1,
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: ElevatedButton(
                onPressed: () {
                  onHelp?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.redButton,
                  shape: CircleBorder(),
                ),
                child: const Text('?', style: TextStyle(fontSize: 35)),
              ),
            ),
          ),
          if (onLogout != null)
            Positioned(
              left: 8,
              top: 1,
              child: IconButton(
                alignment: Alignment.topLeft,
                onPressed: onLogout,
                icon: Icon(
                  Icons.logout,
                  size: 30,
                ),
              ),
            ),
          if (onReturn != null)
            Positioned(
              left: 8,
              top: 1,
              child: IconButton(
                alignment: Alignment.topLeft,
                onPressed: onReturn,
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
