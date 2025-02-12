import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/constants.dart';
import '../../theme/theme.dart';

class LogoAndHelpWidget extends StatelessWidget {
  final Function()? onHelp;
  final bool logout;
  final bool back;
  final double height;
  const LogoAndHelpWidget({
    super.key,
    this.onHelp,
    this.back = true,
    this.logout = false,
    this.height = 0.25,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * height,
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
          if (logout)
            Positioned(
              left: 8,
              top: 1,
              child: IconButton(
                alignment: Alignment.topLeft,
                onPressed: () => context.go('/'),
                icon: Icon(
                  Icons.logout,
                  size: 30,
                ),
              ),
            ),
          if (!logout && back)
            Positioned(
              left: 8,
              top: 1,
              child: IconButton(
                alignment: Alignment.topLeft,
                onPressed: context.pop,
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
