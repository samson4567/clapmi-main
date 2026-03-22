import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:go_router/go_router.dart';

class GooglesiginWebview extends StatefulWidget {
  const GooglesiginWebview(
      {super.key, required this.googleSignInUrl, required this.coinAmount});
  final String googleSignInUrl;
  final String coinAmount;

  @override
  State<GooglesiginWebview> createState() => _GooglesiginWebviewState();
}

class _GooglesiginWebviewState extends State<GooglesiginWebview> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    //**Initialize webview controller */
    print('----${widget.googleSignInUrl}');
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {
          if (progress == 100) {
            setState(() {
              isLoading = false;
            });
          }
        },
        onPageStarted: (url) {
          print("Page started Loading@@____----!!!: $url");
        },
        onPageFinished: (url) {
          print("Page finished loading(((()))))______#####: $url");
          //Check if this is a callback URL from your backend
          if (url.contains("clapmi.com")) {
            // _handleCallback(url);
          }
        },
        onNavigationRequest: (request) {
          print('This is the request data ${request.url}');
          if (request.url.contains("clapmi.com")) {
            // _handleCallback(request.url);
            context.pushReplacementNamed(MyAppRouteConstant.coinAdded,
                extra: widget.coinAmount);
            // return NavigationDecision.navigate;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(widget.googleSignInUrl));

    super.initState();
  }

  // void _handleCallback(String url) {
  //   //Parse the callback URL to extract tokens or codes
  //   Uri uri = Uri.parse(url);
  //   print(uri.toString());
  //   String? code = uri.queryParameters['code'];
  //   String? error = uri.queryParameters['error'];

  //   if (error != null) {
  //   } else if (code != null) {}
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Checkout"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          // if (isLoading)
          //   const Center(
          //     child: CircularProgressIndicator(
          //       valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          //     ),
          //   )
        ],
      ),
    );
  }
}

class TutorialWebView extends StatefulWidget {
  const TutorialWebView({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<TutorialWebView> createState() => _TutorialWebViewState();
}

class _TutorialWebViewState extends State<TutorialWebView> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.videoUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        WebViewWidget(controller: controller),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
      ],
    );
  }
}

class TermsandWebView extends StatefulWidget {
  const TermsandWebView({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<TermsandWebView> createState() => _TermsandWebViewState();
}

class _TermsandWebViewState extends State<TermsandWebView> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.videoUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Clapmi',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Geist',
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
