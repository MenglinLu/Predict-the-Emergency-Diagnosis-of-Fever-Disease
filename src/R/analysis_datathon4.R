# data processing
# read data and merge into one table
library(readr)
fe.data <- read.csv(file="D:\\Rdatamining\\connection\\fe.csv",header=TRUE,colClasses = "character")#×Ö·û
nit.data <- read.csv(file="D:\\Rdatamining\\connection\\nit.csv",header=TRUE,colClasses = "character")#×Ö·û
uwbc.data <- read.csv(file="D:\\Rdatamining\\connection\\uwbc.csv",header=TRUE,colClasses = "character")#×Ö·û
uwbc.m.data <- read.csv(file="D:\\Rdatamining\\connection\\uwbc_m.csv",header=TRUE,colClasses = "character")#×Ö·û
fl.data <- read.csv(file="D:\\Rdatamining\\connection\\fl.csv",header=TRUE,colClasses = "character")#×Ö·û
wbc.data <- read.csv(file="D:\\Rdatamining\\connection\\wbc.csv",header=TRUE,colClasses = "character")#×Ö·û
plt.data <- read.csv(file="D:\\Rdatamining\\connection\\plt.csv",header=TRUE,colClasses = "character")#×Ö·û
pct.data <- read.csv(file="D:\\Rdatamining\\connection\\pct.csv",header=TRUE,colClasses = "character")#×Ö·û
l.data <- read.csv(file="D:\\Rdatamining\\connection\\l.csv",header=TRUE,colClasses = "character")#×Ö·û
il6.data <- read.csv(file="D:\\Rdatamining\\connection\\il6.csv",header=TRUE,colClasses = "character")#×Ö·û
crp.data <- read.csv(file="D:\\Rdatamining\\connection\\crp.csv",header=TRUE,colClasses = "character")#×Ö·û

# uwbc.data <- read.csv(file="D:\\Rdatamining\\connection\\uwbc.csv",header=TRUE,colClasses = "character")#×Ö·û


data.raw <- merge(wbc.data, nit.data[, c('PATIENT_ID', 'VISIT_ID', 'nit')],by=c("PATIENT_ID", 'VISIT_ID'),all.x=TRUE)
data.raw <- merge(data.raw,uwbc.data[, c('PATIENT_ID', 'VISIT_ID', 'uwbc')],by=c("PATIENT_ID", 'VISIT_ID'),all.x=TRUE)
data.raw <- merge(data.raw,uwbc.m.data[, c('PATIENT_ID', 'VISIT_ID', 'uwbc_m')],by=c("PATIENT_ID", 'VISIT_ID'),all.x=TRUE)
data.raw <- merge(data.raw,fl.data[, c('PATIENT_ID', 'VISIT_ID', 'fl')],by=c("PATIENT_ID", 'VISIT_ID'),all.x=TRUE)
data.raw <- merge(data.raw,fe.data[, c('PATIENT_ID', 'VISIT_ID', 'fe')],by=c("PATIENT_ID", 'VISIT_ID'),all.x=TRUE)
data.raw <- merge(data.raw,plt.data[, c('PATIENT_ID', 'VISIT_ID', 'plt')],by=c("PATIENT_ID", 'VISIT_ID'),all.x=TRUE)
data.raw <- merge(data.raw,pct.data[, c('PATIENT_ID', 'VISIT_ID', 'pct')],by=c("PATIENT_ID", 'VISIT_ID'),all.x=TRUE)
data.raw <- merge(data.raw,l.data[, c('PATIENT_ID', 'VISIT_ID', 'l')],by=c("PATIENT_ID", 'VISIT_ID'),all.x=TRUE)
data.raw <- merge(data.raw,il6.data[, c('PATIENT_ID', 'VISIT_ID', 'il6')],by=c("PATIENT_ID", 'VISIT_ID'),all.x=TRUE)
data.raw <- merge(data.raw,crp.data[, c('PATIENT_ID', 'VISIT_ID', 'crp')],by=c("PATIENT_ID", 'VISIT_ID'),all.x=TRUE)

baso <- read.csv(file="D:\\Rdatamining\\connection\\baso.csv",header=TRUE,colClasses = "character")[, c(1:2, 5)]
eos <- read.csv(file="D:\\Rdatamining\\connection\\eos.csv",header=TRUE,colClasses = "character")[, c(1:2, 5)]
lym <- read.csv(file="D:\\Rdatamining\\connection\\lym.csv",header=TRUE,colClasses = "character")[, c(1:2, 5)]
mono <- read.csv(file="D:\\Rdatamining\\connection\\mono.csv",header=TRUE,colClasses = "character")[, c(1:2, 5)]
neut <- read.csv(file="D:\\Rdatamining\\connection\\neut.csv",header=TRUE,colClasses = "character")[, c(1:2, 5)]
data.raw <- merge(data.raw,baso[, c('PATIENT_ID', 'VISIT_ID', 'baso')],by=c("PATIENT_ID", 'VISIT_ID'),all.x=TRUE)
data.raw <- merge(data.raw,eos[, c('PATIENT_ID', 'VISIT_ID', 'eos')],by=c("PATIENT_ID", 'VISIT_ID'),all.x=TRUE)
data.raw <- merge(data.raw,lym[, c('PATIENT_ID', 'VISIT_ID', 'lym')],by=c("PATIENT_ID", 'VISIT_ID'),all.x=TRUE)
data.raw <- merge(data.raw,mono[, c('PATIENT_ID', 'VISIT_ID', 'mono')],by=c("PATIENT_ID", 'VISIT_ID'),all.x=TRUE)
data.raw <- merge(data.raw,neut[, c('PATIENT_ID', 'VISIT_ID', 'neut')],by=c("PATIENT_ID", 'VISIT_ID'),all.x=TRUE)


data.raw[, c(4:15)] <- lapply(data.raw[, c(4:15)], as.numeric)
a <- data.raw[, names(data.raw) %in% c('fe', 'fl', 'uwbc_m') == F]
data.std <- a[complete.cases(a), ]


diagnose <- read.csv(file="D:\\Rdatamining\\connection\\diagnose.csv",header=TRUE,colClasses = "character")[, c(1:2, 5)]
antibiotic <- read.csv(file="D:\\Rdatamining\\connection\\antibiotics.csv",header=TRUE,colClasses = "character")
colnames(antibiotic) <- c('PATIENT_ID', 'VISIT_ID', 'antibiotic_flag')
data.std <- merge(data.std, diagnose, by=c("PATIENT_ID", 'VISIT_ID'),all.x=TRUE)
data.std <- merge(data.std, antibiotic, by=c("PATIENT_ID", 'VISIT_ID'),all.x=TRUE)
data.std$antibiotic_flag[is.na(data.std$antibiotic_flag)] <- 0



# save data
write.csv(data.std, 'D:\\Rdatamining\\connection\\datastd.csv')

