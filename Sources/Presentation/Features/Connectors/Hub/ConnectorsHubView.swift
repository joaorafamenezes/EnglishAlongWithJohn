//
//  ConnectorsHubView.swift
//  English along with John - Presentation / Connectors
//

import SwiftUI

/// Tela Hub de Configuração e Treino de Conectivos em Inglês.
/// Fiel ao design e funcionalidades do jogo web (Connectors in English).
public struct ConnectorsHubView: View {
    @Bindable private var viewModel: ConnectorsHubViewModel

    public init(viewModel: ConnectorsHubViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                // Header com Badge e Título do Game Web
                headerBrandingSection

                // Banner Especial: Phrasal Verbs
                phrasalVerbsPromoCard

                // BLOCO SEPARADO: Especial Família -Ever & Whereas
                everFamilySpecialCard

                // Modos de Prática: Estudo Zen vs Desafio Arcade
                modeSelectorSection

                // Seção de Configuração da Sessão (Dominados, Família, Quantidade)
                practiceConfigurationSection

                // Modos Integrados de Apoio: Deck dos 81 Conectivos e Match Rápido
                companionToolsSection

                // Banner de Erro Reativo
                if let error = viewModel.errorMessage {
                    errorBanner(message: error)
                }

                // Botão de Iniciar Prática
                startButtonView
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
        }
        .background(Color.appBackground)
        .navigationTitle("Conectivos em Inglês")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.onAppear()
        }
    }

    // MARK: - 1. Header com Identidade Visual do Jogo Web

    @ViewBuilder
    private var headerBrandingSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Badge
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.caption2)
                Text("Sem Julgamento • Foco em Fixação")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .foregroundStyle(Color.green)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.green.opacity(0.12))
            .clipShape(Capsule())

            // Título Principal
            Text("Pratique conectivos em frases reais da vida e da tecnologia.")
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundStyle(.primary)
                .lineSpacing(2)

            // Subtítulo didático
            Text("Exercite preenchimento de lacunas com explicações sintáticas detalhadas, tradução completa da frase em português e pronúncia em inglês. Aprenda o porquê de cada escolha sem estresse ou punição.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineSpacing(3)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    // MARK: - 2. Promo Phrasal Verbs

    @ViewBuilder
    private var phrasalVerbsPromoCard: some View {
        NavigationLink(value: AppRoute.phrasalVerbsHub) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.purple.opacity(0.15))
                        .frame(width: 48, height: 48)
                    Image(systemName: "airplane.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.purple)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("Novo Jogo: Phrasal Verbs Challenge")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)

                    Text("Desafio de frases, modo match por tempo e dicionário interativo.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundStyle(.purple)
            }
            .padding(14)
            .background(Color.purple.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.purple.opacity(0.35), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - 3. BLOCO SEPARADO: Especial Família -Ever & Whereas

    @ViewBuilder
    private var everFamilySpecialCard: some View {
        NavigationLink(value: AppRoute.everFamilyHub) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.teal.opacity(0.18))
                            .frame(width: 46, height: 46)
                        Image(systemName: "target")
                            .font(.title2)
                            .foregroundStyle(.teal)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Text("Sessão Especial:")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.teal)
                            Text("Whatever, Whenever, Wherever...")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                        }

                        Text("Aprenda a regra mental do sufixo -ever, diferencie o falso amigo Whereas (contraste) de Wherever (lugar), e treine frases práticas exclusivas.")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineSpacing(2)
                    }
                }

                HStack {
                    Spacer()
                    HStack(spacing: 6) {
                        Text("Abrir Estudo Comparativo & Quiz")
                            .font(.caption)
                            .fontWeight(.bold)
                        Image(systemName: "arrow.right")
                            .font(.caption2)
                            .fontWeight(.bold)
                    }
                    .foregroundStyle(.teal)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.teal.opacity(0.12))
                    .clipShape(Capsule())
                }
            }
            .padding(14)
            .background(Color.teal.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.teal.opacity(0.4), lineWidth: 1.2)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - 4. Seleção de Modo (Zen vs Arcade)

    @ViewBuilder
    private var modeSelectorSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Estilo de Treino")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            HStack(spacing: 12) {
                // Modo Zen
                modeCard(
                    mode: .zen,
                    badge: "RECOMENDADO",
                    title: "Modo Estudo Zen",
                    subtitle: "Zero pressão. Sem vidas, sem cronômetro correndo. Leia as explicações com tranquilidade.",
                    icon: "leaf.fill",
                    color: .green
                )

                // Modo Arcade
                modeCard(
                    mode: .arcade,
                    badge: "DESAFIO",
                    title: "Desafio Arcade",
                    subtitle: "18s por frase, 3 vidas e bônus de combo por sequência de acertos rápidos.",
                    icon: "bolt.fill",
                    color: .orange
                )
            }
        }
    }

    @ViewBuilder
    private func modeCard(mode: GameMode, badge: String, title: String, subtitle: String, icon: String, color: Color) -> some View {
        let isSelected = viewModel.selectedMode == mode

        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.selectedMode = mode
            }
        }) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(badge)
                        .font(.system(size: 9, weight: .heavy))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(isSelected ? Color.white.opacity(0.25) : color.opacity(0.15))
                        .foregroundStyle(isSelected ? .white : color)
                        .clipShape(Capsule())

                    Spacer()

                    Image(systemName: icon)
                        .font(.subheadline)
                        .foregroundStyle(isSelected ? .white : color)
                }

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(isSelected ? .white : .primary)

                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(isSelected ? .white.opacity(0.9) : .secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
            .background(isSelected ? color : Color.appCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? color : Color.primary.opacity(0.08), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - 5. Configuração da Prática

    @ViewBuilder
    private var practiceConfigurationSection: some View {
        VStack(spacing: 14) {
            // Checkbox: Ocultar Dominados
            Button(action: {
                viewModel.hideMastered.toggle()
            }) {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: viewModel.hideMastered ? "checkmark.square.fill" : "square")
                        .font(.title3)
                        .foregroundStyle(viewModel.hideMastered ? .blue : .secondary)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Focar apenas nos itens em estudo")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        Text("\(viewModel.masteredCount) de \(viewModel.totalCatalogCount) conectivos marcados como dominados no Deck serão ignorados nesta sessão.")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineSpacing(2)
                    }

                    Spacer()
                }
                .padding(12)
                .background(Color.appCardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)

            // Seletores: Família e Quantidade
            VStack(spacing: 12) {
                // Família de Conectivos
                HStack {
                    Text("Família de Conectivos:")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Picker("Família", selection: $viewModel.selectedFamilyFilter) {
                        Text("Todas as Categorias").tag(ConnectorFamilyFilter.all)
                        ForEach(ConnectorFamily.allCases, id: \.self) { family in
                            Text(family.displayName).tag(ConnectorFamilyFilter.family(family))
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(.blue)
                }

                Divider()

                // Quantidade de Frases
                HStack {
                    Text("Quantidade de Frases:")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Picker("Quantidade", selection: $viewModel.selectedQuestionCount) {
                        Text("5 frases").tag(5)
                        Text("10 frases").tag(10)
                        Text("15 frases").tag(15)
                        Text("20 frases").tag(20)
                        Text("30 frases").tag(30)
                    }
                    .pickerStyle(.menu)
                    .tint(.blue)
                }
            }
            .padding(14)
            .background(Color.appCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    // MARK: - 6. Ferramentas Complementares (Deck e Match)

    @ViewBuilder
    private var companionToolsSection: some View {
        HStack(spacing: 12) {
            NavigationLink(value: AppRoute.connectorsDeck) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "rectangle.stack.fill")
                            .foregroundStyle(.blue)
                        Spacer()
                        Text("\(viewModel.totalCatalogCount) Cards")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.12))
                            .clipShape(Capsule())
                    }
                    Text("Deck dos 81 Conectivos")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    Text("Flashcards com regras de ouro e maestria")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.appCardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)

            NavigationLink(value: AppRoute.connectorsMatch) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .foregroundStyle(.orange)
                        Spacer()
                        Text("6x6")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.orange)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange.opacity(0.12))
                            .clipShape(Capsule())
                    }
                    Text("Match Rápido")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    Text("Associação ágil de conectivo e significado")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.appCardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - 7. Botão Iniciar

    @ViewBuilder
    private var startButtonView: some View {
        Button(action: {
            Task {
                await viewModel.startSession()
            }
        }) {
            HStack(spacing: 8) {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text("Começar a Praticar")
                        .font(.headline)
                        .fontWeight(.bold)
                    Image(systemName: "arrow.right")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.orange)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.orange.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .disabled(viewModel.isLoading)
        .padding(.top, 4)
    }

    @ViewBuilder
    private func errorBanner(message: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(.orange)
            Text(message)
                .font(.caption)
                .foregroundStyle(.primary)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
