[![Build Status](https://travis-ci.org/missingcharacter/asdf-kotlin.svg?branch=master)](https://travis-ci.org/missingcharacter/asdf-kotlin)

# asdf-kotlin
kotlin (and [kotlin-native if available](https://github.com/missingcharacter/asdf-kotlin/pull/4)) plugin for [asdf version manager](https://github.com/asdf-vm/asdf)

## Requirements

* [Java 6 to 8](http://www.oracle.com/technetwork/java/javase/downloads/index.html) - You may want to try [asdf-java](https://github.com/skotchpine/asdf-java) `asdf plugin-add java https://github.com/skotchpine/asdf-java`

## Install

```
asdf plugin-add kotlin https://github.com/missingcharacter/asdf-kotlin.git
```

## Use

Check the [asdf](https://github.com/asdf-vm/asdf) readme for instructions on how to install & manage versions of kotlin.

## Contributing

Feel free to create an issue or pull request if you find a bug.

## Issues

* Doesn't check if java is installed

## License
MIT License

## Tests

**Note**: See [.travis.yml](./.travis.yml)

- It tests installing a version of kotlin without kotlin native (Version 1.0.3) on mac and linux
- It tests installing a version of kotlin with kotlin native (Version 1.3.21) on mac and linux
