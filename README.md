<!-- markdownlint-disable MD041 -->
<!-- markdownlint-disable MD033 MD013 -->

> [!WARNING]  
> Looking for maintainers. See https://github.com/asdf-community/asdf-kotlin/issues/73

<div align="center">

# asdf-kotlin [![Build](https://github.com/asdf-community/asdf-kotlin/actions/workflows/build.yml/badge.svg)](https://github.com/asdf-community/asdf-kotlin/actions/workflows/build.yml)

kotlin (and [kotlin-native if available](https://github.com/asdf-community/asdf-kotlin/pull/4)) plugin for [asdf version manager](https://github.com/asdf-vm/asdf)

</div>
<!-- markdownlint-enable MD033 MD013 -->

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [Issues](#issues)
- [License](#license)
- [Tests](#tests)

# Dependencies

- `curl`, `tar`, `unzip`: generic POSIX utilities.
- [Java 8+](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
  - You may want to try [asdf-java](https://github.com/halcyon/asdf-java)
    `asdf plugin-add java https://github.com/halcyon/asdf-java`
  - [Which versions of JVM does Kotlin target?](https://kotlinlang.org/docs/faq.html#which-versions-of-jvm-does-kotlin-target)

# Install

Plugin:

```shell
asdf plugin add kotlin
# or
asdf plugin add kotlin https://github.com/asdf-community/asdf-kotlin.git
```

kotlin:

```shell
# Show all installable versions
asdf list-all kotlin

# Install specific version
asdf install kotlin latest

# Set a version globally (on your ~/.tool-versions file)
asdf global kotlin latest

# Now kotlin commands are available
kotlin -help
```

Check the [asdf](https://github.com/asdf-vm/asdf) readme for instructions on
how to install & manage versions of kotlin.

# Contributing

Contributions of any kind welcome! See the
[contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/asdf-community/asdf-kotlin/graphs/contributors)!

# Issues

- Doesn't check if java is installed

# License

MIT License

# Tests

## Github Actions

**Note**: See [workflows](./.github/workflows)

- It tests installing a version of kotlin without kotlin native
  (Version `1.0.3`) on mac and linux
- It tests installing a version of kotlin with kotlin native (Version `1.3.21`)
  on mac and linux
- It tests installing a version of kotlin with new kotlin native naming
  (Version `1.4.30-RC`) on mac and linux
- It tests installing a version of kotling with new kotlin native naming that
  includes arch (Version `1.5.30-M1`) on mac and linux
- It tests installing `latest` version of kotlin on mac and linux

## Locally with Docker Compose

**Note**: Only tests linux (Ubuntu `22.04`) and takes a while since it builds
on every run

- `cd /path/to/this/repo`
- `docker compose up --force-recreate --abort-on-container-exit`

  <!-- markdownlint-disable MD013 -->

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

  <!-- markdownlint-enable MD013 -->
