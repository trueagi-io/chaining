set title "Time/solution ratio of backward search, 6087113 solutions, depth 4"
unset multiplot
set style data lines
set term png
set xlabel "Solution density"
set ylabel "Time/solution ratio"
set yrange [0:0.0005]
set output "plots/backward-time-solution-ratio.png"
set datafile missing NaN
set datafile separator ","
set datafile commentschars "c"
plot "benchmark.csv" using (strcol(1) eq "backward" && strcol(2) eq "petta" && $4 == 4 ? $5 / 6087113 : NaN):($6 / $5) t "PeTTa" with lines smooth unique
