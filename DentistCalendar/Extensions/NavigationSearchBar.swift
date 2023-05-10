//
//  NavigationSearchBar.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 24.03.2021.
//

import Foundation
import SwiftUI

public extension View {
    func navigationSearchBar(text: Binding<String>, scopeSelection: Binding<Int> = Binding.constant(0), options: [NavigationSearchBarOptionKey : Any] = [NavigationSearchBarOptionKey : Any](), actions: [NavigationSearchBarActionKey : NavigationSearchBarActionTask] = [NavigationSearchBarActionKey : NavigationSearchBarActionTask]()) -> some View {
        overlay(NavigationSearchBar<AnyView>(text: text, scopeSelection: scopeSelection, options: options, actions: actions).frame(width: 0, height: 0))
    }

    func navigationSearchBar<SearchResultsContent>(text: Binding<String>, scopeSelection: Binding<Int> = Binding.constant(0), options: [NavigationSearchBarOptionKey : Any] = [NavigationSearchBarOptionKey : Any](), actions: [NavigationSearchBarActionKey : NavigationSearchBarActionTask] = [NavigationSearchBarActionKey : NavigationSearchBarActionTask](), @ViewBuilder searchResultsContent: @escaping () -> SearchResultsContent) -> some View where SearchResultsContent : View {
        overlay(NavigationSearchBar<SearchResultsContent>(text: text, scopeSelection: scopeSelection, options: options, actions: actions, searchResultsContent: searchResultsContent).frame(width: 0, height: 0))
    }
}

public struct NavigationSearchBarOptionKey: Hashable, Equatable, RawRepresentable {
    public static let automaticallyShowsSearchBar = NavigationSearchBarOptionKey("automaticallyShowsSearchBar")
    public static let obscuresBackgroundDuringPresentation = NavigationSearchBarOptionKey("obscuresBackgroundDuringPresentation")
    public static let hidesNavigationBarDuringPresentation = NavigationSearchBarOptionKey("hidesNavigationBarDuringPresentation")
    public static let hidesSearchBarWhenScrolling = NavigationSearchBarOptionKey("hidesSearchBarWhenScrolling")
    public static let placeholder = NavigationSearchBarOptionKey("Placeholder")
    public static let showsBookmarkButton = NavigationSearchBarOptionKey("showsBookmarkButton")
    public static let scopeButtonTitles = NavigationSearchBarOptionKey("scopeButtonTitles")
    
    public static func == (lhs: NavigationSearchBarOptionKey, rhs: NavigationSearchBarOptionKey) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(_ rawValue: String) {
        self.init(rawValue: rawValue)
    }
}

public struct NavigationSearchBarActionKey: Hashable, Equatable, RawRepresentable {
    public static let onCancelButtonClicked = NavigationSearchBarActionKey("onCancelButtonClicked")
    public static let onSearchButtonClicked = NavigationSearchBarActionKey("onSearchButtonClicked")
    public static let onBookmarkButtonClicked = NavigationSearchBarActionKey("onBookmarkButtonClicked")

    public static func == (lhs: NavigationSearchBarActionKey, rhs: NavigationSearchBarActionKey) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(_ rawValue: String) {
        self.init(rawValue: rawValue)
    }
}

public typealias NavigationSearchBarActionTask = () -> Void

fileprivate struct NavigationSearchBar<SearchResultsContent>: UIViewControllerRepresentable where SearchResultsContent : View {
    typealias UIViewControllerType = Wrapper
    typealias OptionKey = NavigationSearchBarOptionKey
    typealias ActionKey = NavigationSearchBarActionKey
    typealias ActionTask = NavigationSearchBarActionTask

    @Binding var text: String
    @Binding var scopeSelection: Int
    
    let options: [OptionKey : Any]
    let actions: [ActionKey : ActionTask]
    let searchResultsContent: () -> SearchResultsContent?
    
    init(text: Binding<String>, scopeSelection: Binding<Int> = Binding.constant(0), options: [OptionKey : Any] = [OptionKey : Any](), actions: [ActionKey : ActionTask] = [ActionKey : ActionTask](), @ViewBuilder searchResultsContent: @escaping () -> SearchResultsContent? = { nil }) {
        self._text = text
        self._scopeSelection = scopeSelection
        self.options = options
        self.actions = actions
        self.searchResultsContent = searchResultsContent
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(representable: self)
    }
    
    func makeUIViewController(context: Context) -> Wrapper {
        Wrapper()
    }
    
    func updateUIViewController(_ wrapper: Wrapper, context: Context) {
        
        if wrapper.searchController != context.coordinator.searchController {
            wrapper.searchController = context.coordinator.searchController
        }
        
        if let hidesSearchBarWhenScrolling = options[.hidesSearchBarWhenScrolling] as? Bool {
            wrapper.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
        }
        
        if options[.automaticallyShowsSearchBar] as? Bool == nil || options[.automaticallyShowsSearchBar] as! Bool  {
            wrapper.navigationBarSizeToFit()
        }

        if let searchController = wrapper.searchController {
            searchController.automaticallyShowsScopeBar = true
            if let obscuresBackgroundDuringPresentation = options[.obscuresBackgroundDuringPresentation] as? Bool {
                searchController.obscuresBackgroundDuringPresentation = obscuresBackgroundDuringPresentation
            } else {
                searchController.obscuresBackgroundDuringPresentation = false
            }
            
            if let hidesNavigationBarDuringPresentation = options[.hidesNavigationBarDuringPresentation] as? Bool {
                searchController.hidesNavigationBarDuringPresentation = hidesNavigationBarDuringPresentation
            }

            if let searchResultsContent = searchResultsContent() {
                (searchController.searchResultsController as? UIHostingController<SearchResultsContent>)?.rootView = searchResultsContent
            }
        }
        
        if let searchBar = wrapper.searchController?.searchBar {
            searchBar.text = text
            searchBar.searchBarStyle = .minimal

            if let placeholder = options[.placeholder] as? String {
                searchBar.placeholder = placeholder
            }
            
            if let showsBookmarkButton = options[.showsBookmarkButton] as? Bool {
                searchBar.showsBookmarkButton = showsBookmarkButton
            }
            
            if let scopeButtonTitles = options[.scopeButtonTitles] as? [String] {
                searchBar.scopeButtonTitles = scopeButtonTitles
            }
            
            searchBar.selectedScopeButtonIndex = scopeSelection
            searchBar.barTintColor = .white
            searchBar.tintColor = .white
            searchBar.searchTextField.tintColor = .white
            searchBar.searchTextField.textColor = .white
            searchBar.setTextField(color: UIColor.white.withAlphaComponent(0.2))
            searchBar.setPlaceholderText(color: UIColor.white.withAlphaComponent(0.2))
                    searchBar.setSearchImage(color: UIColor.white.withAlphaComponent(0.2))
            searchBar.setClearButton(color: UIColor.white.withAlphaComponent(0.2))
        }
    }
    
    
    class Coordinator: NSObject, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
        let representable: NavigationSearchBar
        
        let searchController: UISearchController
        
        init(representable: NavigationSearchBar) {
            self.representable = representable
            
            var searchResultsController: UIViewController? = nil
            if let searchResultsContent = representable.searchResultsContent() {
                searchResultsController = UIHostingController<SearchResultsContent>(rootView: searchResultsContent)
            }
            
            self.searchController = UISearchController(searchResultsController: searchResultsController)
            
            super.init()
            self.searchController.searchResultsUpdater = self
            self.searchController.searchBar.delegate = self
        }
        
        // MARK: - UISearchResultsUpdating
        func updateSearchResults(for searchController: UISearchController) {
            guard let text = searchController.searchBar.text else { return }
            DispatchQueue.main.async { [weak self] in self?.representable.text = text }
        }
        
        // MARK: - UISearchBarDelegate
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            guard let action = self.representable.actions[.onCancelButtonClicked] else { return }
            DispatchQueue.main.async { action() }
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            guard let action = self.representable.actions[.onSearchButtonClicked] else { return }
            DispatchQueue.main.async { action() }
        }
        
        func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
            guard let action = self.representable.actions[.onBookmarkButtonClicked] else { return }
            DispatchQueue.main.async { action() }
        }
        
        func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
            DispatchQueue.main.async { [weak self] in self?.representable.scopeSelection = selectedScope }
        }
    }
    
    class Wrapper: UIViewController {
        var searchController: UISearchController? {
            didSet {
                self.parent?.navigationItem.searchController = self.searchController
            }
        }
        
        var hidesSearchBarWhenScrolling: Bool = false {
            didSet {
                self.parent?.navigationItem.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
            }
        }
        
        func navigationBarSizeToFit() {
            self.parent?.navigationController?.navigationBar.sizeToFit()
        }
        
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            parent?.navigationItem.searchController = searchController
            parent?.navigationItem.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
            navigationBarSizeToFit()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            if let parent = parent, let searchResultsController = searchController?.searchResultsController {
                parent.addChild(searchResultsController)
                searchController?.view.layoutIfNeeded()
            }
         }
        
        override func viewDidAppear(_ animated: Bool) {
            if let parent = parent, let searchResultsController = searchController?.searchResultsController {
                parent.addChild(searchResultsController)
                searchController?.view.layoutIfNeeded()
            }
        }
    }
}

import UIKit

extension UISearchBar {

    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func setText(color: UIColor) { if let textField = getTextField() { textField.textColor = color } }
    func setPlaceholderText(color: UIColor) { getTextField()?.setPlaceholderText(color: color) }
    func setClearButton(color: UIColor) { getTextField()?.setClearButton(color: color) }

    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 10
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }

    func setSearchImage(color: UIColor) {
        guard let imageView = getTextField()?.leftView as? UIImageView else { return }
        imageView.tintColor = color
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
    }
}

extension UITextField {

    private class ClearButtonImage {
        static private var _image: UIImage?
        static private var semaphore = DispatchSemaphore(value: 1)
        static func getImage(closure: @escaping (UIImage?)->()) {
            DispatchQueue.global(qos: .userInteractive).async {
                semaphore.wait()
                DispatchQueue.main.async {
                    if let image = _image { closure(image); semaphore.signal(); return }
                    guard let window = UIApplication.shared.windows.first else { semaphore.signal(); return }
                    let searchBar = UISearchBar(frame: CGRect(x: 0, y: -200, width: UIScreen.main.bounds.width, height: 44))
                    window.rootViewController?.view.addSubview(searchBar)
                    searchBar.text = "txt"
                    searchBar.layoutIfNeeded()
                    _image = searchBar.getTextField()?.getClearButton()?.image(for: .normal)
                    closure(_image)
                    searchBar.removeFromSuperview()
                    semaphore.signal()
                }
            }
        }
    }

    func setClearButton(color: UIColor) {
        ClearButtonImage.getImage { [weak self] image in
            guard   let image = image,
                let button = self?.getClearButton() else { return }
            button.imageView?.tintColor = color
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }

    func setPlaceholderText(color: UIColor) {
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [.foregroundColor: color])
    }

    func getClearButton() -> UIButton? { return value(forKey: "clearButton") as? UIButton }
}

struct CustomNavigationView: UIViewControllerRepresentable {
    
    
    func makeCoordinator() -> Coordinator {
        return CustomNavigationView.Coordinator(parent: self)
    }
    
    var view: AnyView
    
    var largeTitle: Bool
    var title: String
    var placeHolder: String
    
    var onSearch: (String)->()
    var onCancel: ()->()
    
    init(view: AnyView,placeHolder: String? = "Search".localized, largeTitle: Bool? = true, title: String, onSearch: @escaping (String)->(), onCancel: @escaping ()->()) {
      
        self.title = title
        self.largeTitle = largeTitle!
        self.placeHolder = placeHolder!
        self.view = view
        self.onSearch = onSearch
        self.onCancel = onCancel
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        
        let childView = UIHostingController(rootView: view)
        
        let controller = UINavigationController(rootViewController: childView)
        
        
        controller.navigationBar.topItem?.title = title
        controller.navigationBar.prefersLargeTitles = largeTitle
        
        let searchController = UISearchController()

        searchController.searchBar.placeholder = placeHolder
        searchController.searchBar.delegate = context.coordinator

        searchController.obscuresBackgroundDuringPresentation = false
        controller.navigationBar.topItem?.hidesSearchBarWhenScrolling = true
        controller.navigationBar.topItem?.searchController = searchController
        
        searchController.searchBar.searchTextField.tintColor = .systemBlue
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.searchTextField.backgroundColor = .systemGray6
        searchController.searchBar.searchTextField.clipsToBounds = true

        searchController.searchBar.searchTextField.tintColor = .systemBlue
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        uiViewController.navigationBar.topItem?.title = title
        uiViewController.navigationBar.topItem?.searchController?.searchBar.placeholder = placeHolder
        uiViewController.navigationBar.prefersLargeTitles = largeTitle
    }
    
    class Coordinator: NSObject,UISearchBarDelegate{
        
        var parent: CustomNavigationView
        
        init(parent: CustomNavigationView) {
            self.parent = parent
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.parent.onSearch(searchText)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            self.parent.onCancel()
        }
    }
}
