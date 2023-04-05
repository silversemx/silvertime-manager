import 'package:silvertime/include.dart';
import 'package:skeletons/skeletons.dart';

class ProgressDialog extends StatefulWidget {
  final Stream<double> progress;
  final String? title;
  final String? message;
  const ProgressDialog({
    super.key, required this.progress, this.message, this.title
  });

  @override
  State<ProgressDialog> createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<ProgressDialog> {
  bool done = false;
  double _last = 0;

  @override
  void initState() {
    super.initState();
  }

  void _finishedStream () {
    Future.microtask(
      () => setState (() {
        done = true;
      })
    );
  }

  Widget _loading () {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SkeletonLine (
            style: SkeletonLineStyle (
              alignment: Alignment.center,
              width: 32,
              borderRadius: BorderRadius.circular(24)
            ),
          ),
          const SizedBox(height: 16),
          SkeletonParagraph(
            style: SkeletonParagraphStyle (
              lineStyle: SkeletonLineStyle (
                borderRadius: BorderRadius.circular(12),
                alignment: Alignment.center,
                width: 8,
                maxLength: 48,
              ),
              lines: 1
            ),
          )
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: constrainedBigWidth(
          context, MediaQuery.of(context).size.width * 0.2,
          constraintWidth: 40
        )
      ),
      child: Container (
        padding: const EdgeInsets.all(16),
        child: Column (
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text (
              widget.title ?? S.of(context).progress,
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(height: 16),
            Visibility (
              visible: widget.message != null,
              child: Text (
                widget.message ?? "",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder<double>(
              stream: widget.progress,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  _finishedStream ();
                }
                if (snapshot.hasData) {
                  _last = snapshot.data!;
                  return TweenAnimationBuilder(
                    tween: Tween<double> (begin: _last, end: snapshot.data!), 
                    duration: const Duration (milliseconds: 350),
                    curve: Curves.easeIn, 
                    builder: (ctx, value, _) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: value,
                              minHeight: 32,
                              valueColor: ColorTween (
                                begin: UIColors.error,
                                end: UIColors.inputSuccess
                              ).animate(
                                AlwaysStoppedAnimation(value)
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text (
                            "${(value * 100).toStringAsFixed(1)}%",
                            style: Theme.of(context).textTheme.headline4,
                          )
                        ],
                      );
                    }
                  );
                } else {
                  return _loading ();
                }
                
              }
            ),
            const SizedBox(height: 16),
            Align (
              alignment: Alignment.bottomRight,
              child: TextButton (
                onPressed: () {
                  if (done) {
                    Navigator.of(context).pop ();
                  }
                },
                child: Text (
                  S.of(context).okay,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                    color: Theme.of(context).primaryColor.withOpacity(
                      done ? 1 : 0.5
                    )
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}