#!/bin/bash
# Michal Loska 16.11.2021
# Do not mind the unexpected end of file warnings!
# Precondition: gzip
# Assumption: input file name can be changed with env var: INPUT_ARCHIVE_NAME. If not set, 'syslog' by default
#             example file names: syslog.1.zlib, syslog.2.zlib, syslog.3.zlib, ...
# Assumption: output file name can be changed with env var: OUTPUT_FILE_NAME. If not set, 'extracted_logs' by default
# Assumption: output file format  can be changed with env var: OUTPUT_FILE_FORMAT. If not set, '.log' by default
# usage: ./extract_zlib.sh 1 9 remove - extract files indexed 1 to 9 into the default extracted_logs.log and remove the archives 
# usage: ./extract_zlib.sh 1 9 - extract files indexed 1 to 9 into the default extracted_logs.log 

[[ -z "${INPUT_ARCHIVE_NAME}" ]] && archive_base_name='syslog' || archive_base_name="${INPUT_ARCHIVE_NAME}"
[[ -z "${OUTPUT_FILE_NAME}" ]] && default_output_name='extracted_logs' || default_output_name="${OUTPUT_FILE_NAME}"
[[ -z "${OUTPUT_FILE_FORMAT}" ]] && default_output_format='.log' || default_output_format="${OUTPUT_FILE_FORMAT}"

zlib_header="\x1f\x8b\x08\x00\x00\x00\x00\x00"

if [ "$1" == "help" ]; then
    echo "Do not mind the unexpected end of file warnings!"
    echo "Precondition: gzip"
    echo "Assumption: input file name can be changed with env var: INPUT_ARCHIVE_NAME. If not set, 'syslog' by default"
    echo "            example file names: syslog.1.zlib, syslog.2.zlib, syslog.3.zlib, ..."
    echo "Assumption: output file name can be changed with env var: OUTPUT_FILE_NAME. If not set, 'extracted_logs' by default"
    echo "Assumption: output file format  can be changed with env var: OUTPUT_FILE_FORMAT. If not set, '.log' by default"
    echo "usage: ./extract_zlib.sh 1 9 remove - extract files indexed 1 to 9 into the default extracted_logs.log and remove the archives "
    echo "usage: ./extract_zlib.sh 1 9 - extract files indexed 1 to 9 into the default extracted_logs.log "
    exit 0
fi

if [ -z $1 ]; then
    printf "The 1 parameter must contain the min file index\n"
    printf "Quitting...\n"
    exit 1
elif [ -z $2 ]; then
    printf "The 2 parameter must contain the max file index\n"
    printf "Quitting...\n"
    exit 1
elif [ -z $3 ]; then
    printf "The 3 param empty - using default output name: %s \n" "$default_output_name"
fi

if test -f "$default_output_name""$default_output_format"; then
    current_time=$(date +"%T")
    new_file_name="$default_output_name.$current_time"
    echo "$default_output_name$default_output_format file exists, creating new file: $new_file_name"
    touch "$new_file_name"
fi
for ((i = $2; i >= $1; i--)); do
    printf "Iteration $i - $(date)\n"
    archive_name="$archive_base_name.$i.zlib"
    echo "-------------- $archive_name --------------" >>"./$default_output_name""$default_output_format"
    printf "$zlib_header" | cat - "$archive_name" | zcat >> "./$default_output_name""$default_output_format"

    if [ "$3" == "remove" ]; then
        echo "Removing ./$archive_name"
        rm "./$archive_name"
    fi
done

echo "done!"
