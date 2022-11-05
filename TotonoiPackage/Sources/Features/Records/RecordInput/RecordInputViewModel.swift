import Foundation
import Combine
import RecordsData

struct RecordInputUiState {
    var isLoading: Bool
    var sakatsu: Sakatsu
}

@MainActor
final class RecordInputViewModel<Repository: SakatsuRepository>: ObservableObject {
    @Published private(set) var uiState = RecordInputUiState(
        isLoading: true,
        sakatsu: .empty
    )
    
    private let repository: Repository
    
    nonisolated init(repository: Repository = SakatsuUserDefaultsClient.shared) {
        self.repository = repository
    }
}

// MARK: Event handler

extension RecordInputViewModel {
    func onSaveButtonClick() async {
        var sakatsus = (try? await repository.sakatsus()) ?? []
        sakatsus.append(uiState.sakatsu)
        try? await repository.saveSakatsus(sakatsus) // TODO: Error handling
    }
    
    func onAddNewSaunaSetButtonClick() {
        uiState.sakatsu.saunaSets.append(.empty)
    }
    
    func onFacilityNameChange(facilityName: String) {
        guard validate(facilityName: facilityName) else {
            return
        }
        uiState.sakatsu.facilityName = facilityName
    }
    
    func onVisitingDateChange(visitingDate: Date) {
        guard validate(visitingDate: visitingDate) else {
            return
        }
        uiState.sakatsu.visitingDate = visitingDate
    }
    
    func onSaunaTimeChange(saunaSetIndex: Int, saunaTime: TimeInterval?) {
        guard let saunaTime, validate(saunaTime: saunaTime) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].sauna.time = saunaTime * 60
    }
    
    func onCoolBathTimeChange(saunaSetIndex: Int, coolBathTime: TimeInterval?) {
        guard let coolBathTime, validate(coolBathTime: coolBathTime) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].coolBath.time = coolBathTime
    }
    
    func onRelaxationTimeChange(saunaSetIndex: Int, relaxationTime: TimeInterval?) {
        guard let relaxationTime, validate(relaxationTime: relaxationTime) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].relaxation.time = relaxationTime * 60
    }
   
    private func validate(facilityName: String) -> Bool {
        facilityName != ""
    }
    
    private func validate(visitingDate: Date) -> Bool {
        true // TODO: Disable future dates
    }
    
    private func validate(saunaTime: TimeInterval) -> Bool {
        saunaTime >= 0
    }
    
    private func validate(coolBathTime: TimeInterval) -> Bool {
        coolBathTime >= 0
    }
    
    private func validate(relaxationTime: TimeInterval) -> Bool {
        relaxationTime >= 0
    }
}
