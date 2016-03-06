fn.junc<-c(
	"C2863" = "/home/zhangz/R/source/MyMethods/examples/rnaseq/star/pass_1/C2863_SJ.out.tab",
	"C2864" = "/home/zhangz/R/source/MyMethods/examples/rnaseq/star/pass_1/C2864_SJ.out.tab",
	"C2865" = "/home/zhangz/R/source/MyMethods/examples/rnaseq/star/pass_1/C2865_SJ.out.tab",
	"C2866" = "/home/zhangz/R/source/MyMethods/examples/rnaseq/star/pass_1/C2866_SJ.out.tab"
);


library(Rnaseq);

sj<-CombineStarSj(fn.junc, output="/home/zhangz/R/source/MyMethods/examples/rnaseq/star/pass_1/combined_SJ.out.tab", canonical.only=0, unannotated.only=1, min.sample=3, min.unique=3, min.unique.total=12, min.overhang=5)
saveRDS(sj, "/home/zhangz/R/source/MyMethods/examples/rnaseq/star/pass_1/script/sj.rds")
