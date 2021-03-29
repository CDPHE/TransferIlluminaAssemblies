version 1.0

workflow TransferIlluminaAssemblies {

    input {
        Array[File] fastqc_raw1_html
        Array[File] fastqc_raw1_zip
        Array[File] fastqc_raw2_html
        Array[File] fastqc_raw2_zip
        Array[File] fastqc_clean1_html
        Array[File] fastqc_clean1_zip
        Array[File] fastqc_clean2_html
        Array[File] fastqc_clean2_zip
        Array[File] seqyclean_summary
        Array[File] filtered_reads_1
        Array[File] filtered_reads_2
        Array[File] trimsort_bam
        Array[File] trimsort_bamindex
        Array[File] consensus
        Array[File] variants
        Array[File] coverage_out
        Array[File] coverage_hist
        Array[File] flagstat_out
        Array[File] stats_out
        Array[File] renamed_consensus
        String out_dir
    }

    call transfer_outputs {
        input:
            fastqc_raw1_html = fastqc_raw1_html,
            fastqc_raw1_zip = fastqc_raw1_zip,
            fastqc_raw2_html = fastqc_raw2_html,
            fastqc_raw2_zip = fastqc_raw2_zip,
            fastqc_clean1_html = fastqc_clean1_html,
            fastqc_clean1_zip = fastqc_clean1_zip,
            fastqc_clean2_html = fastqc_clean2_html,
            fastqc_clean2_zip = fastqc_clean2_zip,
            seqyclean_summary = seqyclean_summary,
            filtered_reads_1 = filtered_reads_1,
            filtered_reads_2 = filtered_reads_2,
            trimsort_bam = trimsort_bam,
            trimsort_bamindex = trimsort_bamindex,
            consensus = consensus,
            variants = variants,
            coverage_out = coverage_out,
            coverage_hist = coverage_hist,
            flagstat_out = flagstat_out,
            stats_out = stats_out,
            renamed_consensus = renamed_consensus,
            out_dir = out_dir
    }
    
    output {
        String transfer_date = transfer_outputs.transfer_date
    }
}    

task transfer_outputs {
    input {
        String out_dir
        Array[File] fastqc_raw1_html
        Array[File] fastqc_raw1_zip
        Array[File] fastqc_raw2_html
        Array[File] fastqc_raw2_zip
        Array[File] fastqc_clean1_html
        Array[File] fastqc_clean1_zip
        Array[File] fastqc_clean2_html
        Array[File] fastqc_clean2_zip
        Array[File] seqyclean_summary
        Array[File] filtered_reads_1
        Array[File] filtered_reads_2
        Array[File] trimsort_bam
        Array[File] trimsort_bamindex
        Array[File] consensus
        Array[File] variants
        Array[File] coverage_out
        Array[File] coverage_hist
        Array[File] flagstat_out
        Array[File] stats_out
        Array[File] renamed_consensus
    }
    
    String outdir = sub(out_dir, "/$", "")

    command <<<
        
        gsutil -m cp ~{sep=' ' fastqc_raw1_html} ~{outdir}/fastqc/
        gsutil -m cp ~{sep=' ' fastqc_raw1_zip} ~{outdir}/fastqc/
        gsutil -m cp ~{sep=' ' fastqc_raw2_html} ~{outdir}/fastqc/
        gsutil -m cp ~{sep=' ' fastqc_raw2_zip} ~{outdir}/fastqc/
        gsutil -m cp ~{sep=' ' fastqc_clean1_html} ~{outdir}/fastqc/
        gsutil -m cp ~{sep=' ' fastqc_clean1_zip} ~{outdir}/fastqc/
        gsutil -m cp ~{sep=' ' fastqc_clean2_html} ~{outdir}/fastqc/
        gsutil -m cp ~{sep=' ' fastqc_clean2_zip} ~{outdir}/fastqc/
        gsutil -m cp ~{sep=' ' seqyclean_summary} ~{outdir}/seqyclean/
        gsutil -m cp ~{sep=' ' filtered_reads_1} ~{outdir}/seqyclean/
        gsutil -m cp ~{sep=' ' filtered_reads_2} ~{outdir}/seqyclean/
        gsutil -m cp ~{sep=' ' trimsort_bam} ~{outdir}/alignments/
        gsutil -m cp ~{sep=' ' trimsort_bamindex} ~{outdir}/alignments/
        gsutil -m cp ~{sep=' ' consensus} ~{outdir}/assemblies/
        gsutil -m cp ~{sep=' ' variants} ~{outdir}/variants/
        gsutil -m cp ~{sep=' ' coverage_out} ~{outdir}/bam_stats/
        gsutil -m cp ~{sep=' ' coverage_hist} ~{outdir}/bam_stats/
        gsutil -m cp ~{sep=' ' flagstat_out} ~{outdir}/bam_stats/
        gsutil -m cp ~{sep=' ' stats_out} ~{outdir}/bam_stats/
        gsutil -m cp ~{sep=' ' renamed_consensus} ~{outdir}/assemblies/
        
        transferdate=`date`
        echo $transferdate | tee TRANSFERDATE
    >>>

    output {
        String transfer_date = read_string("TRANSFERDATE")
    }

    runtime {
        docker: "theiagen/utility:1.0"
        memory: "16 GB"
        cpu: 4
        disks: "local-disk 10 SSD"
    }
}