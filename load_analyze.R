### R code from vignette source '/Users/jaime/code/sandbox/scifundstats/load_analyze.Rnw'

###################################################
### code chunk number 1: load_analyze.Rnw:65-70
###################################################
prj.stats =read.csv('proj.txt')
prj.stats$percent.funded = with(prj.stats, fund_attained/fund_goal)
prj.stats$multiple.contributions = with(prj.stats, total_contributions/unique_contributions)
prj.stats$average.contribution = with(prj.stats, fund_attained/total_contributions)
prj.stats$multiple.contributions.bool = prj.stats$multiple.contributions > 1


###################################################
### code chunk number 2: load_analyze.Rnw:76-78
###################################################
lm.funded1 = lm(percent.funded~description_length+ total_contributions+ 
  fund_goal+ multiple.contributions+ average.contribution, data = prj.stats)


###################################################
### code chunk number 3: load_analyze.Rnw:81-82
###################################################
lm.funded = step(lm.funded1)


###################################################
### code chunk number 4: load_analyze.Rnw:86-88
###################################################
a = summary(lm.funded)
coef(a)


###################################################
### code chunk number 5: load_analyze.Rnw:95-99
###################################################
lm.avgive1 = lm(average.contribution~description_length+
  total_contributions+
  fund_goal+
  multiple.contributions, data = prj.stats)


###################################################
### code chunk number 6: load_analyze.Rnw:101-102
###################################################
lm.avgive = step(lm.avgive1)


###################################################
### code chunk number 7: load_analyze.Rnw:106-108
###################################################
b = summary(lm.avgive)
coef(b)


###################################################
### code chunk number 8: load_analyze.Rnw:131-135
###################################################
require(ggplot2)
prj.stats$description_length =cut_number(prj.stats$description_length, n=5)
prj.stats$av.contrib.factor = cut_number(prj.stats$average.contribution, n=3)
g = ggplot(prj.stats)


###################################################
### code chunk number 9: load_analyze.Rnw:139-141
###################################################
g2 = g+theme_bw() + geom_point(aes(fund_goal, percent.funded, size=total_contributions, color=description_length))+ facet_grid(multiple.contributions.bool~av.contrib.factor)+scale_color_brewer(type='seq')
print(g2)


###################################################
### code chunk number 10: load_analyze.Rnw:144-146
###################################################
g3 = g +theme_bw() + geom_point(aes(multiple.contributions, average.contribution, color=description_length, size=fund_goal))+scale_color_brewer(type='seq')
print(g3)


###################################################
### code chunk number 11: load_analyze.Rnw:149-151
###################################################
#g +theme_bw()+ geom_boxplot(aes(multiple.contributions.bool, average.contribution))+ geom_point(aes(multiple.contributions.bool, average.contribution, color=description_length, size=fund_goal))+scale_color_brewer(type='seq')



