import Vapor
import HTTP

final class TILController {
    
    func addRoutes(drop: Droplet) {
        drop.get("til", handler: indexView)
    }
    
    func indexView(request: Request) throws -> ResponseRepresentable {
        let acronyms = try Acronym.all().makeNode()
        let parameters = try Node(node: [
            "acronyms": acronyms,
        ])
        return try drop.view.make("index", parameters)
    }
}
