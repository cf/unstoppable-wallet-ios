class RestoreWordsPresenter {
    weak var view: IRestoreWordsView?

    private let interactor: IRestoreWordsInteractor
    private let router: IRestoreWordsRouter

    private var words: [String]?

    init(interactor: IRestoreWordsInteractor, router: IRestoreWordsRouter) {
        self.interactor = interactor
        self.router = router
    }

}

extension RestoreWordsPresenter: IRestoreWordsViewDelegate {

    func viewDidLoad() {
        view?.show(defaultWords: interactor.defaultWords)
    }

    func didTapRestore(words: [String]) {
        do {
            try interactor.validate(words: words)
            self.words = words
            router.showSyncMode(delegate: self)
        } catch {
            view?.show(error: error)
        }
    }

}

extension RestoreWordsPresenter: IRestoreWordsInteractorDelegate {
}

extension RestoreWordsPresenter: ISyncModeDelegate {

    func onSelectSyncMode(isFast: Bool) {
        guard let words = words else { return }

        let accountType: AccountType = .mnemonic(words: words, derivation: .bip44, salt: nil)
        let syncMode: SyncMode = isFast ? .fast : .slow

        router.notifyRestored(accountType: accountType, syncMode: syncMode)
    }

}
