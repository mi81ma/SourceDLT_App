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
}
