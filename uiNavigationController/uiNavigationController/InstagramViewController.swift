//
//  ShowViewController.swift
//  uiNavigationController
//
//  Created by Miguel on 12/11/24.
//

import UIKit

class InstagramViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    /*
     1. Implement DataSource
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setups
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        // ShowViewController will manage the tableView Reference
        tableView.delegate = self
        // Register the type of cell and his identifier
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "example-cell")
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        tableView.separatorStyle = .none
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


// MARK: - UITableViewDataSource
extension InstagramViewController: UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    // What cell I need to show
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "PostTableViewCell",
            for: indexPath
        )
        
//        (cell as? PostTableViewCell)?.usernameLabel.text = "miguelzabalaf"
//        (cell as? PostTableViewCell)?.locationLabel.text = "Barranquilla"

        let post = Post(
            username: "miguelzabalaf",
            location: "Barranquilla",
            profileImage: UIImage(named: "4")!,
            postImage: UIImage(named: "2")!,
            description: "Eat, Sleep, Code, Repeat",
            date: "Sempteber 8, 2024"
        )
        (cell as? PostTableViewCell)?.setupCell(with: post)
        
        return cell
    }

}


// MARK: - UITableViewDelegate
extension InstagramViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do something after select
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
}
