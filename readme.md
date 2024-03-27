# ray tracer in nim

to compile run

```bash
nim c -r --outdir:out src/ray_tracer.nim > out/output.ppm
# or
nim c -r -d:release --outdir:out src/ray_tracer.nim > out/output.ppm
# or with timing
time nim c -r -d:release --outdir:out src/ray_tracer.nim > out/output.ppm
```

with generated C code in the working directory run

```bash
nim c -r --nimcache:build -d:release --outdir:out src/ray_tracer.nim > out/output.ppm
```
