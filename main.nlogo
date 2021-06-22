__includes ["factors.nls"]

turtles-own [
  contribution         ; int- investment into the public fund
  collect              ; int - extraction from common resource
  expcoopothers        ; float - expected level of cooperation of others
  alpha                ; float - Strength aversion to exploiting others
  beta                 ; float - Degree of altruistic tendency
  lambda               ; float - Parameter to define probabilities
  gamma1               ; float - Learning rate investments
  gamma2               ; float - Learning rate extraction
  income               ; earning of agent
  incomeothers         ; earnings of other agents
  expincome            ; expected income
  expshare             ; expected share upstream participants take from resource
  utility              ; utility of decisions
  utillist             ; list of utilities from different possible decisions
  utiltot              ; accumulated level of utilities for different possible decisions
  probinvest           ; probability of investments based on the expected utilities of the possible decisions
  exppg                ; expected level of the public fund
  listcollect          ; list of extraction decisions
  listcontribute       ; list of investment decisions
  agt                  ; agent type if random, altruistich/egalitarian or selfish for the mixedrsa model type
  baseinvest           ; investment baseline for the pseudorandom model type
  trust                ; uniform random distribution of trust variable for simple heuristic
  impact               ; importance of ROI for the heuristic model
  roi                  ; collect/invest; if invest = 0 than roi = 0 or return of investment but as absolute value between extracted and invested rather than extracted/ invested
  wanted               ; parameter affecting extraction
  ]

globals [
  invest               ; total level of investment in public fund
  real-invest          ; actual level of investment in public fund
  pga                  ; available level of common resource
  pg                   ; level of common resource
  datainvest           ; total level of investments in public fund in experiments averaged over 22 groups
  datainvestperperson  ; investment level per person for each position in experiments averaged over 22 groups
  datacollectperperson ; extraction level per person for each position in experiments averaged over 22 groups
  dataginicontribute   ; gini coefficient averaged over rounds of contributions into the public fund averaged over 22 groups
  dataginicollect      ; gini coefficient averaged over rounds of extractions from common resource averaged over 22 groups
  fit                  ; fit between simulation and data based on metric used. 1 is best value for fitness. fit is used in genetic algorithm for calibration
  lfit                 ; fit between simulations and data based on maximum likelihood
  listsimginicont      ; list of simulated gini coefficients for investment levels
  listsimginicol       ; list of simulated gini coefficients for extraction levels
  listsiminvest        ; list of simulated investment levels
  listsiminvestpp      ; levels of investment for each position
  listsimcollectpp     ; levels of extraction for each position
  listinv1 listinv2 listinv3 listinv4 listinv5 listinv6 listinv7 listinv8 listinv9 listinv10 listinv11 listinv12 listinv13 listinv14 listinv15 ; simulated investment for each round
  listinvpp1 listinvpp2 listinvpp3 listinvpp4 listinvpp5 ; simulated investment for each position
  listcollpp1 listcollpp2 listcollpp3 listcollpp4 listcollpp5 ; simulated extraction for each position
  listginicont         ; list of simulated gini coefficient of investments
  listginicoll         ; list of simulated gini coefficient of extraction
  correct

  ;;following lists are same as the above but used to average for all three treatments combined.
   t_listinv1   t_listinv2   t_listinv3   t_listinv4   t_listinv5   t_listinv6   t_listinv7   t_listinv8   t_listinv9   t_listinv10   t_listinv11   t_listinv12   t_listinv13   t_listinv14   t_listinv15
   t_listinvpp1   t_listinvpp2   t_listinvpp3   t_listinvpp4   t_listinvpp5
   t_listcollpp1   t_listcollpp2   t_listcollpp3   t_listcollpp4   t_listcollpp5
   t_listginicont   t_listginicoll

  fit1 fit2  fit3  fit4 fit5  ; fit between data and simulations for the 5 metrics
  lfit1 lfit2  lfit3  lfit4 lfit5  ; list of fit between data and simulations for the 5 metrics so as to calculate overal fit as average of fit of the three treatment
  done                 ; calibration run done
  variab               ; to calculate calpg more accurately
  equalshare           ; equal share of resources for altruistic players
  treatment
  treat
  numgroup
  pl
  ]

to setup
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  clear-all
  set fit 0
  set done 0
  set-default-shape turtles "circle"
  crt 5 [                     ; create the five agents
    set expshare 0
    set contribution 0
    set income 0
    set incomeothers 0
    set expincome 0
    set collect 0
    set utility 0
    set utillist []
    set utiltot 0
    set probinvest []
    set exppg 0
    set listcollect []
    set listcontribute []
    set contribution 0
    set collect 0
  ]
  set listsimginicont []
  set listsimginicol []
  set listsiminvest []
  set listsiminvestpp []
  set listsimcollectpp []
  ask turtles [set listcollect [] set listcontribute []]

  set treat (list "nlh" "nhl" "lhn")
  reset-ticks
end

to calibrate
  ; main procedure that coordinates the calibration process.

    if meanbeta > meanalpha [     ; invalid situation leading the model to stop
      set listinv1 [0]
      set listinv2 [0]
      set listinv3 [0]
      set listinv4 [0]
      set listinv5 [0]
      set listinv6 [0]
      set listinv7 [0]
      set listinv8 [0]
      set listinv9 [0]
      set listinv10 [0]
      set listinv11 [0]
      set listinv12 [0]
      set listinv13[0]
      set listinv14 [0]
      set listinv15 [0]
      set listinvpp1 [0]
      set listinvpp2 [0]
      set listinvpp3 [0]
      set listinvpp4 [0]
      set listinvpp5 [0]
      set listcollpp1 [0]
      set listcollpp2 [0]
      set listcollpp3 [0]
      set listcollpp4 [0]
      set listcollpp5 [0]
      set listginicont [0]
      set listginicoll [0]
      stop
    ]

    if meanbeta2 > meanalpha2 [     ; invalid situation leading the model to stop
      set listinv1 [0]
      set listinv2 [0]
      set listinv3 [0]
      set listinv4 [0]
      set listinv5 [0]
      set listinv6 [0]
      set listinv7 [0]
      set listinv8 [0]
      set listinv9 [0]
      set listinv10 [0]
      set listinv11 [0]
      set listinv12 [0]
      set listinv13[0]
      set listinv14 [0]
      set listinv15 [0]
      set listinvpp1 [0]
      set listinvpp2 [0]
      set listinvpp3 [0]
      set listinvpp4 [0]
      set listinvpp5 [0]
      set listcollpp1 [0]
      set listcollpp2 [0]
      set listcollpp3 [0]
      set listcollpp4 [0]
      set listcollpp5 [0]
      set listginicont [0]
      set listginicoll [0]
      stop
    ]

  set pl 0
  set listinv1 [] set listinv2 [] set listinv3 [] set listinv4 [] set listinv5 [] set listinv6 [] set listinv7 [] set listinv8 [] set listinv9 [] set listinv10 [] set listinv11 [] set listinv12 [] set listinv13 [] set listinv14 [] set listinv15 []
  set listinvpp1 [] set listinvpp2 [] set listinvpp3 [] set listinvpp4 [] set listinvpp5 []
  set listcollpp1 [] set listcollpp2 [] set listcollpp3 [] set listcollpp4 [] set listcollpp5 []
  set listginicont [] set listginicoll []
  set t_listinv1 [] set t_listinv2 [] set t_listinv3 [] set t_listinv4 [] set t_listinv5 [] set t_listinv6 [] set t_listinv7 [] set t_listinv8 [] set t_listinv9 [] set t_listinv10 [] set t_listinv11 [] set t_listinv12 [] set t_listinv13 [] set t_listinv14 [] set t_listinv15 []
  set t_listinvpp1 [] set t_listinvpp2 [] set t_listinvpp3 [] set t_listinvpp4 [] set t_listinvpp5 []
  set t_listcollpp1 [] set t_listcollpp2 [] set t_listcollpp3 [] set t_listcollpp4 [] set t_listcollpp5 []
  set t_listginicont [] set t_listginicoll []
  set lfit1 []     set lfit2 []    set lfit3 []    set lfit4 []    set lfit5 []    set lfit  []

  (foreach treat [

  set listinv1 [] set listinv2 [] set listinv3 [] set listinv4 [] set listinv5 [] set listinv6 [] set listinv7 [] set listinv8 [] set listinv9 [] set listinv10 [] set listinv11 [] set listinv12 [] set listinv13 [] set listinv14 [] set listinv15 []
  set listinvpp1 [] set listinvpp2 [] set listinvpp3 [] set listinvpp4 [] set listinvpp5 []
  set listcollpp1 [] set listcollpp2 [] set listcollpp3 [] set listcollpp4 [] set listcollpp5 []
  set listginicont [] set listginicoll []


    set treatment item pl treat
    let iter 0

    if treatment = "nlh" [
    set datainvest [34.33 35.50 34.33 33.33 34.33 35.50 36.17 32.50 33.50 32.00 36.17 33.67 33.83 30.83 32.50]
    set datainvestperperson [7.5  7.71  7.21  5.47  6.01]
    set datacollectperperson [13.67  19.68  13.86  13.22  10.56]
    set dataginicontribute 0.27
    set dataginicollect 0.33
    set numgroup 6
    set fit 0
  ]
  if treatment = "nhl" [
    set datainvest [26.20 26.00 24.80 27.20 26.60 31.20 28.60 24.20 26.60 24.60 23.80 29.40 29.20 25.80 22.80]
    set datainvestperperson [5.97  6.81  4.59  6.35  2.75]
    set datacollectperperson [16.84  8.21  11.68  7.25  3.19]
    set dataginicontribute 0.32
    set dataginicollect 0.39
    set numgroup 5
    set fit 0
  ]
  if treatment = "lhn" [
    set datainvest [33.40 32.40 32.40 29.00 29.00 27.80 27.40 24.00 26.20 24.00 25.40 27.00 24.20 21.60 18.80]
    set datainvestperperson [7.77  5.95  6.55  3.20  3.37]
    set datacollectperperson [21.87  12.15  16.00  3.71  3.28]
    set dataginicontribute 0.32
    set dataginicollect 0.43
    set numgroup 5
    set fit 0
  ]

  while [iter < 100]   ; 100 times a fit between simulation and data is calculated for each parameter setting
  [
    set listsimginicont []
    set listsimginicol []
    set listsiminvest [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
    set listsiminvestpp [0 0 0 0 0]
    set listsimcollectpp [0 0 0 0 0]

    let groups 0

    while [ groups < numgroup]  ; 16 groups are simulated, 6 for treat NLH, 5 for treat NHL and 5 for treat LHN
    [
      reset-ticks        ; ticks are initialized so that first tick is 0
      ;show "treatment"      ;show treatment      ;show "grounumber"      ;show groups

;;      if modeltype = "heuristic" [
        ask turtles [
          set trust random-normal meantrust sdtrust
          if trust > 1 [set trust 1]
          if trust < 0 [set trust 0]
          set impact random-normal meanimpact sdimpact
          if impact < 0 [set impact 0]
          set wanted random-normal meanwanted sdwanted
        ]
;;      ]

;;      if modeltype = "utilitarian" [
        ask turtles [

          ; define the paramaters of the model based on truncated Gaussian distributions
          set correct 0
          while [correct = 0]
          [
            ; show "setting Excop"
            set expcoopothers random-normal meaneco stdeveco
            if ((expcoopothers <= 1) and (expcoopothers >= 0)) [set correct 1]
          ]
                    set correct 0
          while [correct = 0]
          [             ;show "setting selfish alpha and beta"
            let prob random-float 1
            ;; if agent is selfish alpha and beta are set to 0
            ifelse prob < 0 [
              set alpha 0
              set beta 0
              set correct 1
            ]
            [            ;show "setting alpha and beta variable"
              set alpha random-normal meanalpha stdevalpha
              if alpha <= 1 [
                set beta random-normal meanbeta stdevbeta
                if beta <= alpha and (alpha != 0 or beta != 0) [set correct 1]
              ]
            ]
          ]
          set correct 0
          while [correct = 0]
          [ ;show "setting lambda"
            set lambda random-normal meanlambda stdevlambda
            ifelse lambda >= 0 [set correct 1] [set lambda 0 set correct 1]
          ]

          set correct 0
          while [correct = 0]
          [
            ; show "setting gamma 1"
            set gamma1 random-normal meangamma1 stdevgamma1
            if ((gamma1 <= 1) and (gamma1 >= 0)) [set correct 1]
          ]
          set correct 0
          while [correct = 0]
          [
            ; show "setting gamma 2"
            set gamma2 random-normal meangamma2 stdevgamma2
            if ((gamma2 <= 1) and (gamma2 >= 0)) [set correct 1]
          ]
        ]
;;      ]

;;      if modeltype = "utilitarian2" [
;;        ask turtles [
;;        ; define the paramaters of the model based on truncated Gaussian distributions
;;          set agt random-float 1
;;          ifelse agt < prand [
;;            set correct 0
;;            while [correct = 0]
;;            [
;;              ; show "setting Excop"
;;              set expcoopothers random-normal meaneco stdeveco
;;              if ((expcoopothers <= 1) and (expcoopothers >= 0)) [set correct 1]
;;            ]
;;            set correct 0
;;            while [correct = 0]
;;            [
;;              let prob random-float 1
;;              ;; if agent is selfish alpha and beta are set to 0
;;              ifelse prob < pself-utilitarian [
;;                set alpha 0
;;                set beta 0
;;                set correct 1
;;              ]
;;              [set alpha random-normal meanalpha stdevalpha
;;                if alpha <= 1 [
;;                  set beta random-normal meanbeta stdevbeta
;;                  if beta <= alpha and (alpha != 0 or beta != 0) [set correct 1]
;;                ]
;;              ]
;;            ]
;;            set correct 0
;;            while [correct = 0]
;;            [
;;              set lambda random-normal meanlambda stdevlambda
;;              if lambda >= 0 [set correct 1]
;;            ]
;;            while [correct = 0]
;;            [
;;            ; show "setting gamma 1"
;;              set gamma1 random-normal meangamma1 stdevgamma1
;;              if ((gamma1 <= 1) and (gamma1 >= 0)) [set correct 1]
;;            ]
;;            set correct 0
;;            while [correct = 0]
;;            [
;;              ; show "setting gamma 2"
;;              set gamma2 random-normal meangamma2 stdevgamma2
;;              if ((gamma2 <= 1) and (gamma2 >= 0)) [set correct 1]
;;            ]
;;          ]
;;          [
;;            set correct 0
;;            while [correct = 0]
;;            [
;;            ; show "setting Excop"
;;             set expcoopothers random-normal meaneco stdeveco
;;             if ((expcoopothers <= 1) and (expcoopothers >= 0)) [set correct 1]
;;            ]
;;            set correct 0
;;            while [correct = 0]
;;            [
;;              let prob random-float 1
;;              ;; if agent is selfish alpha and beta are set to 0
;;              ifelse prob < pself-utilitarian [
;;                set alpha 0
;;                set beta 0
;;                set correct 1
;;              ]
;;              [set alpha random-normal meanalpha2 stdevalpha2
;;                if alpha <= 1 [
;;                  set beta random-normal meanbeta2 stdevbeta2
;;                  if beta <= alpha and (alpha != 0 or beta != 0) [set correct 1]
;;                ]
;;              ]
;;            ]
;;            set correct 0
;;            while [correct = 0]
;;            [
;;              set lambda random-normal meanlambda2 stdevlambda2
;;              if lambda >= 0 [set correct 1]
;;            ]
;;            set correct 0
;;            while [correct = 0]
;;            [
;;            ; show "setting gamma 1"
;;              set gamma1 random-normal meangamma12 stdevgamma12
;;              if ((gamma1 <= 1) and (gamma1 >= 0)) [set correct 1]
;;            ]
;;            set correct 0
;;            while [correct = 0]
;;            [
;;            ; show "setting gamma 2"2
;;              set gamma2 random-normal meangamma22 stdevgamma22
;;              if ((gamma2 <= 1) and (gamma2 >= 0)) [set correct 1]
;;            ]
;;          ]
;;        ]
;;      ]


      ask turtles [set listcollect [] set listcontribute []]
      while [ticks < 15] [go]  ; simuated the model for 15 timesteps


      ; define the list of the simulated data in order to compare with actual data

      ask turtle 0 [
        set listsiminvestpp replace-item 0 listsiminvestpp (item 0 listsiminvestpp + mean listcontribute)
        set listsimcollectpp replace-item 0 listsimcollectpp (item 0 listsimcollectpp + mean listcollect)
      ]
      ask turtle 1 [
        set listsiminvestpp replace-item 1 listsiminvestpp (item 1 listsiminvestpp + mean listcontribute)
        set listsimcollectpp replace-item 1 listsimcollectpp (item 1 listsimcollectpp + mean listcollect)


      ]
      ask turtle 2 [
        set listsiminvestpp replace-item 2 listsiminvestpp (item 2 listsiminvestpp + mean listcontribute)
        set listsimcollectpp replace-item 2 listsimcollectpp (item 2 listsimcollectpp + mean listcollect)
      ]
      ask turtle 3 [
        set listsiminvestpp replace-item 3 listsiminvestpp (item 3 listsiminvestpp + mean listcontribute)
        set listsimcollectpp replace-item 3 listsimcollectpp (item 3 listsimcollectpp + mean listcollect)
      ]
      ask turtle 4 [
        set listsiminvestpp replace-item 4 listsiminvestpp (item 4 listsiminvestpp + mean listcontribute)
        set listsimcollectpp replace-item 4 listsimcollectpp (item 4 listsimcollectpp + mean listcollect)
      ]

      set groups groups + 1

    ]


    set fit1 1
    set fit2 1
    set fit3 1
    set fit4 1
    set fit5 1

    ; define the fitness value of the five different metrics
    let jj 0
    let sumdif 0
    while [jj < 15]
    [

       set sumdif sumdif + abs (((item jj datainvest - (item jj listsiminvest / numgroup)) / 50 ))
       if jj = 0 [set listinv1 fput (item jj listsiminvest / numgroup) listinv1 ]
       if jj = 1 [set listinv2 fput (item jj listsiminvest / numgroup) listinv2 ]
       if jj = 2 [set listinv3 fput (item jj listsiminvest / numgroup) listinv3 ]
       if jj = 3 [set listinv4 fput (item jj listsiminvest / numgroup) listinv4 ]
       if jj = 4 [set listinv5 fput (item jj listsiminvest / numgroup) listinv5 ]
       if jj = 5 [set listinv6 fput (item jj listsiminvest / numgroup) listinv6 ]
       if jj = 6 [set listinv7 fput (item jj listsiminvest / numgroup) listinv7 ]
       if jj = 7 [set listinv8 fput (item jj listsiminvest / numgroup) listinv8 ]
       if jj = 8 [set listinv9 fput (item jj listsiminvest / numgroup) listinv9 ]
       if jj = 9 [set listinv10 fput (item jj listsiminvest / numgroup) listinv10]
       if jj = 10 [set listinv11 fput (item jj listsiminvest / numgroup) listinv11 ]
       if jj = 11 [set listinv12 fput (item jj listsiminvest / numgroup) listinv12 ]
       if jj = 12 [set listinv13 fput (item jj listsiminvest / numgroup) listinv13 ]
       if jj = 13 [set listinv14 fput (item jj listsiminvest / numgroup) listinv14 ]
       if jj = 14 [set listinv15 fput (item jj listsiminvest / numgroup) listinv15 ]
       set jj jj + 1
    ]
    set fit1 (1 -  sumdif / 15) ^ 2

    set jj 0
    set sumdif 0
    while [jj < 5]
    [
       set sumdif sumdif + abs (((item jj datainvestperperson - (item jj listsiminvestpp / numgroup)) / 10 ))
       if jj = 0 [set listinvpp1 fput (item jj listsiminvestpp / numgroup) listinvpp1 ]
       if jj = 1 [set listinvpp2 fput (item jj listsiminvestpp / numgroup) listinvpp2 ]
       if jj = 2 [set listinvpp3 fput (item jj listsiminvestpp / numgroup) listinvpp3 ]
       if jj = 3 [set listinvpp4 fput (item jj listsiminvestpp / numgroup) listinvpp4 ]
       if jj = 4 [set listinvpp5 fput (item jj listsiminvestpp / numgroup) listinvpp5 ]
       set jj jj + 1
    ]
    set fit2 (1 -  sumdif / 5 ) ^ 2

    set jj 0
    set sumdif 0
    while [jj < 5]
    [
       set sumdif sumdif + abs (((item jj datacollectperperson - (item jj listsimcollectpp / numgroup)) / 160 ) ) ;;max collection under variability.
       if jj = 0 [set listcollpp1 fput (item jj listsimcollectpp / numgroup) listcollpp1]
       if jj = 1 [set listcollpp2 fput (item jj listsimcollectpp / numgroup) listcollpp2]
       if jj = 2 [set listcollpp3 fput (item jj listsimcollectpp / numgroup) listcollpp3]
       if jj = 3 [set listcollpp4 fput (item jj listsimcollectpp / numgroup) listcollpp4]
       if jj = 4 [set listcollpp5 fput (item jj listsimcollectpp / numgroup) listcollpp5]
       set jj jj + 1
    ]
    set fit3 (1 -  sumdif / 5 ) ^ 2

    let simginicont mean listsimginicont
    let simginicol 0
    if not empty? listsimginicol [set simginicol mean listsimginicol]
    set fit4 (1 - abs (((dataginicontribute - simginicont))))
    set fit5 (1 - abs (((dataginicollect - simginicol))))

    set listginicont fput simginicont listginicont
    set listginicoll fput simginicol listginicoll

    if fit1 < 0 [set fit1 0]
    if fit2 < 0 [set fit2 0]
    if fit3 < 0 [set fit3 0]
    if fit4 < 0 [set fit4 0]
    if fit5 < 0 [set fit5 0]

    if fitnessfunction = "multiplier" [set fit fit + (fit1 * fit2 * fit3 * fit4 * fit5)]
    if fitnessfunction = "average" [ set fit fit + (fit1 + fit2 + fit3 + fit4 + fit5) / 5 ]
    if fitnessfunction = "minimum" [
      let fitmin 1
      ifelse fit1 < fit2 [set fitmin fit1][set fitmin fit2]
      if fit3 < fitmin [set fitmin fit3]
      if fit4 < fitmin [set fitmin fit4]
      if fit5 < fitmin [set fitmin fit5]
      set fit fit + fitmin

      ;show fit
    ]
    set iter iter + 1
    reset-ticks

  ]


  set t_listinv1 sentence listinv1 t_listinv1
  set t_listinv2 sentence listinv2 t_listinv2
  set t_listinv3 sentence listinv3 t_listinv3
  set t_listinv4 sentence listinv4 t_listinv4
  set t_listinv5 sentence listinv5 t_listinv5
  set t_listinv6 sentence listinv6 t_listinv6
  set t_listinv7 sentence listinv7 t_listinv7
  set t_listinv8 sentence listinv8 t_listinv8
  set t_listinv9 sentence listinv9 t_listinv9
  set t_listinv10 sentence listinv10 t_listinv10
  set t_listinv11 sentence listinv11 t_listinv11
  set t_listinv12 sentence listinv12 t_listinv12
  set t_listinv13 sentence listinv13 t_listinv13
  set t_listinv14 sentence listinv14 t_listinv14
  set t_listinv15 sentence listinv15 t_listinv15
  set t_listinvpp1 sentence listinvpp1 t_listinvpp1
  set t_listinvpp2 sentence listinvpp2 t_listinvpp2
  set t_listinvpp3 sentence listinvpp3 t_listinvpp3
  set t_listinvpp4 sentence listinvpp4 t_listinvpp4
  set t_listinvpp5 sentence listinvpp5 t_listinvpp5
  set t_listcollpp1 sentence listcollpp1 t_listcollpp1
  set t_listcollpp2 sentence listcollpp2 t_listcollpp2
  set t_listcollpp3 sentence listcollpp3 t_listcollpp3
  set t_listcollpp4 sentence listcollpp4 t_listcollpp4
  set t_listcollpp5 sentence listcollpp5 t_listcollpp5
  set t_listginicont sentence listginicont t_listginicont
  set t_listginicoll sentence listginicoll t_listginicoll

    set lfit1 lput fit1 lfit1
    set lfit2 lput fit2 lfit2
    set lfit3 lput fit3 lfit3
    set lfit4 lput fit4 lfit4
    set lfit5 lput fit5 lfit5
    set lfit lput fit lfit

  ;show "TREATMENT"
  ;show treatment
  ;show "END TREATMENT"


  set pl pl + 1
  ])

  set fit1 mean lfit1
  set fit2 mean lfit2
  set fit3 mean lfit3
  set fit4 mean lfit4
  set fit5 mean lfit5
  set fit mean lfit

  ;show "FITNESS" ;show fit

  set fit fit / 100   ; in order to have a fitness value between 0 and 1
  set done 1
end

to compute-svo-variables
 ;;; Run the social-value orientation model to collect its related variables
  let i 0
  set utiltot 0
  set utillist []
  while [i <= 10]
  [
    set invest (4 * 10 * expcoopothers) + i
    set pg calpg invest
    ifelse ticks = 0 [
      let exponent (2 - expcoopothers)
      set pga pg * (1 - (who / 5) ^ exponent)
      ifelse pg > 0 [set expshare pga / pg][set expshare 0]
      if (1 - alpha) * (1 - beta) < 1 [set pga pga * (1 - alpha) * (1 - beta)]
    ][
      set pga pg * expshare
      if (1 - alpha) * (1 - beta) < 1 [set pga pga * (1 - alpha) * (1 - beta)]
    ]
    set income 10 - i + pga
    set incomeothers (40 - (10 * 4 * expcoopothers) + (pg - pga)) / 4

    let dif1 0
    let dif2 0
    ifelse income > incomeothers [
      set dif1 income - incomeothers
      set dif2 0
    ][
      set dif1 0
      set dif2 incomeothers - income
    ]
    set utility exp (lambda * (income -  alpha * dif1 + beta * dif2))
    set utillist lput utility utillist
    set utiltot utiltot + utility
    set i i + 1
  ]
  set i 0
  set probinvest []
  while [i <= 10]
  [
    ifelse utiltot > 0 [
      set probinvest lput (item i utillist / utiltot) probinvest
    ][
      set probinvest lput 0.2 probinvest
    ]
    set i i + 1
  ]
end

to go
  ;;  for calculating returns from investment -> variability as in the data sequences depending on treatment and round.
  if treatment = "nlh"[
    ifelse ticks < 5 [set variab 0][
     ifelse ticks < 10 [set variab 1][set variab 2]]
  ]
  if treatment = "nhl" [
    ifelse ticks < 5 [set variab 0][
      ifelse ticks < 10 [set variab 2][set variab 1]]
  ]
  if treatment = "lhn" [
    ifelse ticks < 5 [set variab 1][
      ifelse ticks < 10 [set variab 2][set variab 0]]
  ]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; Begin code modified for EMD ;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ask turtles [
    compute-svo-variables
    set invest truncate
       ; @EMD @EvolveNextLine @Factors-File="factors.nls" @return-type=investment
       random 11
    set contribution invest
  ]
  ;;;;;;;;;;;;;;;;
  ; End EMD code ;
  ;;;;;;;;;;;;;;;;

  ; actual public infrastructure

  set invest 0
  ask turtles [set invest invest + contribution]
  set real-invest invest

  set pg calpg invest ; this is the resource level in the current round

;;  if modeltype = "utilitarian" [
    ask turtles [
      set expcoopothers expcoopothers * gamma1 + (1 - gamma1) * (invest - contribution) / 40
    ]
;;  ]

  set pga pg
  set equalshare pga / 5


  calcollect 0
  set pga pga - [collect] of turtle 0

  calcollect 1
  set pga pga - [collect] of turtle 1

  calcollect 2
  set pga pga - [collect] of turtle 2


  calcollect 3
  set pga pga - [collect] of turtle 3

  calcollect 4

;;  if modeltype = "utilitarian" or modeltype = "utilitarian2" [
    set invest 0
    ask turtles [set invest invest + contribution]
    ask turtles [set expcoopothers expcoopothers * gamma1 + (1 - gamma1) * ((invest - contribution) / 40)]    ; learning on expected level of cooperation of others
;;  ]

  ; calculate metrics for comparison with data and also calculate return of investment or better collect - contribution for each agent

  ask turtles [
    set listcontribute lput contribution listcontribute
    set listcollect lput collect listcollect
    set roi collect - contribution
  ]
  let temp item ticks listsiminvest + invest
  set listsiminvest replace-item ticks listsiminvest temp
  let list1 [who] of turtles
  let list2 [who] of turtles
  let s 0
  foreach list1 [ ?1 ->
    let temp2 [contribution] of turtle ?1
    foreach list2 [ ??1 ->
      set s s + abs(temp2 - [contribution] of turtle ??1)
    ]
  ]
  ifelse mean [contribution] of turtles > 0 [
    set listsimginicont lput (s / (2 * (mean [contribution] of turtles) * (count turtles) ^ 2)) listsimginicont
  ][
    set listsimginicont lput 0 listsimginicont
  ]

  set s 0
  foreach list1 [ ?1 ->
    let temp2 [collect] of turtle ?1
    foreach list2 [ ??1 ->
      set s s + abs(temp2 - [collect] of turtle ??1)
    ]
  ]
  if mean [collect] of turtles > 0 [
  set listsimginicol  lput (s / (2 * (mean [collect] of turtles) * (count turtles) ^ 2)) listsimginicol]

  tick
end

to calcollect [j]
  ask turtle j [
    if modeltype = "random" [
      set collect random pga
    ]
    if modeltype = "selfish" [
      set collect pga
    ]
    if modeltype = "altruistic" [
      set collect equalshare
    ]
    if modeltype = "pseudorandom" [
      ifelse pga != 0[
        set correct 0
        while [correct = 0]
        [ let es pga / (5 - [who] of self)
          set collect es + random-normal 0 sdnoise2
          if pga - collect >= 0 [
            set correct 1
          ]
        ]
      ]
      [set collect pga
      ]
    ]
    if modeltype = "heuristic" [
      ifelse pga != 0 and (pga -  (1 / (6 - ([who] of self + 1))) ^ wanted) > 0 [
        set correct 0
        while [correct = 0]
        [ let pos [who] of self + 1
          let base  1 / (6 - pos)
          set collect base ^ wanted
          if pga - collect >= 0 [
            set correct 1
          ]
        ]
      ]
      [set collect pga
      ]
    ]
    if modeltype = "utilitarian" or modeltype = "utilitarian2" [
      ifelse ticks = 0 [
        if pg > 0 [set expshare pga / pg]
        if pg <= 0 [set expshare 0]
      ][
        if pg > 0 [set expshare expshare * gamma2 + (1 - gamma2) * (pga / pg)]  ; agents update the expecte share for next round
        if expshare > 1 [set expshare 1]
        if expshare < 0 [set expshare 0]
      ]
      set collect 0
      set utillist []
      set utiltot 0
      while [collect <= pga]  ; when there are still resources left make a decision how much to collect
      [
        set income 10 - contribution + collect
        set incomeothers ((40 - invest + contribution) + pg - collect) / 4
        let dif1 0
        let dif2 0
        ifelse income > incomeothers [set dif1 income - incomeothers set dif2 0][set dif1 0 set dif2 incomeothers - income]
        set utility exp (lambda * (income -  alpha * dif1 + beta * dif2))
        set utillist fput utility utillist
        set utiltot utiltot + utility
        set collect collect + 1
      ]
      ifelse best [
        set collect 0
        let utilmax 0
        let i 0
        ifelse pga > 0 [
           set utilmax max utillist
           set i 0
        ]
        [set utilmax 0]

        let utilmaxlist []
        while [i < pga]
        [
          if item i utillist = utilmax [
            set utilmaxlist lput i utilmaxlist]
            set i i + 1
        ]
        if pga > 0 [set collect one-of utilmaxlist]
      ][
        set collect 0
        let probcollect []
        while [collect <= pga]
        [
          ifelse utiltot > 0 [ ;;minor change to avoid the division by 0 problem.
            set probcollect fput (item collect utillist / utiltot) probcollect
            set collect collect + 1
          ][
            set probcollect lput 0 probcollect
          ]
        ]
        let rndnr random-float 1.0
        let cump 0
        let found? false
        set collect 0
        while [collect <= pga and found? = false]
        [
          set cump cump + item collect probcollect
          ifelse rndnr < cump [set found? true][set collect collect + 1]
        ]
      ]
    ]

  ]
end

to-report calpg [inv] ;; with probabilities

  if variab = 0 [
    let calcpg 0
    ifelse inv < 10 [set calcpg 0 ][
      ifelse inv < 15 [set calcpg 5][
        ifelse inv < 20 [set calcpg 20][
          ifelse inv < 25 [set calcpg 40][
            ifelse inv < 30 [set calcpg 60][
              ifelse inv < 35 [set calcpg 75][
                ifelse inv < 40 [set calcpg 85][
                  ifelse inv < 45 [set calcpg 95][set calcpg 100]]]]]]]]
    report calcpg

  ]
  if variab = 1 [
    let calcpg 0
    let p random-float 1
    if p >= 0.17 and p <= 0.83 [

      ifelse inv < 10 [set calcpg 0 ][
        ifelse inv < 15 [set calcpg 5][
          ifelse inv < 20 [set calcpg 20][
            ifelse inv < 25 [set calcpg 40][
              ifelse inv < 30 [set calcpg 60][
                ifelse inv < 35 [set calcpg 75][
                  ifelse inv < 40 [set calcpg 85][
                    ifelse inv < 45 [set calcpg 95][set calcpg 100]]]]]]]]
      report calcpg
    ]
    if p < 0.17 [
         ifelse inv < 10 [set calcpg 0 ][
          ifelse inv < 15 [set calcpg 2][
            ifelse inv < 20 [set calcpg 8][
              ifelse inv < 25 [set calcpg 16][
                ifelse inv < 30 [set calcpg 24][
                  ifelse inv < 35 [set calcpg 30][
                    ifelse inv < 40 [set calcpg 34][
                      ifelse inv < 45 [set calcpg 38][set calcpg 40]]]]]]]]
       report calcpg
    ]
    if p > 0.83 [
        ifelse inv < 10 [set calcpg 0 ][
          ifelse inv < 15 [set calcpg 8][
            ifelse inv < 20 [set calcpg 32][
              ifelse inv < 25 [set calcpg 64][
                ifelse inv < 30 [set calcpg 96][
                  ifelse inv < 35 [set calcpg 120][
                    ifelse inv < 40 [set calcpg 136][
                      ifelse inv < 45 [set calcpg 152][set calcpg 160]]]]]]]]
        report calcpg
    ]

  ]
  if variab = 2 [
    let calcpg 0
    let p random-float 1
    if p >= 0.33 and p <= 0.66 [
         ifelse inv < 10 [set calcpg 0 ][
           ifelse inv < 15 [set calcpg 5][
             ifelse inv < 20 [set calcpg 20][
               ifelse inv < 25 [set calcpg 40][
                 ifelse inv < 30 [set calcpg 60][
                   ifelse inv < 35 [set calcpg 75][
                     ifelse inv < 40 [set calcpg 85][
                       ifelse inv < 45 [set calcpg 95][set calcpg 100]]]]]]]]
         report calcpg
    ]
    if p < 0.33 [
        ifelse inv < 10 [set calcpg 0 ][
          ifelse inv < 15 [set calcpg 2][
            ifelse inv < 20 [set calcpg 8][
              ifelse inv < 25 [set calcpg 16][
                ifelse inv < 30 [set calcpg 24][
                  ifelse inv < 35 [set calcpg 30][
                    ifelse inv < 40 [set calcpg 34][
                      ifelse inv < 45 [set calcpg 38][set calcpg 40]]]]]]]]
        report calcpg
    ]
    if p > 0.66 [
        ifelse inv < 10 [set calcpg 0 ][
          ifelse inv < 15 [set calcpg 5][
            ifelse inv < 20 [set calcpg 20][
              ifelse inv < 25 [set calcpg 40][
                ifelse inv < 30 [set calcpg 60][
                  ifelse inv < 35 [set calcpg 75][
                    ifelse inv < 40 [set calcpg 85][
                      ifelse inv < 45 [set calcpg 95][set calcpg 100]]]]]]]]
        report calcpg
    ]

  ]

end
@#$#@#$#@
GRAPHICS-WINDOW
475
14
637
177
-1
-1
154.0
1
10
1
1
1
0
0
0
1
0
0
0
0
0
0
1
ticks
30.0

BUTTON
12
12
75
45
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
8
58
180
91
meaneco
meaneco
0
1
0.36
0.01
1
NIL
HORIZONTAL

SLIDER
7
94
179
127
stdeveco
stdeveco
0
1
0.48
0.01
1
NIL
HORIZONTAL

SLIDER
6
129
178
162
meanalpha
meanalpha
-1
1
0.83
0.01
1
NIL
HORIZONTAL

SLIDER
5
163
177
196
stdevalpha
stdevalpha
0
1
0.6
0.01
1
NIL
HORIZONTAL

SLIDER
4
265
176
298
meanlambda
meanlambda
0
5
2.23
0.01
1
NIL
HORIZONTAL

SLIDER
4
300
176
333
stdevlambda
stdevlambda
0
1
0.46
0.01
1
NIL
HORIZONTAL

SLIDER
3
335
175
368
meangamma1
meangamma1
0
1
0.54
0.01
1
NIL
HORIZONTAL

SLIDER
2
369
174
402
stdevgamma1
stdevgamma1
0
1
0.49
0.01
1
NIL
HORIZONTAL

BUTTON
91
14
170
47
NIL
calibrate
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
4
197
176
230
meanbeta
meanbeta
-1
1
0.22
0.01
1
NIL
HORIZONTAL

SLIDER
4
231
176
264
stdevbeta
stdevbeta
0
1
0.42
0.01
1
NIL
HORIZONTAL

SWITCH
476
203
579
236
best
best
1
1
-1000

SLIDER
-1
405
171
438
meangamma2
meangamma2
0
1
0.47
0.01
1
NIL
HORIZONTAL

SLIDER
-1
439
171
472
stdevgamma2
stdevgamma2
0
1
0.54
0.01
1
NIL
HORIZONTAL

CHOOSER
326
13
464
58
fitnessfunction
fitnessfunction
"multiplier" "average" "minimum"
0

CHOOSER
184
13
322
58
modeltype
modeltype
"utilitarian2" "utilitarian" "heuristic" "mixedrsa" "pseudorandom" "random" "selfish" "altruistic"
1

SLIDER
175
479
347
512
prand
prand
0
1
0.52
0.01
1
NIL
HORIZONTAL

SLIDER
-3
516
169
549
meaninv
meaninv
0
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
173
517
345
550
sdinv
sdinv
0
5
3.0
0.1
1
NIL
HORIZONTAL

SLIDER
352
517
524
550
sdnoise
sdnoise
0.01
5
4.16
0.01
1
NIL
HORIZONTAL

SLIDER
-1
555
171
588
meanimpact
meanimpact
0
10
4.97
0.01
1
NIL
HORIZONTAL

SLIDER
-1
588
171
621
sdimpact
sdimpact
0
5
1.94
0.01
1
NIL
HORIZONTAL

SLIDER
176
557
348
590
meanwanted
meanwanted
-5
5
0.1
0.1
1
NIL
HORIZONTAL

SLIDER
175
593
347
626
sdwanted
sdwanted
0
5
2.93
0.01
1
NIL
HORIZONTAL

SLIDER
356
558
528
591
meantrust
meantrust
0
1
0.52
0.01
1
NIL
HORIZONTAL

SLIDER
355
593
527
626
sdtrust
sdtrust
0
1
0.45
0.01
1
NIL
HORIZONTAL

SLIDER
531
514
703
547
sdnoise2
sdnoise2
0
5
2.64
0.01
1
NIL
HORIZONTAL

SLIDER
183
60
355
93
meaneco2
meaneco2
0
1
0.58
0.01
1
NIL
HORIZONTAL

SLIDER
181
94
353
127
stdeveco2
stdeveco2
0
1
0.55
0.01
1
NIL
HORIZONTAL

SLIDER
181
130
353
163
meanalpha2
meanalpha2
-1
1
0.3
0.1
1
NIL
HORIZONTAL

SLIDER
179
200
351
233
meanbeta2
meanbeta2
-1
1
0.01
0.01
1
NIL
HORIZONTAL

SLIDER
180
267
352
300
meanlambda2
meanlambda2
0
5
3.26
0.01
1
NIL
HORIZONTAL

SLIDER
179
338
351
371
meangamma12
meangamma12
0
1
0.38
0.01
1
NIL
HORIZONTAL

SLIDER
175
407
347
440
meangamma22
meangamma22
0
1
0.53
0.01
1
NIL
HORIZONTAL

SLIDER
179
164
351
197
stdevalpha2
stdevalpha2
0
1
0.45
0.01
1
NIL
HORIZONTAL

SLIDER
179
234
351
267
stdevbeta2
stdevbeta2
0
1
0.45
0.01
1
NIL
HORIZONTAL

SLIDER
180
303
352
336
stdevlambda2
stdevlambda2
0
1
0.36
0.01
1
NIL
HORIZONTAL

SLIDER
177
372
349
405
stdevgamma12
stdevgamma12
0
1
0.48
0.01
1
NIL
HORIZONTAL

SLIDER
176
442
348
475
stdevgamma22
stdevgamma22
0
1
0.53
0.01
1
NIL
HORIZONTAL

@#$#@#$#@
This is a Netlogo implementation of the model described in Baggio J.A. and M.A. Janssen (2013). “Comparing agent-based models on experimental data of irrigation games”. In Proceedings of the 2013 Winter Simulation Conference Edited by. R. Pasupathy, S.-H. Kim, A. Tolk, R. Hill, and M. E. Kuhl.

The Model has been coded and implemented by Jacopo A. Baggio and Marco A. Janssen, July, Arizona State University, July 2013. Copyright (C) 2013 J.A. Baggio and M.A. Janssen

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="null_models_rnd_self_altr" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>calibrate</go>
    <timeLimit steps="1"/>
    <exitCondition>done = 1</exitCondition>
    <metric>mean t_listinv1</metric>
    <metric>mean t_listinv2</metric>
    <metric>mean t_listinv3</metric>
    <metric>mean t_listinv4</metric>
    <metric>mean t_listinv5</metric>
    <metric>mean t_listinv6</metric>
    <metric>mean t_listinv7</metric>
    <metric>mean t_listinv8</metric>
    <metric>mean t_listinv9</metric>
    <metric>mean t_listinv10</metric>
    <metric>mean t_listinv11</metric>
    <metric>mean t_listinv12</metric>
    <metric>mean t_listinv13</metric>
    <metric>mean t_listinv14</metric>
    <metric>mean t_listinv15</metric>
    <metric>mean t_listinvpp1</metric>
    <metric>mean t_listinvpp2</metric>
    <metric>mean t_listinvpp3</metric>
    <metric>mean t_listinvpp4</metric>
    <metric>mean t_listinvpp5</metric>
    <metric>mean t_listcollpp1</metric>
    <metric>mean t_listcollpp2</metric>
    <metric>mean t_listcollpp3</metric>
    <metric>mean t_listcollpp4</metric>
    <metric>mean t_listcollpp5</metric>
    <metric>mean t_listginicont</metric>
    <metric>mean t_listginicoll</metric>
    <metric>fit</metric>
    <metric>fit1</metric>
    <metric>fit2</metric>
    <metric>fit3</metric>
    <metric>fit4</metric>
    <metric>fit5</metric>
    <enumeratedValueSet variable="modeltype">
      <value value="&quot;selfish&quot;"/>
      <value value="&quot;altruistic&quot;"/>
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fitnessfunction">
      <value value="&quot;multiplier&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prand">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pself">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meaninv">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdinv">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdnoise">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdnoise2">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanimpact">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdimpact">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanwanted">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdwanted">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meantrust">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdtrust">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanalpha">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevalpha">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanbeta">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevbeta">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meaneco">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdeveco">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanlambda">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevlambda">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meangamma1">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevgamma1">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meangamma2">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevgamma2">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="best">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="sens_mixedrsa" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>calibrate</go>
    <exitCondition>done = 1</exitCondition>
    <metric>mean t_listinv1</metric>
    <metric>mean t_listinv2</metric>
    <metric>mean t_listinv3</metric>
    <metric>mean t_listinv4</metric>
    <metric>mean t_listinv5</metric>
    <metric>mean t_listinv6</metric>
    <metric>mean t_listinv7</metric>
    <metric>mean t_listinv8</metric>
    <metric>mean t_listinv9</metric>
    <metric>mean t_listinv10</metric>
    <metric>mean t_listinv11</metric>
    <metric>mean t_listinv12</metric>
    <metric>mean t_listinv13</metric>
    <metric>mean t_listinv14</metric>
    <metric>mean t_listinv15</metric>
    <metric>mean t_listinvpp1</metric>
    <metric>mean t_listinvpp2</metric>
    <metric>mean t_listinvpp3</metric>
    <metric>mean t_listinvpp4</metric>
    <metric>mean t_listinvpp5</metric>
    <metric>mean t_listcollpp1</metric>
    <metric>mean t_listcollpp2</metric>
    <metric>mean t_listcollpp3</metric>
    <metric>mean t_listcollpp4</metric>
    <metric>mean t_listcollpp5</metric>
    <metric>mean t_listginicont</metric>
    <metric>mean t_listginicoll</metric>
    <metric>fit</metric>
    <metric>fit1</metric>
    <metric>fit2</metric>
    <metric>fit3</metric>
    <metric>fit4</metric>
    <metric>fit5</metric>
    <enumeratedValueSet variable="modeltype">
      <value value="&quot;mixedrsa&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fitnessfunction">
      <value value="&quot;multiplier&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prand">
      <value value="0.675"/>
      <value value="0.75"/>
      <value value="0.825"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pself">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meaninv">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdinv">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdnoise">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdnoise2">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanimpact">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdimpact">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanwanted">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdwanted">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meantrust">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdtrust">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanalpha">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevalpha">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanbeta">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevbeta">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meaneco">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdeveco">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanlambda">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevlambda">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meangamma1">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevgamma1">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meangamma2">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevgamma2">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="best">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="sens_pseudorandom" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>calibrate</go>
    <exitCondition>done = 1</exitCondition>
    <metric>mean t_listinv1</metric>
    <metric>mean t_listinv2</metric>
    <metric>mean t_listinv3</metric>
    <metric>mean t_listinv4</metric>
    <metric>mean t_listinv5</metric>
    <metric>mean t_listinv6</metric>
    <metric>mean t_listinv7</metric>
    <metric>mean t_listinv8</metric>
    <metric>mean t_listinv9</metric>
    <metric>mean t_listinv10</metric>
    <metric>mean t_listinv11</metric>
    <metric>mean t_listinv12</metric>
    <metric>mean t_listinv13</metric>
    <metric>mean t_listinv14</metric>
    <metric>mean t_listinv15</metric>
    <metric>mean t_listinvpp1</metric>
    <metric>mean t_listinvpp2</metric>
    <metric>mean t_listinvpp3</metric>
    <metric>mean t_listinvpp4</metric>
    <metric>mean t_listinvpp5</metric>
    <metric>mean t_listcollpp1</metric>
    <metric>mean t_listcollpp2</metric>
    <metric>mean t_listcollpp3</metric>
    <metric>mean t_listcollpp4</metric>
    <metric>mean t_listcollpp5</metric>
    <metric>mean t_listginicont</metric>
    <metric>mean t_listginicoll</metric>
    <metric>fit</metric>
    <metric>fit1</metric>
    <metric>fit2</metric>
    <metric>fit3</metric>
    <metric>fit4</metric>
    <metric>fit5</metric>
    <enumeratedValueSet variable="modeltype">
      <value value="&quot;pseudorandom&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fitnessfunction">
      <value value="&quot;multiplier&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prand">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pself">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meaninv">
      <value value="0"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdinv">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdnoise">
      <value value="0.441"/>
      <value value="0.49"/>
      <value value="0.539"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdnoise2">
      <value value="0.9"/>
      <value value="1"/>
      <value value="1.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanimpact">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdimpact">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanwanted">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdwanted">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meantrust">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdtrust">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanalpha">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevalpha">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanbeta">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevbeta">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meaneco">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdeveco">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanlambda">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevlambda">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meangamma1">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevgamma1">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meangamma2">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevgamma2">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="best">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="sens_heuristic" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>calibrate</go>
    <exitCondition>done = 1</exitCondition>
    <metric>mean t_listinv1</metric>
    <metric>mean t_listinv2</metric>
    <metric>mean t_listinv3</metric>
    <metric>mean t_listinv4</metric>
    <metric>mean t_listinv5</metric>
    <metric>mean t_listinv6</metric>
    <metric>mean t_listinv7</metric>
    <metric>mean t_listinv8</metric>
    <metric>mean t_listinv9</metric>
    <metric>mean t_listinv10</metric>
    <metric>mean t_listinv11</metric>
    <metric>mean t_listinv12</metric>
    <metric>mean t_listinv13</metric>
    <metric>mean t_listinv14</metric>
    <metric>mean t_listinv15</metric>
    <metric>mean t_listinvpp1</metric>
    <metric>mean t_listinvpp2</metric>
    <metric>mean t_listinvpp3</metric>
    <metric>mean t_listinvpp4</metric>
    <metric>mean t_listinvpp5</metric>
    <metric>mean t_listcollpp1</metric>
    <metric>mean t_listcollpp2</metric>
    <metric>mean t_listcollpp3</metric>
    <metric>mean t_listcollpp4</metric>
    <metric>mean t_listcollpp5</metric>
    <metric>mean t_listginicont</metric>
    <metric>mean t_listginicoll</metric>
    <metric>fit</metric>
    <metric>fit1</metric>
    <metric>fit2</metric>
    <metric>fit3</metric>
    <metric>fit4</metric>
    <metric>fit5</metric>
    <enumeratedValueSet variable="modeltype">
      <value value="&quot;heuristic&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fitnessfunction">
      <value value="&quot;multiplier&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prand">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pself">
      <value value="0.36"/>
      <value value="0.4"/>
      <value value="0.44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meaninv">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdinv">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdnoise">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdnoise2">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanimpact">
      <value value="1.17"/>
      <value value="1.3"/>
      <value value="1.43"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdimpact">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanwanted">
      <value value="-1.54"/>
      <value value="-1.4"/>
      <value value="-1.26"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdwanted">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meantrust">
      <value value="0.567"/>
      <value value="0.63"/>
      <value value="0.693"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdtrust">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanalpha">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevalpha">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanbeta">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevbeta">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meaneco">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdeveco">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanlambda">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevlambda">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meangamma1">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevgamma1">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meangamma2">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevgamma2">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="best">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="sens_utilitarian" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>calibrate</go>
    <exitCondition>done = 1</exitCondition>
    <metric>mean t_listinv1</metric>
    <metric>mean t_listinv2</metric>
    <metric>mean t_listinv3</metric>
    <metric>mean t_listinv4</metric>
    <metric>mean t_listinv5</metric>
    <metric>mean t_listinv6</metric>
    <metric>mean t_listinv7</metric>
    <metric>mean t_listinv8</metric>
    <metric>mean t_listinv9</metric>
    <metric>mean t_listinv10</metric>
    <metric>mean t_listinv11</metric>
    <metric>mean t_listinv12</metric>
    <metric>mean t_listinv13</metric>
    <metric>mean t_listinv14</metric>
    <metric>mean t_listinv15</metric>
    <metric>mean t_listinvpp1</metric>
    <metric>mean t_listinvpp2</metric>
    <metric>mean t_listinvpp3</metric>
    <metric>mean t_listinvpp4</metric>
    <metric>mean t_listinvpp5</metric>
    <metric>mean t_listcollpp1</metric>
    <metric>mean t_listcollpp2</metric>
    <metric>mean t_listcollpp3</metric>
    <metric>mean t_listcollpp4</metric>
    <metric>mean t_listcollpp5</metric>
    <metric>mean t_listginicont</metric>
    <metric>mean t_listginicoll</metric>
    <metric>fit</metric>
    <metric>fit1</metric>
    <metric>fit2</metric>
    <metric>fit3</metric>
    <metric>fit4</metric>
    <metric>fit5</metric>
    <enumeratedValueSet variable="modeltype">
      <value value="&quot;utilitarian&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fitnessfunction">
      <value value="&quot;multiplier&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prand">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pself">
      <value value="0"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meaninv">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdinv">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdnoise">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdnoise2">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanimpact">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdimpact">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanwanted">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdwanted">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meantrust">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sdtrust">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanalpha">
      <value value="0.864"/>
      <value value="0.96"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevalpha">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanbeta">
      <value value="0.513"/>
      <value value="0.57"/>
      <value value="0.627"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevbeta">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meaneco">
      <value value="0.369"/>
      <value value="0.41"/>
      <value value="0.451"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdeveco">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meanlambda">
      <value value="0.549"/>
      <value value="0.61"/>
      <value value="0.671"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevlambda">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meangamma1">
      <value value="0.81"/>
      <value value="0.9"/>
      <value value="0.99"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevgamma1">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="meangamma2">
      <value value="0.234"/>
      <value value="0.26"/>
      <value value="0.286"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stdevgamma2">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="best">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
