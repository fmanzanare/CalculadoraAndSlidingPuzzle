//
//  CalculadoraViewController.swift
//  Ejercicio05Calculadora
//
//  Created by dam2 on 22/11/23.
//

import UIKit

class CalculadoraViewController: UIViewController {
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var addToMemory: UIButton!
    @IBOutlet weak var subsToMemory: UIButton!
    @IBOutlet weak var recoverMemory: UIButton!
    @IBOutlet weak var resetMemory: UIButton!
    @IBOutlet weak var resetScreen: UIButton!
    @IBOutlet weak var changeSign: UIButton!
    @IBOutlet weak var percentage: UIButton!
    @IBOutlet weak var divide: UIButton!
    @IBOutlet weak var seven: UIButton!
    @IBOutlet weak var eight: UIButton!
    @IBOutlet weak var nine: UIButton!
    @IBOutlet weak var multiply: UIButton!
    @IBOutlet weak var four: UIButton!
    @IBOutlet weak var five: UIButton!
    @IBOutlet weak var six: UIButton!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var zero: UIButton!
    @IBOutlet weak var point: UIButton!
    @IBOutlet weak var equal: UIButton!
    
    /*
     Funcionalidad de la memoria de la calculadora:
     - M+ = Suma a lo almacenado en memoria (por defecto habra un 0)
     - M- = Resta a lo almacenado en memoria
     - MR = Recupera de la memoria
     - MC = Borra la memoria (la resetea a 0)
     */
    
    var memory: Double = 0.0
    var finalRes: Double = 0.0 // Resultado final que se va acumulando
    var tmpRes: Double = 0.0 // Resultado temporal para las operaciones de "X" y "/"
    var pointOnScreen: Bool = false // Indicar si ya hay una coma en la pantalla
    var afterOperation: Bool = true // Indica si se ha pulsado un boton de operacion
    var lastOperation: String = "" // Guarda el simbolo de la ultima operacion ("+" o "-")
    var lastMiddleOperation: String = "" // Guarda el simbolo de la ultima operacion ("x" o "/")
    var firstOperation: Bool = true // Indica si es la primera operacion que se computa
    var middleOperation: Bool = false // Indica si hay una operacion intermedia ("x" o "/")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
     Setea todas las variables a su valor por defecto cada vez que la vista aparece en pantalla
     */
    override func viewWillAppear(_ animated: Bool) {
        result.text = "0"
        memory = 0.0
        finalRes = 0.0
        tmpRes = 0.0
        pointOnScreen = false
        afterOperation = true
        firstOperation = true
        middleOperation = false
        lastOperation = ""
        lastMiddleOperation = ""
    }
    
    /**
     Action aplicabe a todos los numeros y a la coma
     Contiene la logica para dibujar en la pantalla estos elementos, teniendo en cuenta cuando se ha pulsado una operacion
     */
    @IBAction func numPress(_ sender: UIButton) {
        if result.text != "0" && !afterOperation {
            if sender.titleLabel!.text! == "." && pointOnScreen {
                return
            } else if sender.titleLabel!.text! == "." {
                pointOnScreen = true
            }
            result.text! += sender.titleLabel!.text!
        } else if sender.titleLabel!.text! != "." && sender.titleLabel!.text! != "0" && afterOperation {
            result.text = sender.titleLabel!.text
            afterOperation = false
        } else if sender.titleLabel!.text! == "." && !pointOnScreen {
            result.text! += sender.titleLabel!.text!
            pointOnScreen = true
            afterOperation = false
        }
    }
    
    /**
     Resetea todas las variables a su valor por defecto, salvo la memoria, que tiene su boton propio para ello
     */
    @IBAction func resetScreenPress(_ sender: UIButton) {
        result.text = "0"
        finalRes = 0.0
        tmpRes = 0.0
        pointOnScreen = false
        afterOperation = true
        firstOperation = true
        middleOperation = false
        lastOperation = ""
        lastMiddleOperation = ""
    }
    
    /**
     Action aplicable a todos los botones de operacion ("+", "-", "x", "/")
     */
    @IBAction func operationPress(_ sender: UIButton) {
        if firstOperation && sender.titleLabel!.text! != "x" && sender.titleLabel!.text! != "÷" {
            finalRes += (result.text! as NSString).doubleValue
            lastOperation = sender.titleLabel!.text!
        } else {
            operate(sign: sender.titleLabel!.text!)
        }
        if middleOperation {
            result.text = String(tmpRes)
        } else {
            result.text = String(finalRes)
        }
        afterOperation = true
        firstOperation = false
    }
    
    /**
     Action aplicable al boton de igual "="
     */
    @IBAction func equalPress(_ sender: UIButton) {
        if lastOperation != "" || middleOperation {
            if middleOperation {
                operate(sign: lastMiddleOperation)
            } else {
                operate(sign: lastOperation)
            }
            result.text = String(finalRes)
            firstOperation = true
            middleOperation = false
            lastOperation = ""
            lastMiddleOperation = ""
            finalRes = 0.0
            tmpRes = 0.0
        }
    }
    
    /**
     Contiene la logica de la operacion, teniendo en cuenta las reglas matematicas para ello (orden de factores)
     */
    func operate(sign: String) {
        if !afterOperation {
            switch sign {
                case "+":
                    finalRes += (result.text! as NSString).doubleValue
                    lastOperation = "+"
                    middleOperation = false
                    lastMiddleOperation = ""
                case "-":
                    finalRes -= (result.text! as NSString).doubleValue
                    lastOperation = "-"
                    middleOperation = false
                    lastMiddleOperation = ""
                case "x":
                    operateMultDiv(sign: sign)
                    lastMiddleOperation = "x"
                case "÷":
                    operateMultDiv(sign: sign)
                    lastMiddleOperation = "÷"
                default:
                    return
            }
        }
    }
    
    /**
     Contiene la logica concreta para los casos de multiplicacion y division, para poder seguir las reglas matematicas.
     */
    func operateMultDiv(sign: String) {
        if (!middleOperation) {
            tmpRes += (result.text! as NSString).doubleValue
            middleOperation = true
            return
        }
        switch lastMiddleOperation {
            case "x":
                tmpRes *= (result.text! as NSString).doubleValue
            case "÷":
                tmpRes /= (result.text! as NSString).doubleValue
            default:
                return
        }
        if (lastOperation == "+" || lastOperation == "") {
            finalRes += tmpRes
        } else if (lastOperation == "-") {
            finalRes -= tmpRes
        }
    }
    
    /**
     Action del boton de porcentaje "%"
     */
    @IBAction func percentageActio(_ sender: Any) {
        result.text = String((result.text! as NSString).doubleValue / 100.0)
    }
    
    /**
     Action del boton de cambio de signo "+/-"
     */
    @IBAction func changeSignAction(_ sender: Any) {
        result.text = String((result.text! as NSString).doubleValue * -1)
    }
    
   /**
    Action del boton para añadir a la memoria
    Toma el valor de la pantalla y lo guarda en la variable correspondiente
    */
    @IBAction func addToMemoryAction(_ sender: UIButton) {
        if (sender.titleLabel!.text! == "M+") {
            memory += (result.text! as NSString).doubleValue
        } else {
            memory -= (result.text! as NSString).doubleValue
        }
    }
    
    /**
     Action para el boton "MC"
     Resetea la memoria y la deja a 0.0
     */
    @IBAction func clearMemoryAction(_ sender: Any) {
        memory = 0.0
    }
    
    /**
     Action para el boton "MR"
     Recupera el valor de la memoria y lo pone en pantalla
     */
    @IBAction func recoverMemoryAction(_ sender: Any) {
        result.text = String(memory)
    }
    
}
