### Ch16 字串處理 Manipulating Strings

## 16-1 用paste建立字串

# R初學者第一個用來建立字串的函數為 paste

paste("Hello", "Jared", "and others")
# paste的引數會自動加入空格，也可以指定任何文字 sep = ""
paste("Hello", "Jared", "and others", sep = "/")

# paste也允許向量化運算，一對一配對，若長度不相同，短的vector會被重複利用
paste(c("Hello", "Hey", "Howdy"), c("Jared", "Bob", "David"))
paste("Hello", c("Jared", "Bob", "David"))
paste("Hello", c("Jared", "Bob", "David"), c("Goodbye", "Seeya"))

# 利用paste的collapse函數，可以將vector裡所有文字摺疊成單一vector
# 用空白與星號摺疊
vectorOfText <- c("Hello", "Everyone", "out there", ".")
paste(vectorOfText, collapse = " ")
paste(vectorOfText, collapse = "*")

## 16-2 用sprintf建立含有變數的字串

# 用paste在合併較簡短的字串時很方便，但在合併很多文字時，尤其是夾雜一些變數時
# 用sprintf會比較方便

person <- "Jared"
partySize <- "eight"
waitTime <- 25

# paste方法
paste("Hello", person, ", your party of", partySize,
      " will be seated in ", waitTime, " minutes.", sep = " ")

# sprintf方法，運用%s來對應其變數
sprintf("Hello %s, your party of %s will be seated in %s minutes.",
       person, partySize, waitTime)

# sprintf也允許向量化運算，但要注意vector與vector的長度必須是倍數關係
sprintf("Hello %s, your party of %s will be seated in %s minutes.",
        c("Jared", "Bob"), c("eight", 16, "four", 10), waitTime)

## 16-3 擷取文字

# 使用stringr套件可以使拆解文字更輕鬆
# 以下用XML套件從維基百科下載歷屆美國總統的表格資料來做示範

install.packages("XML")
library(XML)

presidents <- read.delim(file.choose(), header = T, sep = ",")
head(presidents)
tail(presidents$YEAR)
# 去除不要的部分，保留前65列
presidents <- presidents[1:65, ]

# 建立兩個新直行，一個儲存總統上任年分，一個為卸任年分
# 並把年份中間的"-"作為分割點把字串拆成兩半
# 使用stringr套件裡的str_split函數，會以list形式回傳
# list中每一個元素皆為一個vector

library(stringr)

yearList <- str_split(string = presidents$YEAR, pattern = "-")
head(yearList)

# 將分割完的list合併成一個matrix
# Reduce為對一個向量循環執行函數
yearMatrix <- data.frame(Reduce(rbind, yearList))
head(yearMatrix)

# 對直行重新命名
names(yearMatrix) <- c("Start", "Stop")
# 將新的直行合併到data.frame
presidents <- cbind(presidents, yearMatrix)
# 將上任和卸任年分轉換成numeric
presidents$Start <- as.numeric(as.character(presidents$Start))
presidents$Stop <- as.numeric(as.character(presidents$Stop))
# 要先將factor轉換成character再轉換成numeric
# 不然factor只會是一些整數的標籤

head(presidents)
tail(presidents)

# 也可以使用str_sub指定擷取出字串中的一些字元
# 例如擷取出字串前三個字元
str_sub(string = presidents$PRESIDENT, start = 1, end = 3)
str_sub(string = presidents$PRESIDENT, start = 4, end = 8)

# 可以透過上述方法，例如找到年份結尾為1時上任的總統
presidents[str_sub(string = presidents$Start, start = 4, end = 4) == 1,
           c("YEAR", "PRESIDENT", "Start", "Stop")]


## 16-4 正規表示法

# 正規表示法（Regular Expression）是用來搜尋字串的一種特定與法
# 可利用規定的符號代表各種的形式，例如：一個或連續數字、特定字元等

# 利用str_detect去找到名字裡有"John"的總統

# 回傳TRUE/FALSE以表示是否在名字裡找到"John"
johnPos <- str_detect(string = presidents$PRESIDENT, pattern = "John")
presidents[johnPos, c("YEAR", "PRESIDENT", "Start", "Stop")]

# 若要忽略大小寫，可以在規則中加入 ignore.case
goodSearch <- str_detect(presidents$PRESIDENT, regex("John",ignore_case = T))
sum(goodSearch)

# 用美國戰爭的表格來示範更多正規表示法的例子
con <- url("http://www.jaredlander.com/data/warTimes.rdata")
load(con)
close(con)

head(warTimes, 10)

warTimes[str_detect(string = warTimes, pattern = "-")]
# 建立一個儲存戰爭開始時間的直行，必須拆開Time這一行
# 本例子用來分隔的符號為ACAEA和"-"
# 但有些時間裡也有"-"，所以使用"(ACAEA)|-"
# 為了前述橫線被用來拆解，將n=2，代表最多只會被拆解成兩個部分
theTimes <- str_split(string = warTimes, pattern = "(ACAEA)|-", n=2)
head(theTimes)

# 也可以查看之前所提到用橫線作為分隔符號的兩個情況
which(str_detect(string = warTimes, pattern = "-"))
theTimes[[147]]

# 為了要看戰爭開始的時間，我們建立函數
# 在某些情況擷取list中每個vector的第一個元素（留下開始時間的部分
theStart <- sapply(theTimes, function(x) x[1])
head(theStart)

# 可用str_trim去除前後的空格
theStart <- str_trim(theStart)
head(theStart)

# 若想要從資料中擷取任何含有"January"字串的地方，可以使用str_extract
# 不包含此字串的地方將會以NA顯示
str_extract(string = theStart, pattern = "January")

# 若要找出含有"January"的元素並整項回傳，可以用str_detect建立條件敘述
# 進而用敘述結果從theStart找出我們想要的子集合
theStart[str_detect(string = theStart, pattern = "January")]

# 若要擷取年分，要找出四個數字一起出現的情況
# 在正規表示法的搜尋中，"[0-9]"表示搜尋任何數字
# 於是可用"[0-9][0-9][0-9][0-9]"來搜尋四個連在一起的數字
head(str_extract(string = theStart, "[0-9][0-9][0-9][0-9]"), 20)

# 但重複輸入很沒效率，可以將{4}擺在[0-9]後面，代表搜尋任意4位數的數字
head(str_extract(string = theStart, "[0-9]{4}"), 20)

# 輸入[0-9]還不算簡潔，可以用 \\d 來代表任意整數
head(str_extract(string = theStart, "\\d{4}"), 20)

# 大括號也可以利用它對某個數字搜尋1~3次
head(str_extract(string = theStart, "\\d{1, 3}"), 20)

# 正規表示法也可以搜尋固定在某部位的文字
# 搜尋前端文字可使用"^"，搜尋後端文字可以使用"$"
head(str_extract(string = theStart, "^\\d{4}"), 20)
head(str_extract(string = theStart, "\\d{4}$"), 20)
head(str_extract(string = theStart, "^\\d{4}$"), 20)

# 也可以挑選文字來進行取代，先以固定值取代數字做為示範
# 將第一個任意數改為x
head(str_replace(string = theStart, pattern = "\\d", replacement = "x"), 30)

# 也可以將所有看到的數字取代乘x
head(str_replace_all(string = theStart, pattern = "\\d", replacement = "x"), 30)

# 取代任何由一位數到四位數組成的數字字串為x (跑不出來)
head(str_replace_all(string = theStart, pattern = "nndf1, 4g", replacement = "x"), 30)

