task bwa_mem {
    String bwa_dir
    String genome_reference
    String bwa_mem_read1_input_file
    String bwa_mem_read2_input_file
    String bwa_mem_output_file
    String output_dir

    command {
        ${bwa_dir}bwa mem -t 2 -k 19 -w 100 -d 100 -r 1.5 -c 10000 -A 1 -B 4 -O 6 -E 1 -L 5 -U 17 -T 30 -a -M -R '@RG\tID:r\tLB:l\tSM:s\tPL:ILLUMINA' ${genome_reference} ${bwa_mem_read1_input_file} ${bwa_mem_read2_input_file}
    }
    output {    
        String response =  redirectStdout("${output_dir}${bwa_mem_output_file}")
    }
    runtime {
        tool: "bwa-mem"
        strategy: "file_routed"
    }
}

task sam_tools_view {
    String samtools_dir
    String reference_genome_fai
    String output_dir
    String samtools_view_input_sam
    String samtools_view_output_file
    command {
        ${samtools_dir}samtools view -bt ${reference_genome_fai} -@ 4 -o ${output_dir}${samtools_view_output_file} -S ${samtools_view_input_sam}
    }

    output {
        String response = "${output_dir}${samtools_view_output_file}"
    }
        
    runtime {
        tool: "samtools"
        strategy: "file_routed"
    }
} 


##### Do something about this. THis tool doesn't produce any .bai output 
task sam_tools_index {
    String samtools_dir
    String output_dir
    String samtools_index_input_file
    String samtools_index_output_file
    command {
        ${samtools_dir}samtools index ${samtools_index_input_file} ${samtools_index_output_file}
    }

    output {
        String response = "${output_dir}${samtools_index_output_file}"
    }
    
    runtime {
        tool: "samtools"
        strategy: "file_routed"
    }
} 

task sam_tools_sort {
    String samtools_dir
    String output_dir
    String samtools_sort_input_bam
    String samtools_sort_output_file
    command {
        ${samtools_dir}samtools sort -@ 4 -l 5 ${samtools_sort_input_bam} -o ${output_dir}${samtools_sort_output_file}

    }

    output {
        String response = redirectStdout("${output_dir}${samtools_sort_output_file}")
    }
        
    runtime {
        tool: "samtools"
        strategy: "file_routed"
    }
} 

task picard_mark_duplicates {
    String output_dir
    #the path and partial file name of the output BAM file from the JSON input file
    String picard_markduplicates_bam_output_file 
    String picard_markduplicates_metrics_output_file 
    #the path and filename of the input BAM file to work on from the JSON input filename
    String picard_markduplicates_input_bam
    String picard_path
    String picard_markdupicates_input_bam_index

    command {
        /usr/bin/java -Xmx8g -jar ${picard_path}picard.jar MarkDuplicates I=${picard_markduplicates_input_bam} O=${output_dir}${picard_markduplicates_bam_output_file} M=${output_dir}${picard_markduplicates_metrics_output_file} TMP_DIR=${output_dir} VALIDATION_STRINGENCY=SILENT ASSUME_SORTED=true REMOVE_DUPLICATES=true
    }
    output {
        String picard_markduplicates_bam_file = "${output_dir}${picard_markduplicates_bam_output_file}"
        #String picard_markduplicates_metrics_file = "${output_dir}${picard_markduplicates_metrics_output_file}"
    }
        
    runtime {
        tool: "picard"
        strategy: "file_routed"
    }
}

task realigner_target_creator {
    String dbsnp
    String indels
    String genome_reference
    String output_dir
    String realigner_target_creator_intervals_output_file 
    String realigner_target_creator_input_bam
    String GATK_dir
    String realigner_target_creator_input_bam_index

    command {
        /usr/bin/java -Xmx8g -jar ${GATK_dir}GenomeAnalysisTK.jar -T RealignerTargetCreator -nt 4 -R ${genome_reference} -o ${output_dir}${realigner_target_creator_intervals_output_file} -known:dbsnp,VCF  ${dbsnp}  -known:indels,vcf ${indels} -I ${realigner_target_creator_input_bam} 
    }
    output {
        String response = "${output_dir}${realigner_target_creator_intervals_output_file}"
    }
        
    runtime {
        tool: "GATK"
        strategy: "file_routed"
    }
}

task indel_realigner {
    String dbsnp
    String indels
    String genome_reference
    String output_dir
    String indel_realigner_output_bam 
    String indel_realigner_input_bam
    String indel_realigner_input_intervals
    String GATK_dir

    command {
        /usr/bin/java -Xmx8g -jar ${GATK_dir}GenomeAnalysisTK.jar -T IndelRealigner -rf NotPrimaryAlignment -R ${genome_reference} -targetIntervals ${indel_realigner_input_intervals} -known:indels,vcf ${indels} -I ${indel_realigner_input_bam} -o ${output_dir}${indel_realigner_output_bam} 
    }
    output {
        String response = "${output_dir}${indel_realigner_output_bam}"
    }
        
    runtime {
        tool: "GATK"
        strategy: "file_routed"
    }

}

task base_recalibrator {
    String dbsnp
    String indels
    String genome_reference
    String output_dir
    String base_recalibrator_output_file 
    String base_recalibrator_input_bam
    String GATK_dir
    String base_recalibrator_input_bam_index

    command {
         /usr/bin/java -Xmx4g -jar ${GATK_dir}GenomeAnalysisTK.jar -T BaseRecalibrator -I ${base_recalibrator_input_bam} -R ${genome_reference} -rf BadCigar  -knownSites:mask,vcf ${dbsnp} -l INFO  --default_platform illumina -cov QualityScoreCovariate -cov CycleCovariate -cov ContextCovariate -cov ReadGroupCovariate --disable_indel_quals -o ${output_dir}${base_recalibrator_output_file} 

    }
    output {
        String response = "${output_dir}${base_recalibrator_output_file}"
    }
        
    runtime {
        tool: "GATK"
        strategy: "file_routed"
    }
}

task print_reads {
    String genome_reference
    String output_dir
    String print_reads_output_bam 
    String print_reads_input_bam
    String print_reads_input_grp
    String GATK_dir

    command {
        /usr/bin/java -Xmx8g -jar ${GATK_dir}GenomeAnalysisTK.jar -T PrintReads -R ${genome_reference} -I ${print_reads_input_bam} -BQSR ${print_reads_input_grp} -rf BadCigar -o ${output_dir}${print_reads_output_bam} 
    }
    output {
        String response = "${output_dir}${print_reads_output_bam}"
    }
        
    runtime {
        tool: "GATK"
        strategy: "file_routed"
    }
}

task samtools_flagstat {
    String samtools_dir
    String output_dir
    String samtools_flagstat_output_stat 
    String samtools_flagstat_input_bam
    String samtools_flagstat_input_bam_index

    command {
        ${samtools_dir}samtools flagstat ${samtools_flagstat_input_bam} 
    }
    output {
        String response = redirectStdout("${output_dir}${samtools_flagstat_output_stat}")
    }
        
    runtime {
        tool: "samtools"
        strategy: "file_routed"
    }
}


workflow dna_preprocessing {
     String reference_genome
     String global_indels
     String global_dbsnp
     String global_output_dir
     String global_GATK_dir
     String global_samtools_dir
     String global_bwa_dir

     call bwa_mem
          {
              input: genome_reference=reference_genome, output_dir=global_output_dir, bwa_dir=global_bwa_dir
          }
call sam_tools_view 
          {
              input: samtools_view_input_sam = bwa_mem.response, samtools_dir=global_samtools_dir, output_dir=global_output_dir
          } 

     call sam_tools_sort 
          {
              input: samtools_sort_input_bam = sam_tools_view.response, samtools_dir=global_samtools_dir, output_dir=global_output_dir
          }

     call sam_tools_index
         {
              input: samtools_index_input_file = sam_tools_sort.response, samtools_dir=global_samtools_dir, output_dir=global_output_dir     
         }

     call picard_mark_duplicates 
         {
             input: picard_markduplicates_input_bam = sam_tools_sort.response, output_dir=global_output_dir, picard_markdupicates_input_bam_index = sam_tools_index.response
         }

     call sam_tools_index as sam_tools_index_picard_mark_duplicates
         {
              input: samtools_index_input_file = picard_mark_duplicates.picard_markduplicates_bam_file, samtools_dir=global_samtools_dir, samtools_index_output_file = "picard_markduplicates_output.bam.bai", output_dir=global_output_dir     
#              input: samtools_index_input_file = picard_mark_duplicates.picard_markduplicates_bam_file, samtools_dir=global_samtools_dir, samtools_index_output_file = "sam_tools_index_picard_mark_duplicates.bam.bai", output_dir=global_output_dir     
         }

     call realigner_target_creator 
         {
             input: realigner_target_creator_input_bam = picard_mark_duplicates.picard_markduplicates_bam_file , genome_reference=reference_genome, indels=global_indels, dbsnp=global_dbsnp, output_dir=global_output_dir, GATK_dir=global_GATK_dir, realigner_target_creator_input_bam_index = sam_tools_index_picard_mark_duplicates.response 
         }

     call indel_realigner 
         {
             input: indel_realigner_input_bam = picard_mark_duplicates.picard_markduplicates_bam_file , indel_realigner_input_intervals = realigner_target_creator.response, genome_reference=reference_genome, indels=global_indels, dbsnp=global_dbsnp, output_dir=global_output_dir, GATK_dir=global_GATK_dir
         }

     call sam_tools_index as sam_tools_index_realigner_bam
         {
#              input: samtools_index_input_file = indel_realigner.response, samtools_dir=global_samtools_dir, samtools_index_output_file = "sam_tools_index_realigner_bam.bai", output_dir=global_output_dir     
              input: samtools_index_input_file = indel_realigner.response, samtools_dir=global_samtools_dir, samtools_index_output_file = "indel_realigner_output.bam.bai", output_dir=global_output_dir     
         }

     call base_recalibrator 
         {
             input: base_recalibrator_input_bam = indel_realigner.response, genome_reference=reference_genome, indels=global_indels, dbsnp=global_dbsnp, output_dir=global_output_dir, GATK_dir=global_GATK_dir, base_recalibrator_input_bam_index = sam_tools_index_realigner_bam.response
         }
 
     call print_reads 
         {
             input: print_reads_input_bam = indel_realigner.response, print_reads_input_grp=base_recalibrator.response , output_dir=global_output_dir, genome_reference=reference_genome, GATK_dir=global_GATK_dir
         }

     call sam_tools_index as sam_tools_index_base_recalibrator_bam
         {
              input: samtools_index_input_file = print_reads.response, samtools_dir=global_samtools_dir,samtools_index_output_file = "print_reads.bam.bai", output_dir=global_output_dir     
#              input: samtools_index_input_file = print_reads.response, samtools_dir=global_samtools_dir,samtools_index_output_file = "sam_tools_index_base_recalibrator_bam.bai", output_dir=global_output_dir     
         }
     
     call samtools_flagstat
         {
              input: samtools_flagstat_input_bam = print_reads.response, samtools_dir=global_samtools_dir, output_dir=global_output_dir, samtools_flagstat_input_bam_index = sam_tools_index_base_recalibrator_bam.response     
         }
     
}
