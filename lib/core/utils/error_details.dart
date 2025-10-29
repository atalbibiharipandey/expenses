import 'package:expance/core/common.dart';

class ErrorDetails extends StatelessWidget {
  const ErrorDetails({
    super.key,
    required this.message,
    required this.statusCode,
    required this.url,
  });

  final String message;
  final int statusCode;
  final String url;
  @override
  Widget build(BuildContext context) {
    size = getSize(context);
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        elevation: 0,
        // iconTheme: IconThemeData(color: cTeal900),
        title: const Text(
          "Error Details",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.7,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "HTTP Response Code:- $statusCode",
              style: const TextStyle(fontWeight: FontWeight.bold),
              textScaleFactor: 1.2,
            ),
            Text(
              "Url:- $url",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textScaleFactor: 1,
            ),
            Container(
              // decoration: boxDecorartion,
              margin: margin2010,
              padding: margin20all,
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textScaleFactor: 0.9,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        // height: size.height / 9,
        //decoration: boxDecorartion,
        padding: margin20all,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: size.width,
              height: size.height / 15,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  // backgroundColor: cTeal900,
                  elevation: 10,
                  //shadowColor: cTeal50,
                ),
                child: const Text(
                  "Go Back",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
