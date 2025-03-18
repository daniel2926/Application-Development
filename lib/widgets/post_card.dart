import 'package:flutter/material.dart';
import 'package:flutter_pad_1/constants/app_theme.dart';
import 'package:flutter_pad_1/models/post_model.dart';
import 'package:flutter_pad_1/screens/home_screen.dart';
import 'package:flutter_pad_1/screens/post_detail_screen.dart';
import 'package:flutter_pad_1/widgets/time_ago.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    String timeAgoText = timeAgo(post.createdAt);
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailScreen(postId: post.postId)));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // Sudut melengkung kartu
        ),
        elevation: 3, // Bayangan pada kartu
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gunakan Stack untuk overlay badge
            Stack(
              children: [
                // Gambar utama
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4), // Sudut kiri atas melengkung
                    topRight: Radius.circular(4), // Sudut kanan atas melengkung
                  ),
                  child: Image.network(
                    post.images[0], // URL gambar
                    // height: 150, // Tinggi gambar
                    // width: double.infinity, // Lebar gambar sesuai lebar kontainer
                    // fit: BoxFit.cover, // Gambar diatur proporsional
                  ),
                ),
                // Badge untuk ketersediaan
                Positioned(
                  top: 8, // Jarak dari atas
                  right: 8, // Jarak dari kiri
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10, // Padding horizontal
                      vertical: 6, // Padding vertikal
                    ),
                    decoration: BoxDecoration(
                      color: post.isAvailable ? active : inActive, // Warna badge
                      borderRadius: BorderRadius.circular(4), // Sudut melengkung badge
                    ),
                    child: Text(
                      post.isAvailable ? 'For Sale' : 'Sold Out', // Teks badge
                      style: badgetText, // Gaya teks dari app_theme
                    ),
                  ),
                ),
              ],
            ),
            // Judul
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                post.title,
                style: title2, // Gaya judul dari app_theme
              ),
            ),
            // Harga
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '\$${post.price}', // Harga
                style: priceText2, // Gaya harga dari app_theme
              ),
            ),
               Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                timeAgoText, // Display the time ago text here
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ), // A subtle style for the timestamp
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:myapp/constants/app_theme.dart';
// import 'package:myapp/models/post_model.dart';
// import 'package:myapp/screens/post_detail_screen.dart';
// import 'package:myapp/widgets/status_badge.dart';
// import 'package:myapp/widgets/time_ago.dart';

// class PostCard extends StatelessWidget {
//   final PostModel post;

//   const PostCard({
//     super.key,
//     required this.post,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => PostDetailScreen(post: post),
//           ),
//         );
//       },
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(4), // Rounded corners for the card
//         ),
//         elevation: 3, // Shadow effect for the card
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Display the first image from the post's images list with a badge overlay
//             if (post.images.isNotEmpty)
//               Stack(
//                 children: [
//                   ClipRRect(
//                     child: Image.network(
//                       post.images[0],
//                     ),
//                   ),
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: StatusBadge(isAvailable: post.isAvailable),
//                   ),
//                 ],
//               ),
//             // Lower layout: Display title, price, and time ago
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     post.title,
//                     style: title2, // Using the predefined style
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '\$${post.price}',
//                     style: priceText2, // Using the predefined style
//                   ),
//                   const SizedBox(height: 4),
//                   TimeAgo(timestamp: post.createdAt)
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }