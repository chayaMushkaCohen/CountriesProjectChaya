//
//  CountriesTableViewController.swift
//  MatrixCountriesProjectCohenChayaMushka
//
//  Created by hyperactive on 07/06/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import UIKit

var countries: [Country] = []
var applicationHasBeenDisplayed = false

class CountriesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var countriesTableView: UITableView!
    var sortCountriesByName = UIButton()
    var sortCountriesByArea = UIButton()
    var selectedCellIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCountriesTableView()
        setSortButtons()
        
        
        
    }
    
    func setCountriesTableView() {
        countriesTableView.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.height)
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: nil)
        updateUserInterface()
        
        getCountriesData()
        
        if Network.reachability.isConnectedToNetwork {
            print("connected")
        }
        else {
            print("not connected")
            if applicationHasBeenDisplayed == false {
                sendUserToActivateInternetConnection()
                applicationHasBeenDisplayed = true
            }
        }
    }


    
    func updateUserInterface() {
        switch Network.reachability.status {
        case .unreachable:
            //view.backgroundColor = .white
            if Network.reachability.isReachable {
                print("is reachable")
            }
            else {
                sendUserToSettings()
                print("not reachable")
            }
        case .wwan:
            //view.backgroundColor = .yellow
            print("wwan")
        case .wifi:
            print("wifi")
            //view.backgroundColor = .green
        }
        print("Reachability Summary")
        print("Status:", Network.reachability.status)
        print("HostName:", Network.reachability.hostname ?? "nil")
        print("Reachable:", Network.reachability.isReachable)
        print("Wifi:", Network.reachability.isReachableViaWiFi)
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    func sendUserToSettings() {
        
        let alertController = UIAlertController (title: "No Internet Connection", message: "Go to Settings?", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

            //guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
              //  return
            //}
            
            guard let settingsUrl = URL(string: "APP-prefs:WIFI") else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    
    func sendUserToActivateInternetConnection() {
        let alertController = UIAlertController (title: "NO INTERNET CONNECTION", message: "Go to Settings?", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    
    func setSortButtons() {
        sortCountriesByName.frame = CGRect(x: 10, y: 50, width: view.bounds.width / 2 - 40, height: 30)
        sortCountriesByName.backgroundColor = .gray
        sortCountriesByName.setTitle("sort countries from Z to A", for: .normal)
        sortCountriesByName.addTarget(self, action: #selector(arrangeCountriesByName), for: .touchUpInside)
        sortCountriesByName.titleLabel?.adjustsFontSizeToFitWidth = true
        view.addSubview(sortCountriesByName)
        
        sortCountriesByArea.frame = CGRect(x: 20 + sortCountriesByName.bounds.width, y: 50, width: view.bounds.width / 2, height: 30)
        sortCountriesByArea.backgroundColor = .gray
        sortCountriesByArea.setTitle("sort countries from small to big", for: .normal)
        sortCountriesByArea.addTarget(self, action: #selector(arrangeCountriesByArea), for: .touchUpInside)
        sortCountriesByArea.titleLabel?.adjustsFontSizeToFitWidth = true
        view.addSubview(sortCountriesByArea)
        
    }
    
    
    func getCountriesData() {
        if let url = URL(string: "https://restcountries.eu/rest/v2/all?fields=name;nativeName;area;borders;alpha3Code") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let json = try? (JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]])
                        self.populateTable(json: json!)
                    }
                }
            }.resume()
        }
    }
    
    func populateTable(json: [[String: Any]]) {
        for country in json {
            let name = country["name"]! as! String
            let nativeName = country["nativeName"]! as! String
            let area = country["area"] as? Double
            let borders = country["borders"]! as! [String]
            let alphaCode = country["alpha3Code"]! as! String
            
            //let emptyBordersArray: [Country]
            //print("************ \r \(borders)")

            
            //let tableCountry = Country(name: name, nativeName: nativeName, area: area ?? 0, borders: emptyBordersArray, alphaCode: alphaCode)
            let tableCountry = Country(name: name, nativeName: nativeName, area: area ?? 0, bordersStrings: borders, alphaCode: alphaCode)
            countries.append(tableCountry)
        }
        
        for country in countries {
            associateNeighboringCountries(bordersArray: country.bordersStrings, countryUpdated: country)
        }
        
        DispatchQueue.main.sync {
            
            self.countriesTableView.reloadData()
        }
    }
    
    func associateNeighboringCountries(bordersArray: [String], countryUpdated: Country) {
        //let updatedBordersArray: [Country] = []
        for border in bordersArray {
            for neighboringCountry in countries { //country is the neighboring country
                if neighboringCountry.alphaCode == border {
                    countryUpdated.bordersCountries.append(Country(name: neighboringCountry.name, nativeName: neighboringCountry.nativeName, area: neighboringCountry.area, bordersCountries: [], bordersStrings: [], alphaCode: neighboringCountry.alphaCode))
                }
            }
        }
    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountriesTableViewCell
        cell.backgroundColor = .lightGray
        let location = indexPath.row + indexPath.section
        (cell as! CountriesTableViewCell).countryNameLabel.text = "\(countries[location].name), Native name: \(countries[location].nativeName)"
        if String(countries[location].area) == "0.0" {
            (cell as! CountriesTableViewCell).countryArea.text = "area: NO DETAILS"
        }
        else {
            (cell as! CountriesTableViewCell).countryArea.text = "area: " + String(countries[location].area)
        }

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .white
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndex = indexPath.section
        performSegue(withIdentifier: "details", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segue = segue.destination as? CountryDetailsViewController {
            segue.countryIndex = selectedCellIndex
        }
    }
    
    @objc func arrangeCountriesByName() {
        var sortedCountries: [Country] = []
        if sortCountriesByName.titleLabel?.text == "sort countries from A to Z" {
            sortedCountries = countries.sorted{
                return $0.name < $1.name
            }
            sortCountriesByName.setTitle("sort countries from Z to A", for: .normal)
        }
        else {
            sortedCountries = countries.sorted{
                return $0.name > $1.name
            }
            sortCountriesByName.setTitle("sort countries from A to Z", for: .normal)
        }
        countries = sortedCountries
        countriesTableView.reloadData()
    }
    
    @ objc func arrangeCountriesByArea() {
        var sortedCountries: [Country] = []
        if sortCountriesByArea.titleLabel?.text == "sort countries from big to small" {
                sortedCountries = countries.sorted{
                    return $0.area > $1.area
                }
                sortCountriesByArea.setTitle("sort countries from small to big", for: .normal)
        }
        else {
            sortedCountries = countries.sorted{
                return $0.area < $1.area
            }
            sortCountriesByArea.setTitle("sort countries from big to small", for: .normal)
            
        }
        countries = sortedCountries
        countriesTableView.reloadData()

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

