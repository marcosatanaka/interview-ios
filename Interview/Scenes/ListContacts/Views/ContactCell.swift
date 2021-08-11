import UIKit

class ContactCell: UITableViewCell {

    var contact: Contact? {
        didSet {
            guard let contact = contact else { return }
            fullnameLabel.text = contact.name

            if let urlPhoto = URL(string: contact.photoURL) {
                DispatchQueue.global().async { [weak self] in
                    guard let self = self else { return }
                    do {
                        let data = try Data(contentsOf: urlPhoto)
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            if self.fullnameLabel.text == contact.name {
                                self.contactImage.image = image
                            }
                        }
                    } catch _ {}
                }
            }
        }
    }

    private lazy var contactImage = buildContactImage()
    private lazy var fullnameLabel = buildFullnameLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }

    override func prepareForReuse() {
        fullnameLabel.text = ""
        contactImage.image = nil
    }

    private func configureViews() {
        contentView.addSubview(contactImage)
        contentView.addSubview(fullnameLabel)

        NSLayoutConstraint.activate([
            contactImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            contactImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contactImage.heightAnchor.constraint(equalToConstant: 100),
            contactImage.widthAnchor.constraint(equalToConstant: 100),

            fullnameLabel.leadingAnchor.constraint(equalTo: contactImage.trailingAnchor, constant: 16),
            fullnameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            fullnameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            fullnameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - UI Factory

private extension ContactCell {

    private func buildContactImage() -> UIImageView {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }

    private func buildFullnameLabel() -> UILabel {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title3)
                    .addingAttributes([.traits : [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold]])

        let label = UILabel()
        label.font = UIFont(descriptor: fontDescriptor, size: 0)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

}
