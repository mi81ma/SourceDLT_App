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

    var sceneView: ARSCNView!
    var isPushConfirmButton = false
    var alertController: UIAlertController!


    lazy var loginButton: UIButton = {

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)

        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.3018001914, blue: 0.8385717273, alpha: 1)
        button.layer.opacity = 1.0
        button.layer.cornerRadius = 5.0
//        button.addTarget(self, action: #selector(modalViewTouched(_:)), for: .touchUpInside)
        return button

    }()



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
        loginButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 30, bottom: 0, right: 0), size: CGSize(width: 80, height: 30))


        showAlert01()
    }





    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR_Resources", bundle: Bundle.main) else {
            fatalError("Failed to load the reference images")
        }


        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
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

            PhotoNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "object_image_cat")
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

        // --------- 以上、写真のNode ---------------

        //モデルノードの追加
        let scene = SCNScene(named: "art.scnassets/box.scn")
        let modelNode = (scene?.rootNode.childNode(withName: "object", recursively: false))!
//        modelNode.scale = SCNVector3(x: 1.5, y: 1.5, z: 1.5)
        node.addChildNode(modelNode)
     
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
