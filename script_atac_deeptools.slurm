#!/bin/bash
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=30G
#SBATCH --cpus-per-task=8   # Nb of threads we want to run on ${SLURM_CPUS_ON_NODE}
#SBATCH -o log/slurmjob-%A-%a
#SBATCH --job-name=atac_deeptools
#SBATCH --partition=short


#Programme configuration
__author__='Alphonse thiaw'
__email__='alphonse_birane.thiaw@etu.uca.fr'
__credits__=["Alphonse Thiaw"]
__maintainer__='Alphonse Thiaw'
__status__='Development'
__version__=0.0.1

echo 'Genome coverage analysis'

# Handling errors
#set -e # a bash script to exit immediately when a command fails
set -o nounset # force variable initialisation
#set -x # debug mode on : print each command before executing it
#set -o pipefail # exit code of a pipeline to that of the rightmost command to exit with a non-zero status
#set -euxo pipefail
set -o errexit #ensure script will stop in case of ignored error

#Set up whatever package we need to run with
# module load 
module purge
module load gcc/4.8.4 python/2.7.9 numpy/1.9.2 samtools/1.3 deepTools/3.1.2

# set up the temporary directory
SCRATCHDIR=/storage/scratch/"$USER"/"$SLURM_JOB_ID"
mkdir -p -m 700 "$SCRATCHDIR"
cd "$SCRATCHDIR"

OUTPUT="$HOME"/results/atacseq/atac_deeptools
mkdir -p "$OUTPUT"

#Set up data directory
DATA_DIR="$HOME/results/atacseq/atac_picard"

echo "Collect BAM files to analysis" >&2

tab="$DATA_DIR"/*/*_trim_mapped_sorted_q2_nodup.bam

echo "tab = " >&2
printf '%s\n' "${tab[@]}" >&2

# Current filename
#SHORTNAME=$(basename "${tab[$SLURM_ARRAY_TASK_ID]}" .bam )
#echo "shortname = $SHORTNAME" >&2


#Run the program
echo "Start job: "`date` >&2
#


# Run the program
#multiBamSummary bins --bamfile ${tab[$SLURM_ARRAY_TASK_ID]}  -o "$SCRATCHDIR"results_deeptools.npz
multiBamSummary bins --bamfile $tab  -o "$SCRATCHDIR"/results_deeptools.npz

#Move results in one's directory

mv  "$SCRATCHDIR" "$OUTPUT"

# Cleaning in case something went wrong
rm -rf  "$SCRATCHDIR"

echo "Stop job: "`date` >&2
