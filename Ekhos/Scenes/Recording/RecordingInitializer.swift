//
//  RecordingInitializer.swift
//  Ekhos
//
//  Created by Filipe Cruz on 08/07/23.
//

import UIKit

@available(iOS 13.0, *)
extension Recording {
    public static func initializer() -> UIViewController {
        let customView = RecordingView.make()
        let viewController = RecordingViewController(
            customView: customView
        )
        print("veio na initalizer")
        customView.setup(viewController)
        return viewController
    }
}
