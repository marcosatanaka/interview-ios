import Foundation

protocol ListContactsViewModelDelegate: AnyObject {
    func onLoadContacts()
    func onError(error: Error)
    func showAlertOnRowSelected(title: String, message: String, buttonTitle: String)
}

class ListContactsViewModel {

    private weak var delegate: ListContactsViewModelDelegate?
    private let service: ListContactServiceProtocol
    private(set) var contacts = [Contact]()

    init(delegate: ListContactsViewModelDelegate, service: ListContactServiceProtocol = ListContactService()) {
        self.delegate = delegate
        self.service = service
    }

    func loadContacts() {
        service.fetchContacts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.delegate?.onError(error: error)
            case .success(let contacts):
                self.contacts = contacts
                self.delegate?.onLoadContacts()
            }
        }
    }

    func handleRowSelection(at indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        let isLegacy = [10, 11, 12, 13].contains(contact.id)

        if isLegacy {
            delegate?.showAlertOnRowSelected(title: "Atenção",
                                             message: "Você tocou no contato sorteado",
                                             buttonTitle: "OK")
        } else {
            delegate?.showAlertOnRowSelected(title: "Você tocou em",
                                             message: contact.name,
                                             buttonTitle: "OK")
        }
    }
}
