//
//  ViewController.swift
//  SourceDLT_App
//
//  Created by masato on 23/2/2020.
//  Copyright © 2020 Masato Miyai. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {


    var userNameArray = ["XYZpharma789", "VAN2234", "OCEAN402a", "SHOP342B12", "4x234fca987"]
    var userImageArray: [UIImage] = [#imageLiteral(resourceName: "circle_manufacturer"), #imageLiteral(resourceName: "circle_distoributor"), #imageLiteral(resourceName: "circle_shipment"), #imageLiteral(resourceName: "circle_pharmacy"), #imageLiteral(resourceName: "circle_prescription")]
    var recieptTimeArray: [String] = []
    var shipmentTimeArray: [String] = []

    // Add Password TextField
    var tField: UITextField!

    var isLogin = false
    var isPushConfirmButton = true

    var testHsmIdCounter = 0

    var sceneView: ARSCNView!
    var alertController: UIAlertController!


    lazy var transitToHistoryViewButton: UIButton = {

        let button = UIButton(type: UIButton.ButtonType.system) // Button Typeをsystemにすると自然にボタンを押した時に色が変わる
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("History", for: .normal)
        button.tag = 100

        button.tintColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.6650493741, blue: 0.8382979631, alpha: 1)
        button.layer.opacity = 1.0
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(tappedTransitToHistoryViewButton), for: .touchUpInside)
        return button
    }()


    @objc private func tappedTransitToHistoryViewButton() {

        // button vibration
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        // 移動先のViewを定義する.
        let secondViewController = HistoryViewController(collectionViewLayout: UICollectionViewFlowLayout())

        let navigationController = UINavigationController(rootViewController:   secondViewController)

        // SecondViewに移動する.
        navigationController.modalPresentationStyle = .fullScreen

        self.present(navigationController, animated: true, completion: nil)
    }



    lazy var loginStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        label.textColor = .white

        label.text = "  Login User: \(userNameArray[testHsmIdCounter])"
        label.font = UIFont(name: "HiraKakuProN-W6", size: 12)
        return label
    }()



    lazy var logoutButton: UIButton = {

        let button = UIButton(type: UIButton.ButtonType.system) // Button Typeをsystemにすると自然にボタンを押した時に色が変わる
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Logout", for: .normal)

        button.tintColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        button.layer.opacity = 1.0
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(tappedLogoutButton), for: .touchUpInside)
        return button

    }()

    @objc private func tappedLogoutButton() {
        print("test logout button")

        logoutAlert()


    }


    func logoutAlert() {
        // Alert Actionをsetする
        let alertAction = UIAlertAction(title: "Yes", style: .default) { (action) in

            print("Pressed Logout Button")

            DispatchQueue.main.async{
                self.loginStatusLabel.removeFromSuperview()
                self.view.addSubview(self.loginButton)
                self.loginButton.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 20, bottom: 0, right: 0), size: CGSize(width: 55, height: 40))

                self.loginStatusLabel.removeFromSuperview()

                // test Add testHsmIdCounter
                self.testHsmIdCounter += 1


                // test
                print("sceneView.node: ", self.sceneView.scene)

                // reset configuration:
                self.resetSession()
            }

        }


        // AlertActionでCancelボタンを作る
        let cancelAction = UIAlertAction(title: "No", style: .destructive, handler: nil)

        // Alert ActionをUIAlertViewControllerに追加して表示させる
        alertController = UIAlertController(title: "Logout Immediately?", message: "", preferredStyle: .alert)

        // Add Alert Action on UIAlertController
        alertController.addAction(alertAction)
        alertController.addAction(cancelAction)

        // Show AlertController
        DispatchQueue.main.async{
            self.present(self.alertController, animated: true) {

            }
        }
    }

    func resetSession(){
        // sessionを停止
        self.sceneView.session.pause()
        // 全てのNodeに対して処理を行う
        self.sceneView.scene.rootNode.enumerateChildNodes {(node, _) in
            // Nodeを削除
            node.removeFromParentNode()
        }
        // sessionを再開
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }



    lazy var loginButton: UIButton = {

        let button = UIButton(type: UIButton.ButtonType.system) // Button Typeをsystemにすると自然にボタンを押した時に色が変わる
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)

        button.tintColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        button.layer.opacity = 1.0
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
        return button

    }()

    @objc private func tappedLoginButton() {
        print("test button")

        alertInsertUSB()

    }


    fileprivate func afterLoginChangeView() {
        self.isLogin = true

//        self.loginButton.backgroundColor = UIColor.green
//        self.loginButton.tintColor = .black
//        self.loginButton.setTitle("Logout", for: .normal)

        DispatchQueue.main.async{

            self.view.addSubview(self.logoutButton)
            self.logoutButton.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: nil, padding:   .init(top: 50, left: 20, bottom: 0, right: 0), size: CGSize(width: 55, height: 40))

            self.view.addSubview(self.loginStatusLabel)
            self.loginStatusLabel.anchor(top: self.loginButton.topAnchor, leading: self.loginButton.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0), size: CGSize(width: 200, height: 40))

            }

        // reset configuration:
        resetSession()
    }

    func alertInsertUSB() {
        // Alert Actionをsetする
        let alertAction = UIAlertAction(title: "Read HSM", style: .default) { (action) in

            print("Read HSM pressed")


            // test
            do {
//                sleep(4)
            }

            self.alertEnterPassword()

        }

        // AlertActionでCancelボタンを作る
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

        // Alert ActionをUIAlertViewControllerに追加して表示させる
        alertController = UIAlertController(title: "Connect HSM\n(Hardware Security Module)", message: "After connection HSM,\n press \"Read HSM\" Button", preferredStyle: .alert)

        // Add Alert Action on UIAlertController
        alertController.addAction(alertAction)
        alertController.addAction(cancelAction)

        // Show AlertController
        DispatchQueue.main.async{
            self.present(self.alertController, animated: true) {

            }
        }
    }


    func alertEnterPassword() {
        // Alert Actionをsetする
        let alertAction = UIAlertAction(title: "Enter", style: .default) { (action) in

            print("Read HSM pressed")


            // test
            do {
                sleep(2)
            }

            self.afterLoginChangeView()
        }

        // AlertActionでCancelボタンを作る
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

        // Alert ActionをUIAlertViewControllerに追加して表示させる
        alertController = UIAlertController(title: "New HSM recognized\nEnter Password", message: "", preferredStyle: .alert)




        func configurationTextField(textField: UITextField!)
        {
            print("generating the TextField")
            textField.placeholder = "Enter Password"

            tField = textField
            tField.isSecureTextEntry = true
        }

        alertController.addTextField(configurationHandler: configurationTextField)

        // Add Alert Action on UIAlertController
        alertController.addAction(alertAction)
        alertController.addAction(cancelAction)

        // Show AlertController
        DispatchQueue.main.async{
            self.present(self.alertController, animated: true) {

            }
        }

    }



    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView = {
            let arscnView = ARSCNView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))

            return arscnView
        }()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false

        view.addSubview(sceneView)

        view.addSubview(loginButton)
        loginButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 20, bottom: 0, right: 0), size: CGSize(width: 55, height: 40))


        showAlert01()
    }




    // Create a session configuration
    let configuration = ARWorldTrackingConfiguration()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR_Resources", bundle: Bundle.main) else {
            fatalError("Failed to load the reference images")
        }


        
        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages


        // Run the view's session
        sceneView.session.run(configuration)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    fileprivate func AddImage(_ node: SCNNode, isPushConfirm: Bool) {

        if isPushConfirm {
            // add Photo
            let PhotoNode = SCNNode(geometry: SCNPlane(width: 1, height: 1))

            PhotoNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "detail_explanation")
            PhotoNode.geometry?.firstMaterial?.isDoubleSided = true // 写真を両面に配置する

            PhotoNode.name = "photo_node"
            print("photo_node: ", PhotoNode)
            node.addChildNode(PhotoNode)
        }

    }



    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()

        print("find QR code")

        self.AddImage(node, isPushConfirm: self.isPushConfirmButton)

        //モデルノードの追加
        let scene = SCNScene(named: "art.scnassets/box.scn")
        let modelNode = (scene?.rootNode.childNode(withName: "object", recursively: false))!
//        modelNode.scale = SCNVector3(x: 1.5, y: 1.5, z: 1.5)

        // object3D moving
        let rotateAction = SCNAction.rotate(by: 360.degreesToRadians(),
                                            around: SCNVector3(0, 1, 0),
                                            duration: 8)
        let rotateForeverAction = SCNAction.repeatForever(rotateAction)
        modelNode.runAction(rotateForeverAction)

        node.addChildNode(modelNode)

        //Add transitToHistoryViewButton
         DispatchQueue.main.async{
            self.view.addSubview(self.transitToHistoryViewButton)
            self.transitToHistoryViewButton.anchor(top: self.view.topAnchor, leading: nil, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(top: 50, left: 0, bottom: 0, right: 20), size: CGSize(width: 55, height: 40))

            }

     
        return node
    }

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }



    fileprivate func showAlert01() {
        // Alert Actionをsetする
        let alertAction = UIAlertAction(title: "Confirm ", style: .default) { (action) in
            self.isPushConfirmButton = true
            print("self.isPushConfirmButton: ", self.isPushConfirmButton)
        }

        // AlertActionでCancelボタンを作る
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

        // Alert ActionをUIAlertViewControllerに追加して表示させる
        alertController = UIAlertController(title: "Please check your ID", message: "ManufacturerID: XYZpharma789\nTime: 20200223:01:12:33", preferredStyle: .alert)

        // Add Alert Action on UIAlertController
        alertController.addAction(alertAction)
        alertController.addAction(cancelAction)

        // Show AlertController
        DispatchQueue.main.async{
            self.present(self.alertController, animated: true) {

            }
        }
    }
}
