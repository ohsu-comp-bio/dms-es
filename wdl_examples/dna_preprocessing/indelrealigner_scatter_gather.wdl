task indelrealigner {
    # an interval file name pulled from an array
    String scatter_intervals_file
    #the path and partial file name of the output BAM file from the JSON input file
    String out_bam
    #the path and filename of the input BAM file to work on from the JSON input file
    String input_bam
    #the path and filename of the genome reference file to use from the JSON input file
    String genome_reference
    #the path and filename of the indel file to use from the JSON input file
    String indels
    #the path to the directory containing the interval files and the 
    #file that has the list of the file names of the interval files
    String GATK_dir

    command {
       java -Xmx8g -jar ${GATK_dir}GenomeAnalysisTK.jar -T IndelRealigner -o ${out_bam}${scatter_intervals_file}.bam --num_cpu_threads_per_data_thread 1 -LOD 5.0 --pedigreeValidationType STRICT --read_filter NotPrimaryAlignment --interval_set_rule UNION --downsampling_type NONE --baq OFF --baqGapOpenPenalty 40.0 --defaultBaseQualities 0 --validation_strictness SILENT --interval_merging ALL -I ${input_bam} -known:indels,vcf ${indels} -R ${genome_reference} -targetIntervals ${scatter_intervals_file}
    }

    output {
     #output a finished bam file 
     String response = "${out_bam}${scatter_intervals_file}.bam"
    }
    
    runtime {
        tool: "GATK"
    	strategy: "file_routed"
    }
}

task gather {
     Array[String] output_files_to_gather
     String gather_output_path_file
     String picard_path

     command <<<
        echo ${sep=' ' output_files_to_gather} | { list=$(< /dev/stdin); for i in $list; do input_files+=$(printf "INPUT=$i " $input_files); done; java -Xmx2048m -Xms256m -jar ${picard_path}picard.jar MergeSamFiles $input_files OUTPUT="${gather_output_path_file}" MERGE_SEQUENCE_DICTIONARIES=false ASSUME_SORTED=false USE_THREADING=true SORT_ORDER=coordinate VALIDATION_STRINGENCY=LENIENT QUIET=true VERBOSITY=ERROR;   };
     >>>
     output {
         String gather_out_file = "${gather_output_path_file}"
     }
     
     runtime {
        tool: "picard"
    	strategy: "file_routed"
    }
}


workflow indelrealigner_wdl_test {
    #the path and filename of the file continaing the list of 
    #file names of the interval files from the JSON input file
    String global_GATK_dir
    Array[String] scatter_file_array


    scatter (scatter_file in scatter_file_array) {
        call indelrealigner {input: scatter_intervals_file = scatter_file, GATK_dir=global_GATK_dir}
    }

    call gather {input: output_files_to_gather=indelrealigner.response}
}
