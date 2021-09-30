###CH5 進階資料結構

##5-1 data.frame 資料框(架)

#可用data.frame建議與excel試算表類似的行(column)與列(row)

#可以用edit()直接編輯data.frame
exam1 <- data.frame()
exam1 <- edit(exam1) #會跳出編輯視窗

exam1 <- data.frame(ID = character(), Exam1 = numeric())
exam1 <- edit(exam1) #也可以先命名

#可用subset去篩選資料
#subset(資料表,篩選邏輯)
subset(exam1, Exam1 >= 1)

x <- 1:3
y <- -4:-2
q <- c("Hokey","Football","Baseball")
theDF <- data.frame(x, y, q)
theDF

#也可以在宣告前先命名變數

theDF <- data.frame(First = x, Second = y, Sport = q)

#可以用nrow(), ncol(), dim()查看列與行及同時兩個屬性

nrow(theDF)
ncol(theDF)
dim(theDF)

#names()可查看行的名稱
#rownames()可查看列的名稱

names(theDF)
names(theDF)[3] #查看第三行的名稱
rownames(theDF)
rownames(theDF) <- c("One","Two","Three") #替列名稱命名 
rownames(theDF)

rownames(theDF) <- NULL #將列名稱設回通用索引，1, 2, 3...

#可用head(), tail()查看data.frame的首、尾六行

head(theDF)
tail(theDF)
head(theDF, n = 2) #只看2行

#也可以用class去查看data.frame的資料型別

class(theDF) #data.frame

#可用"$"查看特定data.frame的某行

theDF$Sport #查看Sport那行

theDF[3, 2] #theDF[列, 行]，查看第二行第三列
theDF[3, 1:2] #第一二行的第三列
theDF[c(1, 3), 2] #第二行的第一和第三列
theDF[c(1, 3), 2:3] #第三三行的第一和第三列

#若要查一整列或一整行可將行/列號留空

theDF[,3] #看第三行
theDF[2,] #看第二列
theDF[,2:3] #看第二三行

#也可以直接使用直行名稱查看特定行

theDF[,c("First","Sport")]
theDF[, "Sport"] #僅回傳單行，為一個向量vector
theDF["Sport"] #指定顯示單行，為data.frame

#若要保證回傳值是單行的data.frame，可以增加引數drop = FALSE

theDF[, "Sport", drop = FALSE]
theDF[, 3, drop = FALSE]

#若要建立儲存類別資料的變數可以使用factor()
#也可以使用model.matrix來建立指標，會產生數行，每一行代表factor的一個level，若某列矬有該level，則會顯示1，否則為0

newFactor <- factor(c("大學生", "碩士生", "博士生"))
model.matrix(~newFactor - 1)

##5-2 List列表

#list可以儲存任何型別和長度的資料

list(1, 2, 3) #建立3個元素的list

list(c(1, 2, 3)) #建立1個元素的list，且唯一的元素含有三個元素的vector

list3 <- list(c(1, 2, 3), 3:7) #建立2個元素的list，一個含有3個元素的vector，一個含有5個元素的vector

list(theDF, 1:10) #建立2個元素的list，一個為data.frame，一個含有10個元素的vector

list5 <- list(theDF, 1:10, list3) #建立三個元素的list：data.frame, vector, list

#同樣也可以為List命名

names(list5) <- c("data.frame", "vector", "list")
names(list5)
list5

#也可以在建立list時用指派名稱的方式命名

list6 <- list(TheDataFrame = theDF, TheVector = 1:10, TheList = list3)
names(list6)
list6

#若要查詢list中的單一元素，可以使用雙中括號，並指定所要查詢的元素所對應的位置或名稱

list5[[1]] #查詢list5的第一個元素

list5[["data.frame"]]

list5[[1]]$Sport

list5[[1]][, "Second"]
list5[[1]][, "Second", drop = FALSE]

#也可以在list中附加新的元素

length(list5) #查詢list5的長度

list5[[4]] <- 2 #添加第四個元素，且不給予名稱
length(list5)

list5[["NewElement"]] <- 3:6 #添加第五個元素，並給予名稱
length(list5)

names(list5) #會發現元素4的名字是空的
list5

##5-3 Matrix矩陣

#矩陣與data.frame類似，皆是用列和行所構。
#但不同的是，矩陣裡的每一個元素，不管是否在同一行
#都必須是同樣的資料型別
#是二維的資料結構（列*行）

A <- matrix(1:10, nrow = 5) #建立5X2的矩陣
B <- matrix(21:30, nrow = 5) #建立另一個矩陣
C <- matrix(21:40, nrow = 2) #建立2X10的矩陣
nrow(A)
ncol(A)
dim(A)

A + B
A * B
A == B

#若是需要做「矩陣乘法」，則需先將B使用t()轉置，再進行相乘

A %*% t(B)

#matrix和data.frame一樣可以指派行與列的名稱

colnames(A) <- c("Left", "Right")
rownames(A) <- c("1st", "2nd", "3rd", "4th", "5th")
colnames(A)
rownames(A)

#也可直接用大小寫字母命名，使用LETTERS[]/letters[]

colnames(C) <- LETTERS[1:10] #代表字母A~J
rownames(C) <- c("Top", "Bottom")

#若將A轉置與C進行矩陣乘法，則會發現

A %*% C #matrix乘法保留了左邊matrix的列名稱及右邊matrix的行名稱

##5-4 Array陣列

#Array與matrix不同的地方為，array是多維度的vector（如三維度）

theArray <- array(1:12, dim = c(2, 3, 2))
#建立一個2*3*2維度的array
theArray

#可透過中括號查詢

theArray[1, , ]
theArray[, , 2]
