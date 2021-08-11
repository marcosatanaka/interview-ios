import UIKit

class ListContactsViewController: UIViewController {

    private lazy var activity = buildActivityIndicator()
    private lazy var tableView = buildTableView()
    private lazy var viewModel = ListContactsViewModel(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        viewModel.loadContacts()
    }

    func configureViews() {
        title = "Lista de contatos"
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

// MARK: - DataSource/Delegate

extension ListContactsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactCell.self), for: indexPath) as? ContactCell else {
            return UITableViewCell()
        }
        cell.contact = viewModel.contacts[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.handleRowSelection(at: indexPath)
    }

}

// MARK: - ListContactsViewModelDelegate

extension ListContactsViewController: ListContactsViewModelDelegate {

    func onLoadContacts() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activity.stopAnimating()
        }
    }

    func onError(error: Error) {
        DispatchQueue.main.async {
            self.showAlert(title: "Ops, ocorreu um erro", message: error.localizedDescription, buttonTitle: "OK")
        }
    }

    func showAlertOnRowSelected(title: String, message: String, buttonTitle: String) {
        showAlert(title: title, message: message, buttonTitle: buttonTitle)
    }

}

// MARK: - UI Factory

extension ListContactsViewController {

    private func buildActivityIndicator() -> UIActivityIndicatorView {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }

    private func buildTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.register(ContactCell.self, forCellReuseIdentifier: String(describing: ContactCell.self))
        tableView.backgroundView = activity
        tableView.tableFooterView = UIView()
        return tableView
    }

}
