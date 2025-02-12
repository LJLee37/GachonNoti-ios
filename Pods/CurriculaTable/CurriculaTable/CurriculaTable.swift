//
//  CurriculaTable.swift
//  CurriculaTable
//
//  Created by Sun Yaozhu on 2016-09-10.
//  Copyright © 2016 Sun Yaozhu. All rights reserved.
//
import UIKit

public class CurriculaTable: UIView {
    
    private let controller = CurriculaTableController()
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    public var weekdaySymbolType = CurriculaTableWeekdaySymbolType.short {
        didSet {
            //collectionView.reloadData()
        }
    }
    
    public var firstWeekday = CurriculaTableWeekday.monday {
        didSet {
            //collectionView.reloadData()
            drawCurricula()
        }
    }
    
    public var numberOfPeriods = 54 {
        didSet {
            //collectionView.reloadData()
            drawCurricula()
        }
    }
    
    public var curricula = [CurriculaTableItem]() {
        didSet {
            drawCurricula()
        }
    }
    
    public var bgColor = UIColor.clear {
        didSet {
            collectionView.backgroundColor = bgColor
        }
    }
    
    public var symbolsBgColor = UIColor.clear {
        didSet {
            //collectionView.reloadData()
        }
    }
    
    public var symbolsFontSize = CGFloat(14) {
        didSet {
            //collectionView.reloadData()
        }
    }
    
    public var heightOfWeekdaySymbols = CGFloat(28) {
        didSet {
            //collectionView.reloadData()
            drawCurricula()
        }
    }
    
    public var widthOfPeriodSymbols = CGFloat(32) {
        didSet {
            //collectionView.reloadData()
            drawCurricula()
        }
    }
    
    public var borderWidth = CGFloat(1) {
        didSet {
            //collectionView.reloadData()
        }
    }
    
    //UIColor.clear
    public var borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9) {
        didSet {
            //collectionView.reloadData()
        }
    }
    
    public var cornerRadius = CGFloat(0) {
        didSet {
            drawCurricula()
        }
    }
    
    public var rectEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            drawCurricula()
        }
    }
    
    public var textEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            drawCurricula()
        }
    }
    
    public var textFontSize = CGFloat(11) {
        didSet {
            drawCurricula()
        }
    }
    
    public var textAlignment = NSTextAlignment.center {
        didSet {
            drawCurricula()
        }
    }
    
    public var maximumNameLength = 0 {
        didSet {
            drawCurricula()
        }
    }
    
    var weekdaySymbols: [String] {
        var weekdaySymbols = [String]()
        
        switch weekdaySymbolType {
        case .normal:
            weekdaySymbols = Calendar.current.standaloneWeekdaySymbols
        case .short:
            weekdaySymbols = Calendar.current.shortStandaloneWeekdaySymbols
        case .veryShort:
            weekdaySymbols = Calendar.current.veryShortStandaloneWeekdaySymbols
        }
        let firstWeekdayIndex = firstWeekday.rawValue - 1
        weekdaySymbols.rotate(shiftingToStart: firstWeekdayIndex)
        
        return ["월","화","수","목","금","-","-"]
    }
    
    var averageHeight: CGFloat {
        return (collectionView.frame.height - heightOfWeekdaySymbols) / CGFloat(numberOfPeriods)
    }
    
    var averageWidth: CGFloat {
        return (collectionView.frame.width - widthOfPeriodSymbols) / 5 - 0.1
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        controller.curriculaTable = self
        controller.collectionView = collectionView
        
        collectionView.dataSource = controller
        collectionView.delegate = controller
        collectionView.backgroundColor = bgColor
        addSubview(collectionView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
        //collectionView.reloadData()
        drawCurricula()
    }
    
    private func drawCurricula() {
        for subview in subviews {
            if !(subview is UICollectionView) {
                subview.removeFromSuperview()
            }
        }
        for (index, curriculum) in curricula.enumerated() {
            let weekdayIndex = (curriculum.weekday.rawValue - firstWeekday.rawValue + 7) % 7
            let x = widthOfPeriodSymbols + averageWidth * CGFloat(weekdayIndex) + rectEdgeInsets.left
            let y = heightOfWeekdaySymbols + averageHeight * CGFloat(curriculum.startPeriod - 1) + rectEdgeInsets.top
            //여기
            let width = averageWidth - rectEdgeInsets.left - rectEdgeInsets.right - 1
            let height = averageHeight * CGFloat(curriculum.endPeriod - curriculum.startPeriod + 1) - rectEdgeInsets.top - rectEdgeInsets.bottom - 1
            let view = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
            view.backgroundColor = curriculum.bgColor
            view.layer.cornerRadius = cornerRadius
            view.layer.masksToBounds = true
            
            let label = UILabel(frame: CGRect(x: textEdgeInsets.left, y: textEdgeInsets.top, width: view.frame.width - textEdgeInsets.left - textEdgeInsets.right, height: view.frame.height - textEdgeInsets.top - textEdgeInsets.bottom))
            var name = curriculum.name
            if maximumNameLength > 0 {
                name.truncate(maximumNameLength)
            }
            let attrStr = NSMutableAttributedString(string: name + "\n\n" + curriculum.place, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: textFontSize)])
            attrStr.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: textFontSize)], range: NSRange(0..<name.count))
            label.attributedText = attrStr
            label.textColor = curriculum.textColor
            label.textAlignment = textAlignment
            label.numberOfLines = 0
            label.tag = index
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(curriculumTapped)))
            label.isUserInteractionEnabled = true
            
            view.addSubview(label)
            addSubview(view)
        }
    }
    
    @objc func curriculumTapped(_ sender: UITapGestureRecognizer) {
        let curriculum = curricula[(sender.view as! UILabel).tag]
        curriculum.tapHandler(curriculum)
    }
    
}
