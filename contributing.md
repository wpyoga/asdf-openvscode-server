# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

#
asdf plugin test openvscode-server https://github.com/wpyoga/asdf-openvscode-server.git "openvscode-server --version"
```

Tests are automatically run in GitHub Actions on push and PR.
