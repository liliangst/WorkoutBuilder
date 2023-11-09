//
//  LinkedList.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 01/11/2023.
//

import Foundation
import RealmSwift

class LinkedList<T: Equatable>: EmbeddedObject where T: EmbeddedObject {
    @Persisted var head: Node<T>? = Node<T>()
    
    var count: Int {
        return asArray().count
    }
    
    func insert(_ element: T) {
      if self.head?.element == nil {
        self.head?.element = element
      } else {
        var lastNode = head
          while lastNode?.next != nil {
          lastNode = lastNode?.next!
        }
        //once found, create a new node and connect the linked list
        let newNode = Node<T>()
        newNode.element = element
        lastNode?.next = newNode
      }
    }
    
    func remove(_ element: T) {
        if head?.element == element {
            head = head?.next ?? Node<T>()
      }
    if head?.element != nil {
        var node = head
        var previousNode = Node<T>()
        while node?.element != element && node?.next != nil {
          previousNode = node!
          node = node?.next!
        }
        //once found, connect the previous node to the current node's next
        if node?.element == element {
          if node?.next != nil {
            previousNode.next = node?.next
          } else {
            //if at the end, the next is nil
            previousNode.next = nil
          }
        }
      }
    }
    
    func asArray() -> [T] {
        var array = [T]()
        guard head?.element != nil else {
            return array
        }
        array.append((head?.element)!)
        var lastNode = head
        while lastNode?.next != nil {
            lastNode = lastNode?.next!
            array.append((lastNode?.element)!)
        }
        return array
    }
}

class Node<T: Equatable>: EmbeddedObject where T: EmbeddedObject {
  @Persisted var element: T? = nil
  @Persisted var next: Node? = nil
}
