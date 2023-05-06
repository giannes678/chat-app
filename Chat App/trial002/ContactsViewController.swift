

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ContactsViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()

    var contacts: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableView.dataSource = self
        tableView.delegate = self 

        navigationItem.hidesBackButton = true

        var user = (Auth.auth().currentUser?.email)!.capitalized
        user.removeLast(8)
        title = user + "'s Contacts"

        tableView.register(UINib(nibName: K.contactCellNibName, bundle: nil), forCellReuseIdentifier: K.contactCellIdentifier)
        loadMessages()
    }
    
    func loadMessages() {
        

        print((Auth.auth().currentUser?.email)!)
        db.collection((Auth.auth().currentUser?.email)!)
            .order(by: K.FStore.dateField, descending: true)
            .addSnapshotListener { querySnapshot, error in
            

            self.contacts = []
                
            if let e = error{
                print(e)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let friendEmail = data["friendEmail"] as? String {
                            self.contacts.append(friendEmail.capitalized)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                if(self.contacts.count > 0) {
                                    let indexPath = IndexPath(row: self.contacts.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }

                            }
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        print("called")
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection((Auth.auth().currentUser?.email)!).addDocument(data: ["friendEmail" : messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
                ]) { (error) in
                if let e = error{
                    print(e)
                } else {
                    print("saved data")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                    
                }            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
}


extension ContactsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let contact = contacts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.contactCellIdentifier, for: indexPath) as! ContactCell

        cell.label.text = contact
        cell.letterBubble?.text = String(contact.first!).uppercased()

            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("tapped")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let chatViewController = storyboard.instantiateViewController(withIdentifier: "ChatTableView") as? ChatViewController else { return }

        chatViewController.reciever = contacts[indexPath.row]
        navigationController?.pushViewController(chatViewController, animated: true)
    }

}






