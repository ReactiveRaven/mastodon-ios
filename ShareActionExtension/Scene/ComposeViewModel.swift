//
//  ComposeViewModel.swift
//  MastodonShareAction
//
//  Created by MainasuK Cirno on 2021-7-16.
//

import os.log
import Foundation
import Combine
import CoreData
import CoreDataStack
import MastodonSDK
import SwiftUI
import UniformTypeIdentifiers
import MastodonAsset
import MastodonLocalization
import MastodonUI
import MastodonCore

final class ComposeViewModel {

    let logger = Logger(subsystem: "ComposeViewModel", category: "ViewModel")

    var disposeBag = Set<AnyCancellable>()

    static let composeContentLimit: Int = 500

    // input
    let context: AppContext
    
//    private var coreDataStack: CoreDataStack?
//    var managedObjectContext: NSManagedObjectContext?
//    var api: APIService?
//
//    var inputItems = CurrentValueSubject<[NSExtensionItem], Never>([])
//    let viewDidAppear = CurrentValueSubject<Bool, Never>(false)
//    let traitCollectionDidChangePublisher = CurrentValueSubject<Void, Never>(Void())      // use CurrentValueSubject to make initial event emit
//    let selectedStatusVisibility = CurrentValueSubject<ComposeToolbarView.VisibilitySelectionType, Never>(.public)
//
//    // output
//    let authentication = CurrentValueSubject<Result<MastodonAuthentication, Error>?, Never>(nil)
//    let isFetchAuthentication = CurrentValueSubject<Bool, Never>(true)
//    let isPublishing = CurrentValueSubject<Bool, Never>(false)
//    let isBusy = CurrentValueSubject<Bool, Never>(true)
//    let isValid = CurrentValueSubject<Bool, Never>(false)
//    let shouldDismiss = CurrentValueSubject<Bool, Never>(true)
//    let composeViewModel = ComposeViewModel()
//    let characterCount = CurrentValueSubject<Int, Never>(0)

    init(context: AppContext) {
        self.context = context
        // end init
        
//        viewDidAppear.receive(on: DispatchQueue.main)
//            .removeDuplicates()
//            .sink { [weak self] viewDidAppear in
//                guard let self = self else { return }
//                guard viewDidAppear else { return }
//                self.setupCoreData()
//            }
//            .store(in: &disposeBag)
//
//        Publishers.CombineLatest(
//            inputItems.removeDuplicates(),
//            viewDidAppear.removeDuplicates()
//        )
//        .receive(on: DispatchQueue.main)
//        .sink { [weak self] inputItems, _ in
//            guard let self = self else { return }
//            self.parse(inputItems: inputItems)
//        }
//        .store(in: &disposeBag)
//
//        // bind authentication loading state
//        authentication
//            .map { result in result == nil }
//            .assign(to: \.value, on: isFetchAuthentication)
//            .store(in: &disposeBag)
//
//        // bind user locked state
//        authentication
//            .compactMap { result -> Bool? in
//                guard let result = result else { return nil }
//                switch result {
//                case .success(let authentication):
//                    return authentication.user.locked
//                case .failure:
//                    return nil
//                }
//            }
//            .map { locked -> ComposeToolbarView.VisibilitySelectionType in
//                locked ? .private : .public
//            }
//            .assign(to: \.value, on: selectedStatusVisibility)
//            .store(in: &disposeBag)
//
//        // bind author
//        authentication
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] result in
//                guard let self = self else { return }
//                guard let result = result else { return }
//                switch result {
//                case .success(let authentication):
//                    self.composeViewModel.avatarImageURL = authentication.user.avatarImageURL()
//                    self.composeViewModel.authorName = authentication.user.displayNameWithFallback
//                    self.composeViewModel.authorUsername = "@" + authentication.user.username
//                case .failure:
//                    self.composeViewModel.avatarImageURL = nil
//                    self.composeViewModel.authorName = " "
//                    self.composeViewModel.authorUsername =  " "
//                }
//            }
//            .store(in: &disposeBag)
//
//        // bind authentication to compose view model
//        authentication
//            .map { result -> MastodonAuthentication? in
//                guard let result = result else { return nil }
//                switch result {
//                case .success(let authentication):
//                    return authentication
//                case .failure:
//                    return nil
//                }
//            }
//            .assign(to: &composeViewModel.$authentication)
//
//        // bind isBusy
//        Publishers.CombineLatest(
//            isFetchAuthentication,
//            isPublishing
//        )
//        .receive(on: DispatchQueue.main)
//        .map { $0 || $1 }
//        .assign(to: \.value, on: isBusy)
//        .store(in: &disposeBag)
//
//        // pass initial i18n string
//        composeViewModel.statusPlaceholder = L10n.Scene.Compose.contentInputPlaceholder
//        composeViewModel.contentWarningPlaceholder = L10n.Scene.Compose.ContentWarning.placeholder
//        composeViewModel.toolbarHeight = ComposeToolbarView.toolbarHeight
//
//        // bind compose bar button item UI state
//        let isComposeContentEmpty = composeViewModel.$statusContent
//            .map { $0.isEmpty }
//
//        isComposeContentEmpty
//            .assign(to: \.value, on: shouldDismiss)
//            .store(in: &disposeBag)
//
//        let isComposeContentValid = composeViewModel.$characterCount
//            .map { characterCount -> Bool in
//                return characterCount <= ShareViewModel.composeContentLimit
//            }
//        let isMediaEmpty = composeViewModel.$attachmentViewModels
//            .map { $0.isEmpty }
//        let isMediaUploadAllSuccess = composeViewModel.$attachmentViewModels
//            .map { viewModels in
//                viewModels.allSatisfy { $0.uploadStateMachineSubject.value is StatusAttachmentViewModel.UploadState.Finish }
//            }
//
//        let isPublishBarButtonItemEnabledPrecondition1 = Publishers.CombineLatest4(
//            isComposeContentEmpty,
//            isComposeContentValid,
//            isMediaEmpty,
//            isMediaUploadAllSuccess
//        )
//        .map { isComposeContentEmpty, isComposeContentValid, isMediaEmpty, isMediaUploadAllSuccess -> Bool in
//            if isMediaEmpty {
//                return isComposeContentValid && !isComposeContentEmpty
//            } else {
//                return isComposeContentValid && isMediaUploadAllSuccess
//            }
//        }
//        .eraseToAnyPublisher()
//
//        let isPublishBarButtonItemEnabledPrecondition2 = Publishers.CombineLatest(
//            isComposeContentEmpty,
//            isComposeContentValid
//        )
//        .map { isComposeContentEmpty, isComposeContentValid -> Bool in
//            return isComposeContentValid && !isComposeContentEmpty
//        }
//        .eraseToAnyPublisher()
//
//        Publishers.CombineLatest(
//            isPublishBarButtonItemEnabledPrecondition1,
//            isPublishBarButtonItemEnabledPrecondition2
//        )
//        .map { $0 && $1 }
//        .assign(to: \.value, on: isValid)
//        .store(in: &disposeBag)
//
//        // bind counter
//        composeViewModel.$characterCount
//            .assign(to: \.value, on: characterCount)
//            .store(in: &disposeBag)
//
//        // setup theme
//        setupBackgroundColor(theme: ThemeService.shared.currentTheme.value)
//        ThemeService.shared.currentTheme
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] theme in
//                guard let self = self else { return }
//                self.setupBackgroundColor(theme: theme)
//            }
//            .store(in: &disposeBag)
    }

    private func setupBackgroundColor(theme: Theme) {
//        composeViewModel.contentWarningBackgroundColor = Color(theme.contentWarningOverlayBackgroundColor)
    }

}

//extension ShareViewModel {
//    enum ShareError: Error {
//        case `internal`(error: Error)
//        case userCancelShare
//        case missingAuthentication
//    }
//}

extension ComposeViewModel {
//    private func setupCoreData() {
//        logger.debug("\((#file as NSString).lastPathComponent, privacy: .public)[\(#line, privacy: .public)], \(#function, privacy: .public)")
//        DispatchQueue.global().async {
//            let _coreDataStack = CoreDataStack()
//            self.coreDataStack = _coreDataStack
//            self.managedObjectContext = _coreDataStack.persistentContainer.viewContext
//
//            _coreDataStack.didFinishLoad
//                .receive(on: RunLoop.main)
//                .sink { [weak self] didFinishLoad in
//                    guard let self = self else { return }
//                    guard didFinishLoad else { return }
//                    guard let managedObjectContext = self.managedObjectContext else { return }
//
//
//                    self.api = APIService(backgroundManagedObjectContext: _coreDataStack.newTaskContext())
//
//                    self.logger.debug("\((#file as NSString).lastPathComponent, privacy: .public)[\(#line, privacy: .public)], \(#function, privacy: .public): fetch authentication…")
//                    managedObjectContext.perform {
//                        do {
//                            let request = MastodonAuthentication.sortedFetchRequest
//                            let authentications = try managedObjectContext.fetch(request)
//                            let authentication = authentications.sorted(by: { $0.activedAt > $1.activedAt }).first
//                            guard let activeAuthentication = authentication else {
//                                self.authentication.value = .failure(ShareError.missingAuthentication)
//                                return
//                            }
//                            self.authentication.value = .success(activeAuthentication)
//                            self.logger.debug("\((#file as NSString).lastPathComponent, privacy: .public)[\(#line, privacy: .public)], \(#function, privacy: .public): fetch authentication success \(activeAuthentication.userID)")
//                        } catch {
//                            self.authentication.value = .failure(ShareError.internal(error: error))
//                            self.logger.debug("\((#file as NSString).lastPathComponent, privacy: .public)[\(#line, privacy: .public)], \(#function, privacy: .public): fetch authentication fail \(error.localizedDescription)")
//                            assertionFailure(error.localizedDescription)
//                        }
//                    }
//                }
//                .store(in: &self.disposeBag)
//        }
//    }
}

//extension ShareViewModel {
//    func parse(inputItems: [NSExtensionItem]) {
//        var itemProviders: [NSItemProvider] = []
//
//        for item in inputItems {
//            itemProviders.append(contentsOf: item.attachments ?? [])
//        }
//        
//        let _textProvider = itemProviders.first { provider in
//            return provider.hasRepresentationConforming(toTypeIdentifier: UTType.plainText.identifier, fileOptions: [])
//        }
//        
//        let _urlProvider = itemProviders.first { provider in
//            return provider.hasRepresentationConforming(toTypeIdentifier: UTType.url.identifier, fileOptions: [])
//        }
//
//        let _movieProvider = itemProviders.first { provider in
//            return provider.hasRepresentationConforming(toTypeIdentifier: UTType.movie.identifier, fileOptions: [])
//        }
//
//        let imageProviders = itemProviders.filter { provider in
//            return provider.hasRepresentationConforming(toTypeIdentifier: UTType.image.identifier, fileOptions: [])
//        }
//        
//        Task { @MainActor in
//            async let text = ShareViewModel.loadText(textProvider: _textProvider)
//            async let url = ShareViewModel.loadURL(textProvider: _urlProvider)
//            
//            let content = await [text, url]
//                .compactMap { $0 }
//                .joined(separator: " ")
//            self.composeViewModel.statusContent = content
//        }
//        
//        guard let api = self.api else { return }
//        
//        if let movieProvider = _movieProvider {
//            composeViewModel.setupAttachmentViewModels([
//                StatusAttachmentViewModel(api: api, itemProvider: movieProvider)
//            ])
//        } else if !imageProviders.isEmpty {
//            let viewModels = imageProviders.map { provider in
//                StatusAttachmentViewModel(api: api, itemProvider: provider)
//            }
//            composeViewModel.setupAttachmentViewModels(viewModels)
//        }
//
//    }
//    
//    private static func loadText(textProvider: NSItemProvider?) async -> String? {
//        guard let textProvider = textProvider else { return nil }
//        do {
//            let item = try await textProvider.loadItem(forTypeIdentifier: UTType.plainText.identifier)
//            guard let text = item as? String else { return nil }
//            return text
//        } catch {
//            return nil
//        }
//    }
//    
//    private static func loadURL(textProvider: NSItemProvider?) async -> String? {
//        guard let textProvider = textProvider else { return nil }
//        do {
//            let item = try await textProvider.loadItem(forTypeIdentifier: UTType.url.identifier)
//            guard let url = item as? URL else { return nil }
//            return url.absoluteString
//        } catch {
//            return nil
//        }
//    }
//    
//}
//
//extension ShareViewModel {
//    func publish() -> AnyPublisher<Mastodon.Response.Content<Mastodon.Entity.Status>, Error> {
//        guard let authentication = composeViewModel.authentication,
//              let api = self.api
//        else {
//            return Fail(error: APIService.APIError.implicit(.authenticationMissing)).eraseToAnyPublisher()
//        }
//        let authenticationBox = MastodonAuthenticationBox(
//            authenticationRecord: .init(objectID: authentication.objectID),
//            domain: authentication.domain,
//            userID: authentication.userID,
//            appAuthorization: Mastodon.API.OAuth.Authorization(accessToken: authentication.appAccessToken),
//            userAuthorization: Mastodon.API.OAuth.Authorization(accessToken: authentication.userAccessToken)
//        )
//
//        let domain = authentication.domain
//        let attachmentViewModels = composeViewModel.attachmentViewModels
//        let mediaIDs = attachmentViewModels.compactMap { viewModel in
//            viewModel.attachment.value?.id
//        }
//        let sensitive: Bool = composeViewModel.isContentWarningComposing
//        let spoilerText: String? = {
//            let text = composeViewModel.contentWarningContent
//            guard !text.isEmpty else { return nil }
//            return text
//        }()
//        let visibility = selectedStatusVisibility.value.visibility
//
//        let updateMediaQuerySubscriptions: [AnyPublisher<Mastodon.Response.Content<Mastodon.Entity.Attachment>, Error>] = {
//            var subscriptions: [AnyPublisher<Mastodon.Response.Content<Mastodon.Entity.Attachment>, Error>] = []
//            for attachmentViewModel in attachmentViewModels {
//                guard let attachmentID = attachmentViewModel.attachment.value?.id else { continue }
//                let description = attachmentViewModel.descriptionContent.trimmingCharacters(in: .whitespacesAndNewlines)
//                guard !description.isEmpty else { continue }
//                let query = Mastodon.API.Media.UpdateMediaQuery(
//                    file: nil,
//                    thumbnail: nil,
//                    description: description,
//                    focus: nil
//                )
//                let subscription = api.updateMedia(
//                    domain: domain,
//                    attachmentID: attachmentID,
//                    query: query,
//                    mastodonAuthenticationBox: authenticationBox
//                )
//                subscriptions.append(subscription)
//            }
//            return subscriptions
//        }()
//
//        let status = composeViewModel.statusContent
//
//        return Publishers.MergeMany(updateMediaQuerySubscriptions)
//            .collect()
//            .asyncMap { attachments in
//                let query = Mastodon.API.Statuses.PublishStatusQuery(
//                    status: status,
//                    mediaIDs: mediaIDs.isEmpty ? nil : mediaIDs,
//                    pollOptions: nil,
//                    pollExpiresIn: nil,
//                    inReplyToID: nil,
//                    sensitive: sensitive,
//                    spoilerText: spoilerText,
//                    visibility: visibility
//                )
//                return try await api.publishStatus(
//                    domain: domain,
//                    idempotencyKey: nil,    // FIXME:
//                    query: query,
//                    authenticationBox: authenticationBox
//                )
//            }
//            .eraseToAnyPublisher()
//    }
//}
