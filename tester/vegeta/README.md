```
go tool pprof -web /opt/homebrew/bin/vegeta cpu.pprof

vegeta report -type=json results.bin > metrics.json
vegeta results.bin plot > plot.html
vegeta report -type="hist[0,100ms,200ms,300ms]" results.bin
```
