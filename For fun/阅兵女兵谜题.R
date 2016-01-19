x <- 14:30
y <- (20 - x * .88)/.12
plot(x, y, type = 'b', xlab = '88%的年龄', ylab = '对应12%的年龄', lwd = 2.5, col = 'blue', xlim = c(14, 30),
     main = '女兵方阵平均年龄20岁，大学及以上学历占88%')
axis(1, at = 14:30, labels = 14:30)
#abline(v = 22, col = 'red', lty = 2)
abline(h = 5.33, col = 'red', lty = 2)
text(x = 27, y = 7, labels = 'when x = 22, y = 5.33')
abline(h = 0, col = 'red', lwd = 3)
#abline(h = 22, col = 'red', lwd = 3)
points(x = 22, y = 5.3, col = 'red', pch = 19, cex = 1.5)
text(x = 23, y = 10, labels = '剩下的12%女兵平均年龄5.3岁，身高1.73m。。。')


