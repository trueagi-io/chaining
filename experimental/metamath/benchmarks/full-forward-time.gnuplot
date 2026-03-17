set title "Time of full forward search (PeTTa vs MORK)"
unset multiplot
set style data lines
set term png
set xlabel "Depth"
set ylabel "Time(s)"
set logscale y
set autoscale y
set output "plots/full-forward-time.png"
set datafile missing NaN
set datafile separator ","
set datafile commentschars "c"
plot "benchmark.csv" using (strcol(1) eq "forward" && strcol(2) eq "petta" ? $4 : NaN):($6 < 0.001 ? 0.001 : $6) t "PeTTa" with lines, \
     "benchmark.csv" using (strcol(1) eq "forward" && strcol(2) eq "mork" ? $4 : NaN):($6 < 0.001 ? 0.001 : $6) t "MORK" with lines
