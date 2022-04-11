import 'package:flutter/cupertino.dart';
import 'package:online_course/screens/app_colors.dart' as AppColors;
import 'package:flutter/material.dart';
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

              Row(
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Text("WELCOME", style: TextStyle(fontSize: 30))

                  )
                ],
              ),
              SizedBox(height: 20,),

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
                              AppTabs(color:AppColors.menu1Color, text:"PROJECT", key: ValueKey(1), ),
                              AppTabs(color:AppColors.menu2Color, text:"ADD Track", key: ValueKey(2), ),
                              AppTabs(color:AppColors.menu3Color, text:"Trending", key: ValueKey(3),),
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
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                        ),
                        title: Text("Content"),
                      ),

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
