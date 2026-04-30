set title "Regular backward vs forward emulation w.r.t. proof size for all theorems"
unset multiplot
set style data lines
set term png
set xlabel "Proof size"
set ylabel "Time(s)"
set logscale y
set autoscale y
set output "plots/regular-vs-emulated-bc-all.png"
set datafile missing NaN
set datafile separator ","
set datafile commentschars "t"
plot "regular-vs-emulated-petta-benchmark.csv" using (strcol(1) eq "all" ? $3 : NaN):5 t "Regular backward" with lines smooth unique, \
     "regular-vs-emulated-petta-benchmark.csv" using (strcol(1) eq "all" ? $3 : NaN):6 t "Forward emulation" with lines smooth unique
