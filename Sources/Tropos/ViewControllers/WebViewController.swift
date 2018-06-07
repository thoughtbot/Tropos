import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!

    @objc var url = URL(string: "about:blank")!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.loadRequest(URLRequest(url: url))
        webView.scrollView.contentInset = UIEdgeInsets(
            top: 20.0,
            left: 20.0,
            bottom: 20.0,
            right: 20.0
        )
    }

    @IBAction func share(_ sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        present(activityViewController, animated: true, completion: nil)
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        navigationItem.rightBarButtonItem = .activityIndicatorBarButtonItem()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        navigationItem.rightBarButtonItem = nil
    }
}

extension UIBarButtonItem {
    @objc static func activityIndicatorBarButtonItem() -> UIBarButtonItem {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicatorView.startAnimating()
        return UIBarButtonItem(customView: activityIndicatorView)
    }
}
