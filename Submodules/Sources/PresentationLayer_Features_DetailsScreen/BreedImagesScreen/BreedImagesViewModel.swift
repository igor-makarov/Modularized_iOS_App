import Foundation
import DomainLayer
import DataLayer // TODO: Should move to Dependency Container. Is here becouse of FavoritesManager creation
import Networking // TODO: Should move to Dependency Container. Is here becouse of FavoritesManager creation

@Observable public class BreedImagesViewModel {
    public let id = UUID()
    public var state: ViewState<[BreedImageViewModel]> = .idle(data: [])

    private var breedName: String
    private let breedDetailsUseCase: BreedDetailsUseCaseProtocol

    public init(breedName: String,
                breedDetailsUseCase: BreedDetailsUseCaseProtocol) {
        self.breedName = breedName
        self.breedDetailsUseCase = breedDetailsUseCase
    }
    
    public enum Action {
        case onAppear
    }
    
    public func dispatch(_ action: Action) async {
        switch action {
        case .onAppear:
            await fetchBreedDetails()
        }
    }
    
    internal var title: String {
        breedName.capitalized(with: Locale.current)
    }
   
    func fetchBreedDetails() async {
        do {
            let breedDetails = try await fetchBreedDetailsRemote()
            await fillBreedDetails(breedDetails)
        } catch let error {
            await handleError(error)
        }
    }
    
    func fetchBreedDetailsRemote() async throws -> [BreedDetailsEntity] {
        return try await breedDetailsUseCase.getBreedDetails(breedName: breedName)
    }
    
    @MainActor
    private func handleLoading(_ isLoading: Bool) {
        if isLoading {
            state = .loading
        } else {
            if let viewModels = state.data {
                state = .idle(data: viewModels)
            }
        }
    }
    
    @MainActor
    private func fillBreedDetails(_ breedDetails: [BreedDetailsEntity]) {
        let repository = BreedDetailsRepository(service: WebService(), favoritesManager: FavoritesManager.shared) //Move to Devendency container
        let favoritingUseCase = FavoriteUseCase(repository: repository)
        let detailsCardViewModels = breedDetails.map {
            BreedImageViewModel(breedDetails: $0,
                                 favoritingUseCase: favoritingUseCase) }
        state = .idle(data: detailsCardViewModels)
    }
    
    @MainActor
    private func handleError(_ error: Error) {
        guard let error = error as? ErrorEntity else {
            state = .error(message: error.localizedDescription)
            return
        }
        state = .error(message: error.description)
    }
}

extension BreedImagesViewModel: Equatable {
    public static func == (lhs: BreedImagesViewModel, rhs: BreedImagesViewModel) -> Bool {
      return lhs.id == rhs.id
    }
}
