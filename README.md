# SwiftJSON

### Huge shoutout to https://betterprogramming.pub/how-to-encode-and-decode-any-json-safely-in-swift-d5b2b8e2e1e3 for the inspiration for this

An easy way to take JSON data of an unknown shape, and convert it into a usable Swift Object.

This isn't a replacement for Codable and JSON Serialization, rather its a compliment to them. Swift JSON can be used when attempting to decode/encode data.

```
let jsonObject = try JSONDecoder.decode(JSON.self, from: data)
```

You can then use the resulting object to determine what type of data it is and what you have received. But what is more compelling is also sending random data structures. For example, if you want to send form data from a SwiftUI form, but have a bunch of random fields and have not settled on a format yet, you can build objects with JSON and encode them:

```
let age = 32
let nickname = "bhaze"
let object: JSON = .object([
    "age": .integer(age),
    "nickname": .string(nickname)
])

let data = try JSONEncoder.encode(object)
```

