# Contributing Guidelines

### Code of Conduct


Please read our [Code of Conduct](https://github.com/TileImageTeamiOS/THTiledImageView/blob/master/Code_of_Conduct.md).
The THTiledImageView maintainers take this Code of Conduct very seriously. Intolerance, disrespect, harassment, and any form of negativity will not be tolerated.

### Ways to Contribute

You can contribute to THTiledImageView in a variety of ways:

- Fixing or reporting bugs :scream:
- Improving documentation :heart:
- Suggesting new features :smiley:
- Increasing unit test coverage :pray:
- Resolving any open issues :+1:


**Your contributions are always welcome, no contribution is too small.**

### Opening a New Issue

- Please check the [README](https://github.com/TileImageTeamiOS/THTiledImageView/blob/master/README.md) to see if your question is answered there.
- Search [open issues](https://github.com/TileImageTeamiOS/THTiledImageView/issues?q=is%3Aopen+is%3Aissue) and [closed issues](https://github.com/TileImageTeamiOS/THTiledImageView/issues?q=is%3Aissue+is%3Aclosed) to avoid opening a duplicate issue.
- Avoiding duplicate issues organizes all relevant information for project maintainers and other users.
- If no issues represent your problem, please open a new issue with a good title and useful description.

- Information to Provide When Opening an Issue:
    - THTiledImageView version(s)
    - iOS version(s)
    - Devices/Simulators affected
    - Full crash log, if applicable
    - A well written description of the problem you are experiencing
    - *Please provide complete steps to reproduce the issue*
    - For UI related issues, please provide a screenshot/GIF/video showing the issue
    - Link to a project or demo project that exhibits the issue
    - Search for a list any issues that might be related

The more information you can provide, the easier it will be for us to resolve your issue in a timely manner.

### Submitting a Pull Request

- We strongly encourage you to open an issue discussing any potential new features before an implementation is provided.
    - This ensures the feature is in scope and no ones time is wasted.

- **Please DO NOT submit pull requests to the `master` branch**
    - This branch is always stable and represents a release.

- **Please DO submit your pull request to the branch representing the next release version**

1. Link to any issues the pull request resolves. If none exist, create one.
2. Write unit tests for new functionality or fix any broken by your changes.
3. If your changes affect documentation, please update them accordingly.
4. Avoid pull requests with a large number of commits.
5. Write clean code and follow the THTiledImageView [style guidelines](#style-guidelines).

**You should submit one pull request per feature, the smaller the pull request the better chances it will be merged.**
Enormous pull requests take a significant time to review and understand their implications on the existing codebase.

### Style Guidelines

Writing clean code and upholding project standards is as important as adding new features. To ensure this, THTiledImageView employs a few practices:

1. We use [SwiftLint](https://github.com/realm/SwiftLint) to enforce style and conventions at compile time.
2. We adhere to the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).
