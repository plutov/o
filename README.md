# o

»o« means open. `o.sh` is a simple CLI tool to open the repository page of a 
Git remote in a browser.

Just type `o` in your Git repo

![o.gif](https://raw.githubusercontent.com/plutov/o/master/o.gif)

## Installation

Clone the repository and run `install.sh` or run

```
sh <(curl -s https://raw.githubusercontent.com/plutov/o/master/install.sh)
```

## Usage

Basic

```
o
```

Open different remote than `origin`

```
o upstream
```

## Supported remote repositories

`o` detects the corresponding repository page for remotes on the following 
hosts automatically:

- GitHub
- GitLab
- BitBucket
- Stash

For all other remotes it guesses the most fitting URL and tries to open it.

## Supported OS

- Linux
- OSX
- Windows

## License

See [LICENSE](./LICENSE)
