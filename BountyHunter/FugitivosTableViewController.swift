//
//  FugitivosTableViewController.swift
//  BountyHunter
//
//  Created by Infraestructura on 08/10/16.
//  Copyright © 2016 Infraestructura. All rights reserved.
//

import UIKit

class FugitivosTableViewController: UITableViewController {
    // Esta propiedad determina si los registros se van a presentar si estan capturados
    var estaCapturado = 0
    var losFugados:NSArray?
    @IBAction func btnNuevoTouch(sender: AnyObject) {
        self.performSegueWithIdentifier("nuevo", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Es necesario inicializar el array, porque no puede ser nil
        self.losFugados = NSArray()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.cargarTabla()
    }
    func cargarTabla() {
        self.losFugados = DBManager.instance.encuentraTodosLos("Fugitive", filtradosPor:
            NSPredicate(format: "captured=%d", self.estaCapturado))
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.losFugados!.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseID", forIndexPath: indexPath)
        let elFugitivo = self.losFugados![indexPath.row] as! Fugitive
        cell.textLabel!.text = elFugitivo.name
        return cell
    }
    
   
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }



    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let elFugitivo = self.losFugados![indexPath.row] as! Fugitive
            // Eliminar el objeto del arreglo
            do {
                //try self.losFugados![indexPath.row].remove()
                //Eliminar el objeto de la BD
                DBManager.instance.managedObjectContext!.deleteObject(elFugitivo)
                try DBManager.instance.managedObjectContext!.save()
                // Delete the row from the data source
                //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.cargarTabla()
            } catch {
                print ("No se pudo eliminar el objeto del arreglo")
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destino = segue.destinationViewController as! Capturado
        
        let elIndexPath = self.tableView.indexPathForSelectedRow
        
        let elFugitivo = self.losFugados![elIndexPath!.row] as! Fugitive
        destino.fugitiveInfo = elFugitivo
    }
    
    
        
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
