set title "Time of backward search w.r.t. solution density (PeTTa)"
unset multiplot
set style data lines
set term png
set xlabel "Solution density"
set ylabel "Time(s)"
set autoscale y
set output "plots/backward-time.png"
set datafile missing NaN
set datafile separator ","
set datafile commentschars "c"
plot "benchmark.csv" using (strcol(1) eq "backward" && strcol(2) eq "petta" && $4 == 3 ? $5 : NaN):6 t "PeTTa" with lines smooth unique
