////
////  PartialModalView.swift
////  DentistCalendar
////
////  Created by Даник 💪 on 23.01.2021.
////
//
//import SwiftUI
//enum ModalState: CGFloat {
//    
//    case closed , partiallyRevealed, open, fullscreen
//    case base, backgrounded, occluded
//    
//    func offsetFromTop() -> CGFloat {
//        switch self {
//        case .closed:
//            return UIScreen.main.bounds.height + 42
//        case .partiallyRevealed:
//            return UIScreen.main.bounds.height/1.8
//        case .open:
//            return 20
//        case .fullscreen, .base, .backgrounded:
//            return 0
//        case .occluded:
//            return 30
//        }
//    }
//}
//
//struct Modal: Identifiable {
//    let id = UUID()
//    var content: AnyView
//    var position: ModalState  = .base
//    
//    var isFullscreenEnabled: Bool = false
//    var dragOffset: CGSize = .zero
//}
//class ModalManager: ObservableObject {
//    @Published var modals: [Modal] = []
//    
//    func fetchIndex(forID: UUID) -> Int { self.modals.firstIndex { $0.id == forID }! }
//    func fetchModal(forID: UUID) -> Modal? { self.modals.first { $0.id == forID } }
//    func isFirst(id: UUID) -> Bool { return self.modals.first!.id == id }
//    
//    func fetchNext(forID: UUID) -> Modal? {
//        let index = fetchIndex(forID: forID)
//        if self.modals.indices.contains(index + 1) {
//            return self.modals[index + 1]
//        } else {
//            return nil
//        }
//    }
//    
//    func fetchContent() {
//        modals =
//            [Modal(content: AnyView(
//                ZStack {
//                    Color.white
//                    Text("123")
//                }
//            ))
//        ]
//    }
//}
////struct PartialModalView: View {
////
////    // Modal State
////    @Binding var modal: Modal
////    @GestureState var DraggingState: DraggingState = .inactive
////
////    var animation: Animation {
////        Animation
////            .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0)
////            .delay(0)
////    }
////
////    var body: some View {
////
////        let drag = DragGesture(minimumDistance: 30)
////            .updating($DraggingState) { drag, state, transaction in
////                state = .dragging(translation:  drag.translation)
////        }
////        .onChanged {
////            self.modal.dragOffset = $0.translation
////        }
////        .onEnded(onDragEnded)
////
////        return GeometryReader(){ geometry in
////            ZStack(alignment: .top) {
////                Color.black
////                    .opacity(self.modal.position != .closed ? 0.5 : 0)
////                    .onTapGesture {
////                        self.modal.position = .closed
////                }
////                ZStack(alignment: .top) {
////                    Color.white
////                    self.modal.content
////                        .frame(height: UIScreen.main.bounds.height - (self.modal.position.offsetFromTop() + geometry.safeAreaInsets.top + self.DraggingState.translation.height))
////                }
////                .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
////                .offset(y: max(0, self.modal.position.offsetFromTop() + self.DraggingState.translation.height + geometry.safeAreaInsets.top))
////                .gesture(drag)
////                .animation(self.DraggingState.isDragging ? nil : self.animation)
////            }
////        }
////        .edgesIgnoringSafeArea(.top)
////    }
////
////    private func onDragEnded(drag: DragGesture.Value) {
////
////        // Setting stops
////        let higherStop: ModalState
////        let lowerStop: ModalState
////
////        // Nearest position for drawer to snap to.
////        let nearestPosition: ModalState
////
////        // Determining the direction of the drag gesture and its distance from the top
////        let dragDirection = drag.predictedEndLocation.y - drag.location.y
////        let offsetFromTopOfView = modal.position.offsetFromTop() + drag.translation.height
////
////        // Determining whether drawer is above or below `.partiallyRevealed` threshold for snapping behavior.
////        if offsetFromTopOfView <= ModalState.partiallyRevealed.offsetFromTop() {
////            higherStop = .open
////            lowerStop = .partiallyRevealed
////        } else {
////            higherStop = .partiallyRevealed
////            lowerStop = .closed
////        }
////
////        // Determining whether drawer is closest to top or bottom
////        if (offsetFromTopOfView - higherStop.offsetFromTop()) < (lowerStop.offsetFromTop() - offsetFromTopOfView) {
////            nearestPosition = higherStop
////        } else {
////            nearestPosition = lowerStop
////        }
////
////        // Determining the drawer's position.
////        if dragDirection > 0 {
////            modal.position = lowerStop
////        } else if dragDirection < 0 {
////            modal.position = higherStop
////        } else {
////            modal.position = nearestPosition
////        }
////
////    }
////
////}
//struct PartialModalView: View {
//    
//    @EnvironmentObject var modalManager: ModalManager
//    @Binding var currentModal: Modal
//    
//    var isActive: Bool {
//        if let nextModal = modalManager.fetchNext(forID: currentModal.id) {
//            return [.partiallyRevealed, .closed].contains(nextModal.position) && !self.modalManager.isFirst(id: currentModal.id)
//        } else {
//            return [.open, .partiallyRevealed, .closed, .fullscreen].contains(self.currentModal.position)
//        }
//    }
//    
//    var body: some View {
//        return ModifiedContent(content: currentModal.content, modifier: ModalModifier(isActive: isActive, position: $currentModal.position, offset: $currentModal.dragOffset, isFullscreenEnabled: currentModal.isFullscreenEnabled, modalID: currentModal.id))
//    }
//}
//enum DraggingState {
//    
//    case inactive
//    case dragging(translation: CGSize)
//    
//    var translation: CGSize {
//        switch self {
//        case .inactive:
//            return .zero
//        case .dragging(let translation):
//            return translation
//        }
//    }
//    
//    var isDragging: Bool {
//        switch self {
//        case .inactive:
//            return false
//        case .dragging:
//            return true
//        }
//    }
//}
//
//struct ModalModifier: ViewModifier {
//    
//    @EnvironmentObject var modalManager: ModalManager
//    var isActive: Bool
//    
//    // Modal State
//    @GestureState var dragState: DraggingState = .inactive
//    @Binding var position: ModalState
//    @Binding var offset: CGSize
//    @State var isFullscreenEnabled = false
//    
//    var modalID: UUID
//    var animation: Animation {
//        Animation.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0)
//            .delay(self.position == .fullscreen ? 3:0)
//    }
//    
//    var timer: Timer? {
//        return Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
//            if self.position == .open && self.dragState.translation.height == 0 && self.isFullscreenEnabled {
//                self.position = .fullscreen
//            } else {
//                timer.invalidate()
//            }
//        }
//    }
//    
//    func body(content: Content) -> some View {
//        let drag = DragGesture()
//            .updating($dragState) { drag, state, transaction in state = .dragging(translation: (self.position != .fullscreen) ? drag.translation:.zero) }
//            .onChanged {
//                self.offset = (self.position != .fullscreen) ? $0.translation: .zero
//            }
//            .onEnded(onDragEnded)
//        
//        let nextModal = self.modalManager.fetchNext(forID: modalID)
//        let isBackgrounded = nextModal != nil ? ![.base, .closed, .partiallyRevealed].contains(nextModal!.position):false
//        let isFirst = modalManager.isFirst(id: modalID)
//        
//        return ZStack(alignment: .top) {
//            
//            Color.black.opacity(isActive && !isFirst ? 0:1)
//            ZStack {
//                Color.white.opacity(isActive && !isFirst ? 0:1)
//                content
//                    .offset(y: isFirst ? 42:0)
//            }
//            .mask(RoundedRectangle(cornerRadius: isActive ? 20: isBackgrounded ? 15:0, style: .continuous))
//            .scaleEffect(x: isActive ? 1:isBackgrounded ? 0.90:1, y: isActive ? 1:isBackgrounded ? 0.90:1, anchor: .center)
//            
//            Rectangle()
//                .fill(Color.black)
//                .opacity(isActive ? 0:isBackgrounded ? 0.3:0)
//        }
//        .edgesIgnoringSafeArea(.vertical)
//
//        .offset(y: isActive ? max(0, self.position.offsetFromTop() + self.dragState.translation.height):0)
//        .animation(isActive ? (self.dragState.isDragging ? nil : animation):animation)
//        .gesture(isActive ? drag:nil)
//    }
//    
//    private func onDragEnded(drag: DragGesture.Value) {
//        if position == .fullscreen {
//            return
//        }
//        
//        // Setting stops
//        let higherStop: ModalState
//        let lowerStop: ModalState
//        
//        // Nearest position for drawer to snap to.
//        let nearestPosition: ModalState
//        
//        // Determining the direction of the drag gesture and its distance from the top
//        let dragDirection = drag.predictedEndLocation.y - drag.location.y
//        let offsetFromTopOfView = position.offsetFromTop() + drag.translation.height
//        
//        // Determining whether drawer is above or below `.partiallyRevealed` threshold for snapping behavior.
//        if offsetFromTopOfView <= ModalState.partiallyRevealed.offsetFromTop() {
//            higherStop = .open
//            lowerStop = .partiallyRevealed
//        } else {
//            higherStop = .partiallyRevealed
//            lowerStop = .closed
//        }
//        
//        // Determining whether drawer is closest to top or bottom
//        if (offsetFromTopOfView - higherStop.offsetFromTop()) < (lowerStop.offsetFromTop() - offsetFromTopOfView) {
//            nearestPosition = higherStop
//        } else {
//            nearestPosition = lowerStop
//        }
//        
//        // Determining the drawer's position.
//        if dragDirection > 0 {
//            position = lowerStop
//        } else if dragDirection < 0 {
//            position = higherStop
//        } else {
//            position = nearestPosition
//        }
//        _ = timer
//    }
//}
