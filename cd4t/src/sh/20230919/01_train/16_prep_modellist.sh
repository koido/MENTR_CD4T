#!/bin/bash

cd cd4t/resources/trained/03/binary_v1

# xgboost
echo -e "ModelName\tTissue" > modellist_xgb.txt
paste <(ls -1 *.save) <(ls -1 *.save | sed -e "s/^gbtree_logistic_sample_name.//" -e "s/_filterStr.all_num_round.500_early_stopping_rounds.10_base_score.0.5_l1.0_l2.50_eta.0.01_seed.12345_max_depth.4_evalauc_model.save$//g") >> modellist_xgb.txt

# calibration
echo -e "ModelName\tTissue" > modellist_calib.txt
paste <(ls -1 *.joblib) <(ls -1 *.joblib | sed -e "s/^gbtree_logistic_sample_name.//" -e "s/_filterStr.all_num_round.500_early_stopping_rounds.10_base_score.0.5_l1.0_l2.50_eta.0.01_seed.12345_max_depth.4_evalauc_IsotonicRegression.joblib$//g") >> modellist_calib.txt

cd - 1> /dev/null 2>&1