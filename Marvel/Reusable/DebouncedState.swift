//
//  DebouncedState.swift
//  Challenge1
//
//  Created by Nathan Ubeda on 10/15/24.
//

import Combine
import Foundation
import SwiftUI

@propertyWrapper
struct DebouncedState<Value>: DynamicProperty {
	@StateObject private var backingState: BackingState
	
	init(initialValue: Value, delay: Double = 0.3) {
		self.init(wrappedValue: initialValue, delay: delay)
	}
	
	init(wrappedValue: Value, delay: Double = 0.3) {
		self._backingState = StateObject(wrappedValue: BackingState(originalValue: wrappedValue, delay: delay))
	}
	
	var wrappedValue: Value {
		get {
			backingState.debouncedValue
		}
		nonmutating set {
			backingState.currentValue = newValue
		}
	}
	
	public var projectedValue: Binding<Value> {
		Binding {
			backingState.currentValue
		} set: {
			backingState.currentValue = $0
		}
	}
	
	private class BackingState: ObservableObject {
		@Published var currentValue: Value
		@Published var debouncedValue: Value
		
		init(originalValue: Value, delay: Double) {
			_currentValue = Published(initialValue: originalValue)
			_debouncedValue = Published(initialValue: originalValue)
			$currentValue
				.debounce(for: .seconds(delay), scheduler: RunLoop.main)
				.assign(to: &$debouncedValue)
		}
	}
}
