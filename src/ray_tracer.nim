import vec3
import options
import math

type
  Ray = object
    origin: Vec3
    direction: Vec3

  Sphere = object
    pos: Vec3
    radius: float

func normal *(sphere: Sphere, point: Vec3): Vec3 =
  result = point - sphere.pos
  result.normalize

func intersect*(sphere: Sphere, ray: Ray): Option[Vec3] =
  let oc = ray.origin - sphere.pos
  let a = ray.direction.dot ray.direction
  let b = 2 * oc.dot(ray.direction)
  let c = oc.dot(oc) - sphere.radius * sphere.radius
  let discriminant = b * b - 4 * a * c
  result =
    if discriminant >= 0:
      some((-b - discriminant.sqrt) / (2 * a) * ray.direction + ray.origin)
    else:
      none(Vec3)

type
  Camera = object
    origin: Vec3
    direction: Vec3
    near: float
    aspectRatio: float
    resolution: (uint, uint)

type
  Image = object
    data: seq[Vec3]
    width: uint
    height: uint

func createImg*(width, height: uint): Image =
  result.data = newSeq[Vec3](width * height)
  result.width = width
  result.height = height

func setPixel*(img: var Image, x, y: uint, color: Vec3) =
  img.data[y * img.width + x] = color

func toPPM*(image: Image): string =
  var s = "P3\n"
  s.add $image.width
  s.add " "
  s.add $image.height
  s.add "\n255\n"
  for pixel in image.data:
    s.add $int(pixel[0] * 255)
    s.add " "
    s.add $int(pixel[1] * 255)
    s.add " "
    s.add $int(pixel[2] * 255)
    s.add "\n"
  result = s

proc savePPM*(img: Image, filename: string) =
  writeFile filename, img.toPPM

when isMainModule:
  var img = createImg(256, 256)
  for y in 0..<img.height:
    for x in 0..<img.width:
      img.setPixel(x, y, [x.float / img.width.float, y.float / img.height.float, 0.5])
  img.savePPM("output.ppm")
