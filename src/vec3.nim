import math
import random

type
  Vec3* = array[3, float]

func vec3* (x, y, z: float): Vec3 =
  [x, y, z]

func vec3* (a: float): Vec3 =
  [a, a, a]

func x* (a: Vec3): float =
  a[0]

func y* (a: Vec3): float =
  a[1]

func z* (a: Vec3): float =
  a[2]

const Vec3Zero* = vec3 0.0
const Vec3X* = [1.0, 0.0, 0.0]
const Vec3Y* = [0.0, 1.0, 0.0]
const Vec3Z* = [0.0, 0.0, 1.0]

func `+`* (a, b: Vec3): Vec3 =
  result[0] = a[0] + b[0]
  result[1] = a[1] + b[1]
  result[2] = a[2] + b[2]

func `+`* (a: Vec3, b: float): Vec3 =
  result[0] = a[0] + b
  result[1] = a[1] + b
  result[2] = a[2] + b

func `+`* (a: float, b: Vec3): Vec3 =
  b + a

func `+=`* (a: var Vec3, b: Vec3): void =
  a[0] += b[0]
  a[1] += b[1]
  a[2] += b[2]

func `+=`* (a: var Vec3, b: float): void =
  a[0] += b
  a[1] += b
  a[2] += b

func `-`* (a, b: Vec3): Vec3 =
  result[0] = a[0] - b[0]
  result[1] = a[1] - b[1]
  result[2] = a[2] - b[2]

func `-`* (a: Vec3, b: float): Vec3 =
  result[0] = a[0] - b
  result[1] = a[1] - b
  result[2] = a[2] - b

func `-`* (a: float, b: Vec3): Vec3 =
  result[0] = a - b[0]
  result[1] = a - b[1]
  result[2] = a - b[2]

func `-=`* (a: var Vec3, b: Vec3): void =
  a[0] -= b[0]
  a[1] -= b[1]
  a[2] -= b[2]

func `-=`* (a: var Vec3, b: float): void =
  a[0] -= b
  a[1] -= b
  a[2] -= b

func `*`* (a, b: Vec3): Vec3 =
  result[0] = a[0] * b[0]
  result[1] = a[1] * b[1]
  result[2] = a[2] * b[2]

func `*`* (a: Vec3, b: float): Vec3 =
  result[0] = a[0] * b
  result[1] = a[1] * b
  result[2] = a[2] * b

func `*`* (a: float, b: Vec3): Vec3 =
  b * a

func `*=`* (a: var Vec3, b: Vec3): void =
  a[0] *= b[0]
  a[1] *= b[1]
  a[2] *= b[2]

func `*=`* (a: var Vec3, b: float): void =
  a[0] *= b
  a[1] *= b
  a[2] *= b

func `-`* (a: Vec3): Vec3 =
  a * (-1.0)


func `/`* (a, b: Vec3): Vec3 =
  result[0] = a[0] / b[0]
  result[1] = a[1] / b[1]
  result[2] = a[2] / b[2]

func `/`* (a: Vec3, b: float): Vec3 =
  result[0] = a[0] / b
  result[1] = a[1] / b
  result[2] = a[2] / b

func `/`* (a: float, b: Vec3): Vec3 =
  result[0] = a / b[0]
  result[1] = a / b[1]
  result[2] = a / b[2]

func `/=`* (a: var Vec3, b: Vec3): void =
  a[0] /= b[0]
  a[1] /= b[1]
  a[2] /= b[2]

func `/=`* (a: var Vec3, b: float): void =
  a[0] /= b
  a[1] /= b
  a[2] /= b

func dot* (a, b: Vec3): float =
  a[0] * b[0] + a[1] * b[1] + a[2] * b[2]

func cross* (a, b: Vec3): Vec3 =
  result[0] = a[1] * b[2] - a[2] * b[1]
  result[1] = a[2] * b[0] - a[0] * b[2]
  result[2] = a[0] * b[1] - a[1] * b[0]

func lenSquared* (a: Vec3): float =
  a.dot a

func len* (a: Vec3): float =
  a.lenSquared.sqrt

func normal* (a: Vec3): Vec3 =
  a / a.len

func normalize* (a: var Vec3): void =
  a /= a.len

func isNearZero* (a: Vec3): bool =
  const s = 1e-8
  result = a.lenSquared < s

func lerp* (a, b: Vec3, t: float): Vec3 =
  a * (1.0 - t) + b * t

func reflect* (v, n: Vec3): Vec3 =
  v - n * (v.dot(n) * 2.0)

proc randVec* (max = 1.0): Vec3 =
  [rand(max), rand(max), rand(max)]

proc randVecInUnitSphere* (): Vec3 =
  while true:
    let p = randVec(2.0) - 1.0
    if p.lenSquared < 1.0:
      return p

proc randVecInHemisphere* (normal: Vec3): Vec3 =
  let inUnitSphere = randVecInUnitSphere()
  if inUnitSphere.dot(normal) < 0.0:
    -inUnitSphere
  else:
    inUnitSphere

proc randVecUnit* (): Vec3 =
  result = randVecInUnitSphere()
  result.normalize
