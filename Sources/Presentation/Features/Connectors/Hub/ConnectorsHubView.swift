//
//  ConnectorsHubView.swift
//  English along with John - Presentation / Connectors
//

import SwiftUI

/// Tela Hub de Configuração e Treino de Conectivos em Inglês.
public struct ConnectorsHubView: View {
    @Bindable private var viewModel: ConnectorsHubViewModel

    public init(viewModel: ConnectorsHubViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header com Progresso & Apresentação
                headerStatsView

                // Seleção de Modo: Zen vs Arcade
                modeSelectorSection

                // Seleção de Tópico / Família
                familyFilterSection

                // Configurações de Quantidade e Dominados
                sessionSettingsSection

                // Banner de Erro Reativo
                if let error = viewModel.errorMessage {
                    errorBanner(message: error)
                }

                // Botão de Iniciar Sessão
                startButtonView
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color.appBackground)
        .navigationTitle("Prática de Conectivos")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { viewModel.openEverFamilyGuide() }) {
                    Image(systemName: "book.pages.fill")
                        .foregroundStyle(.blue)
                }
            }
        }
        .sheet(isPresented: $viewModel.isGuideSheetPresented) {
            EverFamilyGuideView()
        }
        .task {
            await viewModel.onAppear()
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var headerStatsView: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("English Connectors Lab")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Domine os conectivos essenciais para fluência e argumentação técnica.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button(action: { viewModel.openEverFamilyGuide() }) {
                    VStack(spacing: 2) {
                        Image(systemName: "lightbulb.fill")
                            .font(.title3)
                            .foregroundStyle(.orange)
                        Text("Guia -Ever")
                            .font(.caption2)
                            .fontWeight(.semibold)
                    }
                    .padding(8)
                    .background(Color.appCardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }

            // Barra de Maestria
            HStack {
                Label("\(viewModel.masteredCount) de \(viewModel.totalCatalogCount) conectivos dominados", systemImage: "checkmark.seal.fill")
                    .font(.caption)
                    .foregroundStyle(.green)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.green.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    @ViewBuilder
    private var modeSelectorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Modo de Aprendizado")
                .font(.headline)

            HStack(spacing: 14) {
                modeCard(
                    mode: .zen,
                    title: "Modo Zen",
                    subtitle: "Sem vidas, sem cronômetro. Foque na compreensão gramatical.",
                    icon: "leaf.fill",
                    color: .green
                )

                modeCard(
                    mode: .arcade,
                    title: "Desafio Arcade",
                    subtitle: "18s por questão, 3 vidas, bônus de agilidade e combo streak.",
                    icon: "flame.fill",
                    color: .orange
                )
            }
        }
    }

    @ViewBuilder
    private func modeCard(mode: GameMode, title: String, subtitle: String, icon: String, color: Color) -> some View {
        let isSelected = viewModel.selectedMode == mode

        Button(action: {
            viewModel.selectedMode = mode
        }) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(isSelected ? .white : color)
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.white)
                    }
                }

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(isSelected ? .white : .primary)

                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(isSelected ? .white.opacity(0.85) : .secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 125, alignment: .topLeading)
            .background(isSelected ? color : Color.appCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? color : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var familyFilterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tópico de Estudo")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    topicPill(filter: .all, title: "Todas as Famílias", icon: "square.grid.2x2.fill")
                    topicPill(filter: .everFamily, title: "Família -EVER (Especial)", icon: "sparkles")
                    ForEach(ConnectorFamily.allCases, id: \.self) { family in
                        topicPill(filter: .family(family), title: family.localizedTitle, icon: family.iconName)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func topicPill(filter: ConnectorFamilyFilter, title: String, icon: String) -> some View {
        let isSelected = viewModel.selectedFamilyFilter == filter

        Button(action: {
            viewModel.selectedFamilyFilter = filter
        }) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.footnote)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color.appCardBackground)
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.blue : Color.primary.opacity(0.08), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var sessionSettingsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Configurações da Rodada")
                .font(.headline)

            VStack(spacing: 12) {
                // Quantidade de Frases
                HStack {
                    Text("Quantidade de Frases")
                        .font(.subheadline)
                    Spacer()
                    Picker("Quantidade", selection: $viewModel.selectedQuestionCount) {
                        Text("10 Frases").tag(10)
                        Text("20 Frases").tag(20)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 170)
                }

                Divider()

                // Ocultar Dominados
                Toggle(isOn: $viewModel.hideMastered) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Ocultar conectivos dominados")
                            .font(.subheadline)
                        Text("Foca nos termos ainda em fixação")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .tint(.blue)
            }
            .padding()
            .background(Color.appCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    @ViewBuilder
    private func errorBanner(message: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(.orange)
            Text(message)
                .font(.footnote)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(Color.orange.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private var startButtonView: some View {
        Button(action: {
            Task {
                await viewModel.startSession()
            }
        }) {
            HStack(spacing: 10) {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text("Iniciar Sessão")
                        .font(.headline)
                    Image(systemName: "play.circle.fill")
                        .font(.title3)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .disabled(viewModel.isLoading)
        .padding(.top, 8)
    }
}

#Preview {
    let repo = ConnectorsRepository()
    let useCase = FetchConnectorsSessionUseCase(repository: repo)
    ConnectorsHubView(viewModel: ConnectorsHubViewModel(repository: repo, fetchSessionUseCase: useCase))
}
