//
//  ConnectorsHubViewModel.swift
//  English along with John - Presentation / Connectors
//

import Foundation
import Observation

/// ViewModel para a tela Hub de Prática de Conectivos.
/// Gerencia a configuração da sessão, seleção de filtros e estado do deck.
@Observable
@MainActor
public final class ConnectorsHubViewModel {

    // MARK: - Configuração da Sessão
    public var selectedMode: GameMode = .zen
    public var selectedFamilyFilter: ConnectorFamilyFilter = .all
    public var selectedQuestionCount: Int = 10
    public var hideMastered: Bool = false
    public var isGuideSheetPresented: Bool = false

    // MARK: - Estados de Dados
    public private(set) var isLoading: Bool = false
    public private(set) var errorMessage: String? = nil
    public private(set) var masteredCount: Int = 0
    public private(set) var totalCatalogCount: Int = 12

    // MARK: - Dependências
    private let repository: any ConnectorsRepositoryProtocol
    private let fetchSessionUseCase: any FetchConnectorsSessionUseCaseProtocol
    public var onStartSession: (@MainActor (ConnectorSession) -> Void)?

    public init(
        repository: any ConnectorsRepositoryProtocol,
        fetchSessionUseCase: any FetchConnectorsSessionUseCaseProtocol,
        onStartSession: (@MainActor (ConnectorSession) -> Void)? = nil
    ) {
        self.repository = repository
        self.fetchSessionUseCase = fetchSessionUseCase
        self.onStartSession = onStartSession
    }

    public func onAppear() async {
        await loadMasteryStats()
    }

    public func loadMasteryStats() async {
        do {
            let mastered = try await repository.getMasteredIds()
            self.masteredCount = mastered.count
            let catalog = try await repository.fetchCatalog()
            self.totalCatalogCount = catalog.count
        } catch {
            // Silencioso ou fallback
        }
    }

    /// Prepara a sessão de exercícios com os filtros atuais e dispara o fluxo.
    public func startSession() async {
        isLoading = true
        errorMessage = nil

        let config = SessionConfig(
            mode: selectedMode,
            familyFilter: selectedFamilyFilter,
            questionCount: selectedQuestionCount,
            hideMastered: hideMastered
        )

        do {
            let session = try await fetchSessionUseCase.execute(config: config)
            isLoading = false
            onStartSession?(session)
        } catch let domainError as ConnectorsDomainError {
            isLoading = false
            errorMessage = domainError.errorDescription
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }

    public func openEverFamilyGuide() {
        isGuideSheetPresented = true
    }
}
