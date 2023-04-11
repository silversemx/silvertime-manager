import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';


class CustomTable extends StatefulWidget {
  /// Constraints values that are generated for this widget
  final BoxConstraints constraints;
  /// String column header names
  final List<String> columns;
  /// DataRow rows
  final List<DataRow> rows;
  /// Custom Table height, default in MediaQuery.of(context).height * 0.7
  final double? height;
  /// Custom dataRowHeight, default in 130
  final double dataRowHeight;
  /// Number of pages that the table will have
  final num pages;
  /// Method to update the page and request for new data
  final void Function(int) onPageUpdate;
  /// Loading variable to show a skeleton table while real data is loaded
  final bool loading;

  /// CustomTable Uses Flutter's Datatable in order to generate a responsive table
  const CustomTable({ 
    Key? key, 
    required this.constraints,
    required this.columns,
    required this.rows, 
    required this.onPageUpdate,
    required this.pages,
    this.loading = false,
    this.height,
    this.dataRowHeight = 130
  }) : super(key: key);

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  final ScrollController _horizontalScrollController = ScrollController();

  final ScrollController _verticalScrollController = ScrollController ();

  int _currentPage = 0;

  Widget _tableControls () {
    return Row (
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: _currentPage > 0,
          child: IconButton (
            icon: Icon (Icons.keyboard_double_arrow_left, color: Theme.of(context).primaryColor),
            onPressed: () {
              if (widget.pages > 0) {
                setState(() {
                  _currentPage = 0;
                });
                widget.onPageUpdate(_currentPage);
                _verticalScrollController.animateTo(0, duration: const Duration (milliseconds: 200), curve: Curves.easeIn);
              }
            },
          ),
        ),
        IconButton (
          icon: Icon (Icons.keyboard_arrow_left, color: Theme.of(context).primaryColor),
          onPressed: () {
            if (_currentPage > 0) {
              setState(() {
                _currentPage --;
              });
              widget.onPageUpdate(_currentPage);
            }
            _verticalScrollController.animateTo(0, duration: const Duration (milliseconds: 200), curve: Curves.easeIn);
          },
        ),
        Text (
          "${_currentPage + 1} / ${widget.pages}"
        ),
        IconButton (
          icon: Icon (Icons.keyboard_arrow_right, color: Theme.of(context).primaryColor),
          onPressed: () {
            if ((_currentPage + 1) < widget.pages) {
              setState(() {
                _currentPage ++;
              });
              widget.onPageUpdate(_currentPage);
              _verticalScrollController.animateTo(0, duration: const Duration (milliseconds: 200), curve: Curves.easeIn);
            }
          },
        ),
        Visibility(
          visible: widget.pages > 1 && _currentPage < widget.pages - 1,
          child: IconButton (
            icon: Icon (Icons.keyboard_double_arrow_right, color: Theme.of(context).primaryColor),
            onPressed: () {
              if (widget.pages > 1) {
                setState(() {
                  _currentPage = widget.pages.toInt() - 1;
                });
                widget.onPageUpdate(_currentPage);
                _verticalScrollController.animateTo(0, duration: const Duration (milliseconds: 200), curve: Curves.easeIn);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _loadingSkeleton () {
    double height = widget.height ?? MediaQuery.of(context).size.height * 0.7;

    return SkeletonItem (
      child: SizedBox(
        width: widget.constraints.maxWidth,
        child: Column (
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                5, 
                (index) => SizedBox(
                  width: widget.constraints.maxWidth / 5.2,
                  child: SkeletonParagraph (
                    style: const SkeletonParagraphStyle (
                      lines: 1,
                      lineStyle: SkeletonLineStyle(
                        height: 12
                      ),
                    ),
                  ),
                )
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: widget.constraints.maxWidth,
              child: SkeletonLine (
                style: SkeletonLineStyle (
                  maxLength: widget.constraints.maxWidth,
                  height: 1
                ),
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              height: height * 0.4,
              child: SkeletonListView(
                item: Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    5, 
                    (index) => SizedBox(
                      width: widget.constraints.maxWidth / 5.2,
                      child: SkeletonParagraph (
                        style: const SkeletonParagraphStyle (
                          lines: 2,
                          lineStyle: SkeletonLineStyle(
                            height: 24
                          )
                        ),
                      ),
                    )
                  ),
                ),
                itemCount: 5,
                scrollable: false,
                spacing: 16,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = widget.height ?? MediaQuery.of(context).size.height * 0.7;

    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: widget.constraints.maxWidth,
            height: height * 0.9,
            child: Scrollbar(
              controller: _horizontalScrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _horizontalScrollController,
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints (
                    minWidth: widget.constraints.maxWidth
                  ),
                  child: Scrollbar(
                    controller: _verticalScrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _verticalScrollController,
                      scrollDirection: Axis.vertical,
                      child: widget.loading
                      ? _loadingSkeleton()
                      : DataTable(
                        dataRowHeight: widget.dataRowHeight,
                        columnSpacing: 12,
                        showCheckboxColumn: true,
                        columns: widget.columns.map <DataColumn> (
                          (column) => DataColumn (
                            label: Expanded(
                              child: Center(
                                child: Text (
                                  column,
                                  style: Theme.of(context).textTheme.displaySmall,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            numeric: false,
                            onSort: (int index, bool sorted) {
                              
                            }
                          )
                        ).toList(),
                        rows: widget.rows
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: _tableControls ()),
        ],
      ),
    );
  }
}