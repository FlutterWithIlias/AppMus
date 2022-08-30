// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_null_comparison

import 'dart:developer';
import 'dart:ffi';

import 'package:circular_menu/circular_menu.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:kiko/main.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'dart:ffi';
import 'dart:ui';

class listening extends StatefulWidget {
     
   listening({Key? key , required this.audioPlayer , required this.songs , required this.index}) : super(key: key);
  
 final AudioPlayer audioPlayer ; final List<SongModel> songs ; int index;
  @override
  State<listening> createState() => listeningstate();
  
}

class listeningstate extends State<listening> {
  
 
  void toS(int s){
      Duration d = Duration(seconds: s );
      widget.audioPlayer.seek(d);
  }
  
  bool isplaying = true;Duration duration = const Duration();Duration position = const Duration();
     @override 
     void initState() {
    // TODO: implement initState
    super.initState();
    playsong();isplaying = true;
  }
    void playsong(){
      
      try {
  widget.audioPlayer.setAudioSource(createPlaylist(widget.songs),
                        initialIndex: widget.index);widget.audioPlayer.play() ;
} on Exception  {
  log("message");
  // TODO
}
   widget.audioPlayer.durationStream.listen(
        (d){
            
            setState(() {
              duration=d!;
            });

        }

   );
   widget.audioPlayer.positionStream.listen(
        (p){
            
            setState(() {
              position=p;
            });

        }

   );
  
}
// ignore: unused_field
double _currentSliderValue = 1.0 ; bool isMuted = false ; 
double speed = 1.0 ; 
  
     
  @override
  Widget build(BuildContext context) {
    
    Widget tof = QueryArtworkWidget( id:widget.songs[widget.index].id , type: ArtworkType.AUDIO, artworkBorder: BorderRadius.circular(100)) ;
     // ignore: unused_local_variable
    // ignore: prefer_const_constructors
    if(widget.audioPlayer.position.toString() == widget.audioPlayer.duration.toString()  ) widget.index++;
    return Scaffold(
          backgroundColor: Color.fromARGB(184, 26, 26, 29),
          extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Mus-ily'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        bottomNavigationBar: 
                CurvedNavigationBar( backgroundColor: Color.fromARGB(184, 26, 26, 29) ,items: [
                   IconButton(
                              icon: Icon(Icons.home) ,
                              iconSize: 30,
                              color: Colors.black,
                              onPressed: () {},
                                                                   )
                ]  ),
              
        body: Container(
               child: Stack(
                       children: [
                           Positioned(
                             left: 45,top: 100,
                              child: SleekCircularSlider( 
                                                    
                                                    min :  Duration(microseconds: 0 ).inSeconds.toDouble(), 
                                                    max: duration.inSeconds.toDouble(),
                                                    initialValue : position.inSeconds.toDouble(),
                                                    appearance: CircularSliderAppearance (startAngle: 150,size: 300  ,infoProperties: InfoProperties(mainLabelStyle: TextStyle(color: Colors.white)), customWidths: CustomSliderWidths(
                                                                                             progressBarWidth: 6 ,
                                                                                             trackWidth : 2
                                                                                             ),),
                                                    onChange: ((value) {
                                                      
                                                      setState(() {
                                                     toS(value.toInt());
                                                     value=value;
                                                      });
                                                    }),
                                                  
                                                    
                                                    ),
                            ),
                          Positioned(
                              top: 130,left: 75,
                             child: Container(
                              padding: EdgeInsets.all(13),
                                height: 240 , width: 240,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(130),color: Colors.black,),
                                child:  Container(
                                          height: 100 , width: 100,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(110),
                                          // ignore: unnecessary_null_comparison
                                         // image: DecorationImage( image:  AssetImage("assets/tttt.jpg"))
                                ),
                                          child: tof ,              
                                ),
                             ),
                           ),
                        Positioned( top:330,left: 50,child: Text(position.toString().split(".")[0] , style: TextStyle(
                            color: Colors.white 
                        ),)),
                         Positioned( top:330,left:296,child: Text(duration.toString().split(".")[0] , style: TextStyle(
                            color: Colors.white 
                        ),)) ,
                          Positioned(
                            top: 400 , left: 100, 
                            child: Container(width: 190, height: 70,child: Column(children: [
                                                                Text(widget.songs[widget.index].title, style: TextStyle(
                                                                         color: Colors.white ,
                                                                         fontSize: 25 , fontWeight: FontWeight.bold
                                                                         ),
                                                                         overflow: TextOverflow.ellipsis,  
                                                                         ) ,
                                                                         SizedBox(height: 5,),
                                                               Text(widget.songs[widget.index].artist!,
                                                                    overflow: TextOverflow.ellipsis, 
                                                                    style: TextStyle(
                                                                            color: Color.fromARGB(255, 237, 152, 181), 
                                                                            fontStyle: FontStyle.italic),
                                                                            ) 
                            ],) )),
                      Positioned(
                        top :560 , left: 38,
                        child: Container(
                                    width: 300 ,height: 100,
                                    child: Column(
                                      children: [
                                        Row(
                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                               children: [
                                                IconButton(onPressed: () { setState(() {
                                                  if(widget.audioPlayer.hasPrevious){
                                                 widget.audioPlayer.seekToPrevious();widget.index--;}
                                               });  } , icon: Icon(Icons.skip_previous,size: 45,color: Colors.white,)),
                                                 IconButton(onPressed: (){ setState(() {
                                                          widget.audioPlayer.seek(position - Duration(seconds: 10 )) ; 
                                                 }) ; }, icon: Icon(FontAwesomeIcons.anglesLeft , size: 40,color: Color.fromARGB(255, 237, 152, 181),)) , 
                                                 IconButton(onPressed: ()=> setState(() {
                                               if(isplaying) widget.audioPlayer.pause();
                                               else widget.audioPlayer.play();
                                                isplaying= !isplaying ;
                                                 }), 
                                                icon: Icon(isplaying? Icons.pause : Icons.play_arrow , size: 45,color: Colors.white,)),
                                                IconButton(onPressed: (){ setState(() {
                                                          widget.audioPlayer.seek(position + Duration(seconds: 10 )) ; 
                                                 }) ; }, icon: Icon(FontAwesomeIcons.anglesRight , size: 40,color: Color.fromARGB(255, 237, 152, 181),)) ,
                                               IconButton(onPressed: () { setState(() {
                                                if(widget.audioPlayer.hasNext){
                                                 widget.audioPlayer.seekToNext();widget.index++;}
                                               });  } ,icon: Icon(Icons.skip_next,size: 45,color: Colors.white,)),
                                        ]),  
                                      ],
                                    ),
                        ),
                      ),
                      Positioned(top :485 , left: 171, child: GestureDetector(
                        onTap :() {
                          if(widget.audioPlayer.playing){
                           speed= speed+0.5 ; 
                           if(speed == 3.0) speed = 1.0 ;
                           widget.audioPlayer.setSpeed(speed);
                        }},
                        child: Container( width: 45 , height : 45 , decoration : BoxDecoration(borderRadius: 
                                   BorderRadius.circular(40) , color : Colors.white 
                                    ) , child : Center(child: Text("x${speed.toString()}", style:  TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),) ),
                                    ),
                      )),
                      Positioned( bottom:-75 , left: 145, child: IconButton ( 
                                   onPressed: () { Navigator.pop(context) ;}  ,
                                   icon : Icon(Icons.play_arrow),iconSize: 82,),),

                      Positioned(top: 640,left: 44,child: Container(width: 300 ,height: 85,
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Icon(isMuted ? Icons.volume_off : Icons.volume_up, color: Colors.white, size: 35,),
                                   CupertinoSlider(
                                     
                                    value: _currentSliderValue,activeColor: Color.fromARGB(255, 233, 156, 197),
      max: 1,
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
          widget.audioPlayer.setVolume(value);
          if(value == 0 ) isMuted = true ; else isMuted = false ; 
        });
      },
                                   ),
                                 ],
                               ),
                      ) , )             

                                

                                  

                       ],
               ),
        ),
                    
         
    );
  }
 
}
ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {
    List<AudioSource> sources = [];
    for (var song in songs){
      sources.add(AudioSource.uri(Uri.parse(song.uri!) , tag: MediaItem(
    // Specify a unique ID for each media item:
    id: '${song.id}',
    // Metadata to display in the notification:
    album: '${song.album}',
    title: '${song.displayNameWOExt}',
  ),));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  


