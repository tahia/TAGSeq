library(DESeq2)
library(edgeR)
library(limma)

## Read Count Matrix. This code is for featurecound output so will remove extra 1st through 6th column of gene annotation
dat<-as.data.frame(read.delim("Counts_HAL_mod.tab",sep = "\t",row.names = 1)) # row.names =1 will read read gene names as row names
countTable<-dat[,-c(1:5)] # Remove annotation columns

### Read Design/Meta file
Design<-read.csv("Metasheet.csv",check.names = F,row.names = 7)

# Order counts as design file
countTable<-countTable[,rownames(Design)]

#Filter low abundant genes
countTable<-countTable[-which(as.vector(rowMeans(countTable,na.rm = F)) <5),]

# Dead as DESeq2 object
dds <- DESeqDataSetFromMatrix(countData = countTable,
                              colData = Design,
                              design = ~ 1  )

dds = estimateSizeFactors(dds )
sizeFactors(dds)

# Variance Stabilizing Transformation
vst<-vst(dds,blind = T)
dat<-as.data.frame(assay(vst))

#Get the variances of each gene to select top 1000 genes for PCA
var<-as.data.frame(apply(dat,1,var))
colnames(var)<-"GeneVariance"
TopVarGene<-rownames(var)[order(var$GeneVariance,decreasing = T)][1:1000]
dat_sel<-dat[which(rownames(dat) %in% TopVarGene  ),]

##### run pca by dudi.pca
library(ade4)
library(factoextra)
library(magrittr)
library(gridExtra)

res.pca <- dudi.pca(na.omit(t(dat_sel)),
                    scannf = FALSE,   # Hide scree plot
                    nf = 5 ,center = T,scale = T           # Number of components kept in the results
)


#plot by fviz 
#axis 1 and 2
p1<-fviz_pca_biplot(res.pca, label ="var",axes = c(1,2),
                    geom.var = "point",
                    geom.ind = "point",
                    pointshape = 21, 
                    pointsize = 2.5,
                    fill.ind=Design$Geno_group, #Change "Geno_group to any variable in your Design file to map"
                    #palette = c("#0073C2FF", "#EFC000FF", "#868686FF", "#CD534CFF"), #use your own palette if you want
                    #palette = c("#00AFBB", "#E7B800", "#FC4E07","#E7B800"), 
                    legend.title = list(fill = "GenoGroup"),
                    select.var = list(contrib = 10),
                    repel = TRUE,
                    addEllipses=F, ellipse.level=0.9)+labs(title="PCA on Axis 1 and 2")+
  theme(plot.title = element_text(hjust = 0.5))     # Variable colors            

#Axis 2 and 3

p2<-fviz_pca_biplot(res.pca, label ="var",axes = c(2,3),
                    geom.var = "point",
                    geom.ind = "point",
                    pointshape = 21, 
                    pointsize = 2.5,
                    fill.ind=Design$SITE,
                    #palette = c("#0073C2FF", "#EFC000FF", "#868686FF", "#CD534CFF"),
                    #palette = c("#00AFBB", "#E7B800", "#FC4E07","#E7B800"),
                    legend.title = list(fill = "SITE"),
                    select.var = list(contrib = 10),
                    repel = TRUE,
                    addEllipses=F, ellipse.level=0.9)+labs(title="PCA on Axis 2 and 3")+
  theme(plot.title = element_text(hjust = 0.5))     # Variable colors 

p3<-fviz_pca_biplot(res.pca, label ="var",axes = c(3,4),
                    geom.var = "point",
                    geom.ind = "point",
                    pointshape = 21, 
                    pointsize = 2.5,
                    fill.ind=Design$Geno_group,
                    #palette = c("#0073C2FF", "#EFC000FF", "#868686FF", "#CD534CFF"),
                    #palette = c("#00AFBB", "#E7B800", "#FC4E07","#E7B800"),
                    legend.title = list(fill = "GenoGroup"),
                    select.var = list(contrib = 10),
                    repel = TRUE,
                    addEllipses=F, ellipse.level=0.9)+labs(title="PCA on Axis 3 and 4")+
  theme(plot.title = element_text(hjust = 0.5))     # Variable colors 

p4<-fviz_pca_biplot(res.pca, label ="var",axes = c(4,5),
                    geom.var = "point",
                    geom.ind = "point",
                    pointshape = 21, 
                    pointsize = 2.5,
                    fill.ind=Design$Geno_group,
                    #palette = c("#0073C2FF", "#EFC000FF", "#868686FF", "#CD534CFF"),
                    #palette = c("#00AFBB", "#E7B800", "#FC4E07","#E7B800"),
                    legend.title = list(fill = "GenoGroup"),
                    select.var = list(contrib = 10),
                    repel = TRUE,
                    addEllipses=F, ellipse.level=0.9)+labs(title="PCA on Axis 4 and 5")+
  theme(plot.title = element_text(hjust = 0.5))     # Variable colors 

grid.arrange(p1,p2,p3,p4, ncol=2, nrow = 2)
