import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Layout extends StatelessWidget {
  final Widget content;
  
  const Layout(this.content);

  Widget get saphiLogo {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 150,
          child: SvgPicture.asset(
            'assets/svgs/saphi-logo-white-text.svg',
            width: 150,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            'assets/images/land.jpg',
            fit: BoxFit.fill,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(0, 0, 0, 0.3),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.center,
            ),
          ),
        ),
        Container(
          child: Column(
            children: [
              saphiLogo,
              Container(
                height: 700,
                child: content,
              ),
            ],
          ),
        )
      ],
    );
  }
}
