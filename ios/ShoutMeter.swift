import Foundation
import AVFoundation

@objc(ShoutMeter)
class ShoutMeter: RCTEventEmitter {
  var recorder: AVAudioRecorder?
  var timer: Timer?

  @objc
  override static func requiresMainQueueSetup() -> Bool {
    return false
  }

  @objc
  func start(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    let settings = [
      AVFormatIDKey: Int(kAudioFormatAppleLossless),
      AVSampleRateKey: 44100.0,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
    ]

    let url = URL(fileURLWithPath: "/dev/null")

    do {
      recorder = try AVAudioRecorder(url: url, settings: settings)
      recorder?.isMeteringEnabled = true
      recorder?.prepareToRecord()
      recorder?.record()

      timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
        self.recorder?.updateMeters()
        let level = self.recorder?.averagePower(forChannel: 0) ?? -160
        let normalized = self.normalizePower(level)
        self.sendEvent(withName: "onShoutLevel", body: ["level": normalized])
      }

      resolve("Started recording")
    } catch {
      reject("record_error", "Failed to start recording", error)
    }
  }

  @objc
  func stop() {
    timer?.invalidate()
    recorder?.stop()
    recorder = nil
  }

  override func supportedEvents() -> [String]! {
    return ["onShoutLevel"]
  }

  private func normalizePower(_ db: Float) -> Float {
    let minDb: Float = -60
    let maxDb: Float = 0
    return max(0, min(1, (db - minDb) / (maxDb - minDb)))
  }
}
