//
//  AudioPlayerClient.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import AVFoundation
import ComposableArchitecture

struct AudioPlayerClient {
    var load: @Sendable (URL) async -> AsyncStream<TimeInterval>
    var play: @Sendable () async -> Bool
    var pause: @Sendable () async -> Bool
    var seekForward: @Sendable () async -> TimeInterval
    var seekBackward: @Sendable () async -> TimeInterval
    var seekTo: @Sendable (TimeInterval) async -> TimeInterval
    var setRate: @Sendable (Float) async -> Void
    var observeProgress: @Sendable () async -> AsyncStream<TimeInterval>
    var observeInterruptions: @Sendable () async -> AsyncStream<Void>
    var observePlayEnd: @Sendable () async -> AsyncStream<Void>
}

extension DependencyValues {
    var audioPlayer: AudioPlayerClient {
        get { self[AudioPlayerClient.self] }
        set { self[AudioPlayerClient.self] = newValue }
    }
}

extension AudioPlayerClient: DependencyKey {
    static let liveValue: AudioPlayerClient = {
        let service = AudioPlayerService()

        return AudioPlayerClient(
            load: { await service.load(url: $0) },
            play: { await service.play() },
            pause: { await service.pause() },
            seekForward: { await service.seekForward() },
            seekBackward: { await service.seekBackward() },
            seekTo: { await service.seek(to: $0) },
            setRate: { await service.set(rate: $0) },
            observeProgress: { await service.observeProgress() },
            observeInterruptions: { await service.interruptionStream },
            observePlayEnd: { await service.observePlayEnd() }
        )
    }()
}

private actor AudioPlayerService {
    var isPlaying: Bool { player.rate != 0 && player.error == nil && duration != 0 }
    var currentTime: TimeInterval { player.currentTime().seconds }
    var duration: TimeInterval {
        guard let duration = player.currentItem?.duration else {
            return 0
        }

        return duration.seconds
    }

    private let interruptionStreamContinuation = AsyncStream<Void>.makeStream()
    var interruptionStream: AsyncStream<Void> { interruptionStreamContinuation.stream }

    private let player = AVPlayer()
    private nonisolated(unsafe) var timeObserverToken: Any?
    private nonisolated(unsafe) var durationObserverToken: NSKeyValueObservation?
    private nonisolated(unsafe) var interruptionObserverToken: (any NSObjectProtocol)?
    private nonisolated(unsafe) var playToEndObserverToken: (any NSObjectProtocol)?
    private let timeUpdateInterval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    private var currentURL: URL?

    init() {
        observeInterruptionNotifications()
    }

    func load(url: URL) -> AsyncStream<TimeInterval> {
        removeDurationObserver()
        currentURL = url
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)

        return AsyncStream { continuation in
            durationObserverToken = playerItem.observe(\.duration, options: [.initial, .new]) { _, value in
                guard let new = value.newValue else { return }

                continuation.yield(new.seconds.normalized)
            }
        }
    }

    func play() -> Bool {
        player.play()

        return isPlaying
    }

    func pause() -> Bool {
        player.pause()

        return isPlaying
    }

    func seekForward() -> TimeInterval {
        let currentTime = player.currentTime()
        let newTime = CMTimeAdd(currentTime, CMTime(seconds: 10, preferredTimescale: 1))
        player.seek(to: newTime)

        return newTime.seconds.normalized
    }

    func seek(to time: TimeInterval) -> TimeInterval {
        player.seek(to: CMTime(seconds: time, preferredTimescale: 1))

        return min(time.normalized, duration)
    }

    func seekBackward() -> TimeInterval {
        let currentTime = player.currentTime()
        let newTime = CMTimeSubtract(currentTime, CMTime(seconds: 5, preferredTimescale: 1))
        player.seek(to: max(newTime, .zero))

        return newTime.seconds.normalized
    }

    func set(rate: Float) {
        player.rate = rate
    }

    func observePlayEnd() -> AsyncStream<Void> {
        removePlayToEndObserver()

        return AsyncStream { continuation in
            if let playerItem = player.currentItem {
                playToEndObserverToken = NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: playerItem,
                    queue: .main
                ) { _ in
                    continuation.yield(())
                }
            } else {
                continuation.finish()
            }
        }
    }

    func observeProgress() -> AsyncStream<TimeInterval> {
        removeTimeObserver()

        return AsyncStream { continuation in
            timeObserverToken = player.addPeriodicTimeObserver(
                forInterval: timeUpdateInterval,
                queue: .main
            ) { time in
                continuation.yield(time.seconds)
            }
        }
    }

    private nonisolated func observeInterruptionNotifications() {
        removeInterruptionObserver()
        // Just handle interruption to pause. Play again by hand.
        interruptionObserverToken = NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance(),
            queue: .current
        ) { [weak self] notification in
            guard let self,
                let userInfo = notification.userInfo,
                let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                let type = AVAudioSession.InterruptionType(rawValue: typeValue),
                type == .began
            else { return }

            interruptionStreamContinuation.continuation.yield(())
        }
    }

    private nonisolated func removeDurationObserver() {
        durationObserverToken?.invalidate()
        durationObserverToken = nil
    }

    private nonisolated func removePlayToEndObserver() {
        if let playToEndObserverToken {
            NotificationCenter.default.removeObserver(playToEndObserverToken)
            self.playToEndObserverToken = nil
        }
    }

    private nonisolated func removeTimeObserver() {
        if let timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }

    private nonisolated func removeInterruptionObserver() {
        if let interruptionObserverToken {
            NotificationCenter.default.removeObserver(interruptionObserverToken)
            self.interruptionObserverToken = nil
        }
    }

    deinit {
        removePlayToEndObserver()
        removeDurationObserver()
        removeTimeObserver()
        removeInterruptionObserver()
    }
}
