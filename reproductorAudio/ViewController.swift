//
//  ViewController.swift
//  reproductorAudio
//
//  Created by Jose Navarro Alabarta on 19/1/16.
//  Copyright © 2016 ai2-upv. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var musicaPicker: UIPickerView!
    @IBOutlet weak var visualizadorPortada: UIImageView!
    private var reproductor: AVAudioPlayer!

    
    @IBOutlet weak var tituloCancionRepro: UILabel!
    // sirve para almacenar los nombres y la extension de los audios
    var canciones : Array<Array<String>> = Array<Array<String>>()
    // sirve para almacenar los nombres y la extension de las imagenes
    var portadas : [[String]] = [[String]]()
    //var canciones : [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        listarPortadass ()
        listarAudios()
        configurarPicker()
        //audio()
    }
    
    
    
    
    @IBAction func subirAudio(sender: AnyObject) {
        reproductor.volume++
    }
    
    
    @IBAction func bajarAudio(sender: AnyObject) {
        reproductor.volume--
    }
    private func listarAudios () {
        let fm = NSFileManager.defaultManager()
        let path = NSBundle.mainBundle().resourcePath!
        
        let items = try! fm.contentsOfDirectoryAtPath(path+"/sound")
        
        let needle: Character = "."
        
        for item in items {
            if let idx = item.characters.indexOf(needle) {
                let pos = item.startIndex.distanceTo(idx)
                
                let range1 = item.startIndex.advancedBy(0)...item.startIndex.advancedBy(pos-1)
                let substring: String = item[range1]
                let range2 = item.startIndex.advancedBy(pos+1)...item.startIndex.advancedBy(item.characters.count-1)
                let substring2: String = item[range2]
                
                canciones.append(["\(substring)","\(substring2)"])
            }
            else {
                print("Not found")
            }
        }
    }
    
    private func listarPortadass () {
        let fm = NSFileManager.defaultManager()
        //print("\(fm)")
        let path = NSBundle.mainBundle().resourcePath!
        //print("\(path)")
        
        let items = try! fm.contentsOfDirectoryAtPath(path+"/cover")
        //print("\(items)")
        
        let needle: Character = "."
        
        for item in items {
            //print("\(item)")
            if let idx = item.characters.indexOf(needle) {
                let pos = item.startIndex.distanceTo(idx)
                //print("Found \(needle) at position \(pos), \(idx)")
                
                let range1 = item.startIndex.advancedBy(0)...item.startIndex.advancedBy(pos-1)
                let substring: String = item[range1]
                let range2 = item.startIndex.advancedBy(pos+1)...item.startIndex.advancedBy(item.characters.count-1)
                let substring2: String = item[range2]
                
                //print("\(substring) \t \(substring2)")
                portadas.append(["\(substring)","\(substring2)"])
            }
            else {
                //print("Not found")
            }
        }
    }
    
    private func configurarPicker(){
        self.musicaPicker.showsSelectionIndicator = true
        self.musicaPicker.delegate = self
        self.musicaPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.canciones.count
    }
    
    
    //como llenar el picker
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.canciones[row][0]
    }
    
    
    //Para mostrar la imagen por el ImageView
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let sonidoURL = NSBundle.mainBundle().URLForResource("sound/"+canciones[row][0], withExtension: canciones[row][1])
        // conexion paso 5
        do {
            try reproductor = AVAudioPlayer(contentsOfURL: sonidoURL!)
            
        }catch {
            print("No existe el fichero")
        }
        if !reproductor.playing{
            
            let pp:String = obtenerPortadaAudio(canciones[row][0])
            print(pp)
//            do {
//                let urlImagen = UIImage(named: pp)
//                let dataImage:NSData = NSData(contentsOfURL:urlImagen)!
                visualizadorPortada.image = UIImage(named: pp)

            tituloCancionRepro.text = canciones[row][0]
            reproductor.play()
        }
    }// fin
    
    
    func obtenerPortadaAudio( nPortada: String) -> String {
        
        let rutaimagen: String = "cover/"
        
        for portada in portadas {
            
            if (portada[0] == nPortada){
               return rutaimagen + "\(portada[0]).\(portada[1])"
            }
        }
        
        return "No existe"
    }
    
    @IBAction func reproducir(sender: AnyObject) {
        if !reproductor.playing{
            reproductor.play()
        }
    }
    
    
    @IBAction func pausar(sender: AnyObject) {
        if reproductor.playing{
            reproductor.pause()
            reproductor.currentTime = 0.0
        }
    }
    
    
    @IBAction func parar(sender: AnyObject) {
        if reproductor.playing{
            reproductor.stop()
            
        }

    }


}

