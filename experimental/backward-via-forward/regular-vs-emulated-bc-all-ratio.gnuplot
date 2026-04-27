set title "Ratio of forward emulated / regular backward wrt proof size for all theorems"
unset multiplot
set style data lines
set term png
set xlabel "Proof size"
set ylabel "Ratio"
set autoscale y
set output "plots/regular-vs-emulated-bc-all-ratio.png"
set datafile missing NaN
set datafile separator ","
set datafile commentschars "t"
plot "benchmark.csv" using (strcol(1) eq "all" ? $3 : NaN):($6 / $5) t "emulated / regular" with lines smooth unique
