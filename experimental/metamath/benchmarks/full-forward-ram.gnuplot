set title "RAM usage of full forward search (PeTTa vs MORK)"
unset multiplot
set style data lines
set term png
set xlabel "Depth"
set ylabel "RAM(GB)"
set logscale y
set autoscale y
set output "plots/full-forward-ram.png"
set datafile missing NaN
set datafile separator ","
set datafile commentschars "c"
plot "benchmark.csv" using (strcol(1) eq "forward" && strcol(2) eq "petta" ? $4 : NaN):($7 / 1000000) t "PeTTa" with lines, \
     "benchmark.csv" using (strcol(1) eq "forward" && strcol(2) eq "mork" ? $4 : NaN):($7 / 1000000) t "MORK" with lines
