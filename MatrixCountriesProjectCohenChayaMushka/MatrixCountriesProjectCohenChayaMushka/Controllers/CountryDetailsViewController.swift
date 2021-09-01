//
//  CountryDetailsViewController.swift
//  MatrixCountriesProjectCohenChayaMushka
//
//  Created by hyperactive on 07/06/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import UIKit

class CountryDetailsViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var nativeName: UILabel!
    @IBOutlet weak var tableView: UITableView!

    
    @IBOutlet weak var returnButton: UIButton!
    
    var countryIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewDidAppear(_ animated: Bool) {
        setViewLabels()
//        setNeighboringCountriesLabelText()
        setReurnButton()
        
        
    }
    
    func setViewLabels() {
        setNameLabel()
        setNativeNameLabel()
        //setNeighboringCountriesLabel()
    }
    
    func setNameLabel() {
        name.frame = CGRect(x: 10, y: 50, width: view.bounds.width - 20, height: view.bounds.height / 6)
        name.adjustsFontSizeToFitWidth = true
        name.textAlignment = .center
        //print(countries.count)
        name.text = "country name: \(countries[countryIndex].name)"
        
    }
    
    func setNativeNameLabel() {
        nativeName.frame = CGRect(x: 10, y: 50 + name.bounds.height + 10, width: view.bounds.width - 20, height: view.bounds.height / 6)
        nativeName.adjustsFontSizeToFitWidth = true
        nativeName.textAlignment = .center
        nativeName.text = "country native name: \(countries[countryIndex].nativeName)"
    }
    
//    func setNeighboringCountriesLabel() {
//        neighboringCountries.frame = CGRect(x: 10, y: 50 + name.bounds.height + nativeName.bounds.height + 20, width: view.bounds.width - 20, height: (view.bounds.height / 6) * 2)
//        neighboringCountries.adjustsFontSizeToFitWidth = true
//        neighboringCountries.textAlignment = .center
//
//    }
    
    func setReurnButton() {
        returnButton.backgroundColor = .blue
        returnButton.addTarget(self, action: #selector(returnToCountriesTable), for: .touchUpInside)
        returnButton.frame = CGRect(x: 0, y: 10, width: 50, height: 30)
        returnButton.titleLabel?.adjustsFontSizeToFitWidth = true
        //returnButton.layer.cornerRadius = 0.5 * returnButton.bounds.width
        returnButton.setTitleColor(.white, for: .normal)
        
    }
    
    @objc func returnToCountriesTable() {
         performSegue(withIdentifier: "countries", sender: self)
        
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CountryDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries[countryIndex].bordersCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CountrySelectedTableViewCell
        cell.backgroundColor = .lightGray
        cell.countryNameLabel.text = "name: \(countries[countryIndex].bordersCountries[indexPath.row].name),  native name: \(countries[countryIndex].bordersCountries[indexPath.row].nativeName)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        headerLabel.text = "neighboring countries"
        headerLabel.backgroundColor = .black
        headerLabel.textColor = .white
        return headerLabel
    }
    
    
}
