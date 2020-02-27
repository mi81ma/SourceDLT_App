//
//  HistoryViewController.swift
//  SourceDLT_App
//
//  Created by masato on 26/2/2020.
//  Copyright © 2020 Masato Miyai. All rights reserved.
//



import UIKit

class CustomWidthView: UIView {
    var width = 1.0

    override public var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 0)
    }
}


class CustomHeightView: UIView {
    var height = 1.0

    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: height)
    }
}



// (4) セルのレイアウトを指定するクラスを作る
class HistoryCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        setupViews()
    }

    let wordLabel: UILabel = {
        let label = UILabel()
        label.text = "TEST TEST TEST"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func setupViews() {
        backgroundColor = .white

        //MARK: 1. Vertical Split View
        addSubview(wordLabel)
        wordLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        wordLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        wordLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        wordLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true


        let stackView = UIStackView(arrangedSubviews: [redView, greenView])

        stackView.axis = .horizontal
        stackView.spacing = 1

        stackView.distribution = .fillProportionally
        stackView.alignment = .fill

        stackView.isBaselineRelativeArrangement = false
        stackView.isLayoutMarginsRelativeArrangement = false


        stackView.subviews[0].widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 350 / 1000, constant: 0).isActive = true
        stackView.subviews[1].widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 650 / 1000, constant: 0).isActive = true



        wordLabel.addSubview(stackView)



        stackView.translatesAutoresizingMaskIntoConstraints  = false
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .zero)

    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    //MARK: 1. Vertical Split View Parts
    let redView: CustomWidthView = {
        let view = CustomWidthView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()


    let greenView: CustomWidthView = {
        let view = CustomWidthView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()


    let cyanView: CustomWidthView = {
        let view = CustomWidthView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cyan
        return view
    }()




    //MARK: 2. Horizontal Split Red View
    let orangeview: CustomHeightView = {
        let view = CustomHeightView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange
        return view
    }()


}





class HeaderCell: UICollectionViewCell {

    //    var homeControllerObj = HomeController()

    var line01: CGFloat = 0
    var line02: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()

    }

    let wordLabel: UILabel = {
        let label = UILabel()
        label.text = "TEST TEST TEST"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let lineVertical: UIView = {
        let line = UIView()
        line.backgroundColor = .white
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()


    let lineHorisontal: UIView = {
        let line = UIView()
        line.backgroundColor = .black
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()


    func setupViews() {
        backgroundColor = #colorLiteral(red: 0.01358020119, green: 0.1929352582, blue: 0.4004852176, alpha: 1)

        addSubview(wordLabel)
        addSubview(lineHorisontal)
        addSubview(lineVertical)


        wordLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        wordLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        wordLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        wordLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true


        lineVertical.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 200, bottom: 0, right: 0), size: CGSize(width: 1, height: 50))

        lineHorisontal.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 700, height: 2))


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





class HistoryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {


    let cellId = "cellId"
    let headerId = "headerId"


    // Button Transition to Object3dDetectionViewController
    lazy var transitionButton: UIButton = {
        let button = UIButton()

        return button
    }()



    override func viewDidLoad() {
        super.viewDidLoad()

        //        line01 = view.frame.width / 43  * 18
        //        line02 = view.frame.width / 43  * 15


        collectionView.backgroundColor = .white

        // (5) レイアウトクラスを登録する
        collectionView.register(HistoryCell.self, forCellWithReuseIdentifier: cellId)

        // headerの登録
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)


        // navigationItem Left Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white

        // navigation Title Image
//        let imageView = UIImageView(image: #imageLiteral(resourceName: "object_image_cat"))
//        imageView.contentMode = UIView.ContentMode.scaleAspectFit
//        navigationItem.titleView = imageView


        // navigation bar title
        navigationController?.navigationBar.topItem?.title = "Example Medicine History"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]



        // navigation bar color
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.07887881249, green: 0.231888473, blue: 0.5004345179, alpha: 1)


        // Button Transition to Object3dDetectionViewController
        detection3DTransitionButton.frame = CGRect(x: view.frame.maxX - 80, y: 100, width: 70, height: 70)
        view.addSubview(detection3DTransitionButton)
    }


    @objc private func backTapped() {

        // button vibration
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        self.dismiss(animated: true, completion: nil)
    }


    lazy var detection3DTransitionButton: UIButton = {

        let button = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame.size = CGSize(width: 100, height: 100)
        button.setImage(UIImage(named: "detection3DButton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.addTarget(self, action:#selector(detection3DTransitionButtonTapped), for: .touchUpInside)

        return button
    }()

    @objc func detection3DTransitionButtonTapped() {

//        // button vibration
//        let generator = UIImpactFeedbackGenerator(style: .medium)
//        generator.impactOccurred()
//
//        // 移動先のViewを定義する.
//        let secondViewController = Object3dDetectionViewController()
//
//        // SecondViewに移動する.
//        self.navigationController?.pushViewController(secondViewController, animated: true)

    }


    // (1) セクションに何このCellを表示するかを指定する
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    // (2) セルのレイアウトを変更する
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)

        return cell
    }


    // (3) セルのサイズを指定する（関数を表示するにはUICollectionViewDelegateFlowLayoutが必要）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 150)
    }



    // Headerのレイアウト
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        //        header.backgroundColor = .blue
        return header
    }

    // "refsizeheader"でfunctionを呼び出す。headerの大きさ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 0)
    }



    // GradientColor
    func colorWithGradient(size: CGSize, colors: [UIColor]) -> UIColor {
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.frame = CGRect(origin: .zero, size: size)
        backgroundGradientLayer.colors = colors.map { $0.cgColor }
        UIGraphicsBeginImageContext(size)
        backgroundGradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: backgroundColorImage!)
    }


}

