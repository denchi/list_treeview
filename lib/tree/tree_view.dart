// Copyright (c) 2020 sooxie
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
import 'dart:io';

import 'package:flutter/material.dart';
import 'controller/tree_controller.dart';
import 'node/tree_node.dart';
import 'tree_define.dart';

/// ListTreeView based on ListView.
/// [ListView] is the most commonly used scrolling widget. It displays its
/// children one after another in the scroll direction. In the cross axis, the
/// children are required to fill the [ListView].

/// The default constructor takes takes an [IndexedBuilder] of children.which
/// builds the children on demand.

class ListTreeView extends StatefulWidget {
  ListTreeView({
    required this.itemBuilder,
    this.controller,
    this.shrinkWrap = false,
    this.removeTop = true,
    this.removeBottom = true,
    this.reverse = false,
    this.padding = const EdgeInsets.all(0),
    this.scrollController,
  }) : assert(controller != null, "The TreeViewController can't be empty");

  final IndexedBuilder itemBuilder;
  final TreeViewController? controller;
  final bool shrinkWrap;
  final bool removeBottom;
  final bool removeTop;
  final bool reverse;
  final EdgeInsetsGeometry padding;
  final ScrollController? scrollController;

  @override
  State<StatefulWidget> createState() {
    return _ListTreeViewState();
  }
}

class _ListTreeViewState extends State<ListTreeView> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(updateView);
  }

  /// update view
  void updateView() {
    setState(() => {});
  }

  /// expand or collapse children
  void itemClick(int index) {
    widget.controller?.expandOrCollapse(index);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller == null || widget.controller!.data == null || widget.controller!.data!.length == 0) {
      return Center(
        child: Text(''),
      );
    }

    return Container(
      child: MediaQuery.removePadding(
          removeBottom: widget.removeBottom,
          removeTop: widget.removeTop,
          context: context,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: widget.padding,
            reverse: widget.reverse,
            shrinkWrap: widget.shrinkWrap,
            controller: widget.scrollController,
            itemBuilder: (BuildContext context, int index) {
//        int num = widget.controller.numberOfVisibleChild();
              ///The [TreeNode] associated with the current item
              TreeNode treeNode = widget.controller!.treeNodeOfIndex(index);

              ///The level of the current item
              treeNode.item!.level = widget.controller!.levelOfNode(treeNode.item);
              treeNode.item!.isExpand = widget.controller!.isExpanded(treeNode.item);
              treeNode.item!.index = index;
              NodeData? parent = widget.controller!.parentOfItem(treeNode.item);
              if (parent != null && parent.children.length > 0) {
                treeNode.item!.indexInParent = parent.children.indexOf(treeNode.item!);
              } else {
                treeNode.item!.indexInParent = 0;
              }

              ///Your event is passed through the [Function] with the relevant data
              return widget.itemBuilder(context, treeNode.item!);
            },
            itemCount: widget.controller?.numberOfVisibleChild(),
          )),
    );
  }
}
