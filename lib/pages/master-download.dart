import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/blocs/progress/progress_bloc.dart';
import 'package:newsee/widgets/download_progress_widget.dart';

/*
@author : Gayathri.b    19/05/2025
@description : Displays a download screen UI with a progress bar and skeleton loaders,
             simulating content loading for "Download Master".





 */

class MasterDownload extends StatelessWidget {
  //customaized with and height

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProgressBloc>(
      create: (context) => ProgressBloc()..add(ProgressInit()),
      child: Scaffold(
        backgroundColor: Colors.white,

        body: BlocListener<ProgressBloc, ProgressState>(
          listener: (context, state) {
            print('current progress => ${state.downloadProgress}');
            context.read<ProgressBloc>().add(Progressing());
          },
          child: BlocBuilder<ProgressBloc, ProgressState>(
            builder: (context, state) {
              return DownloadProgressWidget(
                downloadProgress: state.downloadProgress,
                // mastername:
              );
            },
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:newsee/blocs/progress/progress_bloc.dart';
// import 'package:newsee/widgets/download_progress_widget.dart';

/*
@author : Gayathri.b    19/05/2025
@description : Displays a download screen UI with a progress bar and skeleton loaders,
             simulating content loading for "Download Master".





 */

// class MasterDownload extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<ProgressBloc>(
//       create: (context) => ProgressBloc()..add(ProgressInit()),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF6F8FB),
//         body: BlocListener<ProgressBloc, ProgressState>(
//           listener: (context, state) {
//             context.read<ProgressBloc>().add(Progressing());
//           },
//           child: SafeArea(
//             child: Column(
//               children: [
//                 // Header
//                 Padding(
//                   padding: const EdgeInsets.only(top: 24, bottom: 12),
//                   child: Column(
//                     children: const [
//                       Text(
//                         'Download Master',
//                         style: TextStyle(
//                           fontSize: 21,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 0.2,
//                         ),
//                       ),
//                       SizedBox(height: 6),
//                       Text(
//                         'Secure data synchronization',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 //  Center Card
//                 Expanded(
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 5),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 28,
//                           horizontal: 10,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(18),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.02),
//                               blurRadius: 10,
//                               offset: const Offset(0, 10),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             // Icon
//                             Container(
//                               height: 20,
//                               width: 40,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.blue.shade50,
//                               ),
//                               child: const Icon(
//                                 Icons.cloud_download_outlined,
//                                 size: 34,
//                                 color: Color(0xFF1A5FD0),
//                               ),
//                             ),

//                             const SizedBox(height: 18),

//                             const Text(
//                               'Downloading Data',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),

//                             const SizedBox(height: 8),

//                             const Text(
//                               'Please wait while we securely sync your data',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 height: 1.4,
//                                 color: Colors.black54,
//                               ),
//                             ),

//                             const SizedBox(height: 26),

//                             //  Progress
//                             BlocBuilder<ProgressBloc, ProgressState>(
//                               builder: (context, state) {
//                                 return DownloadProgressWidget(
//                                   downloadProgress: state.downloadProgress,
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 //  Footer
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 18),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       Icon(
//                         Icons.lock_outline,
//                         size: 14,
//                         color: Colors.black45,
//                       ),
//                       SizedBox(width: 6),
//                       Text(
//                         'Protected with bank-grade security',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.black45,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




