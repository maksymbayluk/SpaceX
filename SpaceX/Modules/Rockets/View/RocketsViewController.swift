//
//  RocketViewController.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//
import UIKit


final class RocketsViewController: UIViewController {
    private let viewModel: RocketsViewModel
    private var tableView = UITableView()
    private let refreshControl = UIRefreshControl()

    init(viewModel: RocketsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        loadData()
    }

    private func setupUI() {
        title = "SpaceX Rockets"
        view.backgroundColor = .systemGroupedBackground

        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RocketCell.self, forCellReuseIdentifier: "RocketCell")

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupBindings() {
        viewModel.onError = { error in
            AlertService.showAlert(title: "Error", message: String(describing: error))
        }
    }

    private func loadData() {
        refreshControl.beginRefreshing()

        Task { @MainActor in
            await viewModel.fetchRockets()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }

    @objc private func refreshData() {
        loadData()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension RocketsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.rockets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RocketCell.reuseIdentifier, for: indexPath) as! RocketCell
        cell.configure(with: viewModel.rockets[indexPath.row])
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.onSelectRocket?(viewModel.rockets[indexPath.row].id)
    }
}
