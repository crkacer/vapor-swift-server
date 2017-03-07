import Vapor

final class Acronym: NodeRepresentable, JSONRepresentable {
    var short: String
    var long: String
    init(short: String, long:String) {
        self.short = short
        self.long = long
    }
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "short" : short,
            "long" : long
        ])
    }
}
