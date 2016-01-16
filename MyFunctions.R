###------------------------------------------------------------###
#                    Cheng Chen                                  #
#                                          一切历史都是未来         #
#             注意都使用四空格缩进                                   #
###------------------------------------------------------------###
#
###########          我都忘这里扔了什么                ###########
##### 在音智达的时候写的一些和文本处理（挖掘）有关的function
##### 到 line 155 结束,差不多
##### line 160的地方是一个当初用来算MAT442 final grade的小函数,有空可以扩展
##### 紧接着到 180多点结束的,是一个用了计算10年总工资的小函数
##### line 187左右 一个密码生成器,有改进的comments,记得去改


# tm包中对中文操作的话用R base跑,Rstudio会报错,无解决办法
# e.g. RemoveWord()
# 
# 
CreateDict <- function (x, stopword){ 
    # 这个函数自动把 x,一个character object 输出成一个词语vector
    if (is.character (x) && is.character (stopword)) {
        require (Rwordseg)
        i <- nchar (x) == 0 #the index 数据库中下到的文本可能会有空值
        x <- x[!i] # remove the empty comment
        x <- segmentCN (x)  #分词
        x <- lapply ( x, function(q) q[!is.element (q,stopword)])
        word <- unlist (x)
        word <- levels (as.factor (word))
        word <- word[sort (word) > 3]
        return (word)
    }
    else {
        stop ('The args must be char objects!')
    }
}

CleanText <- function (x, stopword) {
    # this function cleans remvoe the stopword of a character object x and returns a list object
    # NO NEED to segment x before use!!!
    i <- nchar (x) != 0 #the index 数据库中下到的文本可能会有空值
    x <- x[i] # remove the empty comment
    require(Rwordseg)
    x <- segmentCN (x)
    x <- lapply (x, function (x) x[!is.element(x, stopword)])
    x
}

ClassifySenti <- function (q, posDict, negDict){
    # this function classify the sentiment of each comment
    # algorithm: compare the bad/good score
    # args: q should be a list object, segmented!
    comments.good.score <- unlist (lapply (q, function (x) sum (is.element ( x, posDict))))
    comments.bad.score <- unlist (lapply (q, function (x) sum (is.element ( x, negDict))))
    q <- data.frame (good.score = comments.good.score, bad.score = comments.bad.score)
    temp <- ifelse ( q[, 1] > q[, 2], 'good', ifelse (q[, 1] < q[, 2], 'bad', 'neutral'))
    q$senti <- temp
    return (list (Data = q, Classfier = (f <- as.data.frame (table (q$senti)))))
}

# ===================================================================================================
######下面几个方程要连用,具体应用见 Rproject 2014-0612
UsedinGetTopic <- function(q, dict) {
    #this function is used in the GetTopic function
    #args: q is a segmented char obj
    #args: dict should ba the dict containing the words(topics) needed to be found
    index <- dict %in% q
    t <- dict[index]
    if (length(t) == 0){
      return ('No topic')
    } 
    else{
      return (t)
    }
}

GetTopic <- function(qq, dict) { #1 first run this then run #2
  #this function classify each char. ojb into the topics the user defined in the dict
  #args: qq should be a segmented list obj
  #args: dict should ba the dict containing the words needed to be found
  result <- lapply(qq, UsedinGetTopic, dict)
  return(result)
}

ReturnInx <- function(result) { # Used in the ClassifyTC function
    #this function takes the result of teh GetTopic function and returns the index 
    #of the commets with >= 2 topics
    #args: result, the result of the the GetTopic function
    tem <- sapply(result, length)
    index <- which(tem > 1)
    return(index)
}

UsedinClassifyTC <- function(q, dict) {
    #this function splits the commt. into subcommts by topics
    #args: q is a segmented char obj
    #get index
    n <- length(q)
    index <- rep(0, n)
    t <- length(dict)
    for (i in 1:t) {
        temp <- ifelse(q == dict[i], i, 0)
        index <- index + temp
    }
    #modify the index #1
    first.nonzero <- which(index == F)[1] 
    index[1:first.nonzero] <- index[first.nonzero]
    #modify the index #2
    for (i in 1:t) {
        for (j in 1: (n-1)) {
            if (index[j] == i) {
                if (index[j+1] == 0) {
                    index[j+1] <- i
                }
            }
        }
    }
    #get result
    result <- list()
    for (o in 1:t) {
        id <- ifelse(index == o, T, F)
        result[[o]] <- q[id]    
    }
    names(result) <- dict
    result
}

ClassifyTC <- function (p, dict) { #2
    #this function takes the result of the GetTopic function
    #   and returns the split comments
    #args: p, the result of the the GetTopic function
    #      dict, the topic dict.
    ID <- ReturnInx(p)
    r <- lapply(p[ID], UsedinGetTopic, dict)
    r
}
# ========================================================================================
makeSim <- function (simname = c('a', 'b'), simnum = 100, pro = NULL, save = T, replace = T, file = ''){
    # aim here：一个可以制造模拟数据的函数
    # args：
    #      simenae: a vector of names you want to simulate
    #      simnum: the number you want simulate
    #      pro: the probability of each element in the simname
    #      replace: T or F, if replace in sample()
    #      save: if write the sample to the disk
    #      file: where to save the file and file name
    n <- length(simname)
    if (!is.null(pro)) {
        if (length(pro) != n) stop('请输入正确的分布概率！')
    else 
        pro <- rep(1/n, n)
    }
    sam <- sample(simname, simnum, replace = replace, p = pro)
    if (save) {
        write(sam, file = file, row.names = F, quote = F)
    }
    else {
        sam
    }
}

##############################################################################
##  grade computation for MAT 442 ##
# srs what am I doing here?
score<-function(hw10=50,hw11=50,final=90){
  hw<-c(56,30,50,37,57,39,25,49,60)
  midterms<-100.5*.5 ##(101+100)/2
  hw.full<-c(hw,hw10,hw11)
  hws<-0.2*mean(sort(hw.full)[4:11])/60*100 
            ##3 lowest will be dropped
  finals<-0.3*final
  score<-midterms+hws+finals #use the weight formula
  return(score)
}

# @2014/7/13 把这个做成了一个shiny app
cal <- function(ini = 3500, len = 10, inc = 500, rate1 = .035, rate2 = 0.033){
  # rate1: the interest rate
  # rate2: the inflation rate
  year <- 1:len
  Year <- paste0('Year', year)
  Rate <- rate1 - rate2
  yr.inc <- (year-1) * inc
  annual.incoming <- (ini+yr.inc) * 12 # PVs
  actual.amt <- annual.incoming * (1+Rate)^(0:(len-1)) # Fvs w/ rates  
  
  table <- data.frame(year = Year, annual.incoming = annual.incoming,
                    act.amt = actual.amt)
  lifetime.earned <- data.frame(without.infloation = sum(annual.incoming),
                              with.infloation = sum(actual.amt))
  output <- list(table, lifetime.earned)
  return(output)
}

pwgen<-function(len=round(runif(1,6,18),0),type=2){
  #len, the length of the pw;type, 1= pure num. 2=combination
  if (!type==1 & !type==2) stop("Please select the correct type of your password") 
  if (!class(len)=="numeric") stop("Please type an integer as the length of your password") 
  if (type==1){
    pw<-sample(0:9,len,replace=T)
    pw<-paste(pw,collapse="")
    
    }
  else{
    pw<-paste(sample(c(0:9,letters,LETTERS,"!","@","#"),len,replace=T),collapse="")
    }
  result<-paste("Your password is:",pw)
  return(result)
  #return(pw)
}
########
# how to improve this function
# 1. build a gui for it
# 2. create a power parameter to control the the strongness of the pass word
# 2 can be achrived by creating different types of dicts.