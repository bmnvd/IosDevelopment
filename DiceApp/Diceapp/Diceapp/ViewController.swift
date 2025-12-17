//
//  ViewController.swift
//  Diceapp
//
//  Created by Daniyal Baimenov on 13.12.2025.
//

import UIKit

final class ViewController: UIViewController {


    @IBOutlet weak var leftDiceImageView: UIImageView!
    @IBOutlet weak var rightDiceImageView: UIImageView!


    private var diceImages: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        diceImages = (1...6).compactMap { UIImage(named: "dice\($0)") }
        leftDiceImageView.image = diceImages.randomElement()
        rightDiceImageView.image = diceImages.randomElement()
    }

    @IBAction func rollButtonTapped(_ sender: UIButton) {
        rollDice(withHaptics: true)
    }

    private func rollDice(withHaptics: Bool = false) {
        guard diceImages.count == 6 else { return }

        leftDiceImageView.image = diceImages.randomElement()
        rightDiceImageView.image = diceImages.randomElement()

        if withHaptics {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }

    override var canBecomeFirstResponder: Bool { true }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resignFirstResponder()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            rollDice(withHaptics: true)
        }
    }
}
