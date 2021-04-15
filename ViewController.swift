//
//  ViewController.swift
//  House Prediction
//
//  Created by Andrew on 14/04/2021.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var bedroomsTF: UITextField!
    @IBOutlet weak var bathroomTF: UITextField!
    @IBOutlet weak var sqftTF: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    
    let bedroomPicker = UIPickerView()
    let bathroomPicker = UIPickerView()
    
    let bedrooms = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    let bathrooms = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        bedroomPicker.delegate = self
        bedroomsTF.inputView = self.bedroomPicker
        bedroomsTF.isEnabled = true
        
        bathroomPicker.delegate = self
        bathroomTF.isEnabled = true
        bathroomTF.inputView = self.bathroomPicker
        
        sqftTF.isEnabled = true
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:))))
        
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
        
    }
    
    @IBAction func predictTapped(_ sender: UIButton){
        if let bedroom = Double(bedroomsTF.text ?? "0"),
           let bathroom = Double(bathroomTF.text ?? "0"),
           let sqft = Double(sqftTF.text ?? "0"){
            if let price = predictHousePrice(bedroom: bedroom, bathroom: bathroom, sqft_living: sqft){
                priceLabel.text = "\(price.rounded()) $"
            }else{
                priceLabel.text = "0.0 $"
            }
        }
    }
    
    
    func predictHousePrice(bedroom: Double, bathroom: Double, sqft_living: Double) -> Double?{
        let model = HousePredictor()
        if let prediction = try? model.prediction(bedrooms: bedroom, bathrooms: bathroom, sqft_living: sqft_living){
            return prediction.price
        }
        return nil
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case bedroomPicker:
            return bedrooms.count
        case bathroomPicker:
            return bathrooms.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case bedroomPicker:
            return "\(bedrooms[row])"
        case bathroomPicker:
            return "\(bathrooms[row])"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case bedroomPicker:
            bedroomsTF.text = "\(bedrooms[row])"
        case bathroomPicker:
            bathroomTF.text = "\(bathrooms[row])"
        default:
            break
        }
    }
}

