# This is a script generates R code to load a set of BAM files
# It uses specifications given in a yaml file and has the option to generate code for qsub

####################################################
# Define variable fn.yaml before running this script
####################################################
library(yaml);
yml<-yaml.load_file("LoadBamScript.yml");

path<-yml$output;
if (!file.exists(path)) dir.create(path, recursive = TRUE);

bams<-yml$bam;
yml<-yml[names(yml) != 'bam']; 

fn<-sapply(names(bams), function(nm) {
  pth<-paste(path, nm, sep='/');
  if (!file.exists(pth)) dir.create(pth, recursive = TRUE); 
  fn.r<-paste(pth, 'LoadBam.r', sep='/'); 
  fn.sh<-paste(pth, 'LoadBam.sh', sep='/'); 
  fn.yml<-paste(pth, 'LoadBam.yml', sep='/'); 
  
  y<-list(name=nm, bam=bams[[nm]]); 
  yml<-c(y, yml); 
  writeLines(as.yaml(yml), fn.yml); 
  
  writeLines(paste(yml$R, fn.r), fn.sh); 
  
  lns<-c(paste('##', nm), 'require("GenomicRanges");', 'require("GenomicAlignments");', 'require("Rnaseq");', '');
  lns<-c(lns, paste('fn.yaml <- ("', fn.yml, '");', sep=''));
  lns<-c(lns, 'ct<-LoadBam(fn.yaml);', '');
  writeLines(lns, fn.r); 
  
  fn.sh;
});

lns<-paste(yml$qsub, fn);
writeLines(lns, paste(path, 'qsub.sh', sep='/')); 
