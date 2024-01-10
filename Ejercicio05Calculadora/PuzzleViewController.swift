//
//  PuzzleViewController.swift
//  Ejercicio05Calculadora
//
//  Created by dam2 on 22/11/23.
//

import UIKit

class PuzzleViewController: UIViewController {
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var seven: UIButton!
    @IBOutlet weak var eight: UIButton!
    @IBOutlet weak var four: UIButton!
    @IBOutlet weak var five: UIButton!
    @IBOutlet weak var six: UIButton!
    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var middleStackView: UIStackView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var congratsMssg: UIView!
    
    var matrix = [[UIButton]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var buttonArr: [UIButton] = [
            whiteButton,
            one,
            two,
            three,
            four,
            five,
            six,
            seven,
            eight
        ]
        
        clearStackView(stackView: &topStackView)
        clearStackView(stackView: &middleStackView)
        clearStackView(stackView: &bottomStackView)
    
        while buttonArr.count > 0 {
            randomOrderOnStack(btnArr: &buttonArr, stackView: &topStackView)
            randomOrderOnStack(btnArr: &buttonArr, stackView: &middleStackView)
            randomOrderOnStack(btnArr: &buttonArr, stackView: &bottomStackView)
        }
        
        buildBtnPositionsArr(stacksArr: [topStackView, middleStackView, bottomStackView])
        
        checkCorrectOrder(stacksArr: [topStackView, middleStackView, bottomStackView])
    }
    
    
    /* ---------- BTNS ACTIONS ---------- */
    /**
     Metodo ejecutado al pulsar alguno de los botones.
     - Comprueba si ese boton se puede mover.
     - Redibuja los stacks.
     - Revisa si el nuevo dibujo es la composicion ganadora.
     */
    @IBAction func btnPress(_ sender: UIButton) {
        checkMovement(btn: sender)
        redrawStacks()
        checkCorrectOrder(stacksArr: [topStackView, middleStackView, bottomStackView])
    }
    
    
    /* --------- ADDITIONAL METHODS ---------- */
    /**
     Metodo que elimina todos los botones del stack que recibe por referencia
     */
    func clearStackView(stackView: inout UIStackView) {
        for _ in 0..<3 {
            let viewToRemove = stackView.arrangedSubviews[0]
            stackView.removeArrangedSubview(viewToRemove)
        }
    }
    
    /**
     Añade, aleatoriamente, los botones alojados en el "btnArr" al stack que recibe por referencia.
     */
    func randomOrderOnStack(btnArr: inout [UIButton], stackView: inout UIStackView) {
        
        for _ in 0..<3 {
            let idx = Int.random(in: 0..<btnArr.count)
            stackView.addArrangedSubview(btnArr[idx] as UIView)
            btnArr.remove(at: idx)
        }
        
    }
    
    /**
     Revisa si el orden de los botones en los stacks se corresponde con la composicion ganadora.
     Si es asi, muestra un View con un mensaje de "Enhorabuena"
     */
    func checkCorrectOrder(stacksArr: [UIStackView]) {
        let orderdedBtns = [
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            nil
        ]
        
        var ordered = true
        var idx = 0
        for stack in stacksArr {
            for view in stack.arrangedSubviews {
                let btn = view as! UIButton
                if (btn.titleLabel?.text != orderdedBtns[idx]) {
                    ordered = false
                }
                idx += 1
            }
        }
        if ordered {
            congratsMssg.isHidden = false
        }
    }
    
    /**
     Construye la matriz de botones en base al array de stacks recibidos por parametros
     */
    func buildBtnPositionsArr(stacksArr: [UIStackView]) {
        matrix.removeAll()
        var idx = 0
        
        for stack in stacksArr {
            matrix.append([UIButton]())
            for view in stack.arrangedSubviews {
                matrix[idx].append(view as! UIButton)
            }
            idx += 1
        }
    }
    
    /**
     Dibuja en el stak recibido por referencia la fila correspondiente de la matriz de botones
     */
    func addButtonsToStack(stack: inout UIStackView, matrix: [[UIButton]], row: Int) {
        clearStackView(stackView: &stack)
        
        for btn in matrix[row] {
            stack.addArrangedSubview(btn as UIView)
        }
    }
    
    /**
     Funcion que revisa si el movimiento del boton recibido por parametro es viable.
     Comprueba si el boton blanco es colindante al boton recibido por referencia.
     */
    func checkMovement(btn: UIButton) {
        var xPos = 0
        var yPos = 0
        
        for row in 0..<matrix.count {
            for col in 0..<matrix[row].count {
                if matrix[row][col] == btn {
                    xPos = row
                    yPos = col
                }
            }
        }
        
        switch xPos {
            case 0:
                if matrix[xPos + 1][yPos] == whiteButton {
                    swapRowPositions(row: xPos, col: yPos, newPlace: 1)
                }
            case 1:
                if matrix[xPos - 1][yPos] == whiteButton{
                    swapRowPositions(row: xPos, col: yPos, newPlace: -1)
                } else if matrix[xPos + 1][yPos] == whiteButton {
                    swapRowPositions(row: xPos, col: yPos, newPlace: 1)
                }
            default:
                if matrix[xPos - 1][yPos] == whiteButton {
                    swapRowPositions(row: xPos, col: yPos, newPlace: -1)
                }
        }
        
        switch yPos {
            case 0:
                if matrix[xPos][yPos + 1] == whiteButton {
                    swapColPositions(row: xPos, col: yPos, newPlace: 1)
                }
            case 1:
                if matrix[xPos][yPos - 1] == whiteButton{
                    swapColPositions(row: xPos, col: yPos, newPlace: -1)
                } else if matrix[xPos][yPos + 1] == whiteButton {
                    swapColPositions(row: xPos, col: yPos, newPlace: 1)
                }
            default:
                if matrix[xPos][yPos - 1] == whiteButton {
                    swapColPositions(row: xPos, col: yPos, newPlace: -1)
                }
        }
    }
    
    /**
     Cambia el boton seleccionado por el boton en blanco, de forma vertical (entre filas de la matriz)
     */
    func swapRowPositions(row: Int, col: Int, newPlace: Int) {
        let elementToBeRemoved = matrix[row][col]
        matrix[row][col] = matrix[row + newPlace][col]
        matrix[row + newPlace][col] = elementToBeRemoved
    }
    
    /**
     Cambia el boton seleccionado por el boton en blanco, de forma horizontal (entre columnas de la matriz)
     */
    func swapColPositions(row: Int, col: Int, newPlace: Int) {
        let elementToBeRemoved = matrix[row][col]
        matrix[row][col] = matrix[row][col + newPlace]
        matrix[row][col + newPlace] = elementToBeRemoved
    }
    
    /**
     Redibuja los stacks en base a la matriz de botones.
     */
    func redrawStacks() {
        clearStackView(stackView: &topStackView)
        clearStackView(stackView: &middleStackView)
        clearStackView(stackView: &bottomStackView)
        
        for btn in matrix[0] {
            topStackView.addArrangedSubview(btn as UIView)
        }
        for btn in matrix[1] {
            middleStackView.addArrangedSubview(btn as UIView)
        }
        for btn in matrix[2] {
            bottomStackView.addArrangedSubview(btn as UIView)
        }
    }

}
