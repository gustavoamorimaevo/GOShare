import 'package:goshare/Utilidades/Utilidades.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';


// class VideoApp extends StatefulWidget {
//   @override
//   _VideoAppState createState() => _VideoAppState();
// }

// class _VideoAppState extends State<VideoApp> {
//   VideoPlayerController _controller;
//   bool videoTocando = false;
 
//   @override
//   void initState() {
//     super.initState();
//       _controller = VideoPlayerController.asset('assets/video.mp4')
//       ..initialize().then((_) {
//         setState(() {});
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Utilidades.RetornaCorTema(),
//           title: Center(child:
//             Text("Tutorial        ", style: TextStyle(color: Colors.black)),
//           ),
//           leading: Container(
//           height: 40,
//           width: 40,
//           decoration: new BoxDecoration(
//             image: new DecorationImage(
//               image: AssetImage("assets/esquerda.png"),
//               fit: BoxFit.fitHeight,
//             ),
//           ),
//           child: FlatButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ),
//         ),
        
//         body: Center(
//           child: _controller.value.initialized
//               ? AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: VideoPlayer(_controller),
//                 )
//               : Container(),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
            
//             // if(_controller.value.isPlaying == false && videoPausado == false){
//             //   _controller = VideoPlayerController.asset('assets/video.mp4')
//             //   ..initialize().then((_) {
//             //   setState(() {});
//             //   });
//             // }
            
            
//             if(videoTocando == true && _controller.value.isPlaying == false){
//                   _controller = VideoPlayerController.asset('assets/video.mp4')
//                   ..initialize().then((_) {
//                      _controller.play();
//                     videoTocando = true;
//                     setState(() {});
//                   });
//                 }
//                 else{
//               setState(() {
                
//                   _controller.value.isPlaying
//                     ? _controller.pause()
//                     : _controller.play();
//                     if(_controller.value.isPlaying){
//                       videoTocando = true;
//                     }
//                     else{
//                       videoTocando = false;
//                     }
//               });
              
//                 }
//             // }
//           },
//           child: Icon(
//             _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//             color: Colors.black,
//           ),
//           backgroundColor: Utilidades.RetornaCorTema(),
//         ),
//       );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }