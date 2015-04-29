class WebViewController : UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!

    var URL: NSURL = NSURL()

    // MARK: UIViewController

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        webView.loadRequest(NSURLRequest(URL: URL))
    }

    // MARK: Actions

    @IBAction func share(sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: [URL], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
    }

    // MARK: UIWebViewDelegate

    func webViewDidStartLoad(webView: UIWebView) {
        navigationItem.rightBarButtonItem = .activityIndicatorBarButtonItem()
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        navigationItem.rightBarButtonItem = nil
    }
}

extension UIBarButtonItem {
    static func activityIndicatorBarButtonItem() -> UIBarButtonItem {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
        activityIndicatorView.startAnimating()
        return UIBarButtonItem(customView: activityIndicatorView)
    }
}