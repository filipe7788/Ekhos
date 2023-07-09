//
//  RecordingView.swift
//  Ekhos
//
//  Created by Filipe Cruz on 08/07/23.
//

import Foundation
import SnapKit
import UIKit
import DSWaveformImage

protocol RecordingViewProtocol where Self: UIView  {
    func setup(_ delegate: RecordingViewDelegate)
    func setupWaveView(samples: [Float])
    func stopWaveView()
}

protocol RecordingViewDelegate: AnyObject {
    func startRecording()
    func stopRecording()
}

final class RecordingView: UIView {
    private weak var delegate: RecordingViewDelegate?

    private let containerStackView = UIStackView()
    
    private var titleLabel = UILabel()
    
    private var recordButton = UIButton()
    
    private var isRecording = false
    
    private let waveformView = WaveformLiveView()

    static func make() -> RecordingView {
        RecordingView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .white
        print("veio no init do view")
        setupContainerStackView()
    }
    
    private func setupContainerStackView() {
        addSubview(containerStackView)
        containerStackView.axis = .vertical
        containerStackView.distribution = .fill
        containerStackView.alignment = .top
        containerStackView.spacing = 60
        containerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        setupTitleLabel()
        setupRecordButton()
        setupWaveFormView()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Vamos começar a gravação"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28.0)
        containerStackView.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupRecordButton() {
        recordButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        recordButton.imageView?.contentMode = .scaleAspectFit
        containerStackView.addArrangedSubview(recordButton)
        recordButton.snp.makeConstraints { make in
            make.height.equalTo(350)
            make.width.equalTo(230)
            make.centerX.equalToSuperview()
        }
        recordButton.addTarget(self, action: #selector(recordButtonWasPressed), for: .touchUpInside)
    }
    
    @objc func recordButtonWasPressed() {
        if self.isRecording {
            recordButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
            self.delegate?.stopRecording()
            
        } else {
            recordButton.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
            self.delegate?.startRecording()
        }
        self.isRecording = !self.isRecording
    }
    
    private func setupWaveFormView() {
        containerStackView.addArrangedSubview(waveformView)
        waveformView.configuration = waveformView.configuration.with(
            style: .gradient([.red, .yellow])
        )
        waveformView.backgroundColor = .white
        waveformView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}

extension RecordingView: RecordingViewProtocol {
    func setupWaveView(samples: [Float]) {
        waveformView.add(samples: samples)
    }
    
    func setup(_ delegate: RecordingViewDelegate) {
        self.delegate = delegate
    }
    
    func stopWaveView() {
        waveformView.reset()
    }
}
