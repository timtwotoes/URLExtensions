# URLExtensions
Adds convenience methods to Swift Foundations URL structure that aids in constructing and modifying URLs.

## Usage

**Constructing an URL using the URL macro**

```swift
let url = #URL("https://example.com")
```

Validates the URL at compile time and produces an unwrapped URL. The string passed to the macro must be a static string.
No string interpolations allowed.

**Constructing an URL with components**

```swift
let url = URL(string: "https://api.example.org") { components in
    components.append(path: "book")
    components.addQuery("title", value: "Sherlock Holmes")
    components.addQuery("isAvailable")
}!
```

Produces the url "https://api.example.org/book?title=Sherlock%20Holmes&isAvailable". Note that it must be unwrapped.

**Modifying an URL in place with components**

```swift
var url = #URL("https://api.example.org")

let didModifyURL: Bool = url.modify { components in
    components.append(path: "book")
    components.addQuery("title", value: "Sherlock Holmes")
    components.addQuery("isAvailable")
}
```

Modifies the url in place and is now "https://api.example.org/book?title=Sherlock%20Holmes&isAvailable". The function
returns if the URL was updated or not. It can be ignored.

**Modify an URL by creating a new URL with components**

```swift
let url = #URL("https://api.example.org")

let modifiedURL = url.modified { components in
    components.append(path: "book")
    components.addQuery("title", value: "Sherlock Holmes")
    components.addQuery("isAvailable")
}!
```

Creates a new modified URL. The modified URL is "https://api.example.org/book?title=Sherlock%20Holmes&isAvailable".
It return nil if the modified URL is malformed.
