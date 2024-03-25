import vec3
import math
import random

# === Ray

type
  Ray = object
    origin: Vec3
    dir: Vec3

func newRay *(origin: Vec3, direction: Vec3): Ray =
  result.origin = origin
  result.dir = direction
  result.dir.normalize

func at *(ray: Ray, t: float): Vec3 =
  ray.origin + ray.dir * t

# === Sphere

type
  Sphere = object
    center: Vec3 = Vec3Zero
    radius: float = 0.0

func normalAt *(sphere: Sphere, point: Vec3): Vec3 =
  result = point - sphere.center
  result.normalize

func intersect*(sphere: Sphere, ray: Ray): float =
  let oc = ray.origin - sphere.center
  let halfB = oc.dot ray.dir
  let c = oc.lenSquared - sphere.radius * sphere.radius
  let discriminant = halfB * halfB - c

  if discriminant >= 0.0:
    let sqrtD = discriminant.sqrt
    let t1 = -halfB - sqrtD
    let t2 = -halfB + sqrtD

    if t1 > 0.0 and t2 > 0.0:
      if t1 < t2: t1 else: t2
    elif t1 > 0.0: t1
    else: t2

  else:
    -1.0

# === Image

type
  Image = object
    data: seq[Vec3]
    width: int
    height: int

func newImg* (width, height: int): Image =
  result.data = newSeq[Vec3](width * height)
  result.width = width
  result.height = height

func setPixel* (img: var Image, x, y: int, color: Vec3) =
  img.data[y * img.width + x] = color

func toPPM* (image: Image): string =
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

proc savePPM* (img: Image, filename: string) =
  writeFile filename, img.toPPM

# === Camera

type
  Camera = object
    origin: Vec3
    direction: Vec3
    near: float
    up = Vec3Y

  SceneObject = tuple[sphere: Sphere, color: Vec3]

  Scene = object
    objects: seq[SceneObject]

proc viewPortDirections* (cam: Camera): tuple[left: Vec3, up: Vec3] =
  result.left = cam.direction.cross cam.up
  if result.left.isNearZero:
    echo "Warning: Camera direction and up vector are parallel"
    return (Vec3Zero, Vec3Zero)
  result.up = cam.direction.cross result.left
  result.left.normalize
  result.up.normalize

const minT = 0.0001
const maxT = 1e9

proc closestObject* (scene: Scene, ray: Ray): (float, SceneObject) =
  var closest = maxT
  var closestObj: SceneObject = (Sphere(), Vec3Zero)

  for obj in scene.objects:
    let t = obj.sphere.intersect ray
    if t > minT and t < closest:
      closest = t
      closestObj = obj

  result = (closest, closestObj)

proc rayColor* (ray: Ray, scene: Scene, depth: int): Vec3 =
  let (t, obj) = scene.closestObject ray

  if t <= minT or t >= maxT:
    let t = 0.5 * (ray.dir.y + 1.0)
    let col1 = vec3 1.0
    let col2 = vec3(0.5, 0.7, 1.0)
    return col1.lerp(col2, t)

  if depth <= 0:
    return vec3 0.0

  let hitNormal = obj.sphere.normalAt(ray.at t)
  let reflectedRay = ray.dir.reflect hitNormal

  var scatterDir = reflectedRay + randVecInUnitSphere() * 1.5
  if scatterDir.isNearZero:
    scatterDir = reflectedRay

  let scattered = newRay(ray.at t, scatterDir)
  return obj.color * rayColor(scattered, scene, depth - 1)

proc render* (cam: Camera, scene: Scene, imgWidth: int, imgHeight: int, raysPerPixel: int = 100, maxBounces: int = 5): Image =
  var img = newImg(imgWidth, imgHeight)
  let height = imgHeight / imgWidth

  let pixelWidth = 1.0 / imgWidth.float
  let pixelHeight = height / imgHeight.float

  let viewPortCenter = cam.origin + cam.direction * cam.near
  let (viewPortU, viewPortV) = cam.viewPortDirections

  for y in 0..<img.height:
    for x in 0..<img.width:
      var color = vec3 0.0
      for _ in 0..<raysPerPixel:
        let pixelX = -0.5 + x.float * pixelWidth + rand(1.0) * pixelWidth
        let pixelY = -height / 2.0 + y.float * pixelHeight + rand(1.0) * pixelHeight
        let rayDir = viewPortCenter + viewPortU * pixelX + viewPortV * pixelY - cam.origin
        let r = newRay(cam.origin, rayDir)
        color += rayColor(r, scene, maxBounces) / raysPerPixel.float
      img.setPixel x, y, color
  result = img

when isMainModule:
  let scene = Scene(objects: @[
    (Sphere(center: vec3(0.0), radius: 0.5), vec3(0.8, 0.3, 0.3)),
    (Sphere(center: vec3(1.0, 0.0, 0.0), radius: 0.5), vec3(0.3, 0.8, 0.3)),
    (Sphere(center: vec3(-1.0, 0.0, 0.0), radius: 0.5), vec3(0.3, 0.3, 0.8)),
    (Sphere(center: vec3(0.0, -100.5, 0.0), radius: 100.0), vec3(0.5, 0.5, 0.5)),
  ])
  let cam = Camera(origin: vec3(0.0, 0.0, 3.0), direction: vec3(0.0, 0.0, -1.0), near: 0.7)
  let img = cam.render(scene, 300, 200, 50, 5)
  img.savePPM("output.ppm")
