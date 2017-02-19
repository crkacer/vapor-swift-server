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
    return try JSON(node: ["person","person\(chat)"])
}

drop.resource("posts", PostController())

drop.run()
