import Vapor
import VaporPostgreSQL

let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider)
drop.preparations += Acronym.self

(drop.view as? LeafRenderer)?.stem.cache = nil
// clear View cache

let controller = TILController()
controller.addRoutes(drop: drop)

let basic = BasicController()
basic.addRoutes(drop: drop)



//===================Simple Get request================================//

//let drop = Droplet()
//drop.get { req in
//    return try drop.view.make("welcome", [
//    	"message": drop.localization[req.lang, "welcome", "title"]
//    ])
//}
//
//drop.get("hello") { request in
//    return ("Hello world")
//}
////hello/vapor
//drop.get("hello","vapor") { request in
//    return try JSON(node: ["Greeting":"Hello vapor"])
//}
////chat/1
//drop.get("chat", Int.self) { request, chat in
//    return try JSON(node: ["person","person-\(chat)"])
//}
//
//drop.post("post") { request in
//    guard let name = request.data["name"]?.string else {
//        throw Abort.badRequest
//    }
//    return try JSON(node: ["message":"Hello \(name)"])
//}
////hello-template
//drop.get("hello-template") { request in
//    return try drop.view.make("hello", Node(node:["name":"willie"]))
//}
////hello-template2/willie
//drop.get("hello-template2", String.self) { request, name in
//    return try drop.view.make("hello", Node(node:["name":name]))
//    
//}
////hello-template3
//drop.get("hello-template3") { request in
//    let users = try [
//        ["name":"willie", "email":"willie@willie.com"].makeNode(),
//        ["name":"vickie", "email":"vickie@willie.com"].makeNode(),
//        ["name":"arthour", "email":"arthour@willie.com"].makeNode()].makeNode()
//    return try drop.view.make("hello3", Node(node: ["users":users]))
//}
//
////hello-template4?sayHello=true
//drop.get("hello-template4") { request in
//    guard let sayHello = request.data["sayHello"]?.bool else {
//        throw Abort.badRequest
//    }
//    return try drop.view.make("ifelse", Node(node:["sayHello":sayHello.makeNode()]))
//    
//}
//drop.resource("posts", PostController())
//===========================================================================//


drop.run()
