//
//  SpeechSynthesizerService.swift
//  English along with John - Presentation / Common / Services
//

import Foundation
import AVFoundation

/// Serviço nativo de Text-to-Speech usando AVFoundation da Apple.
/// Permite ao aluno ouvir a pronúncia correta em inglês nativo sem depender de internet.
@MainActor
public final class SpeechSynthesizerService: NSObject, @unchecked Sendable {
    public static let shared = SpeechSynthesizerService()

    private let synthesizer = AVSpeechSynthesizer()

    private override init() {
        super.init()
    }

    public func speak(_ text: String, rate: Float = 0.48) {
        synthesizer.stopSpeaking(at: .immediate)

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = rate
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0

        synthesizer.speak(utterance)
    }

    public func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
