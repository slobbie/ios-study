//
//  ViewController.swift
//  CurrencyConverterApp
//
//  Created by 정해석 on 2023/07/31.
//

import UIKit

class PickerViewController: UIViewController {
    
    var rates3: [(String, Double)]?
    
    // 선택한 픽커 로우
    var selectedRow = 0 {
        didSet {
            selectedLabel.text = rates3?[selectedRow].0
            
            selectedTextField.text = calculateCurrency()
        }
    }
    
    // 환율 계산 함수
    func calculateCurrency() -> String {
       let selectedValue = rates3?[selectedRow].1 ?? 0
        let usedValue = Double(usdTextField.text ?? "") ?? 00
        // 소수점 2자리 까지만 보여주는 포멧
        let resultValue = String(format: "%.2f", (selectedValue * usedValue))
        return resultValue
    }
    
    @IBOutlet weak var usdTextField: UITextField!
    @IBOutlet weak var selectedTextField: UITextField!
    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Currency Converter Picker"
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        usdTextField.delegate = self
        
        fetchJson()

    }
    
    func fetchJson() {
        let urlString = "https://open.er-api.com/v6/latest/USD"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        // data tesk
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let currencyModel = try JSONDecoder().decode(CurrencyModel.self, from: data)
                // 순서가 보장 안된 딕셔너리를 배열로 만들어 주는 방법 1
                
                /**
                 let rates1 = currencyModel.rates?.map { [$0 : $1] }
                 */
        
                // 순서가 보장 안된 딕셔너리를 배열로 만들어 주는 방법 2
                /**
                 let rates2: [(String, Double)]? = currencyModel.rates?.sorted(by: { dic1, dic2 in
                     dic1.key < dic2.key
                 })
                 */
            
                // 순서가 보장 안된 딕셔너리를 배열로 만들어 주는 방법 2
                self.rates3 = currencyModel.rates?.sorted { $0.key < $1.key}
                
                // 피커를 새로 고침해야 내용이 표시됨
                DispatchQueue.main.async {
                    self.currencyPicker.reloadAllComponents()
                }
               
//                print("currencyModel", currencyModel)
                
            } catch {
                print("error", error)
            }
            
        }.resume()
        
    }

}

extension PickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // 픽커뷰에서 나오는 글자의 항목 수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // numberOfRowsInComponent 리스트의 갯수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // 배열의 길이가 없다면 0을 반환
        return rates3?.count ?? 0
    }
    
    // 리스트에 어떠한 항목이 표시 될지
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 키값이 없다면 빈스트링 반환
        let key = rates3?[row].0 ?? ""
        // Int 를 스트링으로 형변환
        let value = rates3?[row].1.description ?? ""
        
        return key + "  " + value
    }
    
    // 데이터 픽커에서 선택한 로우
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
    
}

extension PickerViewController: UITextFieldDelegate {
    // 텍스트필드 온체인지 이벤트
    func textFieldDidChangeSelection(_ textField: UITextField) {
        selectedTextField.text = calculateCurrency()
    }
}
