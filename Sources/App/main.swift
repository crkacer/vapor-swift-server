import Vapor

let drop = Droplet()

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.get("hello") { request in
    return ("Hello world")
}

drop.get("hello","vapor") { request in
    return try JSON(node: ["Greeting":"Hello vapor"])
}

drop.get("chat", Int.self) { request, chat in
    return try JSON(node: ["person","person-\(chat)"])
}

drop.post("post") { request in
    guard let name = request.data["name"]?.string else {
        throw Abort.badRequest
    }
    return try JSON(node: ["message":"Hello \(name)"])
}

drop.get("hello-template") { request in
    return try drop.view.make("hello", Node(node:["name":"willie"]))
}

drop.get("hello-template2", String.self) { request, name in
    return try drop.view.make("hello", Node(node:["name":name]))
    
}

drop.get("hello-template3") { request in
    let users = try ["willie","vickie", "athour"].makeNode()
    return try drop.view.make("hello3", Node(node: ["users":users]))
}

drop.resource("posts", PostController())

drop.run()
