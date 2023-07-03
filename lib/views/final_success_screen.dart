import "dart:async";
import "dart:math";
import "package:confetti/confetti.dart";
import "package:delivery/constants/uiconstants.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

import "../routehelper.dart";

class FinalSuccessScreen extends StatefulWidget {

  final String title;
  final String txt;
  const FinalSuccessScreen({
    super.key,
    required this.title,
    required this.txt,
  });

  @override
  State<FinalSuccessScreen> createState() => _FinalSuccessScreenState();
}

class _FinalSuccessScreenState extends State<FinalSuccessScreen> with TickerProviderStateMixin{

  late Animation<double> animation;
  late AnimationController _animationController;
  ConfettiController _controllerCenter = ConfettiController();


  @override
  void initState() {
    super.initState();


    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward().then((_){
      _controllerCenter.play();
      Future.delayed(Duration(seconds: 2),(){
        _controllerCenter.stop();
      });
    });

    animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceInOut,
    );

    Timer(
      Duration(seconds: 5),
          (){
        Get.offAllNamed(RouteHelper.getHomePage());
      },
    );
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }


  @override
  void dispose() {
    _animationController.dispose();
    _controllerCenter.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async=> false,
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 30,
              right: 30,
              bottom: 0,
              child: ScaleTransition(
                scale: _animationController,
                child: Center(
                  child: Container(
                    width: double.maxFinite,
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment:  CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/finalconfirm.png",
                                ),
                                fit: BoxFit.contain,
                              )
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: UIConstant.orange,
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.title,
                                  style: UIConstant.title.copyWith(
                                    color: UIConstant.orange,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  widget.txt,
                                  style: UIConstant.minititle,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // TweenAnimationBuilder(
                        //   tween: Tween<double>(begin: 0, end: 1),
                        //   duration: Duration(milliseconds: 1500),
                        //   curve: Curves.linear,
                        //   builder: (BuildContext context, double value, Widget? child) {
                        //     return Transform.rotate(
                        //       angle: value * 2 * pi,
                        //       child: Container(
                        //         padding: EdgeInsets.symmetric(
                        //           vertical: 10,
                        //           horizontal: 20,
                        //         ),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.all(Radius.circular(10)),
                        //           border: Border.all(
                        //             color: UIconstant.orange,
                        //             width: 2,
                        //           ),
                        //         ),
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             Text(
                        //               widget.title,
                        //               style: UIconstant.title.copyWith(
                        //                 color: UIconstant.orange,
                        //               ),
                        //             ),
                        //             Text(
                        //               widget.txt,
                        //               style: UIconstant.minititle,
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  numberOfParticles: 20,
                  confettiController: _controllerCenter,
                  blastDirectionality: BlastDirectionality
                      .explosive, // don't specify a direction, blast randomly
                  maximumSize: Size(30,30),
                  minimumSize: Size(10,10),
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple,
                    Colors.red,
                    Colors.yellow,
                  ], // manually specify the colors to be used
                  createParticlePath: drawStar, // define a custom shape/path.
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
