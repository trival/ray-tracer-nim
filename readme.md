# ray tracer in nim

to compile run

```bash
nim c -r --outdir:out src/ray_tracer.nim
# or
nim c -r -d:release --outdir:out src/ray_tracer.nim
```

with generated C code in the working directory run

```bash
nim c -r --nimcache:build -d:release --outdir:out src/ray_tracer.nim
```
