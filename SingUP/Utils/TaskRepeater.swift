//
//  TaskRepeater.swift
//  SingUP
//
//  Created by Muhammad Chandra Ramadhan on 03/05/25.
//
import Foundation
class TaskRepeater {
    private var timer : DispatchSourceTimer?
    public var tasks : () -> Void = {}
    func start() {
        let queue = DispatchQueue.global(qos: .background)
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now() , repeating: .milliseconds(100))
        timer?.setEventHandler { [weak self] in
            self?.tasks()
        }
        
        timer?.resume()
    }
    
    func stop() {
        timer?.cancel()
        timer = nil
    }
    
    
}
