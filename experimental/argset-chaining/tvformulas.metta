!(import! &self utils)
;Formulas

!(bind! K 800)

(= (mp-formula (stv $abs $abc) (stv $as $ac)) (stv (* $abs $as) (min-atom ($abc $ac))))

(= (precise-mp-formula (stv $nabs $nabc) (stv $abs $abc) (stv $as $ac)) (stv (+ (* $abs $as) (* $nabs (- 1.0 $as))) (min-atom ($nabc  $abc $ac))))

(= (and-formula (stv $as $ac) (stv $bs $bc)) (stv (* $as $bs) (min-atom ($ac $bc))))
(= (or-formula (stv $as $ac) (stv $bs $bc)) (stv (max-atom ($as $bs)) (min-atom ($ac $bc))))

(= (inversion-formula (stv $as $ac) (stv $bs $bc) (stv $abs $abc)) (stv (/ (* $as $abs) $bs) (* 0.9 (min-atom ($ac $bc $abc)))))

(= (inversion-mp-formula (stv $as $ac) (stv $bs $bc) (stv $abs $abc)) (stv (* $as $abs) (min-atom ($ac $bc $abc))))

(= (confidenc-to-count $conf) (/ (* $conf K) (- 1 $conf)))

(= (count-to-confidenc $count) (/ $count (+ $count K)))

!(assertEqual (confidenc-to-count 0.9) 7200.000000000002)

!(assertEqual (count-to-confidenc 400.0) 0.3333333333333333)

(= (merge-counts $count1 $count2) (+ $count1 $count2))

(= (mean-update $m1 $m2 $c1 $c2) (/ (+ (* $m1 $c1) (* $m2 $c2)) (+ $c1 $c2)))

(= (stv-to-bettadist (stv $s $conf)) (let $cnt (confidenc-to-count $conf) (betadist (* $s $cnt) (* $cnt (- 1 $s)))))

!(assertEqual (mean-update 0.9 0.9 1 1) 0.9)

(= (mergetvs (stv $m1 $conf1) (stv $m2 $conf2))
   (let* (($count1 (confidenc-to-count $conf1))
          ($count2 (confidenc-to-count $conf2))
          ($m (mean-update $m1 $m2 $count1 $count2))
          ($c (merge-counts $count1 $count2))
          ($conf (count-to-confidenc $c))
          )
            (stv $m $conf)
         ))

;!(mergetvs (stv 0.9 0.9) (stv 0.9 0.9))


(= (update $atv)
  (let* (($btv1 (stv 0.2 0.9))
         ($btv2 (stv 0.9 0.9))
         ($itv (stv 1 1))
         ($iitv (inversion-formula $atv $btv1 $itv))
         ($natv (mp-formula $iitv $btv2))
        )
        $natv
  )
)

!(update (stv 0.1 0.1))
