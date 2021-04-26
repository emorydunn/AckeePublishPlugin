# AckeePublishPlugin

A plugin for [Publish](https://github.com/JohnSundell/Publish) to include a self-hosted [Ackee](https://ackee.electerious.com) analytics.

## Usage

Configure the shared instance of the `TrackerConfig`:

```swift
TrackerConfig.shared = TrackerConfig(server: URL(string: "https://analytics.example.com")!,
                                     domainID: "your-domain-id")
```

If you're using a custom tracker file you can specify that as well, but defaults to `/tracker.js` at the root of the server URL. 

In your theme include the tracker as an additional node in the head on each page you want tracked:

```swift
HTML(
    ...
    .head(for: ..., on: context.site, stylesheetPaths: ..., additionalNode: .ackeeTracker()),
    .body(...)
)
```
