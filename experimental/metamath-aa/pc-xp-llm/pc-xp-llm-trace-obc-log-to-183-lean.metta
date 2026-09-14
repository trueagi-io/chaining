;; ============================================================
;; pc-xp-llm-trace-obc-log-to-183-lean.metta
;;
;; Lean training data for the LLM sub-theory predictor.
;;
;; Generated from examples/result-hot-llm-full/pc-xp.log (the 2026-07-07
;; hot->LLM->full claude run, which proved every theorem through 183,
;; including pm2.61iii at 182 via a ~4.5h full-KB search).
;; Covers corpus iterations 6..183.  NOTE: any LLM evaluation on
;; theorems <= 183 is therefore contaminated (answer in prompt);
;; the clean out-of-training range starts at 184.
;;
;; Format, per fact:  (TraceSmallest LABEL SMALLEST THEOREM)
;; where SMALLEST is exactly the set of labels directly referenced in
;; the logged proof term, excluding lambda-bound local proof variables.
;; ============================================================

(: TraceSmallest (-> Symbol     ; Label
                      Expression ; Smallest direct label set from obc proof
                      Atom       ; Theorem
                      Atom))     ; TraceSmallest fact

;; iteration 6: mp2
(TraceSmallest mp2 (ax-mp) (-> (→ 𝜑 (→ 𝜓 𝜒)) 𝜓 𝜑 𝜒))
;; iteration 7: mp2b
(TraceSmallest mp2b (ax-mp) (-> (→ 𝜓 𝜒) (→ 𝜑 𝜓) 𝜑 𝜒))
;; iteration 8: a1i
(TraceSmallest a1i (ax-mp ax-1) (-> 𝜑 (→ 𝜓 𝜑)))
;; iteration 9: 2a1i
(TraceSmallest 2a1i (a1i) (-> 𝜑 (→ 𝜓 (→ 𝜒 𝜑))))
;; iteration 10: mp1i
(TraceSmallest mp1i (a1i ax-mp) (-> (→ 𝜑 𝜓) 𝜑 (→ 𝜒 𝜓)))
;; iteration 11: a2i
(TraceSmallest a2i (ax-mp ax-2) (-> (→ 𝜑 (→ 𝜓 𝜒)) (→ (→ 𝜑 𝜓) (→ 𝜑 𝜒))))
;; iteration 12: mpd
(TraceSmallest mpd (ax-mp a2i) (-> (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 𝜓) (→ 𝜑 𝜒)))
;; iteration 13: imim2i
(TraceSmallest imim2i (a2i a1i) (-> (→ 𝜑 𝜓) (→ (→ 𝜒 𝜑) (→ 𝜒 𝜓))))
;; iteration 14: syl
(TraceSmallest syl (ax-mp imim2i) (-> (→ 𝜓 𝜒) (→ 𝜑 𝜓) (→ 𝜑 𝜒)))
;; iteration 15: 3syl
(TraceSmallest 3syl (syl) (-> (→ 𝜒 𝜃) (→ 𝜓 𝜒) (→ 𝜑 𝜓) (→ 𝜑 𝜃)))
;; iteration 16: 4syl
(TraceSmallest 4syl (syl 3syl) (-> (→ 𝜃 𝜏) (→ 𝜒 𝜃) (→ 𝜓 𝜒) (→ 𝜑 𝜓) (→ 𝜑 𝜏)))
;; iteration 17: mpi
(TraceSmallest mpi (mpd a1i) (-> (→ 𝜑 (→ 𝜓 𝜒)) 𝜓 (→ 𝜑 𝜒)))
;; iteration 18: mpisyl
(TraceSmallest mpisyl (syl mpi) (-> (→ 𝜓 (→ 𝜒 𝜃)) 𝜒 (→ 𝜑 𝜓) (→ 𝜑 𝜃)))
;; iteration 19: id
(TraceSmallest id (mpd ax-1) (→ 𝜑 𝜑))
;; iteration 20: idALT
(TraceSmallest idALT (id) (→ 𝜑 𝜑))
;; iteration 21: idd
(TraceSmallest idd (a1i id) (→ 𝜑 (→ 𝜓 𝜓)))
;; iteration 22: a1d
(TraceSmallest a1d (syl ax-1) (-> (→ 𝜑 𝜓) (→ 𝜑 (→ 𝜒 𝜓))))
;; iteration 23: 2a1d
(TraceSmallest 2a1d (a1d) (-> (→ 𝜑 𝜓) (→ 𝜑 (→ 𝜒 (→ 𝜃 𝜓)))))
;; iteration 24: a1i13
(TraceSmallest a1i13 (a1i a1d) (-> (→ 𝜓 𝜃) (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜃)))))
;; iteration 25: 2a1
(TraceSmallest 2a1 (a1d ax-1) (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜑))))
;; iteration 26: a2d
(TraceSmallest a2d (syl ax-2) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜃))) (→ 𝜑 (→ (→ 𝜓 𝜒) (→ 𝜓 𝜃)))))
;; iteration 27: sylcom
(TraceSmallest sylcom (syl a2i) (-> (→ 𝜓 (→ 𝜒 𝜃)) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ 𝜓 𝜃))))
;; iteration 28: syl5com
(TraceSmallest syl5com (sylcom a1d) (-> (→ 𝜒 (→ 𝜓 𝜃)) (→ 𝜑 𝜓) (→ 𝜑 (→ 𝜒 𝜃))))
;; iteration 29: com12
(TraceSmallest com12 (sylcom ax-1) (-> (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜓 (→ 𝜑 𝜒))))
;; iteration 30: syl11
(TraceSmallest syl11 (com12 syl) (-> (→ 𝜃 𝜑) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜓 (→ 𝜃 𝜒))))
;; iteration 31: syl5
(TraceSmallest syl5 (com12 syl5com) (-> (→ 𝜒 (→ 𝜓 𝜃)) (→ 𝜑 𝜓) (→ 𝜒 (→ 𝜑 𝜃))))
;; iteration 32: syl6
(TraceSmallest syl6 (syl imim2i) (-> (→ 𝜒 𝜃) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ 𝜓 𝜃))))
;; iteration 33: syl56
(TraceSmallest syl56 (syl5 syl6) (-> (→ 𝜃 𝜏) (→ 𝜒 (→ 𝜓 𝜃)) (→ 𝜑 𝜓) (→ 𝜒 (→ 𝜑 𝜏))))
;; iteration 34: syl6com
(TraceSmallest syl6com (com12 syl6) (-> (→ 𝜒 𝜃) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜓 (→ 𝜑 𝜃))))
;; iteration 35: mpcom
(TraceSmallest mpcom (mpd com12) (-> (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜓 𝜑) (→ 𝜓 𝜒)))
;; iteration 36: syli
(TraceSmallest syli (sylcom com12) (-> (→ 𝜒 (→ 𝜑 𝜃)) (→ 𝜓 (→ 𝜑 𝜒)) (→ 𝜓 (→ 𝜑 𝜃))))
;; iteration 37: syl2im
(TraceSmallest syl2im (syl syl5) (-> (→ 𝜓 (→ 𝜃 𝜏)) (→ 𝜒 𝜃) (→ 𝜑 𝜓) (→ 𝜑 (→ 𝜒 𝜏))))
;; iteration 38: syl2imc
(TraceSmallest syl2imc (com12 syl2im) (-> (→ 𝜓 (→ 𝜃 𝜏)) (→ 𝜒 𝜃) (→ 𝜑 𝜓) (→ 𝜒 (→ 𝜑 𝜏))))
;; iteration 39: pm2.27
(TraceSmallest pm2.27 (com12 id) (→ 𝜑 (→ (→ 𝜑 𝜓) 𝜓)))
;; iteration 40: mpdd
(TraceSmallest mpdd (mpd a2d) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜃))) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ 𝜓 𝜃))))
;; iteration 41: mpid
(TraceSmallest mpid (mpdd a1d) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜃))) (→ 𝜑 𝜒) (→ 𝜑 (→ 𝜓 𝜃))))
;; iteration 42: mpdi
(TraceSmallest mpdi (mpi a2d) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜃))) (→ 𝜓 𝜒) (→ 𝜑 (→ 𝜓 𝜃))))
;; iteration 43: mpii
(TraceSmallest mpii (mpdd 2a1i) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜃))) 𝜒 (→ 𝜑 (→ 𝜓 𝜃))))
;; iteration 44: syld
(TraceSmallest syld (mpdd a1d) (-> (→ 𝜑 (→ 𝜒 𝜃)) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ 𝜓 𝜃))))
;; iteration 45: syldc
(TraceSmallest syldc (com12 syld) (-> (→ 𝜑 (→ 𝜒 𝜃)) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜓 (→ 𝜑 𝜃))))
;; iteration 46: mp2d
(TraceSmallest mp2d (mpd) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜃))) (→ 𝜑 𝜒) (→ 𝜑 𝜓) (→ 𝜑 𝜃)))
;; iteration 47: a1dd
(TraceSmallest a1dd (syl6 ax-1) (-> (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ 𝜓 (→ 𝜃 𝜒)))))
;; iteration 48: 2a1dd
(TraceSmallest 2a1dd (a1dd) (-> (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ 𝜓 (→ 𝜃 (→ 𝜏 𝜒))))))
;; iteration 49: pm2.43i
(TraceSmallest pm2.43i (mpcom id) (-> (→ 𝜑 (→ 𝜑 𝜓)) (→ 𝜑 𝜓)))
;; iteration 50: pm2.43d
(TraceSmallest pm2.43d (sylcom pm2.27) (-> (→ 𝜑 (→ 𝜓 (→ 𝜓 𝜒))) (→ 𝜑 (→ 𝜓 𝜒))))
;; iteration 51: pm2.43a
(TraceSmallest pm2.43a (mpdd ax-1) (-> (→ 𝜓 (→ 𝜑 (→ 𝜓 𝜒))) (→ 𝜓 (→ 𝜑 𝜒))))
;; iteration 52: pm2.43b
(TraceSmallest pm2.43b (com12 pm2.43a) (-> (→ 𝜓 (→ 𝜑 (→ 𝜓 𝜒))) (→ 𝜑 (→ 𝜓 𝜒))))
;; iteration 53: pm2.43
(TraceSmallest pm2.43 (pm2.43d id) (→ (→ 𝜑 (→ 𝜑 𝜓)) (→ 𝜑 𝜓)))
;; iteration 54: imim2d
(TraceSmallest imim2d (a2d a1d) (-> (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ (→ 𝜃 𝜓) (→ 𝜃 𝜒)))))
;; iteration 55: imim2
(TraceSmallest imim2 (a2d ax-1) (→ (→ 𝜑 𝜓) (→ (→ 𝜒 𝜑) (→ 𝜒 𝜓))))
;; iteration 56: embantd
(TraceSmallest embantd (mpid imim2d) (-> (→ 𝜑 (→ 𝜒 𝜃)) (→ 𝜑 𝜓) (→ 𝜑 (→ (→ 𝜓 𝜒) 𝜃))))
;; iteration 57: 3syld
(TraceSmallest 3syld (syld) (-> (→ 𝜑 (→ 𝜃 𝜏)) (→ 𝜑 (→ 𝜒 𝜃)) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ 𝜓 𝜏))))
;; iteration 58: sylsyld
(TraceSmallest sylsyld (syld syl) (-> (→ 𝜓 (→ 𝜃 𝜏)) (→ 𝜑 (→ 𝜒 𝜃)) (→ 𝜑 𝜓) (→ 𝜑 (→ 𝜒 𝜏))))
;; iteration 59: imim12i
(TraceSmallest imim12i (syl56 id) (-> (→ 𝜒 𝜃) (→ 𝜑 𝜓) (→ (→ 𝜓 𝜒) (→ 𝜑 𝜃))))
;; iteration 60: imim1i
(TraceSmallest imim1i (syl11 pm2.27) (-> (→ 𝜑 𝜓) (→ (→ 𝜓 𝜒) (→ 𝜑 𝜒))))
;; iteration 61: imim3i
(TraceSmallest imim3i (a2d imim2i) (-> (→ 𝜑 (→ 𝜓 𝜒)) (→ (→ 𝜃 𝜑) (→ (→ 𝜃 𝜓) (→ 𝜃 𝜒)))))
;; iteration 62: sylc
(TraceSmallest sylc (pm2.43i syl2im) (-> (→ 𝜓 (→ 𝜒 𝜃)) (→ 𝜑 𝜒) (→ 𝜑 𝜓) (→ 𝜑 𝜃)))
;; iteration 63: syl3c
(TraceSmallest syl3c (mpd sylc) (-> (→ 𝜓 (→ 𝜒 (→ 𝜃 𝜏))) (→ 𝜑 𝜃) (→ 𝜑 𝜒) (→ 𝜑 𝜓) (→ 𝜑 𝜏)))
;; iteration 64: syl6mpi
(TraceSmallest syl6mpi (syl6 mpi) (-> (→ 𝜒 (→ 𝜃 𝜏)) 𝜃 (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ 𝜓 𝜏))))
;; iteration 65: mpsyl
(TraceSmallest mpsyl (ax-mp syl5) (-> (→ 𝜑 (→ 𝜒 𝜃)) (→ 𝜓 𝜒) 𝜑 (→ 𝜓 𝜃)))
;; iteration 66: mpsylsyld
(TraceSmallest mpsylsyld (mpsyl imim2d) (-> (→ 𝜑 (→ 𝜃 𝜏)) (→ 𝜓 (→ 𝜒 𝜃)) 𝜑 (→ 𝜓 (→ 𝜒 𝜏))))
;; iteration 67: syl6c
(TraceSmallest syl6c (sylc imim3i) (-> (→ 𝜒 (→ 𝜃 𝜏)) (→ 𝜑 (→ 𝜓 𝜃)) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ 𝜓 𝜏))))
;; iteration 68: syl6ci
(TraceSmallest syl6ci (mpid syl6) (-> (→ 𝜒 (→ 𝜃 𝜏)) (→ 𝜑 𝜃) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ 𝜓 𝜏))))
;; iteration 69: syldd
(TraceSmallest syldd (syl6c imim2) (-> (→ 𝜑 (→ 𝜓 (→ 𝜃 𝜏))) (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜃))) (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜏)))))
;; iteration 70: syl5d
(TraceSmallest syl5d (syl6ci imim2) (-> (→ 𝜑 (→ 𝜃 (→ 𝜒 𝜏))) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ 𝜃 (→ 𝜓 𝜏)))))
;; iteration 71: syl7
(TraceSmallest syl7 (syl6mpi imim2) (-> (→ 𝜒 (→ 𝜃 (→ 𝜓 𝜏))) (→ 𝜑 𝜓) (→ 𝜒 (→ 𝜃 (→ 𝜑 𝜏)))))
;; iteration 72: syl6d
(TraceSmallest syl6d (syld imim2d) (-> (→ 𝜑 (→ 𝜃 𝜏)) (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜃))) (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜏)))))
;; iteration 73: syl8
(TraceSmallest syl8 (mpsylsyld imim2) (-> (→ 𝜃 𝜏) (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜃))) (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜏)))))
;; iteration 74: syl9
(TraceSmallest syl9 (syl5com imim2d) (-> (→ 𝜃 (→ 𝜒 𝜏)) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ 𝜃 (→ 𝜓 𝜏)))))
;; iteration 75: syl9r
(TraceSmallest syl9r (com12 syl9) (-> (→ 𝜃 (→ 𝜒 𝜏)) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜃 (→ 𝜑 (→ 𝜓 𝜏)))))
;; iteration 76: syl10
(TraceSmallest syl10 (syl6c imim2d) (-> (→ 𝜒 (→ 𝜏 𝜂)) (→ 𝜑 (→ 𝜓 (→ 𝜃 𝜏))) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ 𝜓 (→ 𝜃 𝜂)))))
;; iteration 77: a1ddd
(TraceSmallest a1ddd (syl8 ax-1) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜏))) (→ 𝜑 (→ 𝜓 (→ 𝜒 (→ 𝜃 𝜏))))))
;; iteration 78: imim12d
(TraceSmallest imim12d (syl5d imim2d) (-> (→ 𝜑 (→ 𝜃 𝜏)) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ (→ 𝜒 𝜃) (→ 𝜓 𝜏)))))
;; iteration 79: imim1d
(TraceSmallest imim1d (syl9 id) (-> (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ (→ 𝜒 𝜃) (→ 𝜓 𝜃)))))
;; iteration 80: imim1
(TraceSmallest imim1 (imim1d id) (→ (→ 𝜑 𝜓) (→ (→ 𝜓 𝜒) (→ 𝜑 𝜒))))
;; iteration 81: pm2.83
(TraceSmallest pm2.83 (imim3i imim1) (→ (→ 𝜑 (→ 𝜓 𝜒)) (→ (→ 𝜑 (→ 𝜒 𝜃)) (→ 𝜑 (→ 𝜓 𝜃)))))
;; iteration 82: peirceroll
(TraceSmallest peirceroll (syl9r id imim1) (→ (→ (→ (→ 𝜑 𝜓) 𝜑) 𝜑) (→ (→ (→ 𝜑 𝜓) 𝜒) (→ (→ 𝜒 𝜑) 𝜑))))
;; iteration 83: com23
(TraceSmallest com23 (syl9 pm2.27) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜃))) (→ 𝜑 (→ 𝜒 (→ 𝜓 𝜃)))))
;; iteration 84: com3r
(TraceSmallest com3r (com12 com23) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜃))) (→ 𝜒 (→ 𝜑 (→ 𝜓 𝜃)))))
;; iteration 85: com13
(TraceSmallest com13 (com23 com3r) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜃))) (→ 𝜒 (→ 𝜓 (→ 𝜑 𝜃)))))
;; iteration 86: com3l
(TraceSmallest com3l (com3r) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜃))) (→ 𝜓 (→ 𝜒 (→ 𝜑 𝜃)))))
;; iteration 87: pm2.04
(TraceSmallest pm2.04 (com23 id) (→ (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜓 (→ 𝜑 𝜒))))
;; iteration 88: com34
(TraceSmallest com34 (syl6 pm2.04) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 (→ 𝜃 𝜏)))) (→ 𝜑 (→ 𝜓 (→ 𝜃 (→ 𝜒 𝜏))))))
;; iteration 89: com4l
(TraceSmallest com4l (com34 com3l) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 (→ 𝜃 𝜏)))) (→ 𝜓 (→ 𝜒 (→ 𝜃 (→ 𝜑 𝜏))))))
;; iteration 90: com4t
(TraceSmallest com4t (com4l) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 (→ 𝜃 𝜏)))) (→ 𝜒 (→ 𝜃 (→ 𝜑 (→ 𝜓 𝜏))))))
;; iteration 91: com4r
(TraceSmallest com4r (com3r com34) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 (→ 𝜃 𝜏)))) (→ 𝜃 (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜏))))))
;; iteration 92: com24
(TraceSmallest com24 (com13 com4t) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 (→ 𝜃 𝜏)))) (→ 𝜑 (→ 𝜃 (→ 𝜒 (→ 𝜓 𝜏))))))
;; iteration 93: com14
(TraceSmallest com14 (com3r com4l) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 (→ 𝜃 𝜏)))) (→ 𝜃 (→ 𝜓 (→ 𝜒 (→ 𝜑 𝜏))))))
;; iteration 94: com45
(TraceSmallest com45 (syl8 pm2.04) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 (→ 𝜃 (→ 𝜏 𝜂))))) (→ 𝜑 (→ 𝜓 (→ 𝜒 (→ 𝜏 (→ 𝜃 𝜂)))))))
;; iteration 95: com35
(TraceSmallest com35 (com34 com45) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 (→ 𝜃 (→ 𝜏 𝜂))))) (→ 𝜑 (→ 𝜓 (→ 𝜏 (→ 𝜃 (→ 𝜒 𝜂)))))))
;; iteration 96: com25
(TraceSmallest com25 (com23 com35) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 (→ 𝜃 (→ 𝜏 𝜂))))) (→ 𝜑 (→ 𝜏 (→ 𝜒 (→ 𝜃 (→ 𝜓 𝜂)))))))
;; iteration 97: com5l
(TraceSmallest com5l (com45 com4l) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 (→ 𝜃 (→ 𝜏 𝜂))))) (→ 𝜓 (→ 𝜒 (→ 𝜃 (→ 𝜏 (→ 𝜑 𝜂)))))))
;; iteration 98: com15
(TraceSmallest com15 (com4r com5l) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 (→ 𝜃 (→ 𝜏 𝜂))))) (→ 𝜏 (→ 𝜓 (→ 𝜒 (→ 𝜃 (→ 𝜑 𝜂)))))))
;; iteration 99: com52l
(TraceSmallest com52l (com5l) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 (→ 𝜃 (→ 𝜏 𝜂))))) (→ 𝜒 (→ 𝜃 (→ 𝜏 (→ 𝜑 (→ 𝜓 𝜂)))))))
;; iteration 100: com52r
(TraceSmallest com52r (com5l com52l) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 (→ 𝜃 (→ 𝜏 𝜂))))) (→ 𝜃 (→ 𝜏 (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜂)))))))
;; iteration 101: com5r
(TraceSmallest com5r (com4r com45) (-> (→ 𝜑 (→ 𝜓 (→ 𝜒 (→ 𝜃 (→ 𝜏 𝜂))))) (→ 𝜏 (→ 𝜑 (→ 𝜓 (→ 𝜒 (→ 𝜃 𝜂)))))))
;; iteration 102: imim12
(TraceSmallest imim12 (syl9 imim2 imim1) (→ (→ 𝜑 𝜓) (→ (→ 𝜒 𝜃) (→ (→ 𝜓 𝜒) (→ 𝜑 𝜃)))))
;; iteration 103: jarr
(TraceSmallest jarr (imim1i ax-1) (→ (→ (→ 𝜑 𝜓) 𝜒) (→ 𝜓 𝜒)))
;; iteration 104: jarri
(TraceSmallest jarri (ax-mp jarr) (-> (→ (→ 𝜑 𝜓) 𝜒) (→ 𝜓 𝜒)))
;; iteration 105: pm2.86d
(TraceSmallest pm2.86d (com13 jarri com3l) (-> (→ 𝜑 (→ (→ 𝜓 𝜒) (→ 𝜓 𝜃))) (→ 𝜑 (→ 𝜓 (→ 𝜒 𝜃)))))
;; iteration 106: pm2.86
(TraceSmallest pm2.86 (com23 jarr) (→ (→ (→ 𝜑 𝜓) (→ 𝜑 𝜒)) (→ 𝜑 (→ 𝜓 𝜒))))
;; iteration 107: pm2.86i
(TraceSmallest pm2.86i (ax-mp pm2.86) (-> (→ (→ 𝜑 𝜓) (→ 𝜑 𝜒)) (→ 𝜑 (→ 𝜓 𝜒))))
;; iteration 108: loolin
(TraceSmallest loolin (pm2.43d jarr) (→ (→ (→ 𝜑 𝜓) (→ 𝜓 𝜑)) (→ 𝜓 𝜑)))
;; iteration 109: loowoz
(TraceSmallest loowoz (a2d jarr) (→ (→ (→ 𝜑 𝜓) (→ 𝜑 𝜒)) (→ (→ 𝜓 𝜑) (→ 𝜓 𝜒))))
;; iteration 110: con4
(TraceSmallest con4 (ax-3) (→ (→ (¬ 𝜑) (¬ 𝜓)) (→ 𝜓 𝜑)))
;; iteration 111: con4i
(TraceSmallest con4i (ax-mp ax-3) (-> (→ (¬ 𝜑) (¬ 𝜓)) (→ 𝜓 𝜑)))
;; iteration 112: con4d
(TraceSmallest con4d (syl ax-3) (-> (→ 𝜑 (→ (¬ 𝜓) (¬ 𝜒))) (→ 𝜑 (→ 𝜒 𝜓))))
;; iteration 113: mt4
(TraceSmallest mt4 (ax-mp con4i) (-> (→ (¬ 𝜓) (¬ 𝜑)) 𝜑 𝜓))
;; iteration 114: mt4d
(TraceSmallest mt4d (mpd con4d) (-> (→ 𝜑 (→ (¬ 𝜒) (¬ 𝜓))) (→ 𝜑 𝜓) (→ 𝜑 𝜒)))
;; iteration 115: mt4i
(TraceSmallest mt4i (mpi con4d) (-> (→ 𝜑 (→ (¬ 𝜓) (¬ 𝜒))) 𝜒 (→ 𝜑 𝜓)))
;; iteration 116: pm2.21i
(TraceSmallest pm2.21i (con4i a1i) (-> (¬ 𝜑) (→ 𝜑 𝜓)))
;; iteration 117: pm2.24ii
(TraceSmallest pm2.24ii (ax-mp pm2.21i) (-> (¬ 𝜑) 𝜑 𝜓))
;; iteration 118: pm2.21d
(TraceSmallest pm2.21d (con4d a1d) (-> (→ 𝜑 (¬ 𝜓)) (→ 𝜑 (→ 𝜓 𝜒))))
;; iteration 119: pm2.21ddALT
(TraceSmallest pm2.21ddALT (mpd pm2.21d) (-> (→ 𝜑 (¬ 𝜓)) (→ 𝜑 𝜓) (→ 𝜑 𝜒)))
;; iteration 120: pm2.21
(TraceSmallest pm2.21 (jarri ax-3) (→ (¬ 𝜑) (→ 𝜑 𝜓)))
;; iteration 121: pm2.24
(TraceSmallest pm2.24 (com12 pm2.21) (→ 𝜑 (→ (¬ 𝜑) 𝜓)))
;; iteration 122: jarl
(TraceSmallest jarl (imim1i pm2.21) (→ (→ (→ 𝜑 𝜓) 𝜒) (→ (¬ 𝜑) 𝜒)))
;; iteration 123: jarli
(TraceSmallest jarli (ax-mp jarl) (-> (→ (→ 𝜑 𝜓) 𝜒) (→ (¬ 𝜑) 𝜒)))
;; iteration 124: pm2.18d
(TraceSmallest pm2.18d (pm2.43i con4d sylcom pm2.21) (-> (→ 𝜑 (→ (¬ 𝜓) 𝜓)) (→ 𝜑 𝜓)))
;; iteration 125: pm2.18
(TraceSmallest pm2.18 (pm2.18d id) (→ (→ (¬ 𝜑) 𝜑) 𝜑))
;; iteration 126: pm2.18i
(TraceSmallest pm2.18i (ax-mp pm2.18) (-> (→ (¬ 𝜑) 𝜑) 𝜑))
;; iteration 127: notnotr
(TraceSmallest notnotr (jarli pm2.18) (→ (¬ (¬ 𝜑)) 𝜑))
;; iteration 128: notnotri
(TraceSmallest notnotri (pm2.18i con4i pm2.21i) (-> (¬ (¬ 𝜑)) 𝜑))
;; iteration 129: notnotriALT
(TraceSmallest notnotriALT (pm2.18i pm2.21i) (-> (¬ (¬ 𝜑)) 𝜑))
;; iteration 130: notnotrd
(TraceSmallest notnotrd (pm2.18d pm2.21d) (-> (→ 𝜑 (¬ (¬ 𝜓))) (→ 𝜑 𝜓)))
;; iteration 131: con2d
(TraceSmallest con2d (con4d syl5 notnotr) (-> (→ 𝜑 (→ 𝜓 (¬ 𝜒))) (→ 𝜑 (→ 𝜒 (¬ 𝜓)))))
;; iteration 132: con2
(TraceSmallest con2 (con2d id) (→ (→ 𝜑 (¬ 𝜓)) (→ 𝜓 (¬ 𝜑))))
;; iteration 133: mt2d
(TraceSmallest mt2d (mpd con2d) (-> (→ 𝜑 (→ 𝜓 (¬ 𝜒))) (→ 𝜑 𝜒) (→ 𝜑 (¬ 𝜓))))
;; iteration 134: mt2i
(TraceSmallest mt2i (mpi con2d) (-> (→ 𝜑 (→ 𝜓 (¬ 𝜒))) 𝜒 (→ 𝜑 (¬ 𝜓))))
;; iteration 135: nsyl3
(TraceSmallest nsyl3 (mt2d a1i) (-> (→ 𝜒 𝜓) (→ 𝜑 (¬ 𝜓)) (→ 𝜒 (¬ 𝜑))))
;; iteration 136: con2i
(TraceSmallest con2i (ax-mp con2) (-> (→ 𝜑 (¬ 𝜓)) (→ 𝜓 (¬ 𝜑))))
;; iteration 137: nsyl
(TraceSmallest nsyl (con2i nsyl3) (-> (→ 𝜒 𝜓) (→ 𝜑 (¬ 𝜓)) (→ 𝜑 (¬ 𝜒))))
;; iteration 138: nsyl2
(TraceSmallest nsyl2 (con4i nsyl3) (-> (→ (¬ 𝜒) 𝜓) (→ 𝜑 (¬ 𝜓)) (→ 𝜑 𝜒)))
;; iteration 139: notnot
(TraceSmallest notnot (con4i notnotr) (→ 𝜑 (¬ (¬ 𝜑))))
;; iteration 140: notnoti
(TraceSmallest notnoti (ax-mp notnot) (-> 𝜑 (¬ (¬ 𝜑))))
;; iteration 141: notnotd
(TraceSmallest notnotd (nsyl3 id) (-> (→ 𝜑 𝜓) (→ 𝜑 (¬ (¬ 𝜓)))))
;; iteration 142: con1d
(TraceSmallest con1d (con4d syl6 notnot) (-> (→ 𝜑 (→ (¬ 𝜓) 𝜒)) (→ 𝜑 (→ (¬ 𝜒) 𝜓))))
;; iteration 143: con1
(TraceSmallest con1 (con1d id) (→ (→ (¬ 𝜑) 𝜓) (→ (¬ 𝜓) 𝜑)))
;; iteration 144: con1i
(TraceSmallest con1i (ax-mp con1) (-> (→ (¬ 𝜑) 𝜓) (→ (¬ 𝜓) 𝜑)))
;; iteration 145: mt3d
(TraceSmallest mt3d (mpd con1d) (-> (→ 𝜑 (→ (¬ 𝜓) 𝜒)) (→ 𝜑 (¬ 𝜒)) (→ 𝜑 𝜓)))
;; iteration 146: mt3i
(TraceSmallest mt3i (mpi con1d) (-> (→ 𝜑 (→ (¬ 𝜓) 𝜒)) (¬ 𝜒) (→ 𝜑 𝜓)))
;; iteration 147: pm2.24i
(TraceSmallest pm2.24i (ax-mp pm2.24) (-> 𝜑 (→ (¬ 𝜑) 𝜓)))
;; iteration 148: pm2.24d
(TraceSmallest pm2.24d (pm2.21d notnotd) (-> (→ 𝜑 𝜓) (→ 𝜑 (→ (¬ 𝜓) 𝜒))))
;; iteration 149: con3d
(TraceSmallest con3d (con2d syl6 notnot) (-> (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ (¬ 𝜒) (¬ 𝜓)))))
;; iteration 150: con3
(TraceSmallest con3 (con3d id) (→ (→ 𝜑 𝜓) (→ (¬ 𝜓) (¬ 𝜑))))
;; iteration 151: con3i
(TraceSmallest con3i (con2i notnotd) (-> (→ 𝜑 𝜓) (→ (¬ 𝜓) (¬ 𝜑))))
;; iteration 152: con3rr3
(TraceSmallest con3rr3 (com12 con3d) (-> (→ 𝜑 (→ 𝜓 𝜒)) (→ (¬ 𝜒) (→ 𝜑 (¬ 𝜓)))))
;; iteration 153: nsyld
(TraceSmallest nsyld (syld con3d) (-> (→ 𝜑 (→ 𝜏 𝜒)) (→ 𝜑 (→ 𝜓 (¬ 𝜒))) (→ 𝜑 (→ 𝜓 (¬ 𝜏)))))
;; iteration 154: nsyli
(TraceSmallest nsyli (syl11 con3rr3) (-> (→ 𝜃 (¬ 𝜒)) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 (→ 𝜃 (¬ 𝜓)))))
;; iteration 155: nsyl4
(TraceSmallest nsyl4 (syl con1i) (-> (→ (¬ 𝜑) 𝜒) (→ 𝜑 𝜓) (→ (¬ 𝜒) 𝜓)))
;; iteration 156: nsyl5
(TraceSmallest nsyl5 (con1i nsyl4) (-> (→ (¬ 𝜑) 𝜒) (→ 𝜑 𝜓) (→ (¬ 𝜓) 𝜒)))
;; iteration 157: pm3.2im
(TraceSmallest pm3.2im (con2d pm2.27) (→ 𝜑 (→ 𝜓 (¬ (→ 𝜑 (¬ 𝜓))))))
;; iteration 158: jc
(TraceSmallest jc (sylc pm3.2im) (-> (→ 𝜑 𝜒) (→ 𝜑 𝜓) (→ 𝜑 (¬ (→ 𝜓 (¬ 𝜒))))))
;; iteration 159: jcn
(TraceSmallest jcn (con3d pm2.27) (→ 𝜑 (→ (¬ 𝜓) (¬ (→ 𝜑 𝜓)))))
;; iteration 160: jcnd
(TraceSmallest jcnd (sylc jcn) (-> (→ 𝜑 (¬ 𝜒)) (→ 𝜑 𝜓) (→ 𝜑 (¬ (→ 𝜓 𝜒)))))
;; iteration 161: impi
(TraceSmallest impi (con1i con3rr3) (-> (→ 𝜑 (→ 𝜓 𝜒)) (→ (¬ (→ 𝜑 (¬ 𝜓))) 𝜒)))
;; iteration 162: expi
(TraceSmallest expi (syl6 pm3.2im) (-> (→ (¬ (→ 𝜑 (¬ 𝜓))) 𝜒) (→ 𝜑 (→ 𝜓 𝜒))))
;; iteration 163: simprim
(TraceSmallest simprim (con1i ax-1) (→ (¬ (→ 𝜑 (¬ 𝜓))) 𝜓))
;; iteration 164: simplim
(TraceSmallest simplim (con1i pm2.21) (→ (¬ (→ 𝜑 𝜓)) 𝜑))
;; iteration 165: pm2.5g
(TraceSmallest pm2.5g (pm2.24d simplim) (→ (¬ (→ 𝜑 𝜓)) (→ (¬ 𝜑) 𝜒)))
;; iteration 166: pm2.5
(TraceSmallest pm2.5 (pm2.5g) (→ (¬ (→ 𝜑 𝜓)) (→ (¬ 𝜑) 𝜓)))
;; iteration 167: conax1
(TraceSmallest conax1 (con3i ax-1) (→ (¬ (→ 𝜑 𝜓)) (¬ 𝜓)))
;; iteration 168: conax1k
(TraceSmallest conax1k (a1d conax1) (→ (¬ (→ 𝜑 𝜓)) (→ 𝜒 (¬ 𝜓))))
;; iteration 169: pm2.51
(TraceSmallest pm2.51 (conax1k) (→ (¬ (→ 𝜑 𝜓)) (→ 𝜑 (¬ 𝜓))))
;; iteration 170: pm2.52
(TraceSmallest pm2.52 (pm2.5g) (→ (¬ (→ 𝜑 𝜓)) (→ (¬ 𝜑) (¬ 𝜓))))
;; iteration 171: pm2.521g
(TraceSmallest pm2.521g (pm2.21d conax1) (→ (¬ (→ 𝜑 𝜓)) (→ 𝜓 𝜒)))
;; iteration 172: pm2.521g2
(TraceSmallest pm2.521g2 (con1i pm2.521g) (→ (¬ (→ 𝜑 𝜓)) (→ 𝜒 𝜑)))
;; iteration 173: pm2.521
(TraceSmallest pm2.521 (pm2.521g) (→ (¬ (→ 𝜑 𝜓)) (→ 𝜓 𝜑)))
;; iteration 174: expt
(TraceSmallest expt (com12 imim1d pm3.2im) (→ (→ (¬ (→ 𝜑 (¬ 𝜓))) 𝜒) (→ 𝜑 (→ 𝜓 𝜒))))
;; iteration 175: impt
(TraceSmallest impt (com12 impi com23 pm2.27) (→ (→ 𝜑 (→ 𝜓 𝜒)) (→ (¬ (→ 𝜑 (¬ 𝜓))) 𝜒)))
;; iteration 176: pm2.61d
(TraceSmallest pm2.61d (pm2.18d syld con3d) (-> (→ 𝜑 (→ (¬ 𝜓) 𝜒)) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 𝜒)))
;; iteration 177: pm2.61d1
(TraceSmallest pm2.61d1 (pm2.61d a1i) (-> (→ (¬ 𝜓) 𝜒) (→ 𝜑 (→ 𝜓 𝜒)) (→ 𝜑 𝜒)))
;; iteration 178: pm2.61d2
(TraceSmallest pm2.61d2 (pm2.61d a1i) (-> (→ 𝜓 𝜒) (→ 𝜑 (→ (¬ 𝜓) 𝜒)) (→ 𝜑 𝜒)))
;; iteration 179: pm2.61i
(TraceSmallest pm2.61i (pm2.18i nsyl4) (-> (→ (¬ 𝜑) 𝜓) (→ 𝜑 𝜓) 𝜓))
;; iteration 180: pm2.61ii
(TraceSmallest pm2.61ii (pm2.61i pm2.61d2) (-> (→ 𝜓 𝜒) (→ 𝜑 𝜒) (→ (¬ 𝜑) (→ (¬ 𝜓) 𝜒)) 𝜒))
;; iteration 181: pm2.61nii
(TraceSmallest pm2.61nii (pm2.61i pm2.61d1) (-> (→ (¬ 𝜓) 𝜒) (→ (¬ 𝜑) 𝜒) (→ 𝜑 (→ 𝜓 𝜒)) 𝜒))
;; iteration 182: pm2.61iii
(TraceSmallest pm2.61iii (pm2.61ii expi pm2.61d2 impi) (-> (→ 𝜒 𝜃) (→ 𝜓 𝜃) (→ 𝜑 𝜃) (→ (¬ 𝜑) (→ (¬ 𝜓) (→ (¬ 𝜒) 𝜃))) 𝜃))
;; iteration 183: ja
(TraceSmallest ja (pm2.61d1 imim2i) (-> (→ 𝜓 𝜒) (→ (¬ 𝜑) 𝜒) (→ (→ 𝜑 𝜓) 𝜒)))
