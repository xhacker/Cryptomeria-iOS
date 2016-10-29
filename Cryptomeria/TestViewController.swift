//
//  TestViewController.swift
//  Cryptomeria
//
//  Created by Dongyuan Liu on 2015-10-06.
//  Copyright © 2015 Xhacker. All rights reserved.
//

import UIKit

let kScoreRightColor = UIColor(red: 103.0/255.0, green: 180.0/255.0, blue: 32.0/255.0, alpha: 1)

let kNormalButtonImage = "option-normal"
let kWrongButtonImage = "option-wrong"
let kRightButtonImage = "option-right"

let kAvenirFont = "AvenirNext-Medium"
let kAvenirBoldFont = "AvenirNext-Bold"
let kHiraKakuFont = "HiraKakuProN-W3"
let kHiraKakuBoldFont = "HiraKakuProN-W6"
let kHiraMinchoFont = "HiraMinProN-W3"

let kKanaRangeKey = "KanaRange"
let kDirectionKey = "Direction"
let kKanaSetKey = "Hork"
let kRangeMax = 25

enum Direction: Int {
    case kanaRomaji = 0
    case romajiKana
}

enum KanaSet: Int {
    case hiragana = 0
    case katakana
    case both
}

class TestViewController: UIViewController {
    @IBOutlet var directionControl: UISegmentedControl!
    @IBOutlet var kanaSetControl: UISegmentedControl!
    @IBOutlet var rangeDecreaseButton: UIButton!
    @IBOutlet var rangeIncreaseButton: UIButton!
    @IBOutlet var rangeLabelButton: UIButton!
    @IBOutlet var mainKanaLabel: UILabel!
    @IBOutlet var mainKanaLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet var mainRomajiLabel: UILabel!
    @IBOutlet var optionButtons: [UIButton]!
    @IBOutlet var scoreLabel: UILabel!
    
    weak var mainLabel: UILabel!
    let defaults = UserDefaults.standard
    var sequence: [Int] = []
    var prevKanaSet: KanaSet = .katakana
    var rightText: String = ""
    weak var rightButton: UIButton!
    var correctCount: Int = 0
    var totalCount: Int = 0
    let flattenedRomaji: [String]
    let flattenedHiragana: [String]
    let flattenedKatakana: [String]
    var inGuess = true
    
    var direction: Direction {
        return Direction(rawValue: defaults.integer(forKey: kDirectionKey))!
    }
    
    required init?(coder aDecoder: NSCoder) {
        flattenedRomaji = (CMChartData.romaji() as NSArray).flatten() as! [String]
        flattenedHiragana = (CMChartData.hiragana() as NSArray).flatten() as! [String]
        flattenedKatakana = (CMChartData.katakana() as NSArray).flatten() as! [String]
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateRangeLabelAndButton()
        let directionIndex = defaults.integer(forKey: kDirectionKey)
        directionControl.selectedSegmentIndex = directionIndex
        let kanaSet = defaults.integer(forKey: kKanaSetKey)
        kanaSetControl.selectedSegmentIndex = kanaSet
        
        generateSequence()
        resetScore()
        updateOptionsFont()
        next()
    }
    
    func generateSequence() {
        sequence = []
        let kanaRange = defaults.integer(forKey: kKanaRangeKey)
        let last = CMChartData.last(inRow: kanaRange)
        
        for i in 0...last {
            sequence.append(i)
        }
        
        sequence.shuffle()
    }
    
    func resetScore() {
        correctCount = 0
        totalCount = 0
        scoreLabel.isHidden = true
    }
    
    func next() {
        let kanaSet = KanaSet(rawValue: defaults.integer(forKey: kKanaSetKey))!
        let kanaRange = defaults.integer(forKey: kKanaRangeKey)
        
        if sequence.count == 0 {
            generateSequence()
        }
    
        let thisID = sequence.last!
        sequence.removeLast()
        
        var thisKanaSet = kanaSet
        if kanaSet == .both {
            thisKanaSet = (prevKanaSet == .hiragana) ? .katakana : .hiragana
            prevKanaSet = thisKanaSet
        }
        
        // main label
        var mainText = ""
        if direction == .romajiKana {
            mainText = flattenedRomaji[thisID]
        }
        else if thisKanaSet == .hiragana {
            mainText = flattenedHiragana[thisID]
        }
        else if thisKanaSet == .katakana {
            mainText = flattenedKatakana[thisID]
        }
        mainLabel.text = mainText
        updateMainLabelFont()
        
        
        var section = CMChartData.getSection(thisID)
        let lastInRange = CMChartData.last(inRow: kanaRange)
        if section.last > lastInRange {
            section.last = lastInRange
        }
        
        let rightOption = Int(arc4random() % 4);
        if direction == .kanaRomaji {
            rightText = flattenedRomaji[thisID]
        }
        else if thisKanaSet == .hiragana {
            rightText = flattenedHiragana[thisID]
        }
        else if thisKanaSet == .katakana {
            rightText = flattenedKatakana[thisID]
        }
        optionButtons[rightOption].setWhiteAttributedTitle(rightText, for: UIControlState())
        rightButton = optionButtons[rightOption]
        var usedIDs = [thisID]
        
        for i in 0...3 {
            if i == rightOption {
                continue
            }
            var kanaID: Int!
            repeat {
                let sectionLength = section.last - section.first + 1
                kanaID = section.first + Int(UInt(arc4random()) % UInt(sectionLength))
            } while !isValidOption(usedIDs, newKanaID: kanaID)
            usedIDs.append(kanaID)
        
            var thisText = ""
            if direction == .kanaRomaji {
                thisText = flattenedRomaji[kanaID]
            }
            else if thisKanaSet == .hiragana {
                thisText = flattenedHiragana[kanaID]
            }
            else if thisKanaSet == .katakana {
                thisText = flattenedKatakana[kanaID]
            }
            optionButtons[i].setWhiteAttributedTitle(thisText, for: UIControlState())
        }
        
        // refresh buttons
        for button in optionButtons {
            button.setBackgroundImage(UIImage(named: kNormalButtonImage, in: Bundle.main, compatibleWith: view.traitCollection), for: UIControlState())
        }
    }
    
    func isValidOption(_ existingIDs: [Int], newKanaID: Int) -> Bool {
        if existingIDs.contains(newKanaID) {
            return false
        }
        
        let existingRomajis = existingIDs.map({ self.flattenedRomaji[$0] })
        if existingRomajis.contains(flattenedRomaji[newKanaID]) {
            return false
        }
        
        return true
    }
    
    @IBAction func rangeDecreased(_ sender: UIButton) {
        var range = defaults.integer(forKey: kKanaRangeKey)
        if range > 0 {
            range -= 1
        }
        defaults.set(range, forKey: kKanaRangeKey)
        rangeChanged()
    }
    
    @IBAction func rangeIncreased(_ sender: UIButton) {
        var range = defaults.integer(forKey: kKanaRangeKey)
        if range < kRangeMax {
            range += 1
        }
        defaults.set(range, forKey: kKanaRangeKey)
        rangeChanged()
    }
    
    func rangeChanged() {
        updateRangeLabelAndButton()
        generateSequence()
        resetScore()
        next()
    }
    
    func updateRangeLabelAndButton() {
        let range = defaults.integer(forKey: kKanaRangeKey)
        
        rangeDecreaseButton.isEnabled = (range > 0)
        rangeIncreaseButton.isEnabled = (range < kRangeMax)
        
        let rangeText = "あ－\(CMChartData.hiragana()[range][0])"
        rangeLabelButton.setTitle(rangeText, for: .normal)
    }
    
    @IBAction func directionChanged(_ sender: UISegmentedControl) {
        defaults.set(sender.selectedSegmentIndex, forKey: kDirectionKey)
        generateSequence()
        resetScore()
        updateOptionsFont()
        next()
    }
    
    @IBAction func kanaSetChanged(_ sender: UISegmentedControl) {
        defaults.set(sender.selectedSegmentIndex, forKey: kKanaSetKey)
        generateSequence()
        resetScore()
        next()
    }
    
    @IBAction func optionClicked(_ sender: UIButton) {
        if inGuess {
            totalCount += 1
        }
        
        if sender.currentAttributedTitle!.string == rightText {
            if inGuess {
                correctCount += 1;
            }
            inGuess = true
            next()
        }
        else {
            inGuess = false
            sender.setBackgroundImage(UIImage(named: kWrongButtonImage, in: Bundle.main, compatibleWith: view.traitCollection), for: UIControlState())

            rightButton.setBackgroundImage(UIImage(named: kRightButtonImage, in: Bundle.main, compatibleWith: view.traitCollection), for: UIControlState())
        }
        
        let correctText = "\(correctCount)"
        let totalText = "\(totalCount)"
        let scoreText = "\(correctText) / \(totalText)"
        
        let scoreAttributedString = NSMutableAttributedString(string: scoreText)
        let attributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: kScoreRightColor,
            NSFontAttributeName: UIFont(name: kAvenirBoldFont, size: scoreLabel.font.pointSize)!
        ]
        scoreAttributedString.addAttributes(attributes, range: NSMakeRange(0, correctText.characters.count))
        
        scoreLabel.isHidden = false
        scoreLabel.attributedText = scoreAttributedString
    }
    
    // MARK: - Appearance
    
    func updateMainLabelFont() {
        if direction == .kanaRomaji {
            var fontSize: CGFloat = 140
            if view.traitCollection.horizontalSizeClass == .regular {
                fontSize = 190
            }
            if view.traitCollection.verticalSizeClass == .compact {
                fontSize = 100
            }
            
            let mainText = mainLabel.text ?? ""
            if mainText.characters.count > 1 {
                fontSize *= 0.85
            }
            
            let attributes = [NSFontAttributeName: UIFont(name: kHiraMinchoFont, size: fontSize)!]
            mainLabel.attributedText = NSAttributedString(string: mainText, attributes: attributes)
        }
    }
    
    func updateOptionsFont() {
        let fontSize: CGFloat = (view.traitCollection.horizontalSizeClass == .regular) ? 23 : 20
        if direction == .kanaRomaji {
            mainRomajiLabel.isHidden = true
            mainKanaLabel.isHidden = false
            mainLabel = mainKanaLabel
            for optionButton in optionButtons {
                optionButton.titleLabel?.font = UIFont(name: kAvenirFont, size: fontSize)
            }
        }
        else {
            mainKanaLabel.isHidden = true
            mainRomajiLabel.isHidden = false
            mainLabel = mainRomajiLabel
            for optionButton in optionButtons {
                optionButton.titleLabel?.font = UIFont(name: kHiraKakuFont, size: fontSize)
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateMainLabelFont()
        updateOptionsFont()
    }
}
