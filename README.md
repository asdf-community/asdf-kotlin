[![Build Status](https://travis-ci.org/asdf-community/asdf-kotlin.svg?branch=master)](https://travis-ci.org/asdf-community/asdf-kotlin)

# asdf-kotlin
kotlin (and [kotlin-native if available](https://github.com/asdf-community/asdf-kotlin/pull/4)) plugin for [asdf version manager](https://github.com/asdf-vm/asdf)

## Requirements

* [Java 6 to 8](http://www.oracle.com/technetwork/java/javase/downloads/index.html) - You may want to try [asdf-java](https://github.com/skotchpine/asdf-java) `asdf plugin-add java https://github.com/skotchpine/asdf-java`

## Install

```
asdf plugin-add kotlin https://github.com/asdf-community/asdf-kotlin.git
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

### Travis CI

**Note**: See [.travis.yml](./.travis.yml)

- It tests installing a version of kotlin without kotlin native (Version 1.0.3) on mac and linux
- It tests installing a version of kotlin with kotlin native (Version 1.3.21) on mac and linux

### Locally with Docker Compose

**Note**: Only tests linux (Ubuntu 18.04) and takes a while since it builds on every run

- `cd /path/to/this/repo`
- `docker-compose up --force-recreate`

```bash
Creating asdf-kotlin-linux-test ... done
Attaching to asdf-kotlin-linux-test
asdf-kotlin-linux-test | Cloning into '/home/build/.asdf'...
...
asdf-kotlin-linux-test |   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
asdf-kotlin-linux-test |                                  Dload  Upload   Total   Spent    Left  Speed
100   621    0   621    0     0   1673      0 --:--:-- --:--:-- --:--:--  1673
100 75.5M  100 75.5M    0     0  11.1M      0  0:00:06  0:00:06 --:--:-- 13.6M
asdf-kotlin-linux-test | Setting kotlin 1.0.3 as the default value in ~/.tool-versions
asdf-kotlin-linux-test | Confirming version 1.0.3
asdf-kotlin-linux-test | Kotlin version 1.0.3 (JRE 11.0.1+13)
asdf-kotlin-linux-test | Setting kotlin 1.3.21 as the default value in ~/.tool-versions
asdf-kotlin-linux-test | Confirming version 1.3.21
asdf-kotlin-linux-test | Kotlin version 1.3.21-release-158 (JRE 11.0.1+13)
asdf-kotlin-linux-test | info: kotlinc-native 1.3.21 (JRE 11.0.1+13)
asdf-kotlin-linux-test exited with code 0
```
