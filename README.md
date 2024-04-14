# MENTR for CD4 T project

This is a customized [MENTR](https://rdcu.be/c26Uj), with some modifications to work on CD4 T cells' regulatory elements (Oguchi et al.; **TBD**).

See license and citation information for MENTR itself in the [MENTR GitHub repository](https://github.com/koido/MENTR).

We welcome any questions and requests via GitHub issues.


## Dependency

### External resources

 - GRCh38 fasta file
    - Please run `bash ./cd4t/src/sh/00.download_resources.sh` and `bash ./cd4t/src/sh/01.process_fasta.sh` to download and process the fasta file.
    - We expect that the processed file (`./resources/GRCh38_no_alt_analysis_set_GCA_000001405.15.simple.fasta`) can be found.
 - DeepSEA Beluga, see [here](https://github.com/koido/MENTR?tab=readme-ov-file#external-resources)
 
### Python for almost all analyses

See [here](https://github.com/koido/MENTR?tab=readme-ov-file#software-and-libraries).

### R for calcluating AUROC

For running R script in this repository, we prepared `renv` environment.

First of all, please prepare R v4.1.3 like this:

```bash
conda create --name mentr_cd4t_r -c conda-forge r-base=4.1.3
```

or

```bash
micromamba create -n mentr_cd4t_r -c conda-forge r-base=4.1.3
```

Then, activate the environment when R is needed (i.e., Calculating AUROC)

If you use the directory containing this README file as a working directory, you can use the `renv` automatically (see `.Rprofile`).

Please use `source("renv/activate.R")` in other conditions in R.

### AGE/UGE (job scheduler)

Current scripts depend on `qsub` for the job submission.

If users do not have the environment, please modify the job submission command in the scripts.

Please update the `qsub` options in the scripts to match your environment.

---

## In silico mutagenesis using the pre-trained models

### Run in silico mutagenesis

```bash
bash cd4t/src/sh/20230919/02_mutgen/round1/01_Run_mutgen_round1.sh
```

### Check the in silico mutagenesis

```bash
bash cd4t/src/sh/20230919/02_mutgen/round1/02_Logcheck_mutgen_round1.sh 0
```

If you want to re-run the failed jobs automatically, please set the second argument to 1 and modify `qsub` options in the script.

### Collect results and clean each result

```bash
bash cd4t/src/sh/20230919/02_mutgen/round1/03_Collect_mutgen_round1.sh
bash cd4t/src/sh/20230919/02_mutgen/round1/04_Clean_mutgen_round1.sh
```

NOTE: The published results also contain `round2`'s results.

---

## Training MENTR ML models (OPTIONAL; for developers)

In the following scripts, we assume you are in here (the directory containing this README file).

Please modify the options according to your environment.

### Prepare epigenetic features

#### Collect all positions from bed files

```bash
bash ./cd4t/src/sh/20230919/01_train/01_prep_input_files.sh
```

If you want to add new enhancers in the analysis, please add the bed file to the `01_prep_input_files.sh`.

#### Calculate epigenetic features

```bash
# NOTE: At least 200GB free storage is required for this output directory.
LARGE_DIR="Path for directory writing large output files."
bash ./cd4t/src/sh/20230919/01_train/02_calc_epigenetic_features.GRCh38.1_split.sh ${LARGE_DIR}

# Please change the number of array job in the script, according to the previous splitting script
# Please set the array job setting in the script, according to your environment.
bash ./cd4t/src/sh/20230919/01_train/03_calc_epigenetic_features.GRCh38.2_compute_eff.sh ${LARGE_DIR}

# Please change the index in the for loop, according to the previous splitting script
bash ./cd4t/src/sh/20230919/01_train/04_calc_epigenetic_features.GRCh38.3_merge_eff.sh ${LARGE_DIR}

# Please set the array job setting in the script, according to your environment.
# Need very long time (about 1 day) and large memory (<800GB)
bash ./cd4t/src/sh/20230919/01_train/05_make_hdf5.sh ${LARGE_DIR}
```

### Train MENTR models

#### Prepare class information

This shell script prepares case/control information for each MENTR model and their names in the following training procedures

```bash
bash ./cd4t/src/sh/20230919/01_train/06_prep_class_info.sh
```

#### Train MENTR models

```bash
bash ./cd4t/src/sh/20230919/01_train/07_train_MENTR_models.sh ${LARGE_DIR}
```

### Calibrate the trained MENTR models

Because the computational cost is low, running this script on a local machine is no problem.

```bash
bash ./cd4t/src/sh/20230919/01_train/08_calibrate_MENTR_models.sh ${LARGE_DIR}
```

### Evaluate the performance (AUROC) of the trained MENTR models

In the following scripts for AUROC, you need R v4.1.3 and `renv` (see above).

```bash
bash ./cd4t/src/sh/20230919/01_train/09_evaluate_AUROC.sh
bash ./cd4t/src/sh/20230919/01_train/10_collect_AUROC.sh
bash ./cd4t/src/sh/20230919/01_train/11_evaluate_AUROC_cross.sh
bash ./cd4t/src/sh/20230919/01_train/12_collect_AUROC_cross.sh
bash ./cd4t/src/sh/20230919/01_train/13_prep_fineclass_info.sh
bash ./cd4t/src/sh/20230919/01_train/14_evaluate_AUROC_fineclass.sh
bash ./cd4t/src/sh/20230919/01_train/15_collect_AUROC_fineclass.sh
```

These scripts produce `./cd4t/resources/trained/03/binary_v1/AUROC/auroc.summary.cross.v2.txt`.

### Prepare model list file for in silico mutagenesis

```bash
bash ./cd4t/src/sh/20230919/01_train/16_prep_modellist.sh
```