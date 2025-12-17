//
//  ViewController.swift
//  Musicplayer
//
//  Created by Daniyal Baimenov on 13.12.2025.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    
    private var tracks: [Track] = []
    private var currentTrackIndex = 0
    private var isPlaying = false
    private var audioPlayer: AVAudioPlayer?
    private var progressTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTracks()
        updateUI()
        setupUI()
        setupProgressSlider()
        // Do any additional setup after loading the view.
    }
    
    private func setupTracks() {
        tracks = [Track(title: "Беги", artist: "Macan", coverImageName: "cover1", audioFileName: "song1", duration: 354),
                  Track(title: "Шоколад", artist: "Bonapart feat Madi Rymbaev", coverImageName: "cover2", audioFileName: "song2", duration: 215)]
    }
    
    private func setupUI() {
        
        currentTimeLabel.text = "0:00"
        totalTimeLabel.text = "0:00"
        currentTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        totalTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        
    }
    
    private func setupProgressSlider() {
        
        progressSlider.minimumValue = 0
        progressSlider.value = 0
        progressSlider.isContinuous = true
        progressSlider.addTarget(self, action: #selector(progressSliderChanged), for: .valueChanged)
        
    }
        
    private func updateUI(){
        let track = tracks[currentTrackIndex]
        coverImageView.image = UIImage(named: track.coverImageName)
        trackTitleLabel.text = track.title
        artistNameLabel.text = track.artist
        
        let imageName = isPlaying ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        totalTimeLabel.text = formatTime(track.duration)
        progressSlider.maximumValue = Float(track.duration)
        
    }
    
    private func loadAudio(){
        let track = tracks[currentTrackIndex]
        guard let url = Bundle.main.url(forResource: track.audioFileName, withExtension: "mp3")else{
            print("Audio file not found: \(track.audioFileName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error loading audio: \(error)")
        }
    }
    
    private func animateButton(_ button: UIButton){
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = .identity
            }
        }
    }
    
    @IBAction func previouseButtonTapped(_ sender: UIButton) {
        animateButton(sender)
        
        if currentTrackIndex > 0 {
            currentTrackIndex -= 1
        } else {
            currentTrackIndex = tracks.count - 1
        }
        audioPlayer?.stop()
        progressSlider.value = 0
        currentTimeLabel.text = "0:00"
        
        updateUI()
        loadAudio()
        
        if isPlaying {
            audioPlayer?.play()
            startProgressTimer()
        }
        
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        animateButton(sender)
        
        if currentTrackIndex < tracks.count - 1 {
            currentTrackIndex += 1
        }
        else{
            currentTrackIndex = 0
        }
        audioPlayer?.stop()
        progressSlider.value = 0
        currentTimeLabel.text = "0:00"

        loadAudio()
        updateUI()
        
        if isPlaying {
            audioPlayer?.play()
            startProgressTimer()
        }
        
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        animateButton(sender)
        
        if isPlaying{
            audioPlayer?.pause()
            stopProgressTimer()
            isPlaying = false
        } else{
            if audioPlayer == nil{
                loadAudio()
            }
            audioPlayer?.play()
            stopProgressTimer()
            isPlaying = true
        }
        updateUI()
    }
    private func formatTime(_ seconds: Int) -> String {
            let minutes = seconds / 60
            let remainingSeconds = seconds % 60
            return String(format: "%d:%02d", minutes, remainingSeconds)
    }
        
    private func startProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateProgress()
        }
    }
        
    private func stopProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
        
    private func updateProgress() {
        guard let player = audioPlayer else { return }
        
        let currentTime = Int(player.currentTime)
        currentTimeLabel.text = formatTime(currentTime)
        progressSlider.value = Float(player.currentTime)
    }
        
    @objc private func progressSliderChanged() {
        audioPlayer?.currentTime = TimeInterval(progressSlider.value)
        updateProgress()
    }
}
