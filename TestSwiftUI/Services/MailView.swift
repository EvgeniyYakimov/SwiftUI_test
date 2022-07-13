
import Foundation
import MessageUI
import SwiftUI
import UIKit

struct DataEmail {
    var subject: String = ""
    var recipients: [String]?
    var body: String = ""
    var isBodyHTML = false
    var attachments = [AttachmentData]()
    var images: [UIImage] = []
    

}
struct AttachmentData {
    var data: Data
    var mimeType: String
    var fileName: String
}

public struct MailView: UIViewControllerRepresentable {
   

    @Environment(\.presentationMode) private var presentationMode
    let dataEmail: DataEmail
    var onResult: (Result<MFMailComposeResult, Error>) -> Void

    
    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
            var parent: MailView
            
            init(_ parent: MailView) {
                self.parent = parent
            }
        
        public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                
                if let error = error {
                    parent.onResult(.failure(error))
                    return
                }
                
                parent.onResult(.success(result))
                
                parent.presentationMode.wrappedValue.dismiss()
            }
        
        }
    
    
    
    static func canSendEmail() -> Bool {
            MFMailComposeViewController.canSendMail()
        }



    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIViewController(
        context: UIViewControllerRepresentableContext<MailView>
    ) -> MFMailComposeViewController {
        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = context.coordinator
        controller.setSubject(dataEmail.subject)

        controller.setMessageBody(dataEmail.body, isHTML: false)
        
        for attachment in dataEmail.images {
            controller.addAttachmentData(attachment.jpegData(compressionQuality: CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "test.jpeg")
          }
        return controller
    }

    public func updateUIViewController(
        _ uiViewController: MFMailComposeViewController,
        context: UIViewControllerRepresentableContext<MailView>
    ) {
        // nothing to do here
    }
}
