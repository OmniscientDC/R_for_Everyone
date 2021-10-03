###11 Group Manipulation群駔資料操作

##11-1 apply相關函數

#apply限制性高，只能用在matrix中，所有元素必須是同一類別
#若用在其他結構物件，如data.frame，則需先轉換成matrix

#用法：apply(資料, 1或2(1為橫列，2為直行), 套用函數)

theMatrix <- matrix(1:9, nrow=3) #建立matrix
theMatrix
apply(theMatrix, 1, sum) #計算橫列sum
apply(theMatrix, 2, mean) #計算直行mean

#試著將theMatrix其一函數改為NA，並再使用na.rm處理遺失值

theMatrix[2,1] <- NA
theMatrix
apply(theMatrix, 1 , sum) #會發現其一結果為NA
apply(theMatrix, 1 , sum , na.rm = TRUE) #用na.rm=TRUE處理遺失值

#也可以使用rowSums(), colSums()直接計算

rowSums(theMatrix, na.rm = TRUE)
colSums(theMatrix, na.rm = TRUE)

# lapply用於list中每個元素套用函數，回傳值也為list

theList <- list(A = matrix(1:9, 3), B = 1:5, C = matrix(1:4, 2), D = 2)
theList
lapply(theList, sum)
lapply(theList[1], sum)

#也可以使用 sapply 只是回傳值會以vector形式展現

sapply(theList, sum)

#由於vector也算是list的一種，故lapply跟sapply也可以套用於此

theNames <- c("Jared", "Deb", "Paul")
theNames
sapply(theNames, nchar)
lapply(theNames, nchar)

# mapply 可以對好幾個list中的元素套用指定的函數
# 除了使用mapply 用迴圈也可以完成

#先建立兩個list
firstList <- list(A = matrix(1:16, 4), B = matrix(1:16, 2), C = 1:5)
secondList <- list(A = matrix(1:16,4), B = matrix(1:16, 8), C = 15:1)
firstList
secondList

mapply(identical, firstList, secondList)
#identical用來檢測兩者元素是否相同
mapply(sum , firstList, secondList)

#也可以建立function，再用mapply套用

simpleFunc <- function(x,y){
  NROW(x) + NROW(y)
}
mapply(simpleFunc, firstList, secondList)


# tapply用於將函數應用於因子組合給出的向量子集
# tapply(vector, factor, function)

fac <- c(1,1,2,2,2,3,3,3)
vec <- c(3,2,4,1,6,8,2,5)
tapply(vec, fac, sum)
tapply(vec, fac, barplot)

## aggregate 聚合資料

#用資料庫的diamonds來示範aggregate用法
install.packages("gglopt2")
library(ggplot2)
data("diamonds")
head(diamonds)

#例如想了解切割品質(cut)其平均價值(price)
#aggregate(formula, data, 套用到資料的函數)

aggregate(price ~ cut, data = diamonds, mean)
#波浪符(~)代表 左邊的變數用來計算，右邊的變數為分群依據
aggregate(price ~ table, data = diamonds, mean)
#波浪符右邊可以放類別變數，也可以放數值變數
#害怕遺漏值可以直接添加na.rm=TRUE
aggregate(price ~ cut, data = diamonds, mean, na.rm = TRUE)

#若要以數個變數為依據來分群，可以在formula右邊用加號(+)添加變數
aggregate(price ~ cut + color, data = diamonds, mean)

diaCP <- aggregate(price ~ cut, data = diamonds, mean)
barplot(diaCP$price, names= c(1,2,3,4,5), col = c("red", "yellow", "green", "blue", "purple"))

#如果要同時對兩個變數進行計算，可以用cbind合併起來

aggregate(cbind(price, carat) ~ cut, diamonds, mean)

aggregate(cbind(price, carat) ~ cut + color, diamonds, mean)

#aggregate在執行上比較慢，可以使用plyr, dplyr與data.table在執行上是比較快的

##11-3 plyr套件

#該套件的核心函數包括ddply, llply, ldply
#第一第二的字母代表輸入及輸出資料的結構
#d為data.frame, l為list

install.packages("plyr")
library(plyr)
head(baseball)

#例如 計算棒球的上壘率
#上壘率(OBP)=(H+BB+HBP)/(AB+BB+HBP+SF)
#且將1954年以前的資料sf設為0
#hbp的NA也要改為0
#也排除AB少於50的選手

baseball$sf[baseball$year < 1954] <- 0
any(is.na(baseball$sf))

baseball$hbp[is.na(baseball$hbp)] <- 0
any(is.na(baseball$hbp))

baseball <- baseball[baseball$ab >= 50, ]

#with函數可以只需指定data.frame一次就可以任意使用data.frame裡的直行

baseball$OBP <- with(baseball, (H+BB+HBP)/(AB+BB+HBP+SF))
tail(baseball)

#計算某個選手整個職棒生涯的OBP

obp <- function(data){
  c(OBP = with(data, sum(h + bb + hbp)/sum(ab + bb + hbp + sf)))
}

#再用ddply對每個選手計算其整個棒球職業生涯的OBP

careerOBP <- ddply(baseball, .variables = "id", .fun = obp)

careerOBP <- careerOBP[order(careerOBP$OBP, decreasing = TRUE)]
#排序OBP
head(careerOBP, 10)

# llply

#先前使用lapply來找出list中每個元素的總和，也可以使用llply完成

theList <- list(A = matrix(1:9, 3), B = 1:5, C = matrix(1:4, 2), D = 2)
theList

lapply(theList, sum)
llply(.data = baseball, .fun = sum)

#用identical檢視是否兩者是相同的
identical(lapply(theList, sum),llply(.data = theList, .fun = sum))

#plyr輔助函數

#plyr涵蓋許多有用處的輔助函數，像是 each
#可以將多個函數的功能套用到某個函數中(例如aggregate)

aggregate(price ~ cut, diamonds, each(mean, median))

#另一個則為idata.frame
#此函數可以更快速的對data.frame做資料抽取，並更節省記憶體

head(diamonds)
dlply(.data = diamonds, .variable = "color", .fun = nrow)

system.time(dlply(.data = diamonds, .variable = "color", .fun = nrow))

idiamonds <- idata.frame(diamonds)
system.time(dlply(.data = idiamonds, .variable = "color", .fun = nrow))

## 11-4 data.table

# data.table與data.frame有點不一樣
# data.table可以像資料庫那樣使用索引
# 讓資料的搜尋、分群和合併的速度變得更快

#建立data.table的方式與data.frame的是一樣的

library(data.table)

theDF <- data.frame(A = 1:10,
                    B = letters[1:10],
                    C = LETTERS[1:10],
                    D = rep(c("one","two","three"), length.out=10))
theDF

theDT <- data.table(A = 1:10,
                    B = letters[1:10],
                    C = LETTERS[1:10],
                    D = rep(c("one","two","three"), length.out=10))
theDT

#data.frame會預設把character資料轉換為factor
#data.table則不會

class(theDF$B)
class(theDT$B)

# 也可以從已建立好的data.frame建立出data.table

diamondsDT <- data.table(diamonds)
diamondsDT
#data.table很貼心只把前五行跟後五行顯示出來

theDT[1:2,]
theDT[theDT$A >= 7, ]
theDT[A >= 7]
theDT[theDT$D == "one"]

#在data.frame看個別直行的話
theDF[,2:3]

#若要在data.table裡查看個別直行的話
#直接打直行名稱，無須引號
theDT[ , list(C)]
theDT[ , B]
theDT[ , list(A,D)]

##索引鍵 keys

#可以用talbes()顯示有多少列表
tables()

#索引鍵可以加快搜尋資料的速度
#可用setkey(資料, 作為索引鍵的直行名稱)

setkey(theDT, D)
theDT
# D就會按照字母順序重新排列
#可以使用key() 來確認索引鍵已被設定好

key(theDT)

tables() #設定索引鍵後，在用tables()可以確認列表是否有索引鍵

#在挑選或查看data.table橫列時，也可以直接使用索引鍵
theDT["one",]
theDT[c("one","three"),]

#也可以設定數個直行為索引鍵
setkey(diamondsDT, cut, color)
tables()

diamondsDT["Fair",]
#若同時要根據兩個索引鍵來篩選列，可以使用J()函數
diamondsDT[J("Ideal","E")]
#ideal為cut索引選項，E為color索引選項
diamondsDT[J("Ideal",c("E","D")),]

## data.table的資料分群計算

# 索引的主要好處是可以更快速地進行資料分群計算

aggregate(price ~ cut, diamonds, mean)

#也可以用data.table來取得同樣的結果
diamondsDT[,mean(price), by = cut]

#但用data.table的話，輸出結果的直行名稱的可以自訂
#可用list的形式傳遞
diamondsDT[, list(price = mean(price)), by = cut]

#若要根據好幾個直行進行分群，可以用list來指定
diamondsDT[, mean(price), by = list(cut, color)]
diamondsDT[, list(price = mean(price)), by = list(cut, color)]

#也可以對好幾個引數做分群計算，可以將他們都指定在一個list裡面
diamondsDT[, list(price = mean(price), carat = mean(carat)), by = cut]

#也可以用很多變數為依據進行資料分群，然後對每一群的好幾個變數進行計算
diamondsDT[, list(price = mean(price), carat = mean(carat)), by = list(cut, color)]
