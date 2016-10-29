//
//  Capturado.swift
//  BountyHunter
//
//  Created by Infraestructura on 28/10/16.
//  Copyright © 2016 Infraestructura. All rights reserved.
//

import UIKit
import CoreLocation
import Social

class Capturado: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblDelito: UILabel!
    @IBOutlet weak var lblLatitud: UILabel!
    @IBOutlet weak var lblLongitud: UILabel!
    
    @IBOutlet weak var imvFoto: UIImageView!
    @IBOutlet weak var lblRecompensa: UILabel!
    
    @IBOutlet weak var otlFoto: UIButton!
    
    var fugitiveInfo: Fugitive?
    var localizador: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.localizador = CLLocationManager()
        self.localizador?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.localizador?.delegate = self
        self.localizador?.startUpdatingLocation()
    }

    override func viewWillAppear(animated: Bool) {
        lblNombre.text = fugitiveInfo?.name
        lblDelito.text = fugitiveInfo?.desc
        //lblRecompensa.text = String(fugitiveInfo?.bounty)
        lblRecompensa.text = ("$ \(fugitiveInfo?.bounty)")
        lblRecompensa.textAlignment = .Right
        lblLatitud.text = ""
        lblLongitud.text = ""
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnFoto(sender: AnyObject) {
        creaFotoGalleryPicker()
        
    }
    
    
    @IBAction func btnGuardarTouch(sender: AnyObject) {
        //Define la calidad de la imagen: 1.0 especifica que se guarde al 100 de calidad
        let imageData = NSData(data: UIImageJPEGRepresentation(imvFoto!.image!, 1.0)!)
        
        fugitiveInfo?.image = imageData
        fugitiveInfo?.captdate = NSDate().timeIntervalSinceReferenceDate
        fugitiveInfo?.captured = true
        do{
            try DBManager.instance.managedObjectContext?.save()
            //Enviar un correo con la información del capturado
            let googleMapaURL = "https://www.google.com.mx/maps/@\(self.fugitiveInfo!.capturedLat),\(fugitiveInfo!.capturedLon)"
            let texto = "Ya capturé a \(self.fugitiveInfo?.name!) en \(googleMapaURL)"
            // Si quieren mandar la foto:
            let laFoto = UIImage(data: self.fugitiveInfo!.image!)
            //Si quieren mandar una imagen genérica:
            let image = UIImage(named: "fugitivo")
            
            let hayFace = SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)
            let hayTuit = SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
            //Si existen las dos apps, consultar cual se usa
            
            if hayFace && hayTuit{
                let ac = UIAlertController(title: "Compartir", message: "Compartir la captura a...", preferredStyle: .Alert)
                let btnFeiz = UIAlertAction(title: "Facebook", style: .Default, handler: {(UIAlertAction) in
                    let feizbuc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    feizbuc.setInitialText(texto)
                    feizbuc.addImage(laFoto!)
                    self.presentViewController(feizbuc, animated: true, completion: {self.navigationController?.popViewControllerAnimated(true)
                    })
                })
                
                let btnTuit = UIAlertAction(title: "Twiter", style: .Default, handler: {(UIAlertAction) in
                    let tuiter = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    tuiter.setInitialText(texto)
                    tuiter.addImage(laFoto!)
                    self.presentViewController(tuiter, animated: true, completion: {self.navigationController!.popViewControllerAnimated(true)
                    })
                })
                let noquiero  = UIAlertAction(title: "No Gracias", style: .Destructive, handler: nil)
                
                ac.addAction(btnFeiz)
                ac.addAction(btnTuit)
                ac.addAction(noquiero)
                presentViewController(ac, animated: true, completion: nil)
                
                
                
            }
            else{
            
            
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
                    let feizbuc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    feizbuc.setInitialText(texto)
                    feizbuc.addImage(laFoto!)
                    presentViewController(feizbuc, animated: true, completion: {self.navigationController?.popViewControllerAnimated(true)})
                }
                else if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
                    let tuiter = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    tuiter.setInitialText(texto)
                    tuiter.addImage(laFoto!)
                    presentViewController(tuiter, animated: true, completion: {self.navigationController!.popViewControllerAnimated(true)})
                }
                else{
                    //WHATSAPP: no se pueden compartir dps elementos al mismo tiempo
                    //let items: Array<AnyObject> = [laFoto!]
                    //compartir en otras apps:
                    let items: Array<AnyObject> = [image!,texto, laFoto!]
                    let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    //esto es solo necesario para el caso del correo
                    avc.setValue("Fugitivo Capturado!", forKey: "Subject")
                    presentViewController(avc, animated: true, completion: nil)
                    
                    navigationController?.popViewControllerAnimated(true)
                }
            }
        }
        catch{
            print("Error al salvar la BD")
        }
    }
    
    func creaFotoGalleryPicker () {
        let imagePickerController: UIImagePickerController=UIImagePickerController()
        imagePickerController.modalPresentationStyle = .FullScreen
        
        // Si se quieren usar fotos guardadas en la galeria:
        //imagePickerController.sourceType = .PhotoLibrary
        
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.presentViewController(imagePickerController, animated:true, completion:nil)
        //imvFoto.image = UIImage(named: imagePickerController)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //Esta es la imagen original, tal como la tomó el usuario
        //let image:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //Esta es la imagen que el usuario recortó:
        //solo esta disponible aie el objeto imagePicker se configura con la opcion allowsEditing = true
        let image:UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        imvFoto.image = image
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.localizador?.stopUpdatingLocation()
        //f #available(iOS 8.0, *) {
            let ac = UIAlertController(title: "Error", message: "no se pueden obtener lecturas de GPS",     preferredStyle: .Alert)
            let ab = UIAlertAction(title: "so sad...", style: .Default, handler: nil)
            ac.addAction(ab)
            
            self.presentViewController(ac, animated: true, completion: nil)
        //}
        //else{
          //  UIAlertView(title: "Error", message: "No se pueden obtener lecturas del GPS.", delegate: nil, cancelButtonTitle: "Aceptar").show()
        //}
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let ubicacion = locations.last
        lblLatitud.text = "\(ubicacion?.coordinate.latitude)"
        lblLongitud.text = "\(ubicacion?.coordinate.longitude)"
        
    }
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
