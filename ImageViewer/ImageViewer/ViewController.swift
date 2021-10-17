//
//  ViewController.swift
//  ImageViewer
//
//  Created by koko on 17/10/21.
//

import UIKit

class ViewController: UIViewController {

    //outlets
    @IBOutlet weak var nextBtnOutlet: UIButton!
    @IBOutlet weak var previousBtnOutlet: UIButton!
    @IBOutlet weak var imageOutlet: UIImageView!
    
    //variables
    var imageArray = [String]()                         //to store image urls
    var response: DataModal?
    var imageCounter = 0                                //to keep track of current displayed image
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.previousBtnOutlet.isEnabled = false
        self.getDogImage()
    }

    //api call for getting dog image
    func getDogImage(){
        let url = URL(string: "https://dog.ceo/api/breeds/image/random")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            if let decodedResponse = try? JSONDecoder().decode(DataModal.self, from: data){
                self.imageArray.append(decodedResponse.message ?? "")
                self.loadImage(url: decodedResponse.message ?? "")
            }
        }
        task.resume()
    }
    
    //display image in imageView using url
    func loadImage(url: String) {
        guard let url2 = URL(string: url) else {return}
        if let data = try? Data(contentsOf: url2){
            if let image = UIImage(data: data){
                DispatchQueue.main.async {
                    self.imageOutlet.image = image
                }
            }
        }
    }
    
    @IBAction func previousAction(_ sender: UIButton) {
        self.imageCounter -= 1
        if imageCounter < 1 {
            self.previousBtnOutlet.isEnabled = false
            self.loadImage(url: imageArray[imageCounter])
        }else{
            self.loadImage(url: imageArray[imageCounter])
        }
        print(imageCounter,imageArray)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        self.imageCounter += 1
        self.previousBtnOutlet.isEnabled = true
        if imageCounter >= imageArray.count{
            self.getDogImage()
        }else{
            self.loadImage(url: imageArray[imageCounter])
        }
    }
    
}

