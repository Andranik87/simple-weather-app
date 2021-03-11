//
//  ViewController.swift
//  What's The Weather
//
//  Created by Andranik Karapetyan on 4/14/20.
//  Copyright © 2020 Andranik Karapetyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var cityNameLabel: UITextField!
    @IBOutlet weak var weatherReportLabel: UILabel!
    
    var webURLStringDefault = "https://www.weather-forecast.com/locations/city/forecasts/latest"
    var cityNameList = ["new york", "london", "brooklyn", "yerevan", "san diego"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func getMeCityNameTextBaby(replace: String, with: String, originalString: String) -> String
    {
        let cityName = NSString(string: originalString)

        var newCityName = String()

        if cityName.contains(replace)
        {
            let nameStrings = cityName.components(separatedBy: replace)
            
            var i = 0;
            for name in nameStrings
            {
                i += 1
                newCityName.append(name)

                if i < nameStrings.count
                {
                    newCityName.append(with)
                }
            }
            
            return newCityName
        }
        
        return cityName.substring(to: cityName.length);
    }
    
    func updateWeatherReport(sourceURL: String)
    {
        let url = URL(string: sourceURL)!
        
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            data, response, error in
            
            if(error != nil)
            {
                print (error as Any)
            }
            else
            {
                if let unwrappedData = data
                {
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                                        
                    DispatchQueue.main.sync(execute: {
                        self.updateUI(source: dataString!)
                    })
                }
            }
        }
        task.resume()
    }
    
    func updateUI(source: NSString)
    {
        let separation1 = source.components(separatedBy: "b-forecast__table-description")
        let separation2 = NSString(string: separation1[4]).components(separatedBy: ">")
        
        let result = getMeCityNameTextBaby(replace: "</span", with: "", originalString: separation2[2])
        
        weatherReportLabel.text = result
    }
    
    func doesCityNameExist(cityName: String) -> Bool
    {
        for name in cityNameList
        {
            let newTypeString = NSString(string: cityName)
            let lowercasedName = newTypeString.lowercased
            
            if name == lowercasedName
            {
                return true
            }
        }
        
        return false
    }
    
    @IBAction func getWeatherButton(_ sender: Any)
    {
        let cityNameForURL = getMeCityNameTextBaby(replace: " ", with: "-", originalString: cityNameLabel.text!)
        let webURLString = getMeCityNameTextBaby(replace: "city", with: cityNameForURL, originalString:webURLStringDefault)

        if doesCityNameExist(cityName: cityNameLabel.text!)
        {
            weatherReportLabel.text = "Retrieving your weather report!"
            updateWeatherReport(sourceURL: webURLString)
        }
        else
        {
            weatherReportLabel.text = "Enter a valid city: New York, London, Brooklyn, Yerevan, San Diego"
        }
    }
}


