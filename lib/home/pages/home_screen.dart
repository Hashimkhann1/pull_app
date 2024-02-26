import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:pull_app/home/data/pills.dart';
import 'package:pull_app/home/widget/build_image.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ChewieController? _chewieController;
  ScrollController scrollController = ScrollController();
  bool isPullingTop = false;

  @override
  void initState() {
    super.initState();
    VideoPlayerController videoPlayerController =
        VideoPlayerController.asset("assets/images/video.mp4");
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      showControlsOnInitialize: false,
      showControls: false,
    );
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.offset < 0) {
      setState(() {
        isPullingTop = true;
      });
      _chewieController!.play();
    } else {
      setState(() {
        isPullingTop = false;
      });
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xffF4F4F4),
      child: SafeArea(
        child: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels < 0) {
              setState(() {
                isPullingTop = true;
              });
            } else {
              setState(() {
                isPullingTop = false;
              });
            }
            return false; // return false to allow normal handling of the notification
          },
          child: SingleChildScrollView(
            controller: scrollController,
            physics: isPullingTop
                ? const ClampingScrollPhysics()
                : const BouncingScrollPhysics(),
            child: Column(
              children: [
                isPullingTop
                    ? SizedBox(
                        height: 200.0,
                        child: Chewie(controller: _chewieController!),
                      )
                    : const SizedBox(),
                isPullingTop
                    ? const SizedBox()
                    : const BuildImage(image: "popular-foods.png"),

                //* Pills
                isPullingTop
                    ? const SizedBox()
                    : SizedBox(
                        height: 65,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: DummyData.pills.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: BuildImage(
                                image: DummyData.pills[index],
                              ),
                            );
                          },
                        ),
                      ),

                const SizedBox(height: 10),

                //* Discount
                const BuildImage(image: "Discount.png"),

                const SizedBox(height: 5),

                //* cards
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 10,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: DummyData.cards.length,
                  itemBuilder: (context, index) {
                    return BuildImage(
                      image: DummyData.cards[index],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
