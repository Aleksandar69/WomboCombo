import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/providers/videos_provider.dart';
import 'package:wombocombo/screens/recording/start_recording_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:showcaseview/showcaseview.dart';

/// Camera example home widget.
class VideoRecorder extends StatefulWidget {
  static const routeName = '/video-recorder';

  /// Default Constructor
  @override
  State<VideoRecorder> createState() {
    return _VideoRecorderState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  // This enum is from a different package, so a new value could be added at
  // any time. The example should keep working if that happens.
  // ignore: dead_code
  return Icons.camera;
}

void _logError(String code, String? message) {
  // ignore: avoid_print
  print('Error: $code${message == null ? '' : '\nError Message: $message'}');
}

class _VideoRecorderState extends State<VideoRecorder>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  late final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  late final VideosProvider videosProvider =
      Provider.of<VideosProvider>(context, listen: false);
  CameraController? controller;
  XFile? imageFile;
  XFile? videoFile;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  late AnimationController _exposureModeControlRowAnimationController;
  late Animation<double> _exposureModeControlRowAnimation;
  late AnimationController _focusModeControlRowAnimationController;
  late Animation<double> _focusModeControlRowAnimation;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();

  static const countdownDuration = Duration(seconds: 60);
  Duration duration = Duration();
  Timer? timer;
  bool countDown = true;
  Duration startCountdownDuration = Duration(seconds: 10);
  Duration startDuration = Duration();
  Timer? initialTimer;
  var isInitialCountdownVisible = true;
  var isStarted = false;

  final playerBeep = AudioPlayer();
  final playerRing = AudioPlayer();

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;
  var user;

  void getUser() async {
    user = await userProvider.getUser(authProvider.userId);
  }

  @override
  void initState() {
    super.initState();
    getUser();
    WidgetsBinding.instance.addObserver(this);
    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exposureModeControlRowAnimation = CurvedAnimation(
      parent: _exposureModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusModeControlRowAnimation = CurvedAnimation(
      parent: _focusModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );

    playerSetSource();
    reset();
  }

  void playBell() async {
    return await playerRing.play(AssetSource('sounds/bell.mp3'), volume: 1);
  }

  void playBeep() async {
    return await playerBeep.play(AssetSource('sounds/beep-0.mp3'), volume: 1);
  }

  void playerSetSource() async {
    await playerBeep.setSource(AssetSource('sounds/beep-0.mp3'));
    await playerRing.setSource(AssetSource('sounds/bell.mp3'));
  }

  void reset() {
    if (countDown) {
      setState(() {
        duration = countdownDuration;
        startDuration = startCountdownDuration;
      });
    } else {
      setState(() => duration = Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  startInitDurationTimer() {
    setState(() {
      isStarted = true;
    });
    initialTimer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          var seconds = startDuration.inSeconds - 1;
          if (seconds <= 3 && seconds > 0) {
            playBeep();
          } else if (seconds == 0) {
            playBell();
          } else if (seconds < 0) {
            setState(() {
              isInitialCountdownVisible = false;
            });
            startTimer();
            startVideoRecording().then((_) {
              if (mounted) {
                setState(() {});
              }
            });
            initialTimer?.cancel();
          }
          if (seconds > -1) {
            startDuration = Duration(seconds: seconds);
          }
        });
      }
    });
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds <= 3 && seconds > 0) {
        playBeep();
      } else if (seconds == 0) {
        playBell();
      } else if (seconds < 0) {
        onStopButtonPressed();
        timer?.cancel();
      }
      if (seconds > -1) {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    super.dispose();
  }

  var showShowcase;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var args = ModalRoute.of(context)!.settings.arguments as List;
    _cameras = args[0] as List<CameraDescription>;
    showShowcase = args[1];

    if (showShowcase) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          ShowCaseWidget.of(showcaseContext)
              .startShowCase([_one, _two, _three, _four, _five]));
    }
  }

  // #docregion AppLifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameraController.description);
    }
  }

  // #enddocregion AppLifecycle
  late BuildContext showcaseContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' training session'),
      ),
      body: ShowCaseWidget(
        blurValue: 1,
        disableBarrierInteraction: true,
        builder: Builder(builder: (context) {
          showcaseContext = context;
          return Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: controller != null &&
                              controller!.value.isRecordingVideo
                          ? Colors.redAccent
                          : Colors.grey,
                      width: 3.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Stack(children: [
                      Showcase.withWidget(
                        container: Column(
                          children: [
                            Container(
                              width: 250,
                              child: Text(
                                'Recording starts after the 10 sec countown finishes. Show your skills!',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  ShowCaseWidget.of(context).next();
                                  userProvider.updateUserInfo(
                                      authProvider.userId!,
                                      {'firstTimeRecordScreen': false});
                                },
                                child: Text("Watch me!")),
                          ],
                        ),
                        height: 150,
                        width: 150,
                        key: _three,
                        child: Center(
                          child: _cameraPreviewWidget(),
                        ),
                      ),
                      if (isInitialCountdownVisible && isStarted)
                        Center(
                          child: Text(
                            startDuration.inSeconds.toString(),
                            style: TextStyle(
                                fontSize: 80,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: buildTime(),
                      ),
                    ]),
                  ),
                ),
              ),
              _captureControlRowWidget(),
              _modeControlRowWidget(),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Text("Cameras:", style: TextStyle(fontSize: 14)),
                    Showcase.withWidget(
                      container: Column(
                        children: [
                          Container(
                            width: 400,
                            child: Text('Select one of the available cameras',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                ShowCaseWidget.of(context).next();
                              },
                              child: Text('Alright')),
                        ],
                      ),
                      height: 250,
                      width: 250,
                      key: _one,
                      child: _cameraTogglesRowWidget(),
                    ),
                    // _cameraTogglesRowWidget(),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(children: [
      buildTimeCard(time: minutes),
      SizedBox(
        width: 4,
      ),
      buildTimeCard(time: seconds),
    ]);
  }

  Widget buildTimeCard({required String time}) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(
              time,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 50),
            ),
          ),
        ],
      );

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return Text(
        'Select a camera from options at the bottom',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onTapDown: (TapDownDetails details) =>
                  onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  /// Display a bar with buttons to change the flash and exposure modes
  Widget _modeControlRowWidget() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.flash_on),
              color: Colors.blue,
              onPressed: controller != null ? onFlashModeButtonPressed : null,
            ),
            // The exposure and focus mode are currently not supported on the web.
            ...!kIsWeb
                ? <Widget>[
                    IconButton(
                      icon: const Icon(Icons.exposure),
                      color: Colors.blue,
                      onPressed: controller != null
                          ? onExposureModeButtonPressed
                          : null,
                    ),
                  ]
                : <Widget>[],
          ],
        ),
        _flashModeControlRowWidget(),
        _exposureModeControlRowWidget(),
      ],
    );
  }

  Widget _flashModeControlRowWidget() {
    return SizeTransition(
      sizeFactor: _flashModeControlRowAnimation,
      child: ClipRect(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.flash_off),
              color: controller?.value.flashMode == FlashMode.off
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.off)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.flash_auto),
              color: controller?.value.flashMode == FlashMode.auto
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.auto)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.highlight),
              color: controller?.value.flashMode == FlashMode.torch
                  ? Colors.orange
                  : Colors.blue,
              onPressed: controller != null
                  ? () => onSetFlashModeButtonPressed(FlashMode.torch)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _exposureModeControlRowWidget() {
    final ButtonStyle styleAuto = TextButton.styleFrom(
      // TODO(darrenaustin): Migrate to new API once it lands in stable: https://github.com/flutter/flutter/issues/105724
      // ignore: deprecated_member_use
      primary: controller?.value.exposureMode == ExposureMode.auto
          ? Colors.orange
          : Colors.blue,
    );
    final ButtonStyle styleLocked = TextButton.styleFrom(
      // TODO(darrenaustin): Migrate to new API once it lands in stable: https://github.com/flutter/flutter/issues/105724
      // ignore: deprecated_member_use
      primary: controller?.value.exposureMode == ExposureMode.locked
          ? Colors.orange
          : Colors.blue,
    );

    return SizeTransition(
      sizeFactor: _exposureModeControlRowAnimation,
      child: ClipRect(
        child: Container(
          color: Colors.grey.shade50,
          child: Column(
            children: <Widget>[
              const Center(
                child: Text('Exposure Mode'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    style: styleAuto,
                    onPressed: controller != null
                        ? () =>
                            onSetExposureModeButtonPressed(ExposureMode.auto)
                        : null,
                    onLongPress: () {
                      if (controller != null) {
                        controller!.setExposurePoint(null);
                        showInSnackBar('Resetting exposure point');
                      }
                    },
                    child: const Text('AUTO'),
                  ),
                ],
              ),
              const Center(
                child: Text('Exposure Offset'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(_minAvailableExposureOffset.toString()),
                  Slider(
                    value: _currentExposureOffset,
                    min: _minAvailableExposureOffset,
                    max: _maxAvailableExposureOffset,
                    label: _currentExposureOffset.toString(),
                    onChanged: _minAvailableExposureOffset ==
                            _maxAvailableExposureOffset
                        ? null
                        : setExposureOffset,
                  ),
                  Text(_maxAvailableExposureOffset.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    final CameraController? cameraController = controller;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Showcase.withWidget(
          targetBorderRadius: BorderRadius.circular(35),
          container: Column(
            children: [
              Text('Click on record button to start recording',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    ShowCaseWidget.of(showcaseContext).next();
                  },
                  child: Text('Okay')),
            ],
          ),
          height: 150,
          width: 150,
          key: _two,
          child: IconButton(
            icon: const Icon(Icons.videocam),
            color: Colors.blue,
            onPressed: cameraController != null &&
                    cameraController.value.isInitialized &&
                    !cameraController.value.isRecordingVideo
                ? onVideoRecordButtonPressed
                : null,
          ),
        ),
        IconButton(
          icon: cameraController != null &&
                  cameraController.value.isRecordingPaused
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.pause),
          color: Colors.blue,
          onPressed: cameraController != null &&
                  cameraController.value.isInitialized &&
                  cameraController.value.isRecordingVideo
              ? (cameraController.value.isRecordingPaused)
                  ? onResumeButtonPressed
                  : onPauseButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: cameraController != null &&
                  cameraController.value.isInitialized &&
                  cameraController.value.isRecordingVideo
              ? onStopButtonPressed
              : null,
        ),
      ],
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    void onChanged(CameraDescription? description) {
      if (description == null) {
        return;
      }

      onNewCameraSelected(description);
    }

    if (_cameras.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        showInSnackBar('No camera found.');
      });
      return const Text('None');
    } else {
      var frontCameraAdded = false;
      var backCameraAdded = false;
      for (final CameraDescription cameraDescription in _cameras) {
        var isFront =
            cameraDescription.lensDirection == CameraLensDirection.front;
        if ((cameraDescription.lensDirection == CameraLensDirection.front &&
                !frontCameraAdded) ||
            (cameraDescription.lensDirection == CameraLensDirection.back &&
                !backCameraAdded)) {
          toggles.add(
            SizedBox(
              width: 130.0,
              child: RadioListTile<CameraDescription>(
                title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
                groupValue: controller?.description,
                value: cameraDescription,
                onChanged: onChanged,
              ),
            ),
          );
          if (cameraDescription.lensDirection == CameraLensDirection.front) {
            frontCameraAdded = true;
          } else if (cameraDescription.lensDirection ==
              CameraLensDirection.back) {
            backCameraAdded = true;
          }
        } else if (cameraDescription.lensDirection ==
            CameraLensDirection.external) {}
      }
    }

    return Row(children: toggles);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      return controller!.setDescription(cameraDescription);
    } else {
      return _initializeCameraController(cameraDescription);
    }
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        ...!kIsWeb
            ? <Future<Object?>>[
                cameraController.getMinExposureOffset().then(
                    (double value) => _minAvailableExposureOffset = value),
                cameraController
                    .getMaxExposureOffset()
                    .then((double value) => _maxAvailableExposureOffset = value)
              ]
            : <Future<Object?>>[],
        cameraController
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
          // iOS only
          showInSnackBar('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
          // iOS only
          showInSnackBar('Audio access is restricted.');
          break;
        default:
          _showCameraException(e);
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
      _exposureModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onExposureModeButtonPressed() {
    if (_exposureModeControlRowAnimationController.value == 1) {
      _exposureModeControlRowAnimationController.reverse();
    } else {
      _exposureModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onFocusModeButtonPressed() {
    if (_focusModeControlRowAnimationController.value == 1) {
      _focusModeControlRowAnimationController.reverse();
    } else {
      _focusModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _exposureModeControlRowAnimationController.reverse();
    }
  }

  void onAudioModeButtonPressed() {
    enableAudio = !enableAudio;
    if (controller != null) {
      onNewCameraSelected(controller!.description);
    }
  }

  Future<void> onCaptureOrientationLockButtonPressed() async {
    try {
      if (controller != null) {
        final CameraController cameraController = controller!;
        if (cameraController.value.isCaptureOrientationLocked) {
          await cameraController.unlockCaptureOrientation();
          showInSnackBar('Capture orientation unlocked');
        } else {
          await cameraController.lockCaptureOrientation();
          showInSnackBar(
              'Capture orientation locked to ${cameraController.value.lockedCaptureOrientation.toString().split('.').last}');
        }
      }
    } on CameraException catch (e) {
      _showCameraException(e);
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  void onSetExposureModeButtonPressed(ExposureMode mode) {
    setExposureMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Exposure mode set to ${mode.toString().split('.').last}');
    });
  }

  void onSetFocusModeButtonPressed(FocusMode mode) {
    setFocusMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Focus mode set to ${mode.toString().split('.').last}');
    });
  }

  void onVideoRecordButtonPressed() {
    startInitDurationTimer();
  }

  void onStopButtonPressed() {
    stopTimer();
    stopVideoRecording().then((XFile? file) {
      if (mounted) {
        setState(() {});
      }
      if (file != null) {
        videoFile = file;
        Navigator.of(context).pushReplacementNamed(StartRecording.routeName,
            arguments: videoFile);
      }
    });
  }

  Future<void> onPausePreviewButtonPressed() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isPreviewPaused) {
      await cameraController.resumePreview();
    } else {
      await cameraController.pausePreview();
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onPauseButtonPressed() {
    stopTimer(resets: false);
    pauseVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    startTimer();
    resumeVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Video recording resumed');
    });
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureMode(ExposureMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setExposureMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureOffset(double offset) async {
    if (controller == null) {
      return;
    }

    setState(() {
      _currentExposureOffset = offset;
    });
    try {
      offset = await controller!.setExposureOffset(offset);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFocusMode(FocusMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFocusMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _startVideoPlayer() async {
    if (videoFile == null) {
      return;
    }

    final VideoPlayerController vController = kIsWeb
        ? VideoPlayerController.network(videoFile!.path)
        : VideoPlayerController.file(File(videoFile!.path));

    videoPlayerListener = () {
      if (videoController != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) {
          setState(() {});
        }
        videoController!.removeListener(videoPlayerListener!);
      }
    };
    vController.addListener(videoPlayerListener!);
    await vController.setLooping(true);
    await vController.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imageFile = null;
        videoController = vController;
      });
    }
    await vController.play();
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

List<CameraDescription> _cameras = <CameraDescription>[];

class CameraApp extends StatelessWidget {
  /// Default Constructor
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VideoRecorder(),
    );
  }
}
