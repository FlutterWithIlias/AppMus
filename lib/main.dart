// ignore_for_file: import_of_legacy_library_into_null_safe, unused_import, prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'listening.dart';
/// create a FlutterAudioQuery instance.

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home:  Allsongs(),
    );
  }
}
class Allsongs extends StatefulWidget {
    
  @override
  State<Allsongs> createState() => _AllsongsState();
}

class _AllsongsState extends State<Allsongs> {
  
       GlobalKey<State> key = GlobalKey();
      final AudioPlayer _audioPlayer = AudioPlayer();
      List<SongModel> songs=[];
      List<SongModel> mainSongs=[];
      // ignore: non_constant_identifier_names
      int CurrentIndex = 0 ;
      void playSong(String? uri){
         try {
     _audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(uri!) 
     ));
     _audioPlayer.play() ;
} on Exception{
       log("Error");
}    
      }
       @override 
        // ignore: override_on_non_overriding_member
        void initState(){
          super.initState();
          requestPermission();
        }

        void requestPermission(){
          Permission.storage.request();
        }

        @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
   final audioQ =  OnAudioQuery() ; 
   bool isSearching = false ;
   TextEditingController? _textEC = TextEditingController();
  @override
  Widget build(BuildContext context) {
     
      return Scaffold(

        appBar: AppBar(title: isSearching? Container(decoration: BoxDecoration(color : Colors.white ,
         borderRadius : BorderRadius.circular(30) , 
        ),
        child : TextField(
          onChanged:  (value) {
            setState(() {
              songs = mainSongs.where(((element) => element.title.toLowerCase().contains(value.toLowerCase()))).toList();
              
            });
            print(songs.length);print(isSearching);
           
            
          },
          controller: _textEC , 
          decoration: InputDecoration(
            border: InputBorder.none  ,
                    contentPadding : EdgeInsets.all(15) ,hintText : 'Search' ,
          ),
        )
        ): 

        Text('Mus-ily') ,
        
        actions: [IconButton(onPressed: ()=> setState(() {
                     isSearching= !isSearching; 
                     
          }), 
        icon: Icon(Icons.search))],
        backgroundColor: Color.fromARGB(184, 26, 26, 29),centerTitle: true,),
          

        body: FutureBuilder<List<SongModel>>(
          future :  audioQ.querySongs(
                    sortType:  null ,
                    orderType: OrderType.ASC_OR_SMALLER ,
                    uriType: UriType.EXTERNAL ,
                    ignoreCase: true , 
          ) ,
             builder :(context, item) {
                  
                  if(item.data == null ){
                    return Center( child:  CircularProgressIndicator(),) ;
                  }
                  if(item.data!.isEmpty) {
                    
                        return GestureDetector(child: Center(child: Container(width: 160 , height:80 ,child: Center(child: Text("Welcome !" ,
                        style : TextStyle(color: Colors.white , fontSize: 30 , fontWeight : FontWeight.bold)
                        )), decoration : 
                        BoxDecoration(color:Color.fromARGB(184, 26, 26, 29) , borderRadius : BorderRadius.circular(40) ) ) , )  , 
                        onTap : ()=> 
                        setState(() {
                          
                        }));
                  }
                  if(!isSearching || _textEC!.text.isEmpty){songs = item.data! ;} ; mainSongs=item.data! ;
                  if(songs.length>=1){
                  return   ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context,index)=>ListTile(
                title : Text(songs[index].title) ,    
                subtitle : Text("${songs[index].artist}") ,      
                leading: QueryArtworkWidget( id: songs[index].id, type: ArtworkType.AUDIO, artworkBorder: BorderRadius.circular(100)),
                
                 
                onTap: (){
                  
                  CurrentIndex = index ; 
                
                  Navigator.push(context , MaterialPageRoute(builder: (context) => listening(audioPlayer : _audioPlayer , songs : songs , index : CurrentIndex )));
    
                  
                },
              
                 
          ) );}else{
            return Container(child : Center(child: Text("Nothing Is Found !" , style: TextStyle(fontWeight: FontWeight.bold ,  fontSize : 25),),)) ;
          }
        },
        ),
        );
        
        
        
        }
         
      
       
        }
        
