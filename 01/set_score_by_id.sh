#!/bin/bash

source ../common/extract_input.sh

# Get relevant values using regex
get_ids_from_input=$(grep -oE '[0-9]+' "$input_file")

##################
# Separate lists #
##################

list1=()
list2=()

index=0
for value in $get_ids_from_input; do
  if (( index % 2 == 0 )); then
    list1+=($value)
  else
    list2+=($value)
  fi
  ((index++))
done

# Debug: Print list sizes
# echo "Number of elements in list1: ${#list1[@]}"
# echo "Number of elements in list2: ${#list2[@]}"

######################################
# Clean duplications from first list #
######################################

unique_sorted_list1=($(printf "%s\n" "${list1[@]}" | sort -n | uniq))

#####################
# Set a score by ID #
#####################

declare -A score_by_id

for id in "${unique_sorted_list1[@]}"; do
  count_in_list2=$(printf "%s\n" "${list2[@]}" | grep -c "^$id$")
  score=$((id * count_in_list2))
  score_by_id[$id]=$score
#   echo "ID: $id, Count in List2: $count_in_list2, Score: $score"
done

#########################
# Calculate total score #
#########################

total_score=0

for id in "${!score_by_id[@]}"; do
  total_score=$((total_score + score_by_id[$id]))
done

# Show total score
echo "The total score is: $total_score"