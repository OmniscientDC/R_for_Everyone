##4-3 資料型別

#主要分成：1.numeric(數值) 2.character(字串) 3.Date/POSIXct(時間) 4.logical(邏輯資料-TRUE/FALSE

#資料型別可用 class()來檢測

#4-3-1 數值資料
class("x") #character
class(5) #numeric

#可用 is.numeric()來檢測是否為數值
#is.integer()檢測是否為整數

is.numeric("x") #FALSE
is.numeric(598) #TRUE

#如果要指派一個整數，需要在數字尾端附加一個"L"
i <- 5L
is.numeric(i) #TRUE
is.integer(i) #TRUE

#當integer*numeric，integer就會自動轉換成numeric

class(i*2.8) #numeric

#4-3-2 字元資料

#可用factor()檢驗

x <- "data"
factor(x)

#若要找出character或是numeric的長度，可用nchar()

nchar("data")
nchar(48525)

#4-3-3 日期

#Date儲存時間，POSIXct儲存日期和時間

date1 <- as.Date("2021-09-22")
date1

class(date1)
as.numeric(date1) #會計算從1970-01-01至現在的天數

date2 <- as.POSIXct("2021-09-22 12:17")
date2

class(date2)
as.numeric(date2) #會計算從1970-01-01至現在的秒數

#4-3-4 邏輯(logicals)資料

#邏輯是指只有涵蓋TRUE及FALSE的二元資料，以數值來表示的話，TRUE等同1，FALSE等同0

TRUE*5 #1*5=5
FALSE*5 #0*5=0

k <- TRUE
class(k)
is.logical(k)

#其實可以只簡寫成T及F，但容易被其他值取代，故不建議使用

#logicals也可以藉由比較兩個數字或字元的結果所產生

2 == 3
2 != 3
2 < 3
2 <= 3
"data" == "stats"
"data" < "stats"

##4-4 向量vector

#向量為同型別的元素的集合，一個vector不能涵蓋不同型別的元素
#vector並無維度，像是列向量或行向量
#可用c()函數來建造向量

x <- c(1,2,3,4,5,6,7,8,9,10)
x

#也可以直接透過向量進行運算

x * 3
x^2
sqrt(x)

#也可以透過:建立成vector

x <- 1:10
y <- -5:4
x-y #兩個相同長度的向量可以進行運算
x*y
length(x) #查看向量的長度

#若是對兩個長度不相等的vector做運算的時候，比較短的vector會被循環再用
#直到比較長的vector的每個元素都有一個配對為止

x+ c(1,2)

x + c(1,2,3) #若長的vector的長度不是短的vector的倍數，會出現警告訊息

#也可以比較兩個向量

x <= 5
x > y

#若要看是否所有比較都是TRUE，可用all()函數
#若要看其中是否有一個比較為TRUE，可用any()函數

all(x < y)
any(x < y)

#用中括號[]可以查看vector裡的單一元素。

x[1] #查看單一元素
x[3:5] #查看連續元素
x[c(3,6)] #查看非連續元素

#也可以為vector的元素命名

c(One = "a", Two = "y", Last = "r") #用"名字-值"的方式命名

w <- 1:3
names(w) <- c("a","b","c")
w #也可以用names()來命名

#factor因素在R裡是一個重要的概念，在日後資料建模的時候重要

q <- c("apple", "banana" , "orange", "apple")

#用as.factor()可以輕易轉換為factor

q_factor <- as.factor(q)
q_factor

#一個factor的levels就是將factor變數中不重複的元素個數
#一般的factor裡，levels的排序並不重要
#但也有些情況裡是需要考慮排序的，可以用引數ordered=TRUE建立排序的factor

factor(x = c("apple", "banana" , "orange", "apple"),
       levels=c("apple", "banana" , "orange"),
       ordered = TRUE) 

##4-6 函數說明文件

#R提供的每個函數都有一個相關文件或操作說明，可以在函數前面輸入問號

?"mean"
?"factor"

#若是有不確定的函數名稱，可以用apropos來查看相關的函數

apropos("mea")

##4-7 遺失值

#R有兩種計入遺失值的方式，分別為NA跟NULL，但兩者實質上不一樣

# NA代表缺失值
# NULL代表值根本不存在

z <- c(1, 2, NA, 8, 3, NA, 3)
z
is.na(z)

#計算平均數時，若其中有元素是NA，則會回傳NA

mean(z)

#可利用na.rm = TRUE來移除遺失值，再進行計算

mean(z, na.rm = TRUE)

#NA跟NULL最大的差別是，NA可以存入vector裡，NULL不行

z <- c(1, NULL, 3)
z
is.null(z)
is.null(d <- NULL)

##4-8 Pipe管線運算子

#pipe運算子(%>%)會將其左手邊的值或物件移植到右邊函數的第一個引數
#可用ctrl+shift+m打出來

library(magrittr)
x <- 1:10
x %>% mean

#pipe在我們需要將一系列的函數串聯在一起的時候最有用

z <- c(1,2,NA,8,3,NA,3)
sum(is.na(z))

z %>% is.na %>% sum
z %>% mean(na.rm= TRUE)
