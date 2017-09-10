import Foundation


class MGTRootToSearchTA: MGTPhasedTA {
    
	//
	// -----------------------------------------------------------------------------
	override func phases(context: UIViewControllerContextTransitioning, containerView: UIView, fromVC: UIViewController, toVC: UIViewController) -> [MGTPhasedTA.Phase] {
		
		// без анимации ставим вьюху целевого контроллера в исходное положение
		toVC.view.frame = context.finalFrame(for: toVC)
		toVC.view.alpha = 0
		containerView.addSubview(toVC.view)
		
		// вьюхи и параметры анимации
		guard
			let rootVC: MGTRootVC   = fromVC as? MGTRootVC,
			let srchVC: MGTSearchVC = toVC   as? MGTSearchVC
		else {
			return []
		}
		
		let mapVC: MGTMapVC = rootVC.map
		let bounds: CGRect = mapVC.view.bounds
		
		guard
			let buttonSearch	= mapVC.buttonSearch,
			let buttonSettings	= mapVC.buttonSettings,
			let srchPad			= srchVC.pad,
			let srchBtn			= srchVC.buttonBack
		else {
			return []
		}
		
		let inset: CGFloat				= 10
		let statusBarRect: CGRect		= UIApplication.shared.statusBarFrame
		let y: CGFloat					= statusBarRect.height + inset
		
		let mockPad						= UIView(frame: buttonSearch.frame)
		mockPad.backgroundColor			= MGTLib.colorButtonNormalBlue
		mockPad.layer.cornerRadius		= MGTLib.sizeButtonHeight / 2
		containerView.addSubview(mockPad)
		
		let mockIcon					= UIImageView(frame: CGRect(x: 0, y: 0, width: MGTLib.sizeButtonHeight, height: MGTLib.sizeButtonHeight))
		mockIcon.image					= buttonSearch.image(for: .normal)
		mockIcon.tintColor				= buttonSearch.tintColor
		mockIcon.contentMode			= .center
		mockPad.addSubview(mockIcon)
		
		buttonSearch.alpha				= 0
		
		return [
			Phase(duration: 0.25) {
				// фаза 1, растягиваем колбасу и тушим кнопки
				mockPad.frame			= CGRect(x: inset, y: y, width: bounds.width - inset * 2, height: MGTLib.sizeButtonHeight)
				mockPad.backgroundColor	= srchPad.backgroundColor
				mockIcon.tintColor		= srchBtn.tintColor
				buttonSettings.alpha	= 0
			},
			Phase(duration: 0.125) {
				// фаза 2, гасим кнопку поиска
				mockIcon.alpha			= 0
			},
			Phase(duration: 0.25) {
				// фаза 3, зажигаем вьюху контроллера поиска
				mockPad.alpha			= 0
				srchVC.view.alpha		= 1
			},
			Phase(duration: 0) {
				// фаза последняя, восстанавливаем всю разруху
				buttonSearch.alpha		= 1
				buttonSettings.alpha	= 1
				mockPad.removeFromSuperview()
			},
		]
	}
	
}
