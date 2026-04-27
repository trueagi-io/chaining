set title "Ratio of forward emulation / regular backward for all theorems"
unset multiplot
set style data lines
set term png
set xlabel "Proof size"
set ylabel "Ratio (emulation slow down)"
set autoscale y
set output "plots/regular-vs-emulated-bc-all-ratio.png"
set datafile missing NaN
set datafile separator ","
set datafile commentschars "t"
plot "regular-vs-emulated-petta-benchmark.csv" using (strcol(1) eq "all" ? $3 : NaN):($6 / $5) t "emulation / regular" with lines smooth unique
