#!/bin/bash

# set -x

#############
# Constants #
#############

# Prefix directory where PeTTa and MORK are installed
hypdir="/home/nilg/Work/TrueAGI"

#############
# Functions #
#############

# Convert integer into its Peano representation
i2p() {
    local i=$1
    if [[ $i -eq 0 ]]; then
        echo "Z"
    else
        echo "(S $(i2p $((i - 1))))"
    fi
}

# Count PeTTa solutions stored in the given file
count_petta_solutions() {
    grep "(:" "$1" | wc -l
}

# Count MM2 solutions of a given depth stored in the given file
count_mm2_solutions() {
    grep "(sol $1" "$2" | wc -l
}

# Get user time given GNU time output in a file
get_user_time() {
    grep "User time (seconds)" "$1" | cut -d' ' -f4
}

# Get maximum RAM usage given GNU time output in a file
get_max_ram() {
    grep "Maximum resident set size (kbytes):" "$1" | cut -d' ' -f6
}

# Get the theorem corresponding to its name
get_theorem() {
    case "$1" in
        idrefl)
            echo "(→ (→ 𝜑 𝜓) (→ 𝜑 𝜑))"
            ;;
        id)
            echo "(→ 𝜑 𝜑)"
            ;;
        2a1)
            echo "(→ 𝜑 (→ 𝜓 (→ 𝜒 𝜑)))"
            ;;
        pm2.43)
            echo "(→ (→ 𝜑 (→ 𝜑 𝜓)) (→ 𝜑 𝜓))"
            ;;
        imim2)
            echo "(→ (→ 𝜑 𝜓) (→ (→ 𝜒 𝜑) (→ 𝜒 𝜓)))"
            ;;
        jarr)
            echo "(→ (→ (→ 𝜑 𝜓) 𝜒) (→ 𝜓 𝜒))"
            ;;
        *)
            echo ""
            ;;
    esac
}

########
# Main #
########

# Run the full suite of benchmarks to produce benchmarking data
# comparing PeTTa and MM2.

# 1. Run forward chaining to produce all candidates up to depth 4
echo "*************** Full Forward Chaining ***************"
for depth in {1..1}; do
    echo "------------ depth $depth ------------"
    # MM2
    dst=pc-fc-depth_${depth}-mm2.stdout
    depth_peano="$(i2p $depth)"
    sed -i "s/(ne [()S Z]\+)/(ne $depth_peano)/g" pc-fc.mm2
    /usr/bin/time --verbose "${hypdir}/MORK/target/release/mork" run pc-fc.mm2 &> $dst
    echo "* MM2"
    echo "  - File: $dst"
    echo "  - Solution count: $(count_mm2_solutions "$depth_peano" $dst)"
    echo "  - Time (in second): $(get_user_time $dst)"
    echo "  - Maximum RAM (in byte): $(get_max_ram $dst)"

    # MeTTa
    dst=pc-fc-depth_${depth}-petta.stdout
    sed -i "s/(= (depth) [0-9]\+)/(= (depth) $depth)/g" pc-fc.metta
    /usr/bin/time --verbose "${hypdir}/PeTTa/run.sh" pc-fc.metta --silent &> $dst
    echo "* PeTTa"
    echo "  - File: $dst"
    echo "  - Solution count: $(count_petta_solutions $dst)"
    echo "  - Time (in second): $(get_user_time $dst)"
    echo "  - Maximum RAM (in byte): $(get_max_ram $dst)"
done

# 2. Run backward chaining to produce all candidates up to depth 3
echo "*************** Full Backward Chaining ***************"
for depth in {1..2}; do
    echo "------------ Depth: $depth ------------"
    # MM2
    dst=pc-bc-depth_${depth}-mm2.stdout
    depth_peano="$(i2p $depth)"
    query="(! (bc $depth_peano . (: \$x \$a)))"
    # Set query
    echo "$query" >> pc-bc.mm2
    # Run query
    /usr/bin/time --verbose "${hypdir}/MORK/target/release/mork" run pc-bc.mm2 &> $dst
    # Remove query
    head -n -1 pc-bc.mm2 > pc-bc-tmp.mm2
    mv pc-bc-tmp.mm2 pc-bc.mm2
    # Display statistics
    echo "* MM2"
    echo "  - File: $dst"
    echo "  - Solution count: $(count_mm2_solutions "\." $dst)"
    echo "  - Time (in second): $(get_user_time $dst)"
    echo "  - Maximum RAM (in byte): $(get_max_ram $dst)"

    # MeTTa
    dst=pc-bc-depth_${depth}-petta.stdout
    query="!(bc (fromNumber ${depth}) (: \$x \$a))"
    # Set query
    echo "$query" >> pc-bc.metta
    # Run query
    /usr/bin/time --verbose "${hypdir}/PeTTa/run.sh" pc-bc.metta --silent &> $dst
    # Remove query
    head -n -1 pc-bc.metta > pc-bc-tmp.metta
    mv pc-bc-tmp.metta pc-bc.metta
    # Display statistics
    echo "* PeTTa"
    echo "  - File: $dst"
    echo "  - Solution count: $(count_petta_solutions $dst)"
    echo "  - Time (in second): $(get_user_time $dst)"
    echo "  - Maximum RAM (in byte): $(get_max_ram $dst)"
done

# 3. Run backward chaining to produce all proofs of a given theorems
#    of various solution densities
echo "*************** Theorem Backward Chaining ***************"
for theorem_id in idrefl id 2a1 pm2.43 imim2 jarr; do
    depth=3
    theorem="$(get_theorem $theorem_id)"
    echo "------------ Theorem: $theorem_id, $theorem ------------"
    # MM2
    dst=pc-bc-depth_${depth}-${theorem_id}-mm2.stdout
    depth_peano="$(i2p $depth)"
    query="(! (bc $depth_peano . (: \$x $theorem)))"
    # Set query
    echo "$query" >> pc-bc.mm2
    # Run query
    /usr/bin/time --verbose "${hypdir}/MORK/target/release/mork" run pc-bc.mm2 &> $dst
    # Remove query
    head -n -1 pc-bc.mm2 > pc-bc-tmp.mm2
    mv pc-bc-tmp.mm2 pc-bc.mm2
    # Display statistics
    echo "* MM2"
    echo "  - File: $dst"
    echo "  - Solution count: $(count_mm2_solutions "\." $dst)"
    echo "  - Time (in second): $(get_user_time $dst)"
    echo "  - Maximum RAM (in byte): $(get_max_ram $dst)"

    # MeTTa
    dst=pc-bc-depth_${depth}-${theorem_id}-petta.stdout
    query="!(bc (fromNumber ${depth}) (: \$x $theorem))"
    # Set query
    echo "$query" >> pc-bc.metta
    # Run query
    /usr/bin/time --verbose "${hypdir}/PeTTa/run.sh" pc-bc.metta --silent &> $dst
    # Remove query
    head -n -1 pc-bc.metta > pc-bc-tmp.metta
    mv pc-bc-tmp.metta pc-bc.metta
    # Display statistics
    echo "* PeTTa"
    echo "  - File: $dst"
    echo "  - Solution count: $(count_petta_solutions $dst)"
    echo "  - Time (in second): $(get_user_time $dst)"
    echo "  - Maximum RAM (in byte): $(get_max_ram $dst)"
done

