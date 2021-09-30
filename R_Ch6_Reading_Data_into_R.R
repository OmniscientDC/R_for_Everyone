###Ch6 讀取各類資料

##6-1 讀取CSV

#讀取CSV檔最佳方法是使用read.table()函數，read.csv()也可以\

dat <- read.table(file.choose(), header = TRUE, sep = ",")
#本人習慣使用file.choose()，也可以使用file = 檔案位置
dat <- read.table(file = Url, header = TURE, sep = ",")

#header為是否將資料的第一橫列設為直行的欄位名稱
#sep為分隔資料的分隔符號

#有時會運用到stringAsFactors這個引數，將引數設為FALSE
#可預防含有character的欄位被轉為factor，節省運算時間，也保持character欄位原有的資料型別

x <- 1:3
y <- -4:-2
q <- c("Hokey","Football","Baseball")
theDF <- data.frame(First=x,Second=y,Sport=q, stringsAsFactors = FALSE)
theDF$Sport

#readr套件提供讀取文字檔的函數，可用read_delim

library(readr)
data1 <- read_delim(file.choose(), delim = ",")
#執行read_delim時，會顯示資料存取的欄位名稱和資料型別
#read_delim執行速度比read.table快，也省略了用straingAsFactor設為FALSE的必要性

#另一個讀取較大資料的函數是data.table套件裡的fread函數
#其讀取的第一個引數須為檔案的完整名稱或是路徑(URL)

library(data.table)
theURL <- "檔案路徑"
data2 <- fread(input=theURL, sep=",", header = TRUE)

#read_delim與fread都是運行速度比read.table快且好用的函數

##6-2 Excel資料的讀取 #有點無法下載

#可以先用download.file將網路上的資料下載下來

download.file(url = "網路上的.xlsx檔")

#下載完後檢視表格

library(readxl)
excel_sheets(".xlsx檔") #會出現此檔裡有幾個表格

#read_excel預設會讀取第一頁的excel表格（活頁簿）

tomatoXL <- read_excel(".xlsx檔")
tomatoXL

#若要讀取別的表格，可以輸入第幾頁或是該活頁簿名稱

wineXL <- read_excel(".xlsx", sheet = 2)
#或是
wineXL <- read_excel(".xlsx", sheet = "Wine")



