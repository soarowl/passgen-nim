import std/[random, strformat]
import config

const revision = staticExec("git rev-parse --short HEAD")

proc passgen(
    digit = 1,
    length = 16,
    lower = 1,
    punction = 1,
    upper = 1,
    unique = false,
    D = false,
    L = false,
    P = false,
    U = false,
    v = false,
): void =
  ##[ generate a simple password ]##
  if v:
    echo pkgDescription
    echo fmt"Author:      {pkgAuthor}"
    echo fmt"Version:     {pkgVersion}-{revision}"
    echo fmt"Compiled at: {CompileDate}  {CompileTime}"
    return

  if digit + lower + punction + upper > length:
    echo fmt"The sum of the digit: {digit} + lower: {lower} + punction: {punction} + upper: {upper} must not exceed the password length: {length}."
    return

  randomize()
  var password = newStringOfCap(length)
  var charsets: set[char]
  while true:
    var d = 0
    var l = 0
    var p = 0
    var u = 0

    if D or digit == length:
      l = 0
      p = 0
      u = 0
    elif L or lower == length:
      d = 0
      p = 0
      u = 0
    elif P or punction == length:
      d = 0
      l = 0
      u = 0
    elif U or upper == length:
      d = 0
      l = 0
      p = 0

    if unique:
      if D and length > 10:
        echo "The number of digits must be less than 10."
        return

      if L and length > 26:
        echo "The number of lowercase letters must be less than 26."
        return

      if P and length > 26:
        echo "The number of punctuation characters must be less than 26."
        return

      if U and length > 26:
        echo "The number of uppercase letters must be less than 26."
        return

    for i in 0 ..< length:
      block generate_letter:
        while true:
          var c: char
          if D or digit == length:
            c = char(rand(ord('0') .. ord('9')))
          elif L or lower == length:
            c = char(rand(ord('a') .. ord('z')))
          elif P or punction == length:
            c = char(rand(33 .. 126))
            if c >= '0' and c <= 'z':
              continue
          elif U or upper == length:
            c = char(rand(ord('A') .. ord('Z')))
          else:
            c = char(rand(33 .. 126))
          case c
          of '0' .. '9':
            if digit == 0:
              continue
            inc(d)
          of 'a' .. 'z':
            if lower == 0:
              continue
            inc(l)
          of 'A' .. 'Z':
            if upper == 0:
              continue
            inc(u)
          else:
            if punction == 0:
              continue
            inc(p)
          if (unique and c notin charsets) or (not unique):
            charsets.incl(c)
            password.add(c)
            break generate_letter
    if (d != 0 and d < digit) or (l != 0 and l < lower) or (p != 0 and p < punction) or
        (u != 0 and u < upper):
      password.setLen(0)
      charsets = {}
    else:
      break
  echo password

when isMainModule:
  import cligen
  dispatch passgen,
    help = {
      "digit": "Minimal digital letters",
      "length": "Length of password",
      "lower": "Minimal lower case letters",
      "punction": "Minimal punction letters",
      "upper": "Minimal upper case letters",
      "unique": "Each letter is differently",
      "D": "All letters are digital",
      "L": "All letters are lower case",
      "P": "All letters are punction",
      "U": "All letters are upper case",
      "v": "version"
    }
