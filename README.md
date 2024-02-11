# passgen

A simple password generator.

## install

Download latest release from [Releases](https://github.com/soarowl/passgen-nim/releases)

## builf from source

```sh
git clone https://github.com/soarowl/passgen-nim.git
cd passgen-nim
nimble release
```

## usage

```sh
# short help
passgen -h
# long help
passgen --helps
# generate password
passgen
# generate password with custom length
passgen -l 16
# generate password with custom length and special characters
passgen -l 16 --lower 2 -u 3 -p 4
# generate password all digits
passgen -l 6 -D
```

## colorful output

### linux

Move `config` to `$HOME/.config/cligen`

### windows

Move `config` to `$APPDATA\.config\cligen`

## License

MIT
