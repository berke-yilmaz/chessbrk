import RealmSwift

// Define the UserProfile model
class UserProfile: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var username: String
    @Persisted var email: String
    @Persisted var hashedPassword: String
    @Persisted var rating: Int
    @Persisted var gamesPlayed: Int
    @Persisted var victories: Int
    @Persisted var defeats: Int
    @Persisted var draws: Int
    
    convenience init(username: String, email: String, hashedPassword: String) {
        self.init()
        self.username = username
        self.email = email
        self.hashedPassword = hashedPassword
        self.rating = 400 // default rating
        self.gamesPlayed = 0
        self.victories = 0
        self.defeats = 0
        self.draws = 0
    }
}
