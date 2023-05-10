import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let logic = Logic()
    var elements = [Bigram]()
    var fiteredElements = [String]()
    
    var table: UITableView = {
        var table = UITableView()
        return table
    }()
    
    let textfield: UITextField = {
        let textfield = UITextField()
        textfield.autocapitalizationType = .none
        textfield.placeholder = "Enter \"^\" sign"
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    let name: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 24, weight: .regular)
        name.text = ""
        return name
    }()
    
    let button: UIButton = {
        let button =  UIButton()
        button.setTitle("Show Bigrams", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.dataSource = self
        table.delegate = self
        
        setUI()

        logic.prepareData()
        elements = logic.bigrams.sorted{$0.number > $1.number}
        table.reloadData()
        print(logic.bigrams)
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = elements[indexPath.row].name + "                                                                 \(elements[indexPath.row].number )"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !elements[indexPath.row].name.contains("$") {
            name.text! += elements[indexPath.row].name[1]
        }else {
            name.text! += "."
        }
        
        nextWord()
    }
    
    
    
    func filterBigrams(letter: String) {
        elements = logic.bigrams.filter({ a in
            a.name.hasPrefix(letter)
        })
        elements.sort { $0.number>$1.number }
    }
    func setUI() {
        view.addSubview(table)
        table.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(680)
        }
        view.addSubview(name)
        name.snp.makeConstraints { make in
            make.width.equalTo(280)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(630)
        }
        
        view.addSubview(textfield)
        textfield.snp.makeConstraints { make in
            make.width.equalTo(280)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(700)
        }
        
        view.addSubview(button)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.width.equalTo(280)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(760)
        }
    }
    
    @objc func buttonTapped() {
        filterBigrams(letter: textfield.text ?? "a")
        name.text = ""
        table.reloadData()
    }
    
    func nextWord() {
        var letter = String(((name.text?[name.text!.count-1])!))
        filterBigrams(letter: letter ?? "a")
        table.reloadData()
    }
    
    
}


