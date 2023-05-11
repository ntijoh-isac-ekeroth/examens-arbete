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
