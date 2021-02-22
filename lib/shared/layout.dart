import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Layout extends StatelessWidget {
  final Widget content;
  const Layout({this.content});

  Widget getSaphiLogo(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          // color: Colors.red[40],s
          alignment: Alignment.center,
          height:
              MediaQuery.of(context).size.height * (isLandscape ? 0.1 : 0.15),
          child: SvgPicture.asset(
            'assets/svgs/saphi-logo-white-text.svg',
            width:
                MediaQuery.of(context).size.height * (isLandscape ? 0.3 : 0.15),
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
                Color.fromRGBO(0, 0, 0, 0.5),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.center,
            ),
          ),
        ),
        if (ModalRoute.of(context).settings.name != "/")
          Padding(
            padding: EdgeInsets.fromLTRB(10, 30, 0, 0),
            child: Align(
              alignment: Alignment.topLeft,
              child: BackButton(
                color: Colors.white,
              ),
            ),
          ),
        Container(
          child: Column(
            children: [
              getSaphiLogo(context),
              Container(
                height: MediaQuery.of(context).size.height * 0.85,
                child: content,
              ),
            ],
          ),
        )
      ],
    );
  }
}
