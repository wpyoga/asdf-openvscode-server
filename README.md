<div align="center">

# asdf-openvscode-server [![Build](https://github.com/wpyoga/asdf-openvscode-server/actions/workflows/build.yml/badge.svg)](https://github.com/wpyoga/asdf-openvscode-server/actions/workflows/build.yml) [![Lint](https://github.com/wpyoga/asdf-openvscode-server/actions/workflows/lint.yml/badge.svg)](https://github.com/wpyoga/asdf-openvscode-server/actions/workflows/lint.yml)


[openvscode-server](https://github.com/gitpod-io/openvscode-server) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

`openvscode-server` requires `node.js`, which is bundled with the installer.

# Install

Plugin:

```shell
asdf plugin add openvscode-server
# or
asdf plugin add openvscode-server https://github.com/wpyoga/asdf-openvscode-server.git
```

openvscode-server:

```shell
# Show all installable versions
asdf list-all openvscode-server

# Install specific version
asdf install openvscode-server latest

# Set a version globally (on your ~/.tool-versions file)
asdf global openvscode-server latest

# Now openvscode-server commands are available
openvscode-server --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/wpyoga/asdf-openvscode-server/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [William Poetra Yoga](https://github.com/wpyoga/)
