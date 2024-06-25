

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
      
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("========================")
        if(Auth.auth().currentUser?.email != nil){
            print((Auth.auth().currentUser?.email)!)
//            ContactsTableView
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let contactsViewController = storyboard.instantiateViewController(withIdentifier: "ContactsTableView") as? ContactsViewController else { return }
            navigationController?.pushViewController(contactsViewController, animated: true)
        }
        print("========================")
        registerBtn.layer.cornerRadius = registerBtn.frame.size.height / 5
        
    }
    

    @IBAction func loginPressed(_ sender: UIButton) {
        if let user = emailTextfield.text, let password = passwordTextfield.text {
            let email = user + "@try.com"
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                if let e = error{
                    print(e)
                    let alert = UIAlertController(title: "Error", message: "The username & password you entered does not match!", preferredStyle: UIAlertController.Style.alert)

                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
                // ...
            }
        }
    }
    
}
