#4-3 資料型別

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

