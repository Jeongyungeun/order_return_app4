import 'package:flutter/material.dart';
import 'dart:math';

const Duration _duration = Duration(milliseconds: 300);

class ExpandableFab2 extends StatefulWidget {
  const ExpandableFab2(
      {Key? key, required this.distance, required this.children})
      : super(key: key);

  final double distance;
  // 주버튼과 새끼 버튼 거리
  final List<Widget> children;
  // 새끼위젯

  @override
  _ExpandableFab2State createState() => _ExpandableFab2State();
}

class _ExpandableFab2State extends State<ExpandableFab2>
    with SingleTickerProviderStateMixin {
  //이 클래스는 애니메이션이 시간이
  //변함에 따라 애니메이션 상태의 변화를 알려주는 역할
  bool _open = false; //눌렀는지 안눌렀는지
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        value: _open ? 1.0 : 0.0,
        duration: _duration,
        vsync: this); //this는 singleTicker~~ 에서 내용이 있다.
    _expandAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            // _ExpandableActionButton(
            //     distance: widget.distance,
            //     degree: 45.0,
            //     progress: _expandAnimation,
            //     child: ActionButton(
            //         onPressed: () {},
            //         icon: Icon(
            //           Icons.home,
            //           color: Colors.transparent,
            //         )
            //     )
            // ),
            _buildTapToCloseFab(),
            _buildTapToOpenFab(),
          ]..insertAll(0, _buildExpandableActionButton())),
    );
  }

  List<_ExpandableActionButton> _buildExpandableActionButton() {
    List<_ExpandableActionButton> animchildren = [];
    final int count = widget.children.length;
    final double gap = 90.0 / (count - 1);

    for (var i = 0, degree = 0.0; i < count; i++, degree += gap) {
      animchildren.add(_ExpandableActionButton(
        distance: widget.distance,
        progress: _expandAnimation,
        child: widget.children[i],
        degree: degree,
      ));
    }
    return animchildren;
  }

  AnimatedContainer _buildTapToCloseFab() {
    return AnimatedContainer(
      transformAlignment: Alignment.center,
      duration: _duration,
      transform: Matrix4.rotationZ(_open ? 0 : pi / 4),
      child: FloatingActionButton(
        heroTag: 'btn1',
        backgroundColor: Colors.white,
        onPressed: () {
          toggle();
        },
        child: Icon(
          Icons.close,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  AnimatedContainer _buildTapToOpenFab() {
    return AnimatedContainer(
      transformAlignment: Alignment.center,
      duration: _duration,
      transform: Matrix4.rotationZ(_open ? 0 : pi / 4),
      child: AnimatedOpacity(
        duration: _duration,
        opacity: _open ? 0.0 : 1.0,
        child: FloatingActionButton(
          heroTag: "btn2",
          onPressed: () {
            toggle();
          },
          child: Icon(Icons.close),
        ),
      ),
    );
  }

  void toggle() {
    _open = !_open;
    setState(() {
      if (_open)
        _controller.forward();
      else
        _controller.reverse();
    });
  }
}

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;

// condtuctor에서 다른데서  onPressed, icon을 받아와서 위젯을 완성시키는 구조다.
  const ActionButton({Key? key, required this.onPressed, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        shape: const CircleBorder(), //바깥을 동그랗게 만들어
        clipBehavior: Clip.antiAlias, //동그랗게 하는데 부드럽게.
        elevation: 4.0,
        color: Theme.of(context).primaryColor,
        child: IconButton(onPressed: onPressed, icon: icon));
  }
}

//animation만 주는 위젯

class _ExpandableActionButton extends StatelessWidget {
  final double distance;
  final double degree;
  final Animation<double> progress;
  final Widget child;

  const _ExpandableActionButton(
      {Key? key,
      required this.distance,
      required this.degree,
      required this.progress,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: progress,
        builder: (BuildContext context, Widget? child) {
          final Offset offset = Offset.fromDirection(
              degree * (pi / 180), progress.value * distance);
          //offset의 위치의 변하는 상태가 offset으로 들어온다. 좌표계가 원주 좌표계인듯... 즉
          // 중심과의 거리와 각도로 표현핡수 있는 좌표계계
          return Positioned(
            right: offset.dx + 4,
            bottom: offset.dy + 4,
            child: Container(
              child: child,
            ),
          );
        },
        child: child);
  }
}
