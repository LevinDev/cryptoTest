//
//  HomeVC.swift
//  BitTicker
//
//  Created by Levin Varghese on 6/2/20.
//  Copyright © 2020 Levin Varghese. All rights reserved.
//

import UIKit
import Combine

class HomeVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldInput: UITextField!
    private let viewModel: HomeViewModelType
    private let viewLoadedPub: PassthroughSubject<Void, Never>
    private let userSelection: PassthroughSubject<TickerData, Never>
    private var input = HomeViewModelInput()
    private let cellReuseIdentifier = "cell"
    private lazy var dataSource = makeDataSource()
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init?(coder: NSCoder, viewModel: HomeViewModelType) {
        self.viewModel = viewModel
        self.viewLoadedPub = PassthroughSubject<Void,Never>()
        self.userSelection = PassthroughSubject<TickerData, Never>()
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupTableView()
        inputBinding()
        outputBinding()
        viewLoadedPub.send()
    }
    
    func inputBinding() {
        input.viewLoaded = self.viewLoadedPub.eraseToAnyPublisher()
        input.userSelection = self.userSelection.eraseToAnyPublisher()
        self.textFieldInput.didChangePublisher
            .map(filterCharacters(_:))
            .receive(on: DispatchQueue.main)
            .assign(to: \UITextField.text, on: textFieldInput)
            .store(in: &bindings)
    }
    
    func outputBinding() {
        viewModel.transform(input: input)
            .sink { [unowned self] (state) in
                switch state {
                case .loading:
                    self.showHud(message: "Ticker data loading")
                case .subscriptionData(let ticker):
                    self.hideHud()
                    self.append(ticker: ticker)
                case .failure(let error):
                    self.hideHud()
                    self.showHud(message: error.localizedDescription)
                }
        }.store(in: &bindings)
    }
    
    func setupTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        var snapshot = NSDiffableDataSourceSnapshot<Section, TickerData>()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func filterCharacters(_ notification: Notification) -> String {
        return (notification.object as? UITextField)?.text?.filter({ $0.isNumber || $0.isPunctuation }) ?? ""
    }
}

extension HomeVC: UITableViewDelegate {
    typealias Snapshot = NSDiffableDataSourceSnapshot<HomeVC.Section, TickerData>
    enum Section: CaseIterable {
        case main
    }
    
    func append(ticker: TickerData){
        var snapshot = dataSource.snapshot()
        var projects = snapshot.itemIdentifiers
        guard let updatedSnap = projects.update(ticker) else {
            snapshot.appendItems([ticker], toSection: .main)
            DispatchQueue.main.async { [weak self] in
                self?.dataSource.apply(snapshot, animatingDifferences: false)
            }
            return
        }
        var snapShot = NSDiffableDataSourceSnapshot<Section, TickerData>()
        snapShot.appendSections([.main])
        snapShot.appendItems(updatedSnap, toSection: .main)
        DispatchQueue.main.async { [weak self] in
            self?.dataSource.apply(snapShot, animatingDifferences: false)
        }
    }
    
    func makeDataSource() -> UITableViewDiffableDataSource<Section, TickerData> {
        let reuseIdentifier = cellReuseIdentifier
        
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, ticker in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: reuseIdentifier,
                    for: indexPath
                    ) as! TickerTableViewCell
                cell.bind(ticker: ticker, userInputValue: self.textFieldInput.text)
                return cell
        }
        )
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ticker = dataSource.snapshot().itemIdentifiers[indexPath.row]
        userSelection.send(ticker)
    }
}
