import Vapor
import HTTP

final class TILController {
    
    func addRoutes(drop: Droplet) {
        drop.get("til", handler: indexView)
        drop.post("til", handler: addAcronym)
    }
    
    func indexView(request: Request) throws -> ResponseRepresentable {
        let acronyms = try Acronym.all().makeNode()
        let parameters = try Node(node: [
            "acronyms": acronyms,
        ])
        return try drop.view.make("index", parameters)
    }
    
    
    func addAcronym(request: Request) throws -> ResponseRepresentable {
        guard var short = request.data["short"]?.string,
        let long = request.data["long"]?.string else {
            throw Abort.badRequest
        }
        var acronym = Acronym(short: short, long: long)
        try acronym.save()
    return Response(redirect: "/til")
    }
}
