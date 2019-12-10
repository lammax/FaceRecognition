//
//  ViewController.swift
//  FaceRecognition
//
//  Created by Mac on 10.12.2019.
//  Copyright © 2019 Lammax. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var alertLabel: UILabel!
    
    private let planeWidth: CGFloat = 0.13
    private let planeHeight: CGFloat = 0.06
    private let nodeYPosition: Float = 0.022
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            alertLabel.text = "Face tracking is not supported on this device"

            return
        }
        
        alertLabel.text = ""

        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    
*/
    
    
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else {
            alertLabel.text = "Device - error"
            return nil
        }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let faceNode = SCNNode(geometry: faceGeometry)
        faceNode.geometry?.firstMaterial?.fillMode = .lines
     
        //MARK: add glasses
        let glassesPlane = SCNPlane(width: planeWidth, height: planeHeight)
        glassesPlane.firstMaterial?.isDoubleSided = true
        glassesPlane.firstMaterial?.diffuse.contents = UIImage(named: "glasses0")

        
        let glassesNode = SCNNode()
        glassesNode.geometry = glassesPlane
        glassesNode.position.z = faceNode.boundingBox.max.z * 3 / 4
        glassesNode.position.y = nodeYPosition

        faceNode.addChildNode(glassesNode)
        faceNode.geometry?.firstMaterial?.transparency = 0
        
        
        
        return faceNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            alertLabel.text = "FaceAnchor - error"
            return
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
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
