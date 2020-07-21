#!/bin/bash

# to run snakemake as batch job
# run in the data folder for this project
snakefile=$1
config=$2
cluster_json=$3
working_dir=$4

module load snakemake/5.4.4 || exit 1
mkdir -p ${working_dir}/00log

sbcmd="sbatch --cpus-per-task={threads} \
--mem={cluster.mem} \
--time={cluster.time} \
--partition={cluster.partition} \
--output={cluster.output} \
--error={cluster.error} \
{cluster.extra}"



snakemake -s $snakefile \
-pr --local-cores 2 --jobs 1999 \
--configfile $config \
--directory $working_dir \
--cluster-config $cluster_json \
--cluster "$sbcmd"  --latency-wait 120 --rerun-incomplete \
-k --restart-times 1 --resources res=1

# --notemp Ignore temp() declaration;
# --dryrun 
# --unlock
