import 'package:silvertime/include.dart';
import 'package:silvertime/widgets/common/footer.dart';
import 'package:silvertime/widgets/common/navbar.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final ScrollController _scrollController = ScrollController();
  bool changeColor = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if(
        _scrollController.hasClients && _scrollController.offset > kToolbarHeight &&
        !changeColor
      ) {
        setState(() {
          changeColor = true;
        });
      } else if (
        _scrollController.hasClients && _scrollController.offset <= kToolbarHeight
      ) {
        setState(() {
          changeColor = false;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar (
        changeColor: changeColor,
      ),
      body: Scrollbar (
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container (
                constraints: BoxConstraints (
                  minHeight: MediaQuery.of(context).size.height - Navbar.navbarHeight
                ),
                child: widget.child
              ),
              const Footer()
            ],
          ),
        ),
      ),
    );
  }
}