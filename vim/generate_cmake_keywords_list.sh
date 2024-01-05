#!/bin/bash

list_variables=(
$(cmake --help-variable-list)
)

list_commands=(
$(cmake --help-command-list)
)

list_manuals=(
$(cmake --help-manual-list)
)

list_modules=(
$(cmake --help-module-list)
)

list_policies=(
$(cmake --help-policy-list)
)

list_properties=(
$(cmake --help-property-list)
)

list_cpack_variables=(
    $(cmake --help-full | grep "variable::" | grep CPACK_ | awk '{ print $3  }' | sort -u)
)

truncate -s 0 ./cmake_keywords.dic

echo "help-variable-list" >> ./cmake_keywords.dic
for var in  "${list_variables[@]}"
do
    # grep -q $var ./cmake_keywords.dic || echo "$var"
    echo $var >> ./cmake_keywords.dic
done

echo "help-command-list" >> ./cmake_keywords.dic
for var in  "${list_commands[@]}"
do
    # grep -q $var ./cmake_keywords.dic || echo "$var"
    echo $var >> ./cmake_keywords.dic
done

echo "help-manual-list" >> ./cmake_keywords.dic
for var in  "${list_manuals[@]}"
do
    # grep -q $var ./cmake_keywords.dic || echo "$var"
    echo $var >> ./cmake_keywords.dic
done

echo "help-module-list" >> ./cmake_keywords.dic
for var in  "${list_modules[@]}"
do
    # grep -q $var ./cmake_keywords.dic || echo "$var"
    echo $var >> ./cmake_keywords.dic
done

echo "help-policy-list" >> ./cmake_keywords.dic
for var in  "${list_policies[@]}"
do
    # grep -q $var ./cmake_keywords.dic || echo "$var"
    echo $var >> ./cmake_keywords.dic
done

echo "help-property-list" >> ./cmake_keywords.dic
for var in  "${list_properties[@]}"
do
    # grep -q $var ./cmake_keywords.dic || echo "$var"
    echo $var >> ./cmake_keywords.dic
done

echo "help-cpack-list" >> ./cmake_keywords.dic
for var in  "${list_cpack_variables[@]}"
do
    # grep -q $var ./cmake_keywords.dic || echo "$var"
    echo $var >> ./cmake_keywords.dic
done
