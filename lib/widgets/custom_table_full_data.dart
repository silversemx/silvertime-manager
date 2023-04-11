import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http_request_utils/models/http_exception.dart';
import 'package:silvertime/include.dart';
import 'package:silvertime/widgets/buttons/create_button.dart';
import 'package:silvertime/widgets/custom_table.dart';
import 'package:silvertime/widgets/in_app_messages/confirm_dialog.dart';
import 'package:silvertime/widgets/in_app_messages/error_dialog.dart';
import 'package:silvertime/widgets/in_app_messages/progress_dialog.dart';
import 'package:silvertime/widgets/in_app_messages/status_snackbar.dart';

class ResourceDataWidget<T> extends StatefulWidget {
  final String title;
  final Future<void> Function ({required int skip, required int limit}) fetch;
  final void Function () dismiss;
  final String createSuccessfullyText;
  final String updateSuccessfullyText;
  final String deleteSuccessfullyText;
  final Widget Function ([T?]) dialogCall;
  final String Function (T) id;
  final Stream<double> Function (Iterable<String>) deleteDataStream;
  final String deleteProgressDialogTitle;
  final List<T> data;
  final List<String> columns;
  final List<DataCell> Function (T) cells;
  final Function (T)? access;
  final int pages;

  const ResourceDataWidget({
    Key? key, 
    required this.title,
    required this.fetch,
    required this.dismiss,
    required this.createSuccessfullyText,
    required this.updateSuccessfullyText,
    required this.deleteSuccessfullyText,
    required this.dialogCall,
    required this.id,
    required this.deleteDataStream,
    required this.deleteProgressDialogTitle,
    required this.data,
    required this.cells,
    required this.columns,
    required this.pages,
    this.access
  }): super (key: key);

  @override
  State<ResourceDataWidget<T>> createState() => _ResourceDataWidgetState<T>();
}

class _ResourceDataWidgetState<T> extends State<ResourceDataWidget<T>> {
  bool _loading = true;
  int _currentPage = 0;

  List<String> get columns => [
    ...widget.columns,
    S.of(context).actions
  ];

  set currentPage (int newPage) {
    _currentPage = newPage;
    fetchResourceData ();
    setState(() {});
  }

  Set<String> selectedData = {};

  @override
  void initState() {
    super.initState();
    Future.microtask (_fetchInfo);
  }

  @override
  void dispose() {
    widget.dismiss ();
    super.dispose();
  }

  Future<void> fetchResourceData ({bool showError = true}) async {
    try {
      await widget.fetch (
        skip: 20 * _currentPage, limit: 20
      );
    } on HttpException catch (error) {
      if (showError) {
        showErrorDialog(context, exception: error);
      } else {
        rethrow;
      }
    }
  }

  void _fetchInfo() async {
    setState(() {
      _loading = true;
    });
    try {
      await fetchResourceData(showError: false);
    } on HttpException catch(error) {
      showErrorDialog(context, exception: error);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _createData () async {
    bool? retval = await showDialog (
      context: context,
      builder: (ctx) => widget.dialogCall ()
    );

    if (retval ?? false) {
      showStatusSnackbar(
        context, 
        widget.createSuccessfullyText
      );
    }
  }

  void _updateData (T data) async {
    bool? retval = await showDialog (
      context: context,
      builder: (ctx) => widget.dialogCall (data)
    );

    if (retval ?? false) {
      showStatusSnackbar(
        context, 
        widget.updateSuccessfullyText
      );
    }
  }

  Future<void> _deleteData () async {
    bool? retval = await showConfirmDialog (
      context,
      title: S.of(context).areYouSure, 
      body: S.of(context).thisActionCantBeUndone
    );

    if (retval ?? false) {
      try {
        await showDialog(
          context: context, 
          builder: (ctx) => ProgressDialog(
            progress: widget.deleteDataStream (selectedData),
            title: widget.deleteProgressDialogTitle,
          )
        );

        if (widget.data.length == 1 && _currentPage > 0) {
          _currentPage --;
        }
        selectedData.clear ();
        fetchResourceData();
      } on HttpException catch (error) {
        showErrorDialog(context, exception: error);
        if (error.status != 502 || error.status != 504) {
          fetchResourceData();
        }
      }
    }
  }

  Widget _title () {
    return SizedBox (
      width: double.infinity,
      child: Wrap (
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 32,
        children: [
          Text (
            widget.title,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Row (
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: selectedData.isNotEmpty,
                child: Container(
                  margin: const EdgeInsets.only(right: 32),
                  child: CreateButton (
                    width: 200,
                    color: UIColors.error,
                    onPressed: _deleteData,
                    text: S.of(context).deleteSelected (selectedData.length),
                  ),
                ),
              ),
              CreateButton(
                onPressed: _createData
              )
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  DataRow _schema (T data) {
    return DataRow (
      selected: selectedData.contains(widget.id (data)),
      onSelectChanged: (val) {
        if (val?? false ){
          setState(() {
            selectedData.add (widget.id (data));
          });
        } else {
          setState(() {
            selectedData.remove (widget.id (data));
          });
        }
      },
      cells: [
        ...widget.cells (data),
        DataCell(
          Center (
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: widget.access != null,
                  child: IconButton (
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    style: ButtonStyle (
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: MaterialStateProperty.all(Colors.transparent)
                    ),
                    icon: const Icon (
                      FontAwesomeIcons.doorOpen,
                      size: 24,
                      color: UIColors.inputSuccess,
                    ),
                    onPressed: () {
                      if (widget.access != null) {
                        widget.access! (data);
                      }
                    },
                  )
                ),
                IconButton (
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  icon: const Icon (
                    FontAwesomeIcons.penToSquare,
                    size: 24,
                  ),
                  onPressed: () => _updateData (data),
                ),
              ],
            ),
          )
        )
      ]
    );
  }

  Widget _table () {
    return ConstrainedBox(
      constraints: BoxConstraints (
        minHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          if (widget.data.isEmpty && !_loading) {
            return Center (
              child: Text (
                S.of(context).noInformation,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            );
          } else {
            List<DataRow> rows = widget.data.map<DataRow> (
              (data) => _schema(data)
            ).toList();

            return CustomTable (
              constraints: constraints,
              columns: columns,
              pages: widget.pages,
              rows: rows,
              loading: _loading,
              onPageUpdate: (newPage) => currentPage = newPage,
            );
          }
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints (
        minHeight: (MediaQuery.of(context).size.height * 1) - 45,
        minWidth: MediaQuery.of(context).size.width
      ),
      child: Column (
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title (),
          const SizedBox(height: 16),
          _table()
        ],
      ),
    );
  }

}