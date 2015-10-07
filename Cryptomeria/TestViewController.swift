//
//  TestViewController.swift
//  Cryptomeria
//
//  Created by Dongyuan Liu on 2015-10-06.
//  Copyright © 2015 Xhacker. All rights reserved.
//

import UIKit

let kScoreRightColor = UIColor(red: 103.0/255.0, green: 153.0/255.0, blue: 32.0/255.0, alpha: 1)

let kNormalButtonImage = "option-normal"
let kNormalPressingButtonImage = "option-normal-pressing"
let kWrongButtonImage = "option-wrong"
let kWrongPressingButtonImage = "option-wrong-pressing"
let kRightButtonImage = "option-right"
let kRightPressingButtonImage = "option-right-pressing"

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
    case KanaRomaji = 0
    case RomajiKana
}

enum KanaSet: Int {
    case Hiragana = 0
    case Katakana
    case Both
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
    let defaults = NSUserDefaults.standardUserDefaults()
    var sequence: [Int] = []
    var prevKanaSet: KanaSet = .Katakana
    var rightText: String = ""
    weak var rightButton: UIButton!
    var correctCount: Int = 0
    var totalCount: Int = 0
    let flattenedRomaji: [String]
    let flattenedHiragana: [String]
    let flattenedKatakana: [String]
    var inGuess = true
    
    required init?(coder aDecoder: NSCoder) {
        flattenedRomaji = (CMChartData.romaji() as NSArray).flatten() as! [String]
        flattenedHiragana = (CMChartData.hiragana() as NSArray).flatten() as! [String]
        flattenedKatakana = (CMChartData.katakana() as NSArray).flatten() as! [String]
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateRangeLabelAndButton()
        let direction = defaults.integerForKey(kDirectionKey)
        directionControl.selectedSegmentIndex = direction
        let kanaSet = defaults.integerForKey(kKanaSetKey)
        kanaSetControl.selectedSegmentIndex = kanaSet
        
        generateSequence()
        resetScore()
        changeFont()
        next()
    }
    
    func generateSequence() {
        sequence = []
        let kanaRange = defaults.integerForKey(kKanaRangeKey)
        let last = CMChartData.lastInRow(kanaRange)
        
        for i in 0...last {
            sequence.append(i)
        }
        
        sequence.shuffle()
    }
    
    func resetScore() {
        correctCount = 0
        totalCount = 0
        scoreLabel.hidden = true
    }
    
    func next() {
        let kanaSet = KanaSet(rawValue: defaults.integerForKey(kKanaSetKey))!
        let direction = Direction(rawValue: defaults.integerForKey(kDirectionKey))!
        let kanaRange = defaults.integerForKey(kKanaRangeKey)
        
        if sequence.count == 0 {
            generateSequence()
        }
    
        let thisID = sequence.last!
        sequence.removeLast()
        
        var thisKanaSet = kanaSet
        if kanaSet == .Both {
            thisKanaSet = (prevKanaSet == .Hiragana) ? .Katakana : .Hiragana
            prevKanaSet = thisKanaSet
        }
        
        // main label
        var mainText = ""
        if direction == .RomajiKana {
            mainText = flattenedRomaji[thisID]
        }
        else if thisKanaSet == .Hiragana {
            mainText = flattenedHiragana[thisID]
        }
        else if thisKanaSet == .Katakana {
            mainText = flattenedKatakana[thisID]
        }
        var attributes = [String: AnyObject]()
        if direction == .KanaRomaji {
            var fontSize: CGFloat = 140
            if mainText.characters.count > 1 {
                fontSize *= 0.85
            }
            attributes = [NSFontAttributeName: UIFont(name: kHiraMinchoFont, size: fontSize)!]
        }
        mainLabel.attributedText = NSAttributedString(string: mainText, attributes: attributes)
        
        
        
        var section = CMChartData.getSection(thisID)
        let lastInRange = CMChartData.lastInRow(kanaRange)
        if section.last > lastInRange {
            section.last = lastInRange
        }
        
        let rightOption = Int(arc4random() % 4);
        if direction == .KanaRomaji {
            rightText = flattenedRomaji[thisID]
        }
        else if thisKanaSet == .Hiragana {
            rightText = flattenedHiragana[thisID]
        }
        else if thisKanaSet == .Katakana {
            rightText = flattenedKatakana[thisID]
        }
        optionButtons[rightOption].setWhiteAttributedTitle(rightText, forState: .Normal)
        rightButton = optionButtons[rightOption]
        var usedIDs = [thisID]
        
        for i in 0...3 {
            if i == rightOption {
                continue
            }
            var optionID: Int!
            repeat {
                optionID = section.first + Int(arc4random()) % (section.last - section.first + 1)
            } while usedIDs.contains(optionID)
            usedIDs.append(optionID)
        
            var thisText = ""
            if direction == .KanaRomaji {
                thisText = flattenedRomaji[optionID]
            }
            else if thisKanaSet == .Hiragana {
                thisText = flattenedHiragana[optionID]
            }
            else if thisKanaSet == .Katakana {
                thisText = flattenedKatakana[optionID]
            }
            optionButtons[i].setWhiteAttributedTitle(thisText, forState: .Normal)
        }
        
        // refresh buttons
        for button in optionButtons {
            button.setBackgroundImage(UIImage(namedForCurrentDevice: kNormalButtonImage).resizableImageWithCapInsets(UIEdgeInsetsMake(0, 10, 0, 10)), forState: .Normal)
            button.setBackgroundImage(UIImage(namedForCurrentDevice: kNormalPressingButtonImage).resizableImageWithCapInsets(UIEdgeInsetsMake(0, 10, 0, 10)), forState: .Highlighted)
        }
    }
    
    @IBAction func rangeDecreased(sender: UIButton) {
        var range = defaults.integerForKey(kKanaRangeKey)
        if range > 0 {
            range -= 1
        }
        defaults.setInteger(range, forKey: kKanaRangeKey)
        rangeChanged()
    }
    
    @IBAction func rangeIncreased(sender: UIButton) {
        var range = defaults.integerForKey(kKanaRangeKey)
        if range < kRangeMax {
            range += 1
        }
        defaults.setInteger(range, forKey: kKanaRangeKey)
        rangeChanged()
    }
    
    func rangeChanged() {
        updateRangeLabelAndButton()
        generateSequence()
        resetScore()
        next()
    }
    
    func updateRangeLabelAndButton() {
        let range = defaults.integerForKey(kKanaRangeKey)
        
        rangeDecreaseButton.enabled = (range > 0)
        rangeIncreaseButton.enabled = (range < kRangeMax)
        
        let rangeText = "あ－\(CMChartData.hiragana()[range][0])"
        rangeLabelButton.setTitle(rangeText, forState: .Normal)
    }
    
    @IBAction func directionChanged(sender: UISegmentedControl) {
        defaults.setInteger(sender.selectedSegmentIndex, forKey: kDirectionKey)
        generateSequence()
        resetScore()
        changeFont()
        next()
    }
    
    func changeFont() {
        let direction = Direction(rawValue: defaults.integerForKey(kDirectionKey))!
        let fontSize: CGFloat = 20
        if direction == .KanaRomaji {
            mainRomajiLabel.hidden = true
            mainKanaLabel.hidden = false
            mainLabel = mainKanaLabel
            for optionButton in optionButtons {
                optionButton.titleLabel?.font = UIFont(name: kAvenirFont, size: fontSize)
            }
        }
        else {
            mainKanaLabel.hidden = true
            mainRomajiLabel.hidden = false
            mainLabel = mainRomajiLabel
            for optionButton in optionButtons {
                optionButton.titleLabel?.font = UIFont(name: kHiraKakuFont, size: fontSize)
            }
        }
    }
    
    @IBAction func kanaSetChanged(sender: UISegmentedControl) {
        defaults.setInteger(sender.selectedSegmentIndex, forKey: kKanaSetKey)
        generateSequence()
        resetScore()
        next()
    }
    
    @IBAction func optionClicked(sender: UIButton) {
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
            sender.setBackgroundImage(UIImage(namedForCurrentDevice: kWrongButtonImage).resizableImageWithCapInsets(UIEdgeInsetsMake(0, 10, 0, 10)), forState: .Normal)
            sender.setBackgroundImage(UIImage(namedForCurrentDevice: kWrongPressingButtonImage).resizableImageWithCapInsets(UIEdgeInsetsMake(0, 10, 0, 10)), forState: .Highlighted)

            rightButton.setBackgroundImage(UIImage(namedForCurrentDevice: kRightButtonImage).resizableImageWithCapInsets(UIEdgeInsetsMake(0, 10, 0, 10)), forState: .Normal)
            rightButton.setBackgroundImage(UIImage(namedForCurrentDevice: kRightPressingButtonImage).resizableImageWithCapInsets(UIEdgeInsetsMake(0, 10, 0, 10)), forState: .Highlighted)
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
        
        scoreLabel.hidden = false
        scoreLabel.attributedText = scoreAttributedString
    }
}
