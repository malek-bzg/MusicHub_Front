import 'package:flutter/cupertino.dart';
import 'package:online_course/screens/app_colors.dart' as AppColors;
import 'package:flutter/material.dart';
import 'package:online_course/screens/drum.dart';
import 'package:online_course/screens/piano.dart';
import 'package:online_course/tuner/tunerHome.dart';
import 'my_tabs.dart';
import 'track.dart';
import 'track_home.dart';
class MyTrackHome extends StatefulWidget  {
  const MyTrackHome({Key? key}) : super(key: key);

  @override
  _MyTrackHomeState createState() => _MyTrackHomeState();
}

class _MyTrackHomeState extends State<MyTrackHome> with SingleTickerProviderStateMixin{
  late ScrollController _scrollController;
  late TabController _tabController;
  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [




              Expanded(child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (BuildContext context, bool isScroll){

                  return[
                    SliverAppBar(
                      pinned: true,
                      backgroundColor:AppColors.sliverBackground,
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(50),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20, left: 10),
                          child: TabBar(
                            indicatorPadding: const EdgeInsets.all(0),
                            indicatorSize: TabBarIndicatorSize.label,
                            labelPadding: const EdgeInsets.only(right: 10),
                            controller: _tabController,
                            isScrollable: true,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:Colors.grey.withOpacity(0.2),
                                    blurRadius: 7,
                                    offset: Offset(0, 0),
                                  )
                                ]
                            ),
                            tabs: [
                              AppTabs(color:AppColors.menu1Color, text:"New", key: ValueKey(1), ),
                              AppTabs(color:AppColors.menu2Color, text:"Track List", key: ValueKey(2), ),
                              AppTabs(color:AppColors.menu3Color, text:"Features", key: ValueKey(3),),
                            ],
                          ),
                        ),
                      ),
                    )
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [

                    Material(
                        child:Track()
                    ),
                    Material(
                        child:TrackHome()
                    ),
                    Material(

                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                           ElevatedButton (
                             style: ElevatedButton.styleFrom(
                               primary: Colors.white, // background
                             ),
                            child: Image.asset("assets/images/drumachine.png", width: 500,),

                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Drum()));
                            },
                          ),
                          ElevatedButton (
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white, // background
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                              ),
                            ),
                            child: Image.asset("assets/images/Tuner.png"),

                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TunerHome()));
                            },
                          ),
                          ElevatedButton (
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white, // background
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                              ),
                            ),
                            child: Image.asset("assets/images/Piano.png"),

                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FlutterPianoScreen()));
                            },
                          ),
                        ],
                      )

                    ),
                  ],

                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
