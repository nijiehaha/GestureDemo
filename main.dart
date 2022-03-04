import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';

import 'package:vector_math/vector_math_64.dart' as v;

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

// class Controller extends GetxController {
//   Color borderColor = Colors.red;
//   void change(Color color) {
//     borderColor = color;
//     update();
//   }
// }
//
// class MyHomePage extends StatelessWidget {
//   MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     MyWidget item = MyWidget(
//
//     );
//
//     return Container(
//       child: Column(
//         children: [
//           SizedBox(height: 40,),
//           GestureDetector(
//             behavior: HitTestBehavior.opaque,
//             onTap: () {
//               debugPrint("click change color");
//               item.borderColor.value = Colors.transparent;
//             },
//             child: Text("change color"),
//           ),
//           SizedBox(height: 40,),
//           item,
//         ],
//       ),
//     );
//   }
// }
//
// class MyWidget extends StatelessWidget {
//   MyWidget({
//     Key? key,
//   }) : super(key: key);
//
//   final Rx<Color> borderColor = Colors.red.obs;
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return Container(
//         color: borderColor.value,
//         width: 100,
//         height: 100,
//       );
//     });
//   }
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double avatarSize = 0;
  final avatarWidgets = <Widget>[];

  final comGlobalKey = GlobalKey();

  Uint8List bytes = Uint8List.fromList([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '头像编辑',
          style: TextStyle(
              fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                avatarSize = constraints.constrainWidth();
                return RepaintBoundary(
                  key: comGlobalKey,
                  child: ClipRect(
                    child: Container(
                      color: Colors.blue,
                      width: avatarSize,
                      height: avatarSize,
                      child: Stack(
                        children: avatarWidgets,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      '选择头像模版',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  margin: const EdgeInsets.only(top: 27, bottom: 46),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          Container(
                            color: Colors.red,
                            width: 32,
                            height: 32,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            '添加文字',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      onTap: () {
                        addText(AvatarTextData());
                      },
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          Container(
                            color: Colors.red,
                            width: 32,
                            height: 32,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            '添加贴图',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      onTap: () {
                        //添加图

                        WidgetToImage.widgetToImage(comGlobalKey.currentWidget!,size: Size(40, 40))
                        .then((value) {
                          if (value != null) {
                            setState(() {
                              bytes = value.buffer.asUint8List();
                            });
                          }
                        });



                        // toPng().then((value) {
                        //   if (value != null) {
                        //     setState(() {
                        //       bytes = value;
                        //     });
                        //   }
                        // });

                        // setState(() {
                        //   final text = avatarWidgets.first as AvatarText;
                        //   text.avatarTextData.value.borderColor = Colors.transparent;
                        // });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Image.memory(bytes,width: 40, height: 40,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List?> toPng() async {
    try {
      RenderRepaintBoundary boundary = comGlobalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  void addText(AvatarTextData avatarTextData) {
    final avatarText = AvatarText(
      avatarSize: avatarSize,
      onRemove: (widget) {
        setState(() {
          avatarWidgets.remove(widget);
        });
      },
      onCopy: (AvatarTextData data) {
        addText(data);
      },
    );
    avatarText.avatarTextData.value = avatarTextData;
    debugPrint('添加文字');
    setState(() {
      avatarWidgets.add(avatarText);
    });
  }
}

abstract class AvatarWidget extends StatefulWidget {
  final bool focused;
  final double avatarSize;

  const AvatarWidget({
    Key? key,
    this.focused = false,
    required this.avatarSize,
  }) : super(key: key);
}

class AvatarText extends AvatarWidget {

  final void Function(AvatarTextData data) onCopy;
  final void Function(Widget widget) onRemove;

  var avatarTextData = AvatarTextData().obs;

  AvatarText({
    Key? key,
    focused,
    required this.onCopy,
    required avatarSize,
    required this.onRemove,
  }) : super(key: key, avatarSize: avatarSize);

  @override
  State<StatefulWidget> createState() {
    return AvatarTextState();
  }
}

class AvatarTextState extends State<AvatarText> {
  double startScaleFontSize = 0;
  var scaleOffset = Offset.zero;
  var scaleStartOffset = Offset.zero;

  var _scale = 1.0;
  var _offset = const Offset(0, 0);

  var gestureAreaSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    Widget item = Positioned(
      top: widget.avatarTextData.value.offset.dy,
      left: widget.avatarTextData.value.offset.dx,
      child: Transform.scale(
        scale: _scale,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanUpdate: (details) {
            setState(() {
              _offset += details.delta;
              widget.avatarTextData.value.offset = _offset;
            });
          },
          child: Stack(
            children: [
              AfterLayout(
                callback: (ral) {
                  if (gestureAreaSize == Size.zero) {
                    gestureAreaSize = ral.size;
                  }
                },
                child: Obx((){

                  return Container(
                    margin: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                        border: Border.all(color: widget.avatarTextData.value.borderColor)),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    child: Text(
                      widget.avatarTextData.value.text.split("").join("\n"),
                      style: TextStyle(
                        color: const Color(0xff303133),
                        fontSize: widget.avatarTextData.value.fontSize,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );

                }),
              ),
              Positioned(
                child: Transform.scale(
                  scale: 1 / _scale,
                  child: GestureDetector(
                    child: Container(
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      child:
                          Container(color: Colors.red, width: 16, height: 16),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                    ),
                    onTap: () {
                      debugPrint('点击了remove');
                      widget.onRemove(widget);
                    },
                  ),
                ),
                left: 0,
                top: 0,
              ),
              Positioned(
                child: Transform.scale(
                  scale: 1 / _scale,
                  child: GestureDetector(
                    child: Container(
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      child:
                          Container(color: Colors.red, width: 16, height: 16),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                    ),
                    onTap: () {
                      debugPrint('点击了add');
                      widget.onCopy(widget.avatarTextData.value.copyWith());
                    },
                  ),
                ),
                right: 0,
                top: 0,
              ),
              Positioned(
                child: Transform.scale(
                  scale: 1 / _scale,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 18,
                        height: 18,
                        alignment: Alignment.center,
                        child: Container(
                          color: Colors.red,
                          width: 16,
                          height: 16,
                        ),
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                      ),
                    ),
                    onPanDown: (d) {
                      scalePanDown(d);
                    },
                    onPanUpdate: (details) {
                      scalePanUpdate(details);
                    },
                  ),
                ),
                right: -8,
                bottom: -8,
              ),
            ],
          ),
        ),
      ),
    );

    return item;
  }

  var scaleCenter = Offset.zero;
  var lastCtrlPosition = Offset.zero;

  void scalePanDown(DragDownDetails details) {
    final offset = widget.avatarTextData.value.offset;
    scaleCenter = Offset(
        20 + gestureAreaSize.width / 2.0 + offset.dx,
        kToolbarHeight +
            MediaQueryData.fromWindow(ui.window).padding.top +
            20 +
            gestureAreaSize.height / 2.0 +
            offset.dy);
    lastCtrlPosition = Offset(scaleCenter.dx + gestureAreaSize.width / 2.0,
        scaleCenter.dy + gestureAreaSize.height / 2.0);
  }

  void scalePanUpdate(DragUpdateDetails details) {
    double preDistance = distanceWithTwoPoint(scaleCenter, lastCtrlPosition);
    double newDistance =
        distanceWithTwoPoint(scaleCenter, details.globalPosition);
    setState(() {
      _scale = max(0.3, newDistance / preDistance);
    });
  }

  double distanceWithTwoPoint(Offset start, Offset end) {
    double x = start.dx - end.dx;
    double y = start.dy - end.dy;
    return sqrt(x * x + y * y);
  }
}

class AvatarTextData {
  String text = '点击编辑';
  double fontSize = 20;
  Offset offset = Offset.zero;
  Color borderColor = Colors.red;

  AvatarTextData({
    this.text = '点击编辑',
    this.fontSize = 20,
    this.offset = Offset.zero,
  });

  AvatarTextData copyWith({
    String? text,
    double? fontSize,
    Offset? offset,
  }) {
    return AvatarTextData(
        text: text ?? this.text,
        fontSize: fontSize ?? this.fontSize,
        offset: offset ?? this.offset);
  }
}

class AfterLayout extends SingleChildRenderObjectWidget {
  const AfterLayout({
    Key? key,
    required this.callback,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderAfterLayout(callback);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderAfterLayout renderObject) {
    renderObject.callback = callback;
  }

  ///组件树布局结束后会被触发，注意，并不是当前组件布局结束后触发
  final ValueSetter<RenderAfterLayout> callback;
}

class RenderAfterLayout extends RenderProxyBox {
  RenderAfterLayout(this.callback);

  ValueSetter<RenderAfterLayout> callback;

  @override
  void performLayout() {
    super.performLayout();
    // 不能直接回调callback，原因是当前组件布局完成后可能还有其它组件未完成布局
    // 如果callback中又触发了UI更新（比如调用了 setState）则会报错。因此，我们
    // 在 frame 结束的时候再去触发回调。
    SchedulerBinding.instance!
        .addPostFrameCallback((timeStamp) => callback(this));
  }

  /// 组件在屏幕坐标中的起始点坐标（偏移）
  Offset get offset => localToGlobal(Offset.zero);

  /// 组件在屏幕上占有的矩形空间区域
  Rect get rect => offset & size;
}

class WidgetToImage {
  static Future<ByteData?> repaintBoundaryToImage(GlobalKey key, {double pixelRatio = 1.0}) {
    return new Future.delayed(const Duration(milliseconds: 20), () async {
      if (key.currentContext == null){
        return null;
      }
      RenderRepaintBoundary repaintBoundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await repaintBoundary.toImage(pixelRatio: pixelRatio);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData;
    });
  }

  static Future<ByteData?> widgetToImage(Widget widget, {
    Alignment alignment = Alignment.center,
    Size size = const Size(double.maxFinite, double.maxFinite),
    double devicePixelRatio = 1.0,
    double pixelRatio = 1.0
  }) async {
    RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    RenderView renderView = RenderView(
      child: RenderPositionedBox(alignment: alignment, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: size,
        devicePixelRatio: devicePixelRatio,
      ),
      window: WidgetsBinding.instance!.platformDispatcher.views.first,
    );

    PipelineOwner pipelineOwner = PipelineOwner();
    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
    RenderObjectToWidgetElement rootElement = RenderObjectToWidgetAdapter(
      container: repaintBoundary,
      child: widget,
    ).attachToRenderTree(buildOwner);
    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    ui.Image image = await repaintBoundary.toImage(pixelRatio: pixelRatio);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData;
  }
}