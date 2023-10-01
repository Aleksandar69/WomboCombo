import 'package:flutter/material.dart';
import 'package:wombocombo/providers/strikes_provider.dart';
import '../../widgets/video_image_widgets/video_player.dart';
import 'package:provider/provider.dart';

class StrikeAnimation extends StatefulWidget {
  static const routeName = '/strike-animation';
  const StrikeAnimation({super.key});

  @override
  State<StrikeAnimation> createState() => _StrikeAnimationState();
}

class _StrikeAnimationState extends State<StrikeAnimation> {
  late final StrikesProvider strikesProvider =
      Provider.of<StrikesProvider>(context);
  var strike;
  var isLoading = true;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    var strikeNumber = ModalRoute.of(context)!.settings.arguments as String;
    //strike = strikesProvider.getStrike('correspondingNumber', strikeNumber);
    strike = await getStrike(strikeNumber);
    var test = strike['strikeUrl'];
    var i = 0;
    setState(() {
      isLoading = false;
    });
  }

  getStrike(strikeNumber) async {
    return await strikesProvider.getStrike(strikeNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Please wait while the animation loads"),
                  ],
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyRecordedRemoteVideo(strike['strikeUrl'], true, true, false),
                Text('attack name'),
              ],
            ),
    );
  }
}
