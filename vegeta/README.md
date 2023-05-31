# Run testing

## Testing

Basic usage

```bash
./benchmark.sh [flags]
```

Usage help

```bash
./benchmark.sh -h
```

## OS

### MacOs

Due to MacOs shiping with bash 3.2 and this program relying on newer bash features. `./benchmark.sh` points to a newer version of bash installed with brew.\
If running on MacOs do `brew install bash`\

### Other

Remove the first line of the code in `./benchmark.sh`.\
The first line should be the path to your bash installation example: `#!/bin/bash`

## Vegeta report

```bash
vegeta report -type=json results.bin > metrics.json
vegeta results.bin plot > plot.html
vegeta report -type="hist[0,100ms,200ms,300ms]" results.bin
```

### Vegeta cpu/heap profiling

```bash
go tool pprof -web /opt/homebrew/bin/vegeta cpu.pprof
```
