import 'dart:async';
import 'package:animations/animations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'Constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hopeful Bamboo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xffffffff), scaffoldBackgroundColor: Colors.transparent),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  VideoPlayerController? _controller;
  List _listItems = [];
  bool menuAnimationEnd = false;
  double menuHeight = 75;
  GlobalKey<AnimatedListState> _listKey = GlobalKey();
  bool introFinish = false;
  bool isMenuActive = false;
  bool volume = false;
  SharedAxisTransitionType? _transitionType = SharedAxisTransitionType.horizontal;
  bool _isMenuScreen = false;
  bool isAnimationVertical = false;
  String ANIMATION = "WELCOME";
  bool introMenu = false;
  bool introReverse = false;

  void _updateTransitionType(SharedAxisTransitionType? newType) {
    setState(() {
      _transitionType = newType;
    });
  }

  void _toggleLoginStatus() {
    setState(() {
      _isMenuScreen = !_isMenuScreen;
    });
  }

  List menuList = ['OUR STORY', 'HOW IT WORKS', 'INVITE FRIENDS', 'VISIT WEBSITE', 'CONTACT US', 'TERMS'];

  List bgImageList = [
    '$IMG_PATH/1.jpg',
    '$IMG_PATH/2.jpg',
    '$IMG_PATH/3.jpg',
    '$IMG_PATH/4.jpg',
    '$IMG_PATH/5.jpg',
    '$IMG_PATH/6.jpg',
    '$IMG_PATH/7.jpg',
    '$IMG_PATH/8.jpg',
    '$IMG_PATH/9.jpg',
    '$IMG_PATH/10.jpg',
    '$IMG_PATH/11.jpg',
    '$IMG_PATH/12.jpg',
    '$IMG_PATH/13.jpg',
    '$IMG_PATH/14.jpg',
    '$IMG_PATH/15.jpg',
  ];

  Timer? _timer;
  @override
  void initState() {
    super.initState();
  }

  play() async {
    AudioCache player = AudioCache(fixedPlayer: audioPlayer);
    await player.play('sound/4.wav');
  }

  launchURL(String _url) async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      audioPlayer.stop();
    }
  }

  @override
  dispose() {
    _timer!.cancel();
    audioPlayer.stop();
    _controller!.dispose();
    super.dispose();
  }

  void _onVerticalSwipe(SwipeDirection direction) {
    setState(() {
      if (direction == SwipeDirection.up) {
        _loadItems();
        _updateTransitionType(SharedAxisTransitionType.vertical);
        _isMenuScreen ? null : _toggleLoginStatus();
        isAnimationVertical = true;
      } else {
        _unloadItems(true);
        _updateTransitionType(SharedAxisTransitionType.vertical);
        _isMenuScreen ? _toggleLoginStatus() : null;
        isAnimationVertical = true;
      }
    });
  }

  void _onHorizontalSwipe(SwipeDirection direction) {
    setState(() {
      if (direction == SwipeDirection.left) {
        _loadItems();
        _updateTransitionType(SharedAxisTransitionType.horizontal);
        _isMenuScreen ? null : _toggleLoginStatus();
        isAnimationVertical = false;
      } else {
        _unloadItems(false);
        _updateTransitionType(SharedAxisTransitionType.horizontal);
        _isMenuScreen ? _toggleLoginStatus() : null;
        isAnimationVertical = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    double mHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SimpleGestureDetector(
        onVerticalSwipe: _onVerticalSwipe,
        onHorizontalSwipe: _onHorizontalSwipe,
        child: Stack(
          children: [
            CarouselSlider.builder(
              itemCount: bgImageList.length,
              options: CarouselOptions(
                height: mHeight,
                autoPlayAnimationDuration: Duration(milliseconds: 2000),
                pageSnapping: false,
                viewportFraction: 1,
                autoPlay: true,
                autoPlayCurve: Curves.easeInOutCubic,
                autoPlayInterval: Duration(milliseconds: 6000),
              ),
              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => Container(
                child: Image.asset(bgImageList[itemIndex], height: mHeight, width: mWidth, fit: BoxFit.cover),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black, Colors.black54, Colors.transparent],
                  ),
                ),
                height: mHeight * 0.5,
                width: mWidth,
              ),
            ),
            AnimatedOpacity(opacity: ANIMATION == 'INTRODUCTION' || ANIMATION == 'INTRODUCTION_REV' ? 1 : 0, duration: Duration(milliseconds: 400), child: Container(color: Colors.black54)),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (ANIMATION == 'WELCOME')
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 23),
                      child: FadeInUp(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              ANIMATION = 'TAGGED';
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                'TAG YOUR BAMBOO TO BEGIN',
                                style: TextStyle(height: 1.0, color: kThemeColor, letterSpacing: -1.5, fontSize: 40, fontFamily: 'BebasNeue'),
                              ),
                              Text(
                                'Website  |  Terms  |  Privacy  |  Info',
                                style: TextStyle(color: kThemeColor, fontSize: 19, fontFamily: 'RobotoSlab'),
                              ),
                            ],
                          ),
                        ),
                        animate: false,
                        from: 40,
                        controller: (animate) {
                          Future.delayed(Duration(milliseconds: ANIMATION == 'WELCOME' ? 4000 : 1000), () {
                            animate.animateBack(1, duration: Duration(milliseconds: 1000));
                          });
                        },
                      ),
                    ),
                  )
                else if (ANIMATION == 'TAGGED')
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 23),
                      child: FadeOutDown(
                        child: Column(
                          children: [
                            Text(
                              'TAG YOUR BAMBOO TO BEGIN',
                              style: TextStyle(height: 1.0, color: kThemeColor, letterSpacing: -1.5, fontSize: 40, fontFamily: 'BebasNeue'),
                            ),
                            Text(
                              'Website  |  Terms  |  Privacy  |  Info',
                              style: TextStyle(color: kThemeColor, fontSize: 19, fontFamily: 'RobotoSlab'),
                            ),
                          ],
                        ),
                        animate: false,
                        from: 40,
                        controller: (animate) {
                          Future.delayed(Duration(milliseconds: 100), () {
                            animate.animateBack(1, duration: Duration(milliseconds: 1000));
                            Future.delayed(Duration(milliseconds: 2000), () {
                              setState(() {
                                ANIMATION = 'INTRODUCTION';
                              });
                            });
                          });
                        },
                      ),
                    ),
                  )
              ],
            ),
            if (ANIMATION == 'INTRODUCTION')
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        FadeInUp(
                          child: Image.asset('$ICON_PATH/logo.png', width: 40, height: 40),
                          // animate: false,
                          from: 30,
                          delay: Duration(milliseconds: 1000),
                          duration: Duration(milliseconds: 1000),
                        ),
                        FadeInDown(
                          child: Column(
                            children: [
                              SizedBox(height: 50),
                              Text(
                                'Brought to you by hopefulbamboo;\na company mission to make the world\na more hopeful place through bamboo.',
                                textAlign: TextAlign.center,
                                style: TextStyle(height: 1.5, fontFamily: 'RobotoSlab', fontSize: 18, color: kThemeColor, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 26)
                            ],
                          ),
                          delay: Duration(milliseconds: 1200),
                          duration: Duration(milliseconds: 1000),
                          from: 40,
                        ),
                        FadeInDown(
                          child: Column(
                            children: [
                              Text(
                                'If your phone is unable to recognize\nyour hopeful bamboo, please ensure\nNFC is enabled before tagging.',
                                textAlign: TextAlign.center,
                                style: TextStyle(height: 1.5, fontFamily: 'RobotoSlab', fontSize: 18, color: kThemeColor, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 26)
                            ],
                          ),
                          delay: Duration(milliseconds: 1400),
                          duration: Duration(milliseconds: 1000),
                          from: 40,
                        ),
                        FadeInDown(
                          child: Column(
                            children: [
                              Text(
                                'If you\'re checking to see if we exist,\nwell, we do, and it\'s easy to join in.',
                                textAlign: TextAlign.center,
                                style: TextStyle(height: 1.5, fontFamily: 'RobotoSlab', fontSize: 18, color: kThemeColor, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 50)
                            ],
                          ),
                          delay: Duration(milliseconds: 1600),
                          duration: Duration(milliseconds: 1000),
                          from: 40,
                        ),
                        FadeInLeft(
                          delay: Duration(milliseconds: 1600),
                          duration: Duration(milliseconds: 1000),
                          from: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FadeInLeft(
                                child: Column(
                                  children: [
                                    Text('JOIN IN  |', style: TextStyle(color: kThemeColor, fontSize: 28, fontFamily: 'BebasNeue')),
                                    SizedBox(height: 50),
                                  ],
                                ),
                                delay: Duration(milliseconds: 1600),
                                duration: Duration(milliseconds: 1000),
                                from: 40,
                              ),
                              FadeInLeft(
                                child: Column(
                                  children: [
                                    Text(' TERMS  |', style: TextStyle(color: kThemeColor, fontSize: 28, fontFamily: 'BebasNeue')),
                                    SizedBox(height: 50),
                                  ],
                                ),
                                delay: Duration(milliseconds: 1800),
                                duration: Duration(milliseconds: 1000),
                                from: 40,
                              ),
                              FadeInLeft(
                                child: Column(
                                  children: [
                                    Text(' CLOSE', style: TextStyle(color: kThemeColor, fontSize: 28, fontFamily: 'BebasNeue')),
                                    SizedBox(height: 50),
                                  ],
                                ),
                                animate: false,
                                from: 40,
                                controller: (animate) {
                                  Future.delayed(Duration(milliseconds: 2000), () {
                                    animate.animateBack(1, duration: Duration(milliseconds: 1000));
                                    Future.delayed(Duration(milliseconds: 5000), () {
                                      setState(() {
                                        print('INTRODUCTION_REV');
                                        ANIMATION = 'INTRODUCTION_REV';
                                        introReverse = true;
                                      });
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (ANIMATION == 'INTRODUCTION_REV')
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        FadeOutUp(
                          child: Image.asset('$ICON_PATH/logo.png', width: 40, height: 40),
                          animate: false,
                          from: 40,
                          controller: (animate) {
                            Future.delayed(Duration(milliseconds: 1), () {
                              animate.animateBack(1, duration: Duration(milliseconds: 1000));
                            });
                          },
                        ),
                        FadeOutUp(
                          child: Column(
                            children: [
                              SizedBox(height: 50),
                              Text(
                                'Brought to you by hopefulbamboo;\na company mission to make the world\na more hopeful place through bamboo.',
                                textAlign: TextAlign.center,
                                style: TextStyle(height: 1.5, fontFamily: 'RobotoSlab', fontSize: 18, color: kThemeColor, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 26)
                            ],
                          ),
                          animate: false,
                          from: 40,
                          controller: (animate) {
                            Future.delayed(Duration(milliseconds: 600), () {
                              animate.animateBack(1, duration: Duration(milliseconds: 1000));
                            });
                          },
                        ),
                        FadeOutUp(
                          child: Column(
                            children: [
                              Text(
                                'If your phone is unable to recognize\nyour hopeful bamboo, please ensure\nNFC is enabled before tagging.',
                                textAlign: TextAlign.center,
                                style: TextStyle(height: 1.5, fontFamily: 'RobotoSlab', fontSize: 18, color: kThemeColor, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 26)
                            ],
                          ),
                          animate: false,
                          from: 40,
                          controller: (animate) {
                            Future.delayed(Duration(milliseconds: 800), () {
                              animate.animateBack(1, duration: Duration(milliseconds: 1000));
                            });
                          },
                        ),
                        FadeOutUp(
                          child: Column(
                            children: [
                              Text(
                                'If you\'re checking to see if we exist,\nwell, we do, and it\'s easy to join in.',
                                textAlign: TextAlign.center,
                                style: TextStyle(height: 1.5, fontFamily: 'RobotoSlab', fontSize: 18, color: kThemeColor, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 50)
                            ],
                          ),
                          animate: false,
                          from: 40,
                          controller: (animate) {
                            Future.delayed(Duration(milliseconds: 1000), () {
                              animate.animateBack(1, duration: Duration(milliseconds: 1000));
                            });
                          },
                        ),
                        FadeOutLeft(
                          animate: false,
                          from: 40,
                          controller: (animate) {
                            Future.delayed(Duration(milliseconds: 1000), () {
                              animate.animateBack(1, duration: Duration(milliseconds: 1000));
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FadeOutLeft(
                                child: Column(
                                  children: [
                                    Text('JOIN IN  |', style: TextStyle(color: kThemeColor, fontSize: 28, fontFamily: 'BebasNeue')),
                                    SizedBox(height: 50),
                                  ],
                                ),
                                animate: false,
                                from: 40,
                                controller: (animate) {
                                  Future.delayed(Duration(milliseconds: 1000), () {
                                    animate.animateBack(1, duration: Duration(milliseconds: 1000));
                                  });
                                },
                              ),
                              FadeOutLeft(
                                child: Column(
                                  children: [
                                    Text(' TERMS  |', style: TextStyle(color: kThemeColor, fontSize: 28, fontFamily: 'BebasNeue')),
                                    SizedBox(height: 50),
                                  ],
                                ),
                                animate: false,
                                from: 40,
                                controller: (animate) {
                                  Future.delayed(Duration(milliseconds: 1200), () {
                                    animate.animateBack(1, duration: Duration(milliseconds: 1000));
                                  });
                                },
                              ),
                              FadeOutLeft(
                                child: Column(
                                  children: [
                                    Text(' CLOSE', style: TextStyle(color: kThemeColor, fontSize: 28, fontFamily: 'BebasNeue')),
                                    SizedBox(height: 50),
                                  ],
                                ),
                                animate: false,
                                from: 40,
                                controller: (animate) {
                                  Future.delayed(Duration(milliseconds: 1400), () {
                                    animate.animateBack(1, duration: Duration(milliseconds: 1000));
                                    Future.delayed(Duration(milliseconds: 1000), () {
                                      setState(() {
                                        ANIMATION = 'INTRODUCTION_REV_DONE';
                                      });
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (ANIMATION == 'INTRODUCTION_REV_DONE')
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeInRight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Image.asset('$ICON_PATH/logo.png', width: 26, height: 26),
                        ),
                        animate: false,
                        from: 20,
                        controller: (animate) {
                          Future.delayed(Duration(milliseconds: 100), () {
                            animate.animateBack(1, duration: Duration(milliseconds: 1000));
                            Future.delayed(Duration(milliseconds: 2000), () {
                              animate.reverse(from: 20);
                            });
                          });
                        },
                      ),
                      FadeInLeft(
                        child: Text(
                          '23232',
                          style: TextStyle(color: kThemeColor, fontSize: 22, fontFamily: 'BebasNeue'),
                        ),
                        animate: false,
                        from: 20,
                        controller: (animate) {
                          Future.delayed(Duration(milliseconds: 100), () {
                            animate.animateBack(1, duration: Duration(milliseconds: 1000));
                            Future.delayed(Duration(milliseconds: 2000), () {
                              animate.reverse(from: 20);
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            if (introFinish && !isMenuActive)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // play();
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierColor: Colors.transparent,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Scaffold(
                                body: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '6553 SCANS SO FAR'.toUpperCase(),
                                        style: TextStyle(color: kThemeColor, fontSize: 24, fontFamily: 'BebasNeue'),
                                      ),
                                      SizedBox(height: 18),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Column(
                                          children: [
                                            Container(
                                              color: Colors.black26,
                                              alignment: Alignment.center,
                                              width: mWidth - 30,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 32.0),
                                                child: Text(
                                                  'Feel Your Emotions'.toUpperCase(),
                                                  style: TextStyle(color: kThemeColor, fontSize: 46, fontFamily: 'BebasNeue'),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: mWidth - 30,
                                              constraints: BoxConstraints(maxHeight: mHeight * 0.54, minHeight: mHeight * 0.38),
                                              color: kThemeColor,
                                              child: SingleChildScrollView(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(18.0),
                                                  child: Text(
                                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. In metus vulputate eu scelerisque felis imperdiet. Vitae congue mauris rhoncus aenean vel. In mollis nunc sed id semper risus in hendrerit gravida. Tortor id aliquet lectus proin nibh nisl condimentum id. Ut diam quam nulla porttitor. Ut etiam sit amet nisl purus in mollis. Platea dictumst vestibulum rhoncus est. Id leo in vitae turpis massa sed elementum tempus egestas. Purus non enim praesent elementum facilisis leo vel. Semper eget duis at tellus at. Non arcu risus quis varius quam quisque id diam vel.',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(height: 1.5, fontFamily: 'RobotoSlab', fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Image.asset('$ICON_PATH/arrow.png', width: 60, height: 44),
                                      SizedBox(height: 60),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 36.0),
                        child: Image.asset('$ICON_PATH/logo.png', width: 30, height: 30),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _loadItems() {
    if (!_isMenuScreen) {
      var future = Future(() {});

      setState(() {
        isMenuActive = true;
        menuAnimationEnd = false;
        _listItems = [];
        _listKey = GlobalKey();
      });

      for (var i = 0; i < menuList.length; i++) {
        future = future.then((_) {
          return Future.delayed(const Duration(milliseconds: 300), () {
            _listItems.add(menuList[i]);
            _listKey.currentState?.insertItem(_listItems.length - 1);
          });
        });
      }
    }
  }

  void _unloadItems(bool isAnimationVertical) {
    var future = Future(() {});
    String deletedItem = '';
    for (var i = _listItems.length - 1; i >= 0; i--) {
      future = future.then((_) {
        return Future.delayed(const Duration(milliseconds: 350), () {
          deletedItem = _listItems.removeAt(i);
          _listKey.currentState?.removeItem(i, (BuildContext context, Animation<double> animation) {
            return SlideTransition(
              position: CurvedAnimation(
                curve: Curves.easeIn,
                parent: animation,
              ).drive((Tween<Offset>(begin: isAnimationVertical ? Offset(0, 0.05) : Offset(0.05, 0), end: Offset(0, 0)))),
              child: GestureDetector(
                child: Container(
                  height: menuHeight,
                  alignment: Alignment.center,
                  child: Text(deletedItem, style: TextStyle(color: kThemeColor, fontSize: 40, fontFamily: 'BebasNeue')),
                ),
                onTap: () {
                  if (i == 0) {
                    launchURL('http://www.hopefulbamboo.com/story');
                  } else if (i == 2) {
                    Share.share('Check out our website http://www.hopefulbamboo.com/');
                  } else if (i == 3) {
                    launchURL('http://www.hopefulbamboo.com/');
                  } else if (i == 4) {
                    launchURL('http://www.hopefulbamboo.com/contact');
                  } else if (i == 5) {
                    launchURL('http://www.hopefulbamboo.com/terms');
                  }
                },
              ),
            );
          });

          Future.delayed(Duration(milliseconds: 500), () {
            if (_listItems.length == 0) {
              if (mounted) {
                isMenuActive = false;
                menuAnimationEnd = true;

                setState(() {});
              }
            }
          });
        });
      });
    }
  }
}
