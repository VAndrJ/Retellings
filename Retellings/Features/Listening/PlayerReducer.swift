//
//  PlayerReducer.swift
//  Retellings
//
//  Created by VAndrJ on 4/19/25.
//

import ComposableArchitecture
import Foundation
import TCAComposer

@Composer
struct PlayerReducer {
    struct State: Equatable {
        var isPlaying = false
        var currentTime: TimeInterval = 0
        var rate: Float = 1.0
        var duration: TimeInterval = 0
    }

    enum Actions: Equatable {
        enum Effect {
            case resetCurrentTime
            case load(URL)
            case progressUpdated(TimeInterval)
            case playbackInterrupted
            case playChanged(Bool)
            case updateDuration(TimeInterval)
            case play
            case pause
            case observeProgressStream
            case observeInterruptionStream
            case observePlayEnd
        }

        enum View {
            case playPause
            case seekForward
            case seekBackward
            case seek(toTime: TimeInterval)
            case updateRate(Float)
        }
    }

    private enum CancelToken {
        case progress
        case duration
        case interruption
        case playEnd
    }

    @Dependency(\.audioPlayer)
    private var audioPlayer

    @ComposeBodyActionCase
    func effect(state: inout State, action: Actions.Effect) -> EffectOf<Self> {
        switch action {
        case .resetCurrentTime:
            state.currentTime = 0

            return .none
        case .play:
            let rate = state.rate

            return .concatenate(
                .run { send in
                    let isPlaying = await audioPlayer.play()
                    await send(.effect(.playChanged(isPlaying)))
                },
                .run { _ in await audioPlayer.setRate(rate) }
            )
        case .pause:
            return .run { send in
                let isPlaying = await audioPlayer.pause()
                await send(.effect(.playChanged(isPlaying)))
            }
        case let .load(url):
            return .concatenate(
                .run { send in
                    await send(.effect(.pause))
                },
                .run { send in
                    await send(.effect(.resetCurrentTime))
                },
                .run { send in
                    let duration = await audioPlayer.load(url)
                    for await time in duration {
                        await send(.effect(.updateDuration(time)))
                    }
                }
                .cancellable(id: CancelToken.duration, cancelInFlight: true)
            )
        case let .updateDuration(duration):
            print("duration", duration)
            state.duration = duration

            return .none
        case let .playChanged(isPlaying):
            state.isPlaying = isPlaying
            if isPlaying {
                return .merge(
                    .send(.effect(.observeProgressStream)),
                    .send(.effect(.observeInterruptionStream)),
                    .send(.effect(.observePlayEnd))
                )
            } else {
                return .merge(
                    .cancel(id: CancelToken.interruption),
                    .cancel(id: CancelToken.progress),
                    .cancel(id: CancelToken.playEnd)
                )
            }
        case let .progressUpdated(time):
            state.currentTime = time

            return .none
        case .playbackInterrupted:
            return .run { send in
                let isPlaying = await audioPlayer.pause()
                await send(.effect(.playChanged(isPlaying)))
            }
        case .observeProgressStream:
            return .run { send in
                for await time in await audioPlayer.observeProgress() {
                    await send(.effect(.progressUpdated(time)))
                }
            }
            .cancellable(id: CancelToken.progress, cancelInFlight: true)
        case .observeInterruptionStream:
            return .run { send in
                for await _ in await audioPlayer.observeInterruptions() {
                    await send(.effect(.playbackInterrupted))
                }
            }
            .cancellable(id: CancelToken.interruption, cancelInFlight: true)
        case .observePlayEnd:
            return .run { send in
                for await _ in await audioPlayer.observePlayEnd() {
                    await send(.effect(.pause))
                }
            }
            .cancellable(id: CancelToken.playEnd, cancelInFlight: true)
        }
    }

    @ComposeBodyActionCase
    func view(state: inout State, action: Actions.View) -> EffectOf<Self> {
        switch action {
        case .playPause:
            if state.isPlaying {
                return .run { send in
                    await send(.effect(.pause))
                }
            } else {
                return .run { send in
                    await send(.effect(.play))
                }
            }
        case .seekForward:
            return .run { send in
                let time = await audioPlayer.seekForward()
                await send(.effect(.progressUpdated(time)))
            }
        case .seekBackward:
            return .run { send in
                let time = await audioPlayer.seekBackward()
                await send(.effect(.progressUpdated(time)))
            }
        case let .seek(toTime):
            if state.currentTime.isRoughlyEqual(to: toTime, precision: 1) {
                return .none
            } else {
                return .run { send in
                    let time = await audioPlayer.seekTo(toTime)
                    await send(.effect(.progressUpdated(time)))
                }
            }
        case let .updateRate(rate):
            state.rate = rate

            return .run { _ in await audioPlayer.setRate(rate) }
        }
    }
}
