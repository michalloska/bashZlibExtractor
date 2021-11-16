# bashZlibExtractor
extract .zlib archives with a simple bash script

Do not mind the unexpected end of file warnings!
Precondition: gzip
Assumption: input file name can be changed with env var: INPUT_ARCHIVE_NAME. If not set, 'syslog' by default
            example file names: syslog.1.zlib, syslog.2.zlib, syslog.3.zlib, ...
Assumption: output file name can be changed with env var: OUTPUT_FILE_NAME. If not set, 'extracted_logs' by default
Assumption: output file format  can be changed with env var: OUTPUT_FILE_FORMAT. If not set, '.log' by default
usage: ./extract_zlib.sh 1 9 remove - extract files indexed 1 to 9 into the default extracted_logs.log and remove the archives 
usage: ./extract_zlib.sh 1 9 - extract files indexed 1 to 9 into the default extracted_logs.log 