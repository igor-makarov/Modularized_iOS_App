import Testing
import Domain
import List

struct RecipesViewModelTests {
    
    @Test func whenRecipesFetchedSuccesfully_shouldFillRecipesViewModelArray_andShowCorrectInfo() async {
        let sut = await makeSUT(breedsUseCase: BreedsUseCaseMock(breeds: BreedEntity.mock))
        await sut.dispatch(.onAppear)
        
        #expect(sut.state.data?.count == 10)
        #expect(sut.state.error == nil)
        
        if let breedViewModel = sut.state.data?.first as? BreedEntity {
            #expect(breedViewModel.name == "Golden Retriever")
        }
    }
    
    @Test func whenAstronomiesFetchError_shouldPresentError() async {
        let sut = await makeSUT(breedsUseCase: BreedsUseCaseMock(error: ErrorEntity.general))
        
        await sut.dispatch(.onAppear)
        
        #expect(sut.state.error != nil)
        
        if let error = sut.state.error {
            #expect(error == "Oops, something went wrong")
        }
    }
    
    
    // MARK: - Test helpers
    @MainActor
    func makeSUT(breedsUseCase: some BreedsUseCaseProtocol) -> BreedsViewModel {
        let sut = BreedsViewModel(breedsUseCase: breedsUseCase)
        return sut
    }
}
