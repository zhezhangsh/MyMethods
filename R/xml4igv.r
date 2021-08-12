xml4igv <- function(x, fout) {
  # x   list(lab='', url='', project=list(p1=list(BAM=list(f1=s1, f2=s2), VCF=list(...)), p2=list(...)); 
  # fout path and name of the XML file to write to
  
  require(xml2);
  
  lab <- x$lab;
  url <- x$url;
  prj <- x$project;
  
  lst <- lapply(prj, function(p) {
    l <- lapply(p, function(fs) {
      structure(lapply(names(fs), function(nm) {
        list(Resource=structure(list(), name=nm, path=fs[[nm]]));
      }));
    });
    names(l) <- rep('Category', length(l));
    for (i in 1:length(l)) attr(l[[i]], 'name') <- names(p)[i];
    l;
  });
  
  names(lst) <- rep('Category', length(lst));
  for (i in 1:length(lst)) attr(lst[[i]], 'name') <- names(prj)[i];
  
  xml <- list(lst);
  attr(xml, 'name') <- lab;
  attr(xml, 'hyperlink') <- url;
  
  write_xml(as_xml_document(list(Global=xml)), fout);

  fout;
}

