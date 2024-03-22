import math

type
  Vec3* = array[3, float]

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

func squareLen* (a: Vec3): float =
  a[0] * a[0] + a[1] * a[1] + a[2] * a[2]

func len* (a: Vec3): float =
  a.squareLen.sqrt

func normal* (a: Vec3): Vec3 =
  a / a.len

func normalize* (a: var Vec3): void =
  a /= a.len


