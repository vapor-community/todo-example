//
//  TodoDao.swift
//  VaporApp
//
//  Created by Sebastien Arbogast on 16/05/2016.
//
//

import Foundation

protocol TodoDao {
    func createTodo(_ todo:Todo) -> Todo?;
    func findAllTodos() -> [Todo]?;
    func deleteAllTodos();
    func getTodoWithId(_ id:String) -> Todo?;
    func modifyTodoWithId(_ id:String, changes:[String:Any]) -> Todo?;
    func deleteTodoWithId(_ id:String)
    func updateTodo(_ todo:Todo) -> Todo?
}