#!/bin/bash

source ../common/utils.sh
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
echo "Number of elements in list1: ${#list1[@]}"
echo "Number of elements in list2: ${#list2[@]}"

##################################################
# Sort each list from smaller to larger numbers  #
##################################################

sorted_list1=($(printf "%s\n" "${list1[@]}" | sort -n))
sorted_list2=($(printf "%s\n" "${list2[@]}" | sort -n))

# Debug: Print sorted lists
echo "Number of elements in sorted list1: ${#sorted_list1[@]}"
echo "Number of elements in sorted list2: ${#sorted_list2[@]}"

#################################
# Measure length between tuples #
#################################

length=0

for ((i=0; i<${#sorted_list1[@]}; i++)); do
  abs_diff=$(absolute $((sorted_list1[i] - sorted_list2[i])))

  length=$((length + abs_diff))

  # Debug: Print current step
  echo "Comparing: ${sorted_list1[i]} and ${sorted_list2[i]}, abs_diff: $abs_diff, current length: $length"
done

plop_diff=$(absolute "${sorted_list1[999]}" - "${sorted_list2[999]}")

echo "The smallest number in the left list is ${sorted_list1[999]}, and the smallest number in the right list is ${sorted_list2[999]}. The distance between them is $plop_diff"

# Show total distance between lists
echo "The total distance is: $length"
