import Vapor
import VaporPostgreSQL

let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider)
drop.preparations += Acronym.self

let controller = TILController()
controller.addRoutes(drop: drop)

drop.get("version") { request in
    if let db = drop.database?.driver as? PostgreSQLDriver {
        let version = try db.raw("SELECT version()")
        return try JSON(node:version)
    } else {
        return "No db connection"
    }
}

drop.get("model") { request in
    let acronym = Acronym(short: "AFK", long: "Away From Keyboard")
    return try acronym.makeJSON()
}

drop.get("test") { request in
    var acronym = Acronym(short: "AFK", long: "Away From Keyboard")
    try acronym.save()
    return try JSON(node: Acronym.all().makeNode())
}

drop.post("new") { request in
    var acronym = try Acronym(node: request.json)
    try acronym.save()
    return acronym
}

drop.get("all") { request in
    return try JSON(node: Acronym.all().makeNode())
}

drop.get("first") { request in
    return try JSON(node: Acronym.query().first()?.makeNode())
}
drop.get("afk") { request in
    return try JSON(node: Acronym.query().filter("short","AFK").all().makeNode())
}
drop.get("no-afk") { request in
    return try JSON(node: Acronym.query().filter("short", .notEquals, "AFK").all().makeNode())
}
drop.get("update-first") { request in
    guard var first = try Acronym.query().first(),
        let long = request.data["long"]?.string else {
            throw Abort.badRequest
    }
    first.long = long
    try first.save()
    return first
    //localhost:8080/update-first?long=
}
drop.get("delete-afks") { request in
    let query = try Acronym.query().filter("short","AFK")
    try query.delete()
    return try JSON(node: Acronym.all().makeNode())
}
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
