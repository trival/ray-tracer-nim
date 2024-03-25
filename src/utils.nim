import std/times
import random

var r = initRand(getTime().toUnix)

proc resetRand* (seed: int64): void =
  r = initRand(seed)

proc rand* (max: float = 1.0): float =
  rand(r, max)
