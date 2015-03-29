import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!

    var URL = NSURL()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        webView.loadRequest(NSURLRequest(URL: URL))
        webView.scrollView.contentInset = UIEdgeInsets(
            top: 20.0,
            left: 20.0,
            bottom: 20.0,
            right: 20.0
        )
    }

    @IBAction func share(sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(
            activityItems: [URL],
            applicationActivities: nil
        )
        presentViewController(activityViewController, animated: true, completion: nil)
    }

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
