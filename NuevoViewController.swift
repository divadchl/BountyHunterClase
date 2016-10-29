//
//  NuevoViewController.swift
//  BountyHunter
//
//  Created by Infraestructura on 08/10/16.
//  Copyright © 2016 Infraestructura. All rights reserved.
//

import UIKit
import CoreData

class NuevoViewController: UIViewController {

    @IBOutlet weak var txtNom: CustomTextField!
    @IBOutlet weak var txtDelito: CustomTextField!
    @IBOutlet weak var txtRecompensa: CustomTextField!
    @IBAction func btnGuardarTouch(sender: AnyObject) {
        // 1. Validar si los cuadros de texto estan llenos
        var elMsg = ""
        if self.txtNom.text == "" {
            elMsg = "Falta el nombre"
        } else if self.txtDelito.text == "" {
            elMsg = "Falta el delito"
        } else if self.txtRecompensa.text == "" {
            elMsg = "Falta la recompensa"
        }
        // 2. Si falta algun texto, presentar mensaje de error
        if elMsg != "" {
            let ac = UIAlertController(title: "", message: elMsg, preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            ac.addAction(action)
            self.presentViewController(ac, animated: true, completion: nil)
        } else {
        // 3. Si todo esta correcto, crear una instancia de Fugitive, asignar los datos, y salvar el contexto
            let entityInfo = NSEntityDescription.entityForName("Fugitive", inManagedObjectContext:DBManager.instance.managedObjectContext!)
            let nuevoFugitivo = NSManagedObject.init(entity: entityInfo!, insertIntoManagedObjectContext: DBManager.instance.managedObjectContext!) as! Fugitive
            nuevoFugitivo.name = self.txtNom.text
            nuevoFugitivo.desc = self.txtDelito.text
            nuevoFugitivo.bounty = NSDecimalNumber(string: self.txtRecompensa.text)
            nuevoFugitivo.captured = false
            do {
               try DBManager.instance.managedObjectContext!.save()
               self.navigationController?.popViewControllerAnimated(true)
            } catch {
                print ("Error al salvar la BD... what's up?")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
