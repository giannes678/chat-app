
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var toBeSorted: [String] = []
    var reciever = ""
    var messageCollection = ""
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toBeSorted.append((reciever.lowercased() + "@try.com"))
        toBeSorted.append((Auth.auth().currentUser?.email)!)
        toBeSorted.sort()
        print(toBeSorted)
        messageCollection = toBeSorted[0] + "&" + toBeSorted[1]
        print(messageCollection)
        
        title = reciever.capitalized
        tableView.dataSource = self

        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
        print(reciever)
    }
    
    func loadMessages() {
    print("working")
        

        db.collection(messageCollection)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
            
            self.messages = []
            
            if let e = error{
                print(e)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                if(self.messages.count > 0) {
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
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
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(messageCollection).addDocument(data: [K.FStore.senderField : messageSender,

                K.FStore.bodyField: messageBody,
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


extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        cell.letter.text = String(reciever.first!).uppercased()
        if message.sender == Auth.auth().currentUser?.email{
            cell.letter.isHidden = true
            cell.letterView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.letter.isHidden = false
            cell.letterView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        

        return cell
    }

}

extension ChatViewController: UITableViewDelegate{
    
}

